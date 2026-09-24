using System;
using System.Collections.Generic;
using System.Data;

namespace BE
{
    public class AnalisisVentasReporte
    {
        public IReadOnlyCollection<ReporteVentaItem> Ventas { get; set; } = new List<ReporteVentaItem>();
        public bool Mensual { get; set; }
        public string Agrupacion { get; set; } = "Producto";
    }

    public class AnalisisStockReporte
    {
        public IReadOnlyCollection<ReporteStockItem> Stock { get; set; } = new List<ReporteStockItem>();
        public int Umbral { get; set; } = 10;
    }

    public class ComparacionReporte
    {
        public decimal Actual { get; set; }
        public decimal? Anterior { get; set; }
    }

    public class PuntoReporte
    {
        public string Etiqueta { get; set; } = string.Empty;
        public decimal Valor { get; set; }
    }

    public class DatosGraficoReporte
    {
        public string Titulo { get; set; } = string.Empty;
        public PuntoReporte[] Puntos { get; set; } = Array.Empty<PuntoReporte>();
        public bool EsEvolucion { get; set; }
    }

    public class ReporteIndicador
    {
        public string Nombre { get; set; } = string.Empty;
        public string Valor { get; set; } = string.Empty;
    }

    public class ReporteDocumento
    {
        public string Titulo { get; set; } = string.Empty;
        public string Filtros { get; set; } = string.Empty;
        public DateTime Generado { get; set; }
        public string Usuario { get; set; } = string.Empty;
        public DataTable Tabla { get; set; } = new DataTable();
        public ReporteIndicador[] Resumen { get; set; } = Array.Empty<ReporteIndicador>();
        public string Nota { get; set; } = string.Empty;
    }
}
