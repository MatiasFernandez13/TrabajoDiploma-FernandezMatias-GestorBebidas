using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;
using System.Data;
using System.Windows.Forms;
using BE;

namespace SERVICIOS
{
    public static class DigitoVerificador
    {
        private static readonly string _connectionString = ConfigurationManager.ConnectionStrings["MiConexion"].ConnectionString;
        private const long PRIMO_DVV = 2147483647;
        public static decimal CalcularDVH(string datos)
        {
            if (string.IsNullOrEmpty(datos))
                return 0;
            using (SHA256 sha = SHA256.Create())
            {
                byte[] bytes = Encoding.UTF8.GetBytes(datos);
                byte[] hash = sha.ComputeHash(bytes);
                long dvh = BitConverter.ToInt64(hash, 0);
                if (dvh < 0)
                    dvh = -dvh;
                return Convert.ToDecimal(dvh);
            }
        }

        public static decimal CalcularDVH(Producto p)
        {
            string datos = $"{p.Id}{p.Nombre}{p.Categoria}{p.Precio}{p.LitrosPorUnidad}{p.Stock}{p.Activo}";
            return CalcularDVH(datos);
        }

        public static decimal CalcularDVH(Usuario u)
        {
            string datos = $"{u.Id}{u.NombreUsuario}{u.ContraseñaHasheada}{u.Salt}{u.Idioma}{u.Activo}";
            return CalcularDVH(datos);
        }

        public static decimal CalcularDVH(Cliente c)
        {
            string datos = $"{c.Id}{c.NombreCompleto}{c.Direccion}{c.Telefono}{c.Email}{c.Zona}{c.Activo}";
            return CalcularDVH(datos);
        }

        public static void RecalcularDVV(string tabla)
        {
            decimal sumaDVH = 0;
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                try
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand($"SELECT SUM(DVH) FROM {tabla}", conn))
                    {
                        object result = cmd.ExecuteScalar();
                        sumaDVH = (result != null && result != DBNull.Value) ? Convert.ToDecimal(result) : 0;
                    }

                    string query = @"
                        IF EXISTS (SELECT 1 FROM DigitoVerificador WHERE Tabla = @Tabla)
                            UPDATE DigitoVerificador SET DVV = @ValorDVV WHERE Tabla = @Tabla
                        ELSE
                            INSERT INTO DigitoVerificador (Tabla, DVV) VALUES (@Tabla, @ValorDVV)";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Tabla", tabla);
                        decimal valor = (sumaDVH % PRIMO_DVV);
                        cmd.Parameters.AddWithValue("@ValorDVV", valor);
                        cmd.ExecuteNonQuery();
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Error al calcular o guardar el DVV:\n" + ex.Message);
                }
            }
        }

        public static bool VerificarDVV(string tabla, out decimal dvvCalculado, out decimal dvvGuardado)
        {
            dvvCalculado = 0;
            dvvGuardado = 0;
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                try
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand($"SELECT SUM(DVH) FROM {tabla}", conn))
                    {
                        object result = cmd.ExecuteScalar();
                        decimal suma = (result != null && result != DBNull.Value) ? Convert.ToDecimal(result) : 0;
                        dvvCalculado = (suma % PRIMO_DVV);
                    }

                    using (SqlCommand cmd = new SqlCommand("SELECT DVV FROM DigitoVerificador WHERE Tabla = @Tabla", conn))
                    {
                        cmd.Parameters.AddWithValue("@Tabla", tabla);
                        object result = cmd.ExecuteScalar();
                        dvvGuardado = (result != null && result != DBNull.Value) ? Convert.ToDecimal(result) : 0;
                    }

                    return dvvCalculado == dvvGuardado;
                }
                catch
                {
                    return false;
                }
            }
        }

        public static void VerificarYAlertar(string tabla)
        {
            if (!VerificarDVV(tabla, out decimal calculado, out decimal guardado))
            {
                DialogResult r = MessageBox.Show($"Integridad comprometida en {tabla}. Guardado={guardado}, Calculado={calculado}. ¿Recalcular?", "Integridad", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
                if (r == DialogResult.Yes)
                {
                    RecalcularDVV(tabla);
                }
            }
        }

        public static void RecalcularDVHUsuarios()
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                try
                {
                    conn.Open();
                    using (SqlCommand sel = new SqlCommand("SELECT Id, NombreUsuario, Contraseña, Salt, Idioma, Activo FROM Usuarios", conn))
                    using (SqlDataReader rd = sel.ExecuteReader())
                    {
                        List<(int Id, string NombreUsuario, string Contraseña, string Salt, string Idioma, bool Activo)> datos = new List<(int Id, string NombreUsuario, string Contraseña, string Salt, string Idioma, bool Activo)>();
                        while (rd.Read())
                        {
                            int Id = Convert.ToInt32(rd["Id"]);
                            string NombreUsuario = rd["NombreUsuario"].ToString();
                            string Contraseña = rd["Contraseña"].ToString();
                            string Salt = rd["Salt"] != DBNull.Value ? rd["Salt"].ToString() : "";
                            string Idioma = rd["Idioma"] != DBNull.Value ? rd["Idioma"].ToString() : "es";
                            bool Activo = rd["Activo"] != DBNull.Value && Convert.ToBoolean(rd["Activo"]);
                            datos.Add((Id, NombreUsuario, Contraseña, Salt, Idioma, Activo));
                        }

                        rd.Close();
                        foreach ((int Id, string NombreUsuario, string Contraseña, string Salt, string Idioma, bool Activo) d in datos)
                        {
                            Usuario u = new Usuario
                            {
                                Id = d.Id,
                                NombreUsuario = d.NombreUsuario,
                                ContraseñaHasheada = d.Contraseña,
                                Salt = d.Salt,
                                Idioma = d.Idioma,
                                Activo = d.Activo
                            };
                            decimal dvh = CalcularDVH(u);
                            using (SqlCommand upd = new SqlCommand("UPDATE Usuarios SET DVH=@DVH WHERE Id=@Id", conn))
                            {
                                upd.Parameters.AddWithValue("@DVH", dvh);
                                upd.Parameters.AddWithValue("@Id", u.Id);
                                upd.ExecuteNonQuery();
                            }
                        }
                    }

                    RecalcularDVV("Usuarios");
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Error al recalcular DVH/DVV de Usuarios:\n" + ex.Message);
                }
            }
        }

        public static void RecalcularDVHProductos()
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                try
                {
                    conn.Open();
                    using (SqlCommand sel = new SqlCommand("SELECT Id, Nombre, CategoriaId, Precio, LitrosPorUnidad, Stock, Activo FROM Productos", conn))
                    using (SqlDataReader rd = sel.ExecuteReader())
                    {
                        List<Producto> datos = new List<Producto>();
                        while (rd.Read())
                        {
                            Producto p = new Producto
                            {
                                Id = Convert.ToInt32(rd["Id"]),
                                Nombre = rd["Nombre"].ToString(),
                                Categoria = Convert.ToInt32(rd["CategoriaId"]),
                                Precio = Convert.ToDecimal(rd["Precio"]),
                                LitrosPorUnidad = Convert.ToDouble(rd["LitrosPorUnidad"]),
                                Stock = Convert.ToInt32(rd["Stock"]),
                                Activo = Convert.ToBoolean(rd["Activo"])
                            };
                            datos.Add(p);
                        }

                        rd.Close();
                        foreach (Producto p in datos)
                        {
                            decimal dvh = CalcularDVH(p);
                            using (SqlCommand upd = new SqlCommand("UPDATE Productos SET DVH=@DVH WHERE Id=@Id", conn))
                            {
                                upd.Parameters.AddWithValue("@DVH", dvh);
                                upd.Parameters.AddWithValue("@Id", p.Id);
                                upd.ExecuteNonQuery();
                            }
                        }
                    }

                    RecalcularDVV("Productos");
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Error al recalcular DVH/DVV de Productos:\n" + ex.Message);
                }
            }
        }

        public static List<Usuario> UsuariosConDVHInvalido()
        {
            List<Usuario> lista = new List<Usuario>();
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                conn.Open();
                using (SqlCommand sel = new SqlCommand("SELECT Id, NombreUsuario, Contraseña, Salt, Idioma, Activo, DVH FROM Usuarios", conn))
                using (SqlDataReader rd = sel.ExecuteReader())
                {
                    while (rd.Read())
                    {
                        Usuario u = new Usuario
                        {
                            Id = Convert.ToInt32(rd["Id"]),
                            NombreUsuario = rd["NombreUsuario"].ToString(),
                            ContraseñaHasheada = rd["Contraseña"].ToString(),
                            Salt = rd["Salt"] != DBNull.Value ? rd["Salt"].ToString() : "",
                            Idioma = rd["Idioma"] != DBNull.Value ? rd["Idioma"].ToString() : "es",
                            Activo = rd["Activo"] != DBNull.Value && Convert.ToBoolean(rd["Activo"]),
                            DVH = rd["DVH"] != DBNull.Value ? Convert.ToDecimal(rd["DVH"]) : 0
                        };
                        decimal dvhCalc = CalcularDVH(u);
                        if (u.DVH != dvhCalc)
                            lista.Add(u);
                    }
                }
            }

            return lista;
        }

        public static List<Producto> ProductosConDVHInvalido()
        {
            List<Producto> lista = new List<Producto>();
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                conn.Open();
                using (SqlCommand sel = new SqlCommand("SELECT Id, Nombre, CategoriaId, Precio, LitrosPorUnidad, Stock, Activo, DVH FROM Productos", conn))
                using (SqlDataReader rd = sel.ExecuteReader())
                {
                    while (rd.Read())
                    {
                        Producto p = new Producto
                        {
                            Id = Convert.ToInt32(rd["Id"]),
                            Nombre = rd["Nombre"].ToString(),
                            Categoria = Convert.ToInt32(rd["CategoriaId"]),
                            Precio = Convert.ToDecimal(rd["Precio"]),
                            LitrosPorUnidad = Convert.ToDouble(rd["LitrosPorUnidad"]),
                            Stock = Convert.ToInt32(rd["Stock"]),
                            Activo = Convert.ToBoolean(rd["Activo"]),
                            DVH = rd["DVH"] != DBNull.Value ? Convert.ToDecimal(rd["DVH"]) : 0
                        };
                        decimal dvhCalc = CalcularDVH(p);
                        if (p.DVH != dvhCalc)
                            lista.Add(p);
                    }
                }
            }

            return lista;
        }

        public static void RecalcularDVHClientes()
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                try
                {
                    conn.Open();
                    using (SqlCommand sel = new SqlCommand("SELECT Id, NombreCompleto, Direccion, Telefono, Email, Zona, Activo FROM Clientes", conn))
                    using (SqlDataReader rd = sel.ExecuteReader())
                    {
                        List<Cliente> datos = new List<Cliente>();
                        while (rd.Read())
                        {
                            Cliente c = new Cliente
                            {
                                Id = Convert.ToInt32(rd["Id"]),
                                NombreCompleto = rd["NombreCompleto"]?.ToString() ?? "",
                                Direccion = rd["Direccion"]?.ToString() ?? "",
                                Telefono = rd["Telefono"]?.ToString() ?? "",
                                Email = rd["Email"]?.ToString() ?? "",
                                Zona = rd["Zona"]?.ToString() ?? "",
                                Activo = rd["Activo"] != DBNull.Value && Convert.ToBoolean(rd["Activo"])
                            };
                            datos.Add(c);
                        }

                        rd.Close();
                        foreach (Cliente c in datos)
                        {
                            decimal dvh = CalcularDVH(c);
                            using (SqlCommand upd = new SqlCommand("UPDATE Clientes SET DVH=@DVH WHERE Id=@Id", conn))
                            {
                                upd.Parameters.AddWithValue("@DVH", dvh);
                                upd.Parameters.AddWithValue("@Id", c.Id);
                                upd.ExecuteNonQuery();
                            }
                        }
                    }

                    RecalcularDVV("Clientes");
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Error al recalcular DVH/DVV de Clientes:\n" + ex.Message);
                }
            }
        }

        public static List<Cliente> ClientesConDVHInvalido()
        {
            List<Cliente> lista = new List<Cliente>();
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                conn.Open();
                using (SqlCommand sel = new SqlCommand("SELECT Id, NombreCompleto, Direccion, Telefono, Email, Zona, Activo, DVH FROM Clientes", conn))
                using (SqlDataReader rd = sel.ExecuteReader())
                {
                    while (rd.Read())
                    {
                        Cliente c = new Cliente
                        {
                            Id = Convert.ToInt32(rd["Id"]),
                            NombreCompleto = rd["NombreCompleto"]?.ToString() ?? "",
                            Direccion = rd["Direccion"]?.ToString() ?? "",
                            Telefono = rd["Telefono"]?.ToString() ?? "",
                            Email = rd["Email"]?.ToString() ?? "",
                            Zona = rd["Zona"]?.ToString() ?? "",
                            Activo = rd["Activo"] != DBNull.Value && Convert.ToBoolean(rd["Activo"]),
                            DVH = rd["DVH"] != DBNull.Value ? Convert.ToDecimal(rd["DVH"]) : 0
                        };
                        decimal dvhCalc = CalcularDVH(c);
                        if (c.DVH != dvhCalc)
                            lista.Add(c);
                    }
                }
            }

            return lista;
        }
    }
}
