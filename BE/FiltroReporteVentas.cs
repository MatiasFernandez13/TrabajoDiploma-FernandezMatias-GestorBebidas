using System;

namespace BE
{
    public class FiltroReporteVentas
    {
        public string Zona { get; set; }
        public int? ProductoId { get; set; }
        public DateTime? FechaDesde { get; set; }
        public DateTime? FechaHasta { get; set; }
    }
}
