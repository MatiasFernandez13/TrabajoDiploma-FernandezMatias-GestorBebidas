using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;

namespace DAL
{
    public class UsuarioPermisoDAL
    {
        private readonly string _connectionString;

        public UsuarioPermisoDAL()
        {
            _connectionString = ConfigurationManager.ConnectionStrings["MiConexion"].ConnectionString;
        }

        public void AsignarGruposAUsuario(int idUsuario, List<int> idGrupos)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                conn.Open();

                var cmdDel = new SqlCommand("DELETE FROM Usuario_GrupoPermiso WHERE IdUsuario = @IdUsuario", conn);
                cmdDel.Parameters.AddWithValue("@IdUsuario", idUsuario);
                cmdDel.ExecuteNonQuery();

                foreach (var idGrupo in idGrupos)
                {
                    var cmdIns = new SqlCommand("INSERT INTO Usuario_GrupoPermiso (IdUsuario, IdGrupoPermiso) VALUES (@IdUsuario, @IdGrupo)", conn);
                    cmdIns.Parameters.AddWithValue("@IdUsuario", idUsuario);
                    cmdIns.Parameters.AddWithValue("@IdGrupo", idGrupo);
                    cmdIns.ExecuteNonQuery();
                }
            }
        }

        public List<int> ObtenerGruposDeUsuario(int idUsuario)
        {
            List<int> lista = new List<int>();
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                conn.Open();
                var cmd = new SqlCommand("SELECT IdGrupoPermiso FROM Usuario_GrupoPermiso WHERE IdUsuario = @IdUsuario", conn);
                cmd.Parameters.AddWithValue("@IdUsuario", idUsuario);
                var reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    lista.Add((int)reader["IdGrupoPermiso"]);
                }
            }
            return lista;
        }
    }
}