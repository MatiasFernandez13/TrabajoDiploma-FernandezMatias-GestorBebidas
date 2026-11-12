using System.Collections.Generic;

namespace BE
{
    public class SolicitudProducto
    {
        public Producto Producto { get; set; }
        public Lote Lote { get; set; }
    }

    public class ResultadoIngresoLote
    {
        public Lote Lote { get; set; }
        public bool Consolidado { get; set; }
    }

    public class SolicitudSeleccionLotes
    {
        public Producto Producto { get; set; }
        public int Cantidad { get; set; }
        public int? LotePreferidoId { get; set; }
        public List<Lote> Lotes { get; set; } = new List<Lote>();
        public List<VentaDetalle> Reservas { get; set; } = new List<VentaDetalle>();
    }

    public class OpcionLotesVenta
    {
        public string Descripcion { get; set; }
        public List<VentaDetalle> Detalles { get; set; } = new List<VentaDetalle>();
        public override string ToString() => Descripcion;
    }
}
