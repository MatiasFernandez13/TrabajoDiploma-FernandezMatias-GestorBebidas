using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BE;

namespace DAL
{
    public class IdiomaDAL
    {
        private readonly string _connectionString = ConfigurationManager.ConnectionStrings["MiConexion"].ConnectionString;

        public List<IdiomaDTO> ObtenerIdiomas()
        {
            var lista = new List<IdiomaDTO>();

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                conn.Open();
                var cmd = new SqlCommand("SELECT Codigo, Nombre FROM Idiomas", conn);
                var reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    lista.Add(new IdiomaDTO
                    {
                        Codigo = reader["Codigo"].ToString(),
                        Nombre = reader["Nombre"].ToString()
                    });
                }
            }

            return lista;
        }

        public Dictionary<string, string> ObtenerTraducciones(string codigoIdioma)
        {
            var traducciones = new Dictionary<string, string>();

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                conn.Open();

                string query = @"
            SELECT t.Nombre AS Tag, tr.Traduccion
            FROM TraduccionT tr
            JOIN Tag t ON tr.IdTag = t.Id
            JOIN Idiomas i ON tr.IdIdioma = i.Id
            WHERE i.Codigo = @Codigo";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Codigo", codigoIdioma);
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            string tag = reader["Tag"].ToString();
                            string traduccion = reader["Traduccion"].ToString();
                            traducciones[tag] = traduccion;
                        }
                    }
                }
            }

            return traducciones;
        }
    }
}
