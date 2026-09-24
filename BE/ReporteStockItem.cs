namespace BE
{
    public class ReporteStockItem
    {
        public int ProductoId { get; set; }
        public string Producto { get; set; }
        public string Categoria { get; set; }
        public int StockTotal { get; set; }
        public decimal Precio { get; set; }
        public double LitrosPorUnidad { get; set; }
        public int LotesActivos { get; set; }
        public int LotesPorVencer { get; set; }
        public int LotesVencidos { get; set; }
    }
}
