using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using BE;

namespace DAL
{
    public class ProductoDAL
    {
        private readonly string _connectionString;

        public ProductoDAL()
        {
            _connectionString = ConfigurationManager.ConnectionStrings["MiConexion"].ConnectionString;
        }

        public List<Producto> Listar()
        {
            var lista = new List<Producto>();

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM Productos", conn);
                conn.Open();

                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    Producto p = new Producto
                    {
                        Id = Convert.ToInt32(reader["Id"]),
                        Nombre = reader["Nombre"].ToString(),
                        Categoria = Convert.ToInt32(reader["CategoriaId"]),
                        Precio = Convert.ToDecimal(reader["Precio"]),
                        Capacidad = Convert.ToDouble(reader["CapacidadLitros"]),
                        Stock = Convert.ToInt32(reader["Stock"])
                    };

                    lista.Add(p);
                }
            }

            return lista;
        }

        public Producto ObtenerPorId(int id)
        {
            Producto producto = null;

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM Productos WHERE Id = @Id", conn);
                cmd.Parameters.AddWithValue("@Id", id);
                conn.Open();

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    producto = new Producto
                    {
                        Id = Convert.ToInt32(reader["Id"]),
                        Nombre = reader["Nombre"].ToString(),
                        Categoria = Convert.ToInt32(reader["CategoriaId"]),
                        Precio = Convert.ToDecimal(reader["Precio"]),
                        Capacidad = Convert.ToDouble(reader["CapacidadLitros"]),
                        Stock = Convert.ToInt32(reader["Stock"])
                    };
                }
            }

            return producto;
        }

        public void Agregar(Producto producto)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                string query = "INSERT INTO Productos (Nombre, CategoriaId, Precio, CapacidadLitros, Stock) " +
                               "VALUES (@Nombre, @CategoriaId, @Precio, @CapacidadLitros, @Stock)";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Nombre", producto.Nombre);
                cmd.Parameters.AddWithValue("@CategoriaId", producto.Categoria);
                cmd.Parameters.AddWithValue("@Precio", producto.Precio);
                cmd.Parameters.AddWithValue("@CapacidadLitros", producto.Capacidad);
                cmd.Parameters.AddWithValue("@Stock", producto.Stock);

                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public void Modificar(Producto producto)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                string query = "UPDATE Productos SET Nombre = @Nombre, Categoria = @Categoria, Precio = @Precio, CapacidadLitros = @CapacidadLitros, Stock = @Stock WHERE Id = @Id";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Id", producto.Id);
                cmd.Parameters.AddWithValue("@Nombre", producto.Nombre);
                cmd.Parameters.AddWithValue("@Categoria", producto.Categoria);
                cmd.Parameters.AddWithValue("@Precio", producto.Precio);
                cmd.Parameters.AddWithValue("@CapacidadLitros", producto.Capacidad);
                cmd.Parameters.AddWithValue("@Stock", producto.Stock);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public void Eliminar(int id)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                SqlCommand cmd = new SqlCommand("DELETE FROM Productos WHERE Id = @Id", conn);
                cmd.Parameters.AddWithValue("@Id", id);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }
    }
}
