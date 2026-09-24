using System;
using System.Collections.Generic;

namespace BE
{
    public class ResultadoReporteVentas
    {
        public List<ReporteVentaItem> Actual { get; set; } = new List<ReporteVentaItem>();
        public List<ReporteVentaItem> Anterior { get; set; }
        public DateTime? FechaDesdeAnterior { get; set; }
        public DateTime? FechaHastaAnterior { get; set; }
    }

    public class CatalogoReportes
    {
        public List<Producto> Productos { get; set; } = new List<Producto>();
        public List<string> Zonas { get; set; } = new List<string>();
        public List<string> Categorias { get; set; } = new List<string>();
    }
}
