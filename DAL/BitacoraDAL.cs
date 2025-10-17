using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;
using System.Data.SqlClient;
using BE;

namespace DAL
{
    public class BitacoraDAL
    {
        private readonly string _connectionString = ConfigurationManager.ConnectionStrings["MiConexion"].ConnectionString;

        public void Insertar(Bitacora b)
        {
            using (var conn = new SqlConnection(_connectionString))
            {
                conn.Open();
                var cmd = new SqlCommand(@"
            INSERT INTO Bitacora (UsuarioId, FechaRegistro, Entidad, Accion, Detalle)
            VALUES (@UsuarioId, @FechaRegistro, @Entidad, @Accion, @Detalle)", conn);

                cmd.Parameters.AddWithValue("@UsuarioId", b.UsuarioId);
                cmd.Parameters.AddWithValue("@FechaRegistro", b.FechaRegistro);
                cmd.Parameters.AddWithValue("@Entidad", b.Entidad ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@Accion", b.Accion ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@Detalle", b.Detalle ?? (object)DBNull.Value);

                cmd.ExecuteNonQuery();
            }
        }

        public List<Bitacora> Buscar(DateTime? desde = null, DateTime? hasta = null, string usuario = null, string accion = null)
        {
            var lista = new List<Bitacora>();

            using (var conn = new SqlConnection(_connectionString))
            {
                conn.Open();

                var query = @"
                            SELECT b.Id, b.UsuarioId, u.NombreUsuario, b.FechaRegistro, b.Entidad, b.Accion, b.Detalle
                            FROM Bitacora b
                            INNER JOIN Usuarios u ON b.UsuarioId = u.Id
                            WHERE ( @Desde IS NULL OR b.FechaRegistro >= @Desde )
                            AND ( @Hasta IS NULL OR b.FechaRegistro <= @Hasta )
                            AND ( @Usuario IS NULL OR u.NombreUsuario LIKE '%' + @Usuario + '%' )
                            AND ( @Accion IS NULL OR b.Accion LIKE '%' + @Accion + '%' )
                            ORDER BY b.FechaRegistro DESC";

                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Desde", (object)desde ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Hasta", (object)hasta ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Usuario", (object)usuario ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Accion", (object)accion ?? DBNull.Value);

                    var reader = cmd.ExecuteReader();
                    while (reader.Read())
                    {
                        lista.Add(new Bitacora
                        {
                            Id = (int)reader["Id"],
                            UsuarioId = (int)reader["UsuarioId"],
                            UsuarioNombre = reader["NombreUsuario"].ToString(),
                            FechaRegistro = (DateTime)reader["FechaRegistro"],
                            Entidad = reader["Entidad"].ToString(),
                            Accion = reader["Accion"].ToString(),
                            Detalle = reader["Detalle"].ToString()
                        });
                    }
                }
            }

            return lista;
        }
    }
}
