using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using BE;
using System.Data;

namespace DAL
{
    public class UsuarioDAL
    {
        private readonly string _connectionString;

        public UsuarioDAL(string connectionString)
        {
            _connectionString = connectionString;
        }

        public Usuario ObtenerPorNombreUsuario(string nombreUsuario)
        {

            Usuario usuario = null;

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                conn.Open();
                var cmd = new SqlCommand(@"SELECT u.Id, u.NombreUsuario, u.Contraseña, u.Salt, u.Idioma, r.Id AS RolId, r.Nombre AS RolNombre
                                           FROM Usuarios u
                                           INNER JOIN Roles r ON u.RolId = r.Id
                                           WHERE u.NombreUsuario = @nombre", conn);

                cmd.Parameters.AddWithValue("@nombre", nombreUsuario);
                var reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    usuario = new Usuario
                    {
                        Id = (int)reader["Id"],
                        NombreUsuario = reader["NombreUsuario"].ToString(),
                        ContraseñaHasheada = reader["Contraseña"].ToString(),
                        Rol = new Rol
                        {
                            Id = (int)reader["RolId"],
                            Nombre = reader["RolNombre"].ToString()
                        }
                    };
                }
            }

            return usuario;
        }

        public string ObtenerSaltPorUsuario(string nombreUsuario)
        {
            string salt = null;

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                conn.Open();
                var cmd = new SqlCommand("SELECT Salt FROM Usuarios WHERE NombreUsuario = @nombre", conn);
                cmd.Parameters.AddWithValue("@nombre", nombreUsuario);

                var result = cmd.ExecuteScalar();
                if (result != null)
                    salt = result.ToString();
            }

            return salt;
        }

        public void Insertar(Usuario usuario, string salt, long dvh)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                conn.Open();

                var cmd = new SqlCommand(@"INSERT INTO Usuarios 
                                   (NombreUsuario, Contraseña, Salt, RolId, Idioma, DVH)
                                   VALUES (@nombre, @contraseña, @salt, @rolId, @idioma, @dvh)", conn);

                cmd.Parameters.AddWithValue("@nombre", usuario.NombreUsuario);
                cmd.Parameters.AddWithValue("@contraseña", usuario.ContraseñaHasheada);
                cmd.Parameters.AddWithValue("@salt", salt);
                cmd.Parameters.AddWithValue("@rolId", usuario.Rol.Id);
                cmd.Parameters.AddWithValue("@idioma", usuario.Idioma ?? "es");
                cmd.Parameters.AddWithValue("@dvh", dvh);

                cmd.ExecuteNonQuery();
            }
        }

        public List<Usuario> ObtenerTodos()
        {
            var lista = new List<Usuario>();

            using (var conn = new SqlConnection(_connectionString))
            {
                conn.Open();
                var cmd = new SqlCommand(@"SELECT u.Id, u.NombreUsuario, u.Contraseña, r.Id AS RolId, r.Nombre AS RolNombre
                                           FROM Usuarios u
                                           INNER JOIN Roles r ON u.RolId = r.Id", conn);
                var reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    var usuario = new Usuario
                    {
                        Id = (int)reader["Id"],
                        NombreUsuario = reader["NombreUsuario"].ToString(),
                        ContraseñaHasheada = reader["Contraseña"].ToString(),
                        Rol = new Rol
                        {
                            Id = (int)reader["RolId"],
                            Nombre = reader["RolNombre"].ToString()
                        }
                    };
                    lista.Add(usuario);
                }
            }

            return lista;
        }

        public void Modificar(Usuario usuario, long dvh)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                conn.Open();
                var cmd = new SqlCommand(@"UPDATE Usuarios 
                                   SET NombreUsuario = @NombreUsuario, RolId = @RolId, Idioma = @Idioma, DVH = @dvh
                                   WHERE Id = @Id", conn);

                cmd.Parameters.AddWithValue("@NombreUsuario", usuario.NombreUsuario);
                cmd.Parameters.AddWithValue("@RolId", usuario.Rol.Id);
                cmd.Parameters.AddWithValue("@Idioma", usuario.Idioma ?? "es");
                cmd.Parameters.AddWithValue("@dvh", dvh);
                cmd.Parameters.AddWithValue("@Id", usuario.Id);

                cmd.ExecuteNonQuery();
            }
 
        }
        public void Eliminar(int id)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                conn.Open();
                var cmd = new SqlCommand("DELETE FROM Usuarios WHERE Id = @Id", conn);
                cmd.Parameters.AddWithValue("@Id", id);

                cmd.ExecuteNonQuery();
            }
            RecalcularDVV("Usuarios");
        }
        public void GuardarIdioma(int idUsuario, string idioma)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("UPDATE Usuarios SET Idioma = @Idioma WHERE Id = @Id", conn);
                cmd.Parameters.AddWithValue("@Idioma", idioma);
                cmd.Parameters.AddWithValue("@Id", idUsuario);
                cmd.ExecuteNonQuery();
            }
        }

        private void RecalcularDVV(string nombreTabla)
        {
            long sumaDVH = 0;

            using (var conn = new SqlConnection(_connectionString))
            {
                conn.Open();
                var cmd = new SqlCommand($"SELECT SUM(DVH) FROM {nombreTabla}", conn);
                var result = cmd.ExecuteScalar();
                sumaDVH = result != DBNull.Value ? Convert.ToInt64(result) : 0;
            }

            using (var conn = new SqlConnection(_connectionString))
            {
                conn.Open();
                var cmd = new SqlCommand(@"
            MERGE DigitoVerificador AS target
            USING (SELECT @Tabla AS Tabla) AS source
            ON target.Tabla = source.Tabla
            WHEN MATCHED THEN UPDATE SET DVV = @DVV
            WHEN NOT MATCHED THEN INSERT (Tabla, DVV) VALUES (@Tabla, @DVV);", conn);

                cmd.Parameters.AddWithValue("@Tabla", nombreTabla);
                cmd.Parameters.AddWithValue("@DVV", sumaDVH);
                cmd.ExecuteNonQuery();
            }
        }
    }
}
