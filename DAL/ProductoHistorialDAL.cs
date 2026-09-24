using BE;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace DAL
{
    public class ProductoHistorialDAL
    {
        public void InsertarSnapshot(Producto p, string accion)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                InsertarSnapshot(p, accion, acceso);
                acceso.ConfirmarTransaccion();
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

        public void InsertarSnapshot(Producto p, string accion, ACCESO acceso)
        {
            try
            {
                List<SqlParameter> parametros = new List<SqlParameter>
                {
                    acceso.CrearParametro("@IdProducto", p.Id),
                    acceso.CrearParametro("@Nombre", p.Nombre),
                    acceso.CrearParametro("@CategoriaId", p.Categoria),
                    acceso.CrearParametro("@Precio", p.Precio),
                    acceso.CrearParametro("@LitrosPorUnidad", p.LitrosPorUnidad),
                    acceso.CrearParametro("@Stock", p.Stock),
                    acceso.CrearParametro("@Activo", p.Activo),
                    acceso.CrearParametro("@Accion", accion ?? "Modificar")
                };
                acceso.Escribir("sp_ProductoHistorial_Insertar", parametros);
            }
            catch (Exception ex)
            {
                throw new Exception("Error en ProductoHistorialDAL.InsertarSnapshot", ex);
            }
        }

        public List<(int IdHistorial, DateTime Fecha, Producto Snapshot)> ListarPorProducto(int idProducto)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            try
            {
                List<SqlParameter> parametros = new List<SqlParameter>
                {
                    acceso.CrearParametro("@Id", idProducto)
                };
                DataTable dt = acceso.Leer("sp_ProductoHistorial_ListarPorProducto", parametros);
                List<(int, DateTime, Producto)> lista = new List<(int, DateTime, Producto)>();
                foreach (DataRow rd in dt.Rows)
                {
                    Producto p = new Producto
                    {
                        Id = idProducto,
                        Nombre = rd["Nombre"].ToString(),
                        Categoria = rd["CategoriaId"] != DBNull.Value ? Convert.ToInt32(rd["CategoriaId"]) : 0,
                        Precio = rd["Precio"] != DBNull.Value ? Convert.ToDecimal(rd["Precio"]) : 0,
                        LitrosPorUnidad = rd["LitrosPorUnidad"] != DBNull.Value ? Convert.ToDouble(rd["LitrosPorUnidad"]) : 0,
                        Stock = rd["Stock"] != DBNull.Value ? Convert.ToInt32(rd["Stock"]) : 0,
                        Activo = rd["Activo"] != DBNull.Value && Convert.ToBoolean(rd["Activo"])
                    };
                    lista.Add((Convert.ToInt32(rd["IdHistorial"]), Convert.ToDateTime(rd["Fecha"]), p));
                }

                return lista;
            }
            catch (Exception ex)
            {
                throw new Exception("Error en ProductoHistorialDAL.ListarPorProducto", ex);
            }
            finally
            {
                acceso.Cerrar();
            }
        }
    }
}
