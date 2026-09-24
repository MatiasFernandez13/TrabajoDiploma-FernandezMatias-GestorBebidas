using BE;
using System;
using System.Collections.Generic;
using System.Data;

namespace DAL
{
    public class VentaDAL
    {
        public int RegistrarVenta(Venta venta)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                int ventaId = RegistrarVenta(venta, acceso);
                acceso.ConfirmarTransaccion();
                return ventaId;
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

        public int RegistrarVenta(Venta venta, ACCESO acceso)
        {
            try
            {
                List<System.Data.SqlClient.SqlParameter> paramsVenta = new List<System.Data.SqlClient.SqlParameter>
                {
                    acceso.CrearParametro("@Fecha", venta.Fecha),
                    acceso.CrearParametro("@UsuarioId", venta.UsuarioId),
                    acceso.CrearParametro("@ClienteId", venta.ClienteId),
                    acceso.CrearParametro("@Zona", venta.Zona),
                    acceso.CrearParametro("@Vendedor", venta.Vendedor)
                };
                object resVentaId = acceso.EscribirEscalar("sp_Ventas_Insertar", paramsVenta);
                int ventaId = 0;
                if (resVentaId != null && resVentaId != DBNull.Value)
                    ventaId = Convert.ToInt32(resVentaId);
                if (ventaId <= 0)
                {
                    throw new Exception("No se pudo obtener el Id de la venta recién insertada (sp_Ventas_Insertar devolvió NULL/0).\n\n" + "👉 CAUSA MÁS COMÚN: El stored procedure usa 'RETURN SCOPE_IDENTITY()' en vez de 'SELECT SCOPE_IDENTITY()'.\n" + "👉 SOLUCIÓN (EN SSMS sobre BaseGestionBebidasMF): Ejecutá NUEVAMENTE el script:\n" + "   BASE\\ScriptsClientes\\08_sp_Ventas_Insertar_ConClienteId.sql\n" + "   (actualizado a la VERSIÓN 3 que ya usa SELECT para que C# lo capture correctamente).");
                }

                foreach (VentaDetalle detalle in venta.Detalles)
                {
                    List<System.Data.SqlClient.SqlParameter> paramsDetalle = new List<System.Data.SqlClient.SqlParameter>
                    {
                        acceso.CrearParametro("@VentaId", ventaId),
                        acceso.CrearParametro("@ProductoId", detalle.ProductoId),
                        acceso.CrearParametro("@Cantidad", detalle.Cantidad),
                        acceso.CrearParametro("@PrecioUnitario", detalle.PrecioUnitario)
                    };
                    acceso.Escribir("sp_DetalleVentas_Upsert", paramsDetalle);
                    DescontarStockDetalle(detalle, acceso);
                    int stockActual = CalcularStockTotalLotes(detalle.ProductoId, acceso);
                    List<System.Data.SqlClient.SqlParameter> paramsStock = new List<System.Data.SqlClient.SqlParameter>
                    {
                        acceso.CrearParametro("@ProductoId", detalle.ProductoId),
                        acceso.CrearParametro("@Stock", stockActual)
                    };
                    acceso.Escribir("sp_Lote_ActualizarStockProducto", paramsStock);
                }

                return ventaId;
            }
            catch (Exception ex)
            {
                string msg = $"Error en VentaDAL.RegistrarVenta: {ex.Message}";
                if (ex.InnerException != null)
                {
                    msg += $"\n→ Detalle BD: {ex.InnerException.Message}";
                    if (ex.InnerException.InnerException != null)
                        msg += $"\n→ Info extra: {ex.InnerException.InnerException.Message}";
                }

                msg += "\n\n⚠️ Verificá haber ejecutado TODOS los scripts SQL en SSMS:" + "\n  - 07_AlterTable_Ventas_Zona_Vendedor.sql (agrega columnas Zona/Vendedor)" + "\n  - 08_sp_Ventas_Insertar_ConClienteId.sql" + "\n  - sp_DetalleVentas_Upsert / sp_Lote_ListarPorProducto / sp_Lote_ActualizarStockProducto / sp_Lote_CalcularStockTotal";
                throw new Exception(msg, ex);
            }
        }

