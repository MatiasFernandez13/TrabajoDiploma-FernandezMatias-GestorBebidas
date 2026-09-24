using System;

namespace BE
{
    public enum EstadoReporteStock
    {
        Todos,
        SinStock,
        StockBajo,
        PorVencer,
        ConLotesVencidos
    }

    public class FiltroReporteStock
    {
        public int? ProductoId { get; set; }
        public string Categoria { get; set; }
        public EstadoReporteStock Estado { get; set; }
        public int Umbral { get; set; } = 10;

        public bool Incluye(ReporteStockItem producto)
        {
            if (producto == null)
                throw new ArgumentNullException(nameof(producto));
            if (ProductoId.HasValue && producto.ProductoId != ProductoId.Value)
                return false;
            if (!string.IsNullOrEmpty(Categoria) && producto.Categoria != Categoria)
                return false;
            switch (Estado)
            {
                case EstadoReporteStock.SinStock:
                    return producto.StockTotal == 0;
                case EstadoReporteStock.StockBajo:
                    return producto.StockTotal > 0 && producto.StockTotal <= Umbral;
                case EstadoReporteStock.PorVencer:
                    return producto.LotesPorVencer > 0;
                case EstadoReporteStock.ConLotesVencidos:
                    return producto.LotesVencidos > 0;
                default:
                    return true;
            }
        }
    }
}
