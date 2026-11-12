using BE;
using System;
using System.Collections.Generic;
using System.Data;

namespace DAL
{
    public class LoteDAL
    {
        public void Agregar(Lote lote)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                Agregar(lote, acceso);
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

        public void Eliminar(Lote lote)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                Eliminar(lote, acceso);
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

        public ResultadoIngresoLote Agregar(Lote lote, ACCESO acceso)
        {
            List<System.Data.SqlClient.SqlParameter> parametros = new List<System.Data.SqlClient.SqlParameter>
            {
                acceso.CrearParametro("@NumeroLote", lote.NumeroLote),
                acceso.CrearParametro("@FechaIngreso", lote.FechaIngreso),
                acceso.CrearParametro("@FechaVencimiento", lote.FechaVencimiento),
                acceso.CrearParametro("@Cantidad", lote.Cantidad),
                acceso.CrearParametro("@ProductoId", lote.ProductoId)
            };
            try
            {
                DataTable resultado = acceso.Leer("sp_Lote_Agregar", parametros);
                lote.Id = Convert.ToInt32(resultado.Rows[0]["Id"]);
                return new ResultadoIngresoLote { Lote = lote, Consolidado = Convert.ToBoolean(resultado.Rows[0]["Consolidado"]) };
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message, ex);
            }
        }

        public void ActualizarStockEnProducto(int productoId, ACCESO acceso)
        {
            try
            {
                int stockTotal = CalcularStockTotal(productoId, acceso);
                List<System.Data.SqlClient.SqlParameter> parametros = new List<System.Data.SqlClient.SqlParameter>
                {
                    acceso.CrearParametro("@ProductoId", productoId),
                    acceso.CrearParametro("@Stock", stockTotal)
                };
                acceso.Escribir("sp_Lote_ActualizarStockProducto", parametros);
            }
            catch (Exception ex)
            {
                throw new Exception("Error en LoteDAL.ActualizarStockEnProducto", ex);
            }
        }

        public void ActualizarCantidad(Lote lote, ACCESO acceso)
        {
            List<System.Data.SqlClient.SqlParameter> parametros = new List<System.Data.SqlClient.SqlParameter>
            {
                acceso.CrearParametro("@Cantidad", lote.Cantidad), acceso.CrearParametro("@Id", lote.Id), acceso.CrearParametro("@ProductoId", lote.ProductoId)
            };
            if (acceso.EscribirSQL("UPDATE dbo.Lote SET Cantidad=@Cantidad WHERE Id=@Id AND ProductoId=@ProductoId AND Activo=1 AND @Cantidad>=0", parametros) != 1)
                throw new ArgumentException("El lote no pertenece al producto o está dado de baja.");
        }

        public Lote BuscarExistente(Lote referencia)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            try
            {
                List<System.Data.SqlClient.SqlParameter> parametros = new List<System.Data.SqlClient.SqlParameter>
                {
                    acceso.CrearParametro("@ProductoId", referencia.ProductoId), acceso.CrearParametro("@Numero", referencia.NumeroLote)
                };
                DataTable tabla = acceso.LeerSQL("SELECT Id,NumeroLote,FechaIngreso,FechaVencimiento,Cantidad,ProductoId,Activo FROM dbo.Lote WHERE ProductoId=@ProductoId AND NumeroLoteClave=dbo.NormalizarIdentificador(@Numero) COLLATE Latin1_General_100_CI_AI", parametros);
                return tabla.Rows.Count == 0 ? null : MapearLote(tabla.Rows[0]);
            }
            finally { acceso.Cerrar(); }
        }

        public void Eliminar(Lote lote, ACCESO acceso)
        {
            List<System.Data.SqlClient.SqlParameter> parametros = new List<System.Data.SqlClient.SqlParameter>
            {
                acceso.CrearParametro("@Id", lote.Id), acceso.CrearParametro("@ProductoId", lote.ProductoId)
            };
            if (acceso.EscribirSQL("UPDATE dbo.Lote SET Activo=0 WHERE Id=@Id AND ProductoId=@ProductoId AND Activo=1", parametros) != 1)
                throw new ArgumentException("El lote no pertenece al producto o ya está dado de baja.");
        }

        public List<Lote> ListarPorProducto(int productoId, ACCESO acceso = null)
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
                    acceso.CrearParametro("@ProductoId", productoId)
                };
                DataTable tabla = acceso.Leer("sp_Lote_ListarPorProducto", parametros);
                List<Lote> lista = new List<Lote>();
                foreach (DataRow fila in tabla.Rows)
                    lista.Add(MapearLote(fila));
                return lista;
            }
            catch (Exception ex)
            {
                throw new Exception("Error en LoteDAL.ListarPorProducto", ex);
            }
            finally
            {
                if (propioAcceso)
                    acceso.Cerrar();
            }
        }

        public int CalcularStockTotal(int productoId, ACCESO acceso = null)
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
                    acceso.CrearParametro("@ProductoId", productoId)
                };
                object resultado = acceso.EscribirEscalar("sp_Lote_CalcularStockTotal", parametros);
                return resultado != null && resultado != DBNull.Value ? Convert.ToInt32(resultado) : 0;
            }
            catch (Exception ex)
            {
                throw new Exception("Error en LoteDAL.CalcularStockTotal", ex);
            }
            finally
            {
                if (propioAcceso)
                    acceso.Cerrar();
            }
        }

        private static Lote MapearLote(DataRow fila)
        {
            return new Lote
            {
                Id = Convert.ToInt32(fila["Id"]),
                NumeroLote = fila["NumeroLote"].ToString(),
                FechaIngreso = Convert.ToDateTime(fila["FechaIngreso"]),
                FechaVencimiento = Convert.ToDateTime(fila["FechaVencimiento"]),
                Cantidad = Convert.ToInt32(fila["Cantidad"]),
                ProductoId = Convert.ToInt32(fila["ProductoId"]),
                Activo = Convert.ToBoolean(fila["Activo"])
            };
        }
    }
}
