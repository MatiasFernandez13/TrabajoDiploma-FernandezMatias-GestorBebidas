using System;

namespace BE
{
    public class ReporteVentaItem
    {
        public int VentaId { get; set; }
        public DateTime Fecha { get; set; }
        public string Vendedor { get; set; }
        public int Cantidad { get; set; }
        public string Producto { get; set; }
        public string Cliente { get; set; }
        public string Zona { get; set; }
        public decimal PrecioUnitario { get; set; }
        public decimal Subtotal { get; set; }
    }
}