        private static void DescontarStockDetalle(VentaDetalle detalle, ACCESO acceso)
        {
            if (detalle.LoteId.HasValue)
            {
                DescontarDeLoteEspecifico(detalle.ProductoId, detalle.LoteId.Value, detalle.Cantidad, acceso);
            }
            else
            {
                DescontarLotesFIFO(detalle.ProductoId, detalle.Cantidad, acceso);
            }
        }

        private static void DescontarDeLoteEspecifico(int productoId, int loteId, int cantidadVendida, ACCESO acceso)
        {
            List<System.Data.SqlClient.SqlParameter> paramsLotes = new List<System.Data.SqlClient.SqlParameter>
            {
                acceso.CrearParametro("@ProductoId", productoId)
            };
            DataTable lotes = acceso.Leer("sp_Lote_ListarPorProducto", paramsLotes);
            DataRow filaLote = null;
            foreach (DataRow fila in lotes.Rows)
            {
                if (Convert.ToInt32(fila["Id"]) == loteId)
                {
                    filaLote = fila;
                    break;
                }
            }

            if (filaLote == null)
                throw new Exception($"No se encontró el Lote Id={loteId} para el producto Id={productoId}. " + "Probablemente haya sido eliminado. Cancelar la venta y volver a seleccionar.");
            int stockLote = Convert.ToInt32(filaLote["Cantidad"]);
            if (stockLote < cantidadVendida)
                throw new Exception($"Stock insuficiente en el Lote #{loteId}. " + $"Dispone de {stockLote} unidades y se requieren {cantidadVendida}.");
            List<System.Data.SqlClient.SqlParameter> paramsUpd = new List<System.Data.SqlClient.SqlParameter>
            {
                acceso.CrearParametro("@Cantidad", cantidadVendida),
                acceso.CrearParametro("@Id", loteId)
            };
            acceso.EscribirSQL("UPDATE Lote SET Cantidad = Cantidad - @Cantidad WHERE Id = @Id", paramsUpd);
        }

        private static void DescontarLotesFIFO(int productoId, int cantidadVendida, ACCESO acceso)
        {
            List<System.Data.SqlClient.SqlParameter> paramsLotes = new List<System.Data.SqlClient.SqlParameter>
            {
                acceso.CrearParametro("@ProductoId", productoId)
            };
            DataTable lotes = acceso.Leer("sp_Lote_ListarPorProducto", paramsLotes);
            int restante = cantidadVendida;
            foreach (DataRow fila in lotes.Rows)
            {
                if (restante <= 0)
                    break;
                int loteId = Convert.ToInt32(fila["Id"]);
                int cantidadLote = Convert.ToInt32(fila["Cantidad"]);
                int aDescontar = Math.Min(restante, cantidadLote);
                List<System.Data.SqlClient.SqlParameter> paramsUpd = new List<System.Data.SqlClient.SqlParameter>
                {
                    acceso.CrearParametro("@Cantidad", aDescontar),
                    acceso.CrearParametro("@Id", loteId)
                };
                acceso.EscribirSQL("UPDATE Lote SET Cantidad = Cantidad - @Cantidad WHERE Id = @Id", paramsUpd);
                restante -= aDescontar;
            }

            if (restante > 0)
                throw new Exception($"Stock insuficiente en lotes para el producto Id={productoId}. " + $"Faltan {restante} unidades.");
        }

        private static int CalcularStockTotalLotes(int productoId, ACCESO acceso)
        {
            List<System.Data.SqlClient.SqlParameter> parametros = new List<System.Data.SqlClient.SqlParameter>
            {
                acceso.CrearParametro("@ProductoId", productoId)
            };
            object resultado = acceso.EscribirEscalar("sp_Lote_CalcularStockTotal", parametros);
            return resultado != null && resultado != DBNull.Value ? Convert.ToInt32(resultado) : 0;
        }
    }
}
