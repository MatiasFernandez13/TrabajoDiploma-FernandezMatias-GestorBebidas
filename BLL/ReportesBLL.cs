using BE;
using DAL;
using System;
using System.Collections.Generic;
using System.Linq;

namespace BLL
{
    public class ReportesBLL
    {
        private readonly ReportesDAL _reportesDal = new ReportesDAL();
        public List<string> ListarZonas()
        {
            try
            {
                return _reportesDal.ListarZonas();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar las zonas para reportes.", ex);
            }
        }

        public List<Producto> ListarProductosBasicos()
        {
            try
            {
                return _reportesDal.ListarProductosBasicos();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar los productos para reportes.", ex);
            }
        }

        public List<ReporteVentaItem> GenerarReporteVentas(FiltroReporteVentas filtro)
        {
            if (filtro == null)
                throw new ArgumentNullException(nameof(filtro));
            if (filtro.FechaDesde.HasValue && filtro.FechaHasta.HasValue && filtro.FechaDesde.Value.Date > filtro.FechaHasta.Value.Date)
                throw new ArgumentException("La fecha desde no puede ser posterior a la fecha hasta.");
            try
            {
                List<ReporteVentaItem> resultado = _reportesDal.GenerarReporteVentas(filtro);
                decimal total = resultado.Sum(r => r.Subtotal);
                int cant = resultado.Sum(r => r.Cantidad);
                BitacoraHelper.Registrar("Reporte", "ReporteVentas", $"Generado reporte de ventas: " + $"Zona={ZonaONulo(filtro.Zona)}, " + $"ProductoId={filtro.ProductoId?.ToString() ?? "NULL"}, " + $"FechaDesde={FechaONula(filtro.FechaDesde)}, " + $"FechaHasta={FechaONula(filtro.FechaHasta)} " + $"→ {resultado.Count} fila(s), {cant} unidad(es), ${total:N2}");
                return resultado;
            }
            catch (Exception ex)
            {
                BitacoraHelper.Registrar("Reporte", "Error", $"Error al generar reporte de ventas: {MensajeCompleto(ex)}");
                throw new Exception("Error al generar el reporte de ventas.", ex);
            }
        }

        public List<ReporteStockItem> GenerarReporteStock(FiltroReporteStock filtro)
        {
            try
            {
                if (filtro == null)
                    throw new ArgumentNullException(nameof(filtro));
                if (filtro.Umbral < 1)
                    throw new ArgumentException("El umbral debe ser positivo.", nameof(filtro));
                List<ReporteStockItem> resultado = _reportesDal.GenerarReporteStock().Where(filtro.Incluye).ToList();
                int stockTotal = resultado.Sum(r => r.StockTotal);
                decimal valorizado = resultado.Sum(r => r.StockTotal * r.Precio);
                BitacoraHelper.Registrar("Reporte", "ReporteStock", $"Generado reporte de stock: {resultado.Count} producto(s), " + $"{stockTotal} unidad(es), valorizado ${valorizado:N2}");
                return resultado;
            }
            catch (Exception ex)
            {
                BitacoraHelper.Registrar("Reporte", "Error", $"Error al generar reporte de stock: {MensajeCompleto(ex)}");
                throw new Exception("Error al generar el reporte de stock.", ex);
            }
        }

        public CatalogoReportes CargarCatalogo()
        {
            return new CatalogoReportes
            {
                Productos = ListarProductosBasicos(),
                Zonas = ListarZonas(),
                Categorias = GenerarReporteStock(new FiltroReporteStock()).Select(producto => producto.Categoria).Distinct().OrderBy(categoria => categoria).ToList()
            };
        }

        public ResultadoReporteVentas GenerarVentasComparadas(FiltroReporteVentas filtro)
        {
            ResultadoReporteVentas resultado = new ResultadoReporteVentas
            {
                Actual = GenerarReporteVentas(filtro)
            };
            if (filtro.FechaDesde.HasValue && filtro.FechaHasta.HasValue)
            {
                int dias = (filtro.FechaHasta.Value.Date - filtro.FechaDesde.Value.Date).Days + 1;
                if (filtro.FechaDesde.Value.Date >= new DateTime(1753, 1, 1).AddDays(dias))
                {
                    FiltroReporteVentas anterior = new FiltroReporteVentas
                    {
                        Zona = filtro.Zona,
                        ProductoId = filtro.ProductoId,
                        FechaDesde = filtro.FechaDesde.Value.Date.AddDays(-dias),
                        FechaHasta = filtro.FechaDesde.Value.Date.AddDays(-1)
                    };
                    resultado.Anterior = GenerarReporteVentas(anterior);
                    resultado.FechaDesdeAnterior = anterior.FechaDesde;
                    resultado.FechaHastaAnterior = anterior.FechaHasta;
                }
            }

            return resultado;
        }

        private static string ZonaONulo(string zona) => string.IsNullOrWhiteSpace(zona) ? "TODAS" : zona;
        private static string FechaONula(DateTime? fecha) => fecha.HasValue ? fecha.Value.ToString("yyyy-MM-dd") : "SIN FILTRO";
        private static string MensajeCompleto(Exception ex) => ex.InnerException != null ? $"{ex.Message} → {ex.InnerException.Message}" : ex.Message;
    }
}
