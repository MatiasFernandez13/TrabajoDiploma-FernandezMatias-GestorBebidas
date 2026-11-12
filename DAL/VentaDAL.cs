using BE;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;

namespace DAL
{
    public class VentaDAL
    {
        public int RegistrarVenta(Venta venta, ACCESO acceso)
        {
            List<SqlParameter> parametros = new List<SqlParameter>
            {
                acceso.CrearParametro("@Fecha", venta.Fecha),
                acceso.CrearParametro("@UsuarioId", venta.UsuarioId),
                acceso.CrearParametro("@ClienteId", venta.ClienteId),
                acceso.CrearParametro("@Zona", venta.Zona),
                acceso.CrearParametro("@Vendedor", venta.Vendedor)
            };
            int ventaId = Convert.ToInt32(acceso.EscribirEscalar("sp_Ventas_Insertar", parametros));
            if (ventaId <= 0) throw new InvalidOperationException("No se pudo registrar la venta.");
            foreach (IGrouping<int, VentaDetalle> producto in venta.Detalles.GroupBy(d => d.ProductoId).OrderBy(g => g.Key))
            {
                List<SqlParameter> bloqueo = new List<SqlParameter> { acceso.CrearParametro("@ProductoId", producto.Key) };
                if (acceso.LeerSQL("SELECT Id FROM dbo.Productos WITH (UPDLOCK,HOLDLOCK) WHERE Id=@ProductoId AND Activo=1", bloqueo).Rows.Count == 0)
                    throw new InvalidOperationException("El producto ya no está disponible. Revise el carrito.");
                List<SqlParameter> detalle = new List<SqlParameter>
                {
                    acceso.CrearParametro("@VentaId", ventaId),
                    acceso.CrearParametro("@ProductoId", producto.Key),
                    acceso.CrearParametro("@Cantidad", producto.Sum(d => d.Cantidad)),
                    acceso.CrearParametro("@PrecioUnitario", producto.First().PrecioUnitario)
                };
                acceso.Escribir("sp_DetalleVentas_Upsert", detalle);
                foreach (VentaDetalle asignacion in producto.OrderBy(d => d.LoteId))
                {
                    List<SqlParameter> descuento = new List<SqlParameter>
                    {
                        acceso.CrearParametro("@LoteId", asignacion.LoteId),
                        acceso.CrearParametro("@ProductoId", asignacion.ProductoId),
                        acceso.CrearParametro("@Cantidad", asignacion.Cantidad)
                    };
                    int filas = acceso.EscribirSQL(@"UPDATE dbo.Lote SET Cantidad=Cantidad-@Cantidad
                        WHERE Id=@LoteId AND ProductoId=@ProductoId AND Activo=1 AND @Cantidad>0 AND Cantidad>=@Cantidad
                          AND FechaIngreso<=CONVERT(date,GETDATE()) AND FechaVencimiento>=CONVERT(date,GETDATE())", descuento);
                    if (filas != 1)
                        throw new InvalidOperationException($"El lote {asignacion.LoteNumero ?? asignacion.LoteId.ToString()} no tiene las {asignacion.Cantidad} unidades disponibles o dejó de estar vigente. No se registró la venta. Quite ese producto y vuelva a elegir otro lote o una combinación.");
                    List<SqlParameter> trazabilidad = new List<SqlParameter>
                    {
                        acceso.CrearParametro("@VentaId", ventaId), acceso.CrearParametro("@ProductoId", asignacion.ProductoId),
                        acceso.CrearParametro("@LoteId", asignacion.LoteId), acceso.CrearParametro("@Cantidad", asignacion.Cantidad)
                    };
                    acceso.EscribirSQL("INSERT dbo.DetalleVentaLote(VentaId,ProductoId,LoteId,Cantidad) VALUES(@VentaId,@ProductoId,@LoteId,@Cantidad)", trazabilidad);
                }
                new LoteDAL().ActualizarStockEnProducto(producto.Key, acceso);
            }
            return ventaId;
        }
    }
}
