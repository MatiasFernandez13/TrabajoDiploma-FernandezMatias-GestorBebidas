using BE;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace DAL
{
    public class BitacoraDAL
    {
        public void Insertar(Bitacora b)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            try
            {
                List<SqlParameter> parametros = new List<SqlParameter>();
                if (b.UsuarioId > 0)
                    parametros.Add(acceso.CrearParametro("@UsuarioId", b.UsuarioId));
                else
                    parametros.Add(new SqlParameter("@UsuarioId", SqlDbType.Int) { Value = DBNull.Value });
                parametros.Add(acceso.CrearParametro("@FechaRegistro", b.FechaRegistro));
                parametros.Add(acceso.CrearParametro("@Entidad", b.Entidad));
                parametros.Add(acceso.CrearParametro("@Accion", b.Accion));
                parametros.Add(acceso.CrearParametro("@Detalle", b.Detalle));
                acceso.Escribir("sp_Bitacora_Insertar", parametros);
            }
            catch (Exception ex)
            {
                throw new Exception("Error en BitacoraDAL.Insertar", ex);
            }
            finally
            {
                acceso.Cerrar();
            }
        }

        public void Insertar(Bitacora b, ACCESO BA)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            try
            {
                List<SqlParameter> parametros = new List<SqlParameter>();
                if (b.UsuarioId > 0)
                    parametros.Add(acceso.CrearParametro("@UsuarioId", b.UsuarioId));
                else
                    parametros.Add(new SqlParameter("@UsuarioId", SqlDbType.Int) { Value = DBNull.Value });
                parametros.Add(BA.CrearParametro("@FechaRegistro", b.FechaRegistro));
                parametros.Add(BA.CrearParametro("@Entidad", b.Entidad));
                parametros.Add(BA.CrearParametro("@Accion", b.Accion));
                parametros.Add(BA.CrearParametro("@Detalle", b.Detalle));
                acceso.Escribir("sp_Bitacora_Insertar", parametros);
            }
            catch (Exception ex)
            {
                throw new Exception("Error en BitacoraDAL.Insertar", ex);
            }
        }

        public List<Bitacora> Buscar(DateTime? desde, DateTime? hasta, string usuario, string accion)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            try
            {
                string sql = @"
                                SELECT b.Id,
                                       b.UsuarioId,
                                       u.NombreUsuario,
                                       b.FechaRegistro,
                                       b.Entidad,
                                       b.Accion,
                                       b.Detalle
                                FROM dbo.Bitacora b
                                LEFT JOIN dbo.Usuarios u ON b.UsuarioId = u.Id
                                WHERE (@Desde IS NULL OR b.FechaRegistro >= @Desde)
                                  AND (@Hasta IS NULL OR b.FechaRegistro <= @Hasta)
                                  AND (@Usuario IS NULL OR u.NombreUsuario LIKE '%' + @Usuario + '%')
                                  AND (@Accion IS NULL OR b.Accion LIKE '%' + @Accion + '%')
                                ORDER BY b.FechaRegistro DESC;";
                List<SqlParameter> parametros = new List<SqlParameter>
                {
                    new SqlParameter("@Desde", SqlDbType.DateTime2)
                    {
                        Value = (object)desde ?? DBNull.Value
                    },
                    new SqlParameter("@Hasta", SqlDbType.DateTime2)
                    {
                        Value = (object)hasta ?? DBNull.Value
                    },
                    new SqlParameter("@Usuario", SqlDbType.NVarChar, 200)
                    {
                        Value = (object)usuario ?? DBNull.Value
                    },
                    new SqlParameter("@Accion", SqlDbType.NVarChar, 100)
                    {
                        Value = (object)accion ?? DBNull.Value
                    }
                };
                DataTable dt = acceso.LeerSQL(sql, parametros);
                List<Bitacora> lista = new List<Bitacora>();
                foreach (DataRow fila in dt.Rows)
                {
                    lista.Add(new Bitacora { Id = Convert.ToInt32(fila["Id"]), UsuarioId = fila["UsuarioId"] != DBNull.Value ? Convert.ToInt32(fila["UsuarioId"]) : 0, UsuarioNombre = fila["NombreUsuario"] != DBNull.Value ? fila["NombreUsuario"].ToString() : string.Empty, FechaRegistro = Convert.ToDateTime(fila["FechaRegistro"]), Entidad = fila["Entidad"].ToString(), Accion = fila["Accion"].ToString(), Detalle = fila["Detalle"].ToString() });
                }

                return lista;
            }
            catch (Exception ex)
            {
                throw new Exception("Error en BitacoraDAL.Buscar", ex);
            }
            finally
            {
                acceso.Cerrar();
            }
        }
    }
}
