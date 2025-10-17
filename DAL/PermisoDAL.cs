using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using BE.Permisos;

namespace DAL
{
    public class PermisoDAL
    {
        private readonly string _connectionString;

        public PermisoDAL()
        {
            _connectionString = ConfigurationManager.ConnectionStrings["MiConexion"].ConnectionString;
        }

        public int CrearPermisoSimple(PermisoSimple permiso)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                string query = "IF NOT EXISTS (SELECT 1 FROM Permiso WHERE Nombre = @Nombre) " +
                               "INSERT INTO Permiso (Nombre) OUTPUT INSERTED.Id VALUES (@Nombre); " +
                               "SELECT Id FROM Permiso WHERE Nombre = @Nombre;";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Nombre", permiso.Nombre);
                conn.Open();
                return (int)cmd.ExecuteScalar();
            }
        }

        public int CrearGrupoPermiso(GrupoPermiso grupo)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                conn.Open();

                string insertGrupo = "INSERT INTO GrupoPermiso (Nombre) OUTPUT INSERTED.Id VALUES (@Nombre)";
                SqlCommand cmdGrupo = new SqlCommand(insertGrupo, conn);
                cmdGrupo.Parameters.AddWithValue("@Nombre", grupo.Nombre);
                int idGrupo = (int)cmdGrupo.ExecuteScalar();

                foreach (var hijo in grupo.Hijos)
                {
                    SqlCommand cmdDetalle = new SqlCommand("INSERT INTO Grupo_PermisoDetalle (IdGrupo, IdPermiso, IdGrupoHijo) VALUES (@IdGrupo, @IdPermiso, @IdGrupoHijo)", conn);
                    cmdDetalle.Parameters.AddWithValue("@IdGrupo", idGrupo);

                    if (hijo is PermisoSimple simple)
                    {
                        int idPermiso = CrearPermisoSimple(simple);
                        cmdDetalle.Parameters.AddWithValue("@IdPermiso", idPermiso);
                        cmdDetalle.Parameters.AddWithValue("@IdGrupoHijo", DBNull.Value);
                    }
                    else if (hijo is GrupoPermiso subGrupo)
                    {
                        int idSubGrupo = CrearGrupoPermiso(subGrupo);
                        cmdDetalle.Parameters.AddWithValue("@IdPermiso", DBNull.Value);
                        cmdDetalle.Parameters.AddWithValue("@IdGrupoHijo", idSubGrupo);
                    }

                    cmdDetalle.ExecuteNonQuery();
                }

                return idGrupo;
            }
        }

        public void AsignarPermisosARol(int idRol, List<IPermiso> permisos)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                conn.Open();

                SqlCommand cmdDelete = new SqlCommand("DELETE FROM Rol_Permiso WHERE IdRol = @IdRol", conn);
                cmdDelete.Parameters.AddWithValue("@IdRol", idRol);
                cmdDelete.ExecuteNonQuery();

                foreach (var permiso in permisos)
                {
                    SqlCommand cmdInsert = new SqlCommand("INSERT INTO Rol_Permiso (IdRol, IdPermiso, IdGrupo) VALUES (@IdRol, @IdPermiso, @IdGrupo)", conn);
                    cmdInsert.Parameters.AddWithValue("@IdRol", idRol);

                    if (permiso is PermisoSimple simple)
                    {
                        int idPermiso = CrearPermisoSimple(simple);
                        cmdInsert.Parameters.AddWithValue("@IdPermiso", idPermiso);
                        cmdInsert.Parameters.AddWithValue("@IdGrupo", DBNull.Value);
                    }
                    else if (permiso is GrupoPermiso grupo)
                    {
                        int idGrupo = CrearGrupoPermiso(grupo);
                        cmdInsert.Parameters.AddWithValue("@IdPermiso", DBNull.Value);
                        cmdInsert.Parameters.AddWithValue("@IdGrupo", idGrupo);
                    }

                    cmdInsert.ExecuteNonQuery();
                }
            }
        }

        public List<IPermiso> ObtenerGruposDePermisos()
        {
            List<IPermiso> lista = new List<IPermiso>();

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                conn.Open();

                string query = "SELECT Id, Nombre FROM GrupoPermiso";
                SqlCommand cmd = new SqlCommand(query, conn);
                var reader = cmd.ExecuteReader();

                var grupos = new Dictionary<int, GrupoPermiso>();

                while (reader.Read())
                {
                    int id = (int)reader["Id"];
                    string nombre = reader["Nombre"].ToString();

                    var grupo = new GrupoPermiso { Id = id, Nombre = nombre }; 
                    grupos.Add(id, grupo);
                }

                reader.Close();

                // Cargo las relaciones hijos 
                foreach (var kvp in grupos)
                {
                    int idGrupo = kvp.Key;
                    GrupoPermiso grupo = kvp.Value;

                    SqlCommand cmdHijos = new SqlCommand("SELECT IdPermiso, IdGrupoHijo FROM Grupo_PermisoDetalle WHERE IdGrupo = @IdGrupo", conn);
                    cmdHijos.Parameters.AddWithValue("@IdGrupo", idGrupo);

                    using (SqlDataReader subReader = cmdHijos.ExecuteReader())
                    {
                        var hijosSimples = new List<int>();
                        var hijosGrupos = new List<int>();

                        while (subReader.Read())
                        {
                            if (subReader["IdPermiso"] != DBNull.Value)
                                hijosSimples.Add((int)subReader["IdPermiso"]);
                            else if (subReader["IdGrupoHijo"] != DBNull.Value)
                                hijosGrupos.Add((int)subReader["IdGrupoHijo"]);
                        }

                        subReader.Close();

                        
                        foreach (var idPermiso in hijosSimples)
                        {
                            PermisoSimple permiso = ObtenerPermisoSimplePorId(idPermiso, conn);
                            grupo.Agregar(permiso);
                        }

                        foreach (var idSubGrupo in hijosGrupos)
                        {
                            if (grupos.ContainsKey(idSubGrupo))
                            {
                                grupo.Agregar(grupos[idSubGrupo]);
                            }
                        }
                    }

                    lista.Add(grupo);
                }
            }

            return lista;
        }

        private PermisoSimple ObtenerPermisoSimplePorId(int id, SqlConnection conn)
        {
            SqlCommand cmd = new SqlCommand("SELECT Nombre FROM Permiso WHERE Id = @Id", conn);
            cmd.Parameters.AddWithValue("@Id", id);
            return new PermisoSimple
            {
                Nombre = cmd.ExecuteScalar().ToString()
            };
        }
    }
}