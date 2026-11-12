using BE;
using DAL;
using SERVICIOS;
using System;
using System.Collections.Generic;
using System.Linq;

namespace BLL
{
    public class VentaBLL
    {
        private readonly VentaDAL _ventaDAL = new VentaDAL();
        private readonly ProductoDAL _productoDal = new ProductoDAL();
        public Venta ConfirmarVenta(Venta solicitud)
        {
            if (solicitud == null || solicitud.Detalles == null || solicitud.Detalles.Count == 0)
                throw new ArgumentException("El carrito está vacío.");
            if (solicitud.UsuarioId <= 0 || solicitud.Detalles.Any(d => d.ProductoId <= 0 || !d.LoteId.HasValue || d.LoteId.Value <= 0 || d.Cantidad <= 0 || d.PrecioUnitario < 0))
                throw new ArgumentException("La venta debe incluir cantidades positivas y una selección de lotes válida.");
            if (solicitud.Detalles.GroupBy(d => d.ProductoId).Any(g => g.Select(d => d.PrecioUnitario).Distinct().Count() > 1))
                throw new ArgumentException("Cambió el precio de un producto. Quite sus líneas del carrito y vuelva a seleccionarlo.");
            List<VentaDetalle> consolidados = solicitud.Detalles.GroupBy(d => new { d.ProductoId, d.LoteId }).Select(g => new VentaDetalle
            {
                ProductoId = g.Key.ProductoId, LoteId = g.Key.LoteId, LoteNumero = g.First().LoteNumero,
                ProductoNombre = g.First().ProductoNombre, Cantidad = g.Sum(d => d.Cantidad), PrecioUnitario = g.First().PrecioUnitario
            }).OrderBy(d => d.ProductoId).ThenBy(d => d.LoteId).ToList();
            Venta venta = new Venta
            {
                Fecha = DateTime.Now, UsuarioId = solicitud.UsuarioId, ClienteId = solicitud.ClienteId,
                Zona = solicitud.Zona?.Trim(), Vendedor = solicitud.Vendedor?.Trim(), Detalles = consolidados
            };
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                int ventaId = _ventaDAL.RegistrarVenta(venta, acceso);
                venta.Id = ventaId;
                foreach (VentaDetalle detalle in consolidados)
                {
                    Producto p = _productoDal.ObtenerPorId(detalle.ProductoId, acceso);
                    if (p != null)
                    {
                        p.DVH = DigitoVerificador.CalcularDVH(p);
                        _productoDal.Modificar(p, acceso);
                    }
                }

                acceso.RecalcularDVV("Productos");
                acceso.ConfirmarTransaccion();
                BitacoraHelper.Registrar("Venta", "Alta", $"Venta #{ventaId} registrada por UsuarioId={venta.UsuarioId}, ClienteId={venta.ClienteId} " + $"({consolidados.Count} producto(s))");
                return venta;
            }
            catch (Exception ex)
            {
                acceso.CancelarTransaccion();
                BitacoraHelper.Registrar("Venta", "Error", $"Confirmar venta fallida: {MensajeCompleto(ex)}");
                throw;
            }
            finally
            {
                acceso.Cerrar();
            }
        }

        private static string MensajeCompleto(Exception ex) => ex.InnerException != null ? $"{ex.Message} → {ex.InnerException.Message}" : ex.Message;
    }
}
