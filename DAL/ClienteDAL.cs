using BE;
using System;
using System.Collections.Generic;
using System.Data;

namespace DAL
{
    public class ClienteDAL : MAPPER<Cliente>
    {
        public override int Insertar(Cliente objeto)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                int id = Insertar(objeto, acceso);
                acceso.ConfirmarTransaccion();
                return id;
            }
            catch
            {
                acceso.CancelarTransaccion();
                throw;
            }
            finally
            {
                acceso.Cerrar();
            }
        }

        public override int Modificar(Cliente objeto)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                int filas = Modificar(objeto, acceso);
                acceso.ConfirmarTransaccion();
                return filas;
            }
            catch
            {
                acceso.CancelarTransaccion();
                throw;
            }
            finally
            {
                acceso.Cerrar();
            }
        }

        public override int Eliminar(Cliente objeto)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                int filas = Eliminar(objeto, acceso);
                acceso.ConfirmarTransaccion();
                return filas;
            }
            catch
            {
                acceso.CancelarTransaccion();
                throw;
            }
            finally
            {
                acceso.Cerrar();
            }
        }

        public override List<Cliente> ListarTodos()
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            try
            {
                DataTable tabla = acceso.Leer("sp_Clientes_Listar");
                List<Cliente> lista = new List<Cliente>();
                foreach (DataRow fila in tabla.Rows)
                    lista.Add(Mapear(fila));
                return lista;
            }
            catch (Exception ex)
            {
                throw new Exception("Error en ClienteDAL.ListarTodos", ex);
            }
            finally
            {
                acceso.Cerrar();
            }
        }

        public int Insertar(Cliente objeto, ACCESO acceso)
        {
            List<System.Data.SqlClient.SqlParameter> parametros = new List<System.Data.SqlClient.SqlParameter>
            {
                acceso.CrearParametro("@NombreCompleto", objeto.NombreCompleto),
                acceso.CrearParametro("@Direccion", objeto.Direccion),
                acceso.CrearParametro("@Telefono", objeto.Telefono),
                acceso.CrearParametro("@Email", objeto.Email),
                acceso.CrearParametro("@Zona", objeto.Zona),
                acceso.CrearParametro("@Activo", objeto.Activo),
                acceso.CrearParametro("@DVH", objeto.DVH)
            };
            try
            {
                object resultado = acceso.EscribirEscalar("sp_Clientes_Insertar", parametros);
                return Convert.ToInt32(resultado);
            }
            catch (Exception ex)
            {
                throw new Exception("Error en ClienteDAL.Insertar", ex);
            }
        }

        public int Modificar(Cliente objeto, ACCESO acceso)
        {
            List<System.Data.SqlClient.SqlParameter> parametros = new List<System.Data.SqlClient.SqlParameter>
            {
                acceso.CrearParametro("@Id", objeto.Id),
                acceso.CrearParametro("@NombreCompleto", objeto.NombreCompleto),
                acceso.CrearParametro("@Direccion", objeto.Direccion),
                acceso.CrearParametro("@Telefono", objeto.Telefono),
                acceso.CrearParametro("@Email", objeto.Email),
                acceso.CrearParametro("@Zona", objeto.Zona),
                acceso.CrearParametro("@DVH", objeto.DVH)
            };
            try
            {
                return acceso.Escribir("sp_Clientes_Modificar", parametros);
            }
            catch (Exception ex)
            {
                throw new Exception("Error en ClienteDAL.Modificar", ex);
            }
        }

        public int Eliminar(Cliente objeto, ACCESO acceso)
        {
            List<System.Data.SqlClient.SqlParameter> parametros = new List<System.Data.SqlClient.SqlParameter>
            {
                acceso.CrearParametro("@Id", objeto.Id)
            };
            try
            {
                return acceso.Escribir("sp_Clientes_Eliminar", parametros);
            }
            catch (Exception ex)
            {
                throw new Exception("Error en ClienteDAL.Eliminar", ex);
            }
        }

        public Cliente ObtenerPorId(int id, ACCESO acceso = null)
        {
            bool propioAcceso = acceso == null;
            if (propioAcceso)
            {
                acceso = new ACCESO();
                acceso.Abrir();
            }

            try
            {
                List<System.Data.SqlClient.SqlParameter> parametros = new List<System.Data.SqlClient.SqlParameter>
                {
                    acceso.CrearParametro("@Id", id)
                };
                DataTable tabla = acceso.Leer("sp_Clientes_ObtenerPorId", parametros);
                return tabla.Rows.Count > 0 ? Mapear(tabla.Rows[0]) : null;
            }
            catch (Exception ex)
            {
                throw new Exception("Error en ClienteDAL.ObtenerPorId", ex);
            }
            finally
            {
                if (propioAcceso)
                    acceso.Cerrar();
            }
        }

        public List<string> ListarZonas()
        {
            List<string> lista = new List<string>();
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            try
            {
                DataTable dt = acceso.Leer("sp_Clientes_ListarZonas");
                foreach (DataRow fila in dt.Rows)
                {
                    string zona = fila["Zona"]?.ToString();
                    if (!string.IsNullOrWhiteSpace(zona))
                        lista.Add(zona);
                }
            }
            finally
            {
                acceso.Cerrar();
            }

            return lista;
        }

        private static Cliente Mapear(DataRow fila)
        {
            Cliente c = new Cliente
            {
                Id = Convert.ToInt32(fila["Id"]),
                NombreCompleto = fila["NombreCompleto"]?.ToString() ?? string.Empty,
                Direccion = fila["Direccion"]?.ToString() ?? string.Empty,
                Telefono = fila["Telefono"]?.ToString() ?? string.Empty,
                Email = fila["Email"]?.ToString() ?? string.Empty,
                Zona = fila["Zona"]?.ToString() ?? string.Empty,
                Activo = Convert.ToBoolean(fila["Activo"])
            };
            if (fila.Table.Columns.Contains("DVH") && fila["DVH"] != DBNull.Value)
                c.DVH = Convert.ToDecimal(fila["DVH"]);
            return c;
        }
    }
}
