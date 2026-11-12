using BE;
using System;
using System.Collections.Generic;
using System.Linq;

namespace BLL
{
    public class SeleccionLotesBLL
    {
        public List<OpcionLotesVenta> CrearOpciones(SolicitudSeleccionLotes solicitud)
        {
            if (solicitud == null || solicitud.Producto == null)
                throw new ArgumentNullException(nameof(solicitud));
            if (solicitud.Cantidad <= 0)
                throw new ArgumentException("La cantidad debe ser mayor a cero.");
            if (solicitud.Reservas.Any(d => d.ProductoId == solicitud.Producto.Id && (!d.LoteId.HasValue || d.Cantidad <= 0)))
                throw new ArgumentException("El carrito contiene una selección de lotes inválida. Quite ese producto y vuelva a seleccionarlo.");
            Dictionary<int, int> reservas = solicitud.Reservas.Where(d => d.ProductoId == solicitud.Producto.Id && d.LoteId.HasValue)
                .GroupBy(d => d.LoteId.Value).ToDictionary(g => g.Key, g => g.Sum(d => d.Cantidad));
            List<Lote> disponibles = solicitud.Lotes.Where(l => l.ProductoId == solicitud.Producto.Id && l.Activo && l.FechaIngreso.Date <= DateTime.Today && l.FechaVencimiento.Date >= DateTime.Today)
                .OrderBy(l => l.FechaIngreso).ThenBy(l => l.Id)
                .Select(l => new Lote { Id = l.Id, ProductoId = l.ProductoId, NumeroLote = l.NumeroLote, FechaIngreso = l.FechaIngreso, FechaVencimiento = l.FechaVencimiento, Activo = true, Cantidad = Math.Max(0, l.Cantidad - (reservas.TryGetValue(l.Id, out int reservadas) ? reservadas : 0)) })
                .Where(l => l.Cantidad > 0).ToList();
            List<OpcionLotesVenta> opciones = new List<OpcionLotesVenta>();
            foreach (Lote lote in disponibles.Where(l => l.Cantidad >= solicitud.Cantidad).OrderByDescending(l => l.Id == solicitud.LotePreferidoId))
            {
                opciones.Add(new OpcionLotesVenta
                {
                    Descripcion = $"Lote {lote.NumeroLote}: {solicitud.Cantidad} unidades (disponibles: {lote.Cantidad})",
                    Detalles = new List<VentaDetalle> { CrearDetalle(solicitud, lote, solicitud.Cantidad) }
                });
            }
            if (disponibles.Sum(l => (long)l.Cantidad) >= solicitud.Cantidad)
            {
                int pendiente = solicitud.Cantidad;
                List<VentaDetalle> distribucion = new List<VentaDetalle>();
                foreach (Lote lote in disponibles.OrderByDescending(l => l.Id == solicitud.LotePreferidoId))
                {
                    int cantidad = Math.Min(pendiente, lote.Cantidad);
                    if (cantidad > 0)
                        distribucion.Add(CrearDetalle(solicitud, lote, cantidad));
                    pendiente -= cantidad;
                    if (pendiente == 0)
                        break;
                }
                if (distribucion.Count > 1)
                    opciones.Add(new OpcionLotesVenta { Descripcion = "Combinar lotes: " + string.Join(" + ", distribucion.Select(d => $"{d.LoteNumero} ({d.Cantidad} u.)")), Detalles = distribucion });
            }
            return opciones;
        }

        private static VentaDetalle CrearDetalle(SolicitudSeleccionLotes solicitud, Lote lote, int cantidad)
        {
            return new VentaDetalle { ProductoId = solicitud.Producto.Id, ProductoNombre = solicitud.Producto.Nombre, PrecioUnitario = solicitud.Producto.Precio, Cantidad = cantidad, LoteId = lote.Id, LoteNumero = lote.NumeroLote };
        }
    }
}
