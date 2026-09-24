using System;
using System.Collections.Generic;
using System.Linq;
using BE;
using System.Data;
using System.Globalization;

namespace BLL;
public class ReporteCalculosBLL
{
    private static readonly CultureInfo Cultura = CultureInfo.GetCultureInfo("es-AR");
    public DatosGraficoReporte RankingVentas(AnalisisVentasReporte solicitud)
    {
        return new DatosGraficoReporte
        {
            Titulo = "5 productos más vendidos · Unidades",
            Puntos = solicitud.Ventas.GroupBy(venta => venta.Producto).OrderByDescending(grupo => grupo.Sum(venta => venta.Cantidad)).Take(5).Select(grupo => new PuntoReporte { Etiqueta = grupo.Key, Valor = grupo.Sum(venta => venta.Cantidad) }).ToArray()
        };
    }

    public DatosGraficoReporte CategoriasStock(AnalisisStockReporte solicitud)
    {
        return new DatosGraficoReporte
        {
            Titulo = "5 categorías con más stock · Unidades",
            Puntos = solicitud.Stock.GroupBy(producto => producto.Categoria).OrderByDescending(grupo => grupo.Sum(producto => producto.StockTotal)).Take(5).Select(grupo => new PuntoReporte { Etiqueta = grupo.Key, Valor = grupo.Sum(producto => producto.StockTotal) }).ToArray()
        };
    }

    public DatosGraficoReporte EstadosStock(AnalisisStockReporte solicitud)
    {
        return new DatosGraficoReporte
        {
            Titulo = "Estado del stock · Productos",
            Puntos = new PuntoReporte[]
            {
                new PuntoReporte
                {
                    Etiqueta = "Sin stock",
                    Valor = solicitud.Stock.Count(producto => producto.StockTotal == 0)
                },
                new PuntoReporte
                {
                    Etiqueta = "Stock bajo",
                    Valor = solicitud.Stock.Count(producto => producto.StockTotal > 0 && producto.StockTotal <= solicitud.Umbral)
                },
                new PuntoReporte
                {
                    Etiqueta = "Sobre el umbral",
                    Valor = solicitud.Stock.Count(producto => producto.StockTotal > solicitud.Umbral)
                }
            }
        };
    }

    public PuntoReporte[] Evolucion(AnalisisVentasReporte solicitud)
    {
        IReadOnlyCollection<ReporteVentaItem> ventas = solicitud.Ventas;
        bool mensual = solicitud.Mensual;
        if (ventas.Count == 0)
            return Array.Empty<PuntoReporte>();
        Dictionary<DateTime, decimal> grupos = ventas.GroupBy(v => mensual ? new DateTime(v.Fecha.Year, v.Fecha.Month, 1) : v.Fecha.Date).ToDictionary(g => g.Key, g => g.Sum(v => v.Subtotal));
        List<PuntoReporte> puntos = new List<PuntoReporte>();
        DateTime fin = grupos.Keys.Max();
        for (DateTime fecha = grupos.Keys.Min(); fecha <= fin;)
        {
            puntos.Add(new PuntoReporte { Etiqueta = fecha.ToString(mensual ? "MM/yy" : "dd/MM", Cultura), Valor = grupos.GetValueOrDefault(fecha) });
            if (fecha == fin)
                break;
            fecha = mensual ? fecha.AddMonths(1) : fecha.AddDays(1);
        }

        return puntos.ToArray();
    }

    public ReporteIndicador[] ResumenVentas(IReadOnlyCollection<ReporteVentaItem> ventas)
    {
        int operaciones = ventas.Select(v => v.VentaId).Distinct().Count();
        decimal importe = ventas.Sum(v => v.Subtotal);
        return new[]
        {
            new ReporteIndicador
            {
                Nombre = "Importe vendido (ARS)",
                Valor = importe.ToString("N2", Cultura)
            },
            new ReporteIndicador
            {
                Nombre = "Ventas distintas",
                Valor = operaciones.ToString("N0", Cultura)
            },
            new ReporteIndicador
            {
                Nombre = "Unidades vendidas",
                Valor = ventas.Sum(v => v.Cantidad).ToString("N0", Cultura)
            },
            new ReporteIndicador
            {
                Nombre = "Ticket del filtro (ARS)",
                Valor = (operaciones == 0 ? 0 : importe / operaciones).ToString("N2", Cultura)
            }
        };
    }

    public ReporteIndicador[] ResumenStock(IReadOnlyCollection<ReporteStockItem> stock) => new[]
    {
        new ReporteIndicador
        {
            Nombre = "Valor a precio de venta (ARS)",
            Valor = stock.Sum(s => s.Precio * s.StockTotal).ToString("N2", Cultura)
        },
        new ReporteIndicador
        {
            Nombre = "Productos",
            Valor = stock.Count.ToString("N0", Cultura)
        },
        new ReporteIndicador
        {
            Nombre = "Unidades en stock",
            Valor = stock.Sum(s => s.StockTotal).ToString("N0", Cultura)
        },
        new ReporteIndicador
        {
            Nombre = "Productos sin stock",
            Valor = stock.Count(s => s.StockTotal == 0).ToString("N0", Cultura)
        }
    };
    public string Comparacion(ComparacionReporte comparacion)
    {
        decimal actual = comparacion.Actual;
        decimal? anterior = comparacion.Anterior;
        if (!anterior.HasValue)
            return "Seleccioná ambas fechas para comparar con el período anterior de igual duración";
        if (anterior == 0)
            return actual == 0 ? "Sin ventas en ambos períodos" : "Sin importe en el período anterior: variación porcentual no disponible";
        return $"Variación de importe: {((actual - anterior.Value) / anterior.Value):+0.0%;-0.0%;0.0%} frente al período anterior";
    }

    private static DataTable Tabla(ColumnaReporte[] columnas)
    {
        DataTable tabla = new DataTable
        {
            Locale = Cultura
        };
        foreach (ColumnaReporte c in columnas)
            tabla.Columns.Add(c.Nombre, c.Tipo);
        return tabla;
    }

    public DataTable TablaVentas(IEnumerable<ReporteVentaItem> ventas)
    {
        DataTable tabla = Tabla(new ColumnaReporte[] { new ColumnaReporte { Nombre = "Venta", Tipo = typeof(int) }, new ColumnaReporte { Nombre = "Fecha", Tipo = typeof(DateTime) }, new ColumnaReporte { Nombre = "Vendedor", Tipo = typeof(string) }, new ColumnaReporte { Nombre = "Zona", Tipo = typeof(string) }, new ColumnaReporte { Nombre = "Cliente", Tipo = typeof(string) }, new ColumnaReporte { Nombre = "Producto", Tipo = typeof(string) }, new ColumnaReporte { Nombre = "Cantidad", Tipo = typeof(int) }, new ColumnaReporte { Nombre = "Precio unit. (ARS)", Tipo = typeof(decimal) }, new ColumnaReporte { Nombre = "Subtotal (ARS)", Tipo = typeof(decimal) } });
        foreach (ReporteVentaItem v in ventas)
            tabla.Rows.Add(v.VentaId, v.Fecha, v.Vendedor, v.Zona, v.Cliente, v.Producto, v.Cantidad, v.PrecioUnitario, v.Subtotal);
        return tabla;
    }

    public DataTable TablaStock(AnalisisStockReporte solicitud)
    {
        IReadOnlyCollection<ReporteStockItem> stock = solicitud.Stock;
        int umbral = solicitud.Umbral;
        DataTable tabla = Tabla(new ColumnaReporte[] { new ColumnaReporte { Nombre = "Categoría", Tipo = typeof(string) }, new ColumnaReporte { Nombre = "Producto", Tipo = typeof(string) }, new ColumnaReporte { Nombre = "Stock", Tipo = typeof(int) }, new ColumnaReporte { Nombre = "Estado", Tipo = typeof(string) }, new ColumnaReporte { Nombre = "Precio venta (ARS)", Tipo = typeof(decimal) }, new ColumnaReporte { Nombre = "Valor venta (ARS)", Tipo = typeof(decimal) }, new ColumnaReporte { Nombre = "Lotes vigentes", Tipo = typeof(int) }, new ColumnaReporte { Nombre = "Por vencer (30 d)", Tipo = typeof(int) }, new ColumnaReporte { Nombre = "Lotes vencidos", Tipo = typeof(int) } });
        foreach (ReporteStockItem s in stock)
            tabla.Rows.Add(s.Categoria, s.Producto, s.StockTotal, s.StockTotal == 0 ? "Sin stock" : s.StockTotal <= umbral ? "Stock bajo" : "Disponible", s.Precio, s.Precio * s.StockTotal, s.LotesActivos, s.LotesPorVencer, s.LotesVencidos);
        return tabla;
    }

    public DataTable AgruparVentas(AnalisisVentasReporte solicitud)
    {
        IReadOnlyCollection<ReporteVentaItem> ventas = solicitud.Ventas;
        string campo = solicitud.Agrupacion;
        DataTable tabla = Tabla(new ColumnaReporte[] { new ColumnaReporte { Nombre = campo, Tipo = typeof(string) }, new ColumnaReporte { Nombre = "Ventas distintas", Tipo = typeof(int) }, new ColumnaReporte { Nombre = "Unidades", Tipo = typeof(int) }, new ColumnaReporte { Nombre = "Importe (ARS)", Tipo = typeof(decimal) } });
        foreach (IGrouping<string, ReporteVentaItem> grupo in ventas.GroupBy(v => campo switch
        {
            "Vendedor" => v.Vendedor,
            "Zona" => v.Zona,
            "Cliente" => v.Cliente,
            _ => v.Producto
        }).OrderByDescending(g => g.Sum(v => v.Subtotal)))
            tabla.Rows.Add(string.IsNullOrWhiteSpace(grupo.Key) ? "Sin informar" : grupo.Key, grupo.Select(v => v.VentaId).Distinct().Count(), grupo.Sum(v => v.Cantidad), grupo.Sum(v => v.Subtotal));
        return tabla;
    }

    public DataTable AgruparStock(IEnumerable<ReporteStockItem> stock)
    {
        DataTable tabla = Tabla(new ColumnaReporte[] { new ColumnaReporte { Nombre = "Categoría", Tipo = typeof(string) }, new ColumnaReporte { Nombre = "Productos", Tipo = typeof(int) }, new ColumnaReporte { Nombre = "Unidades", Tipo = typeof(int) }, new ColumnaReporte { Nombre = "Valor venta (ARS)", Tipo = typeof(decimal) } });
        foreach (IGrouping<string, ReporteStockItem> grupo in stock.GroupBy(s => s.Categoria).OrderByDescending(g => g.Sum(s => s.StockTotal)))
            tabla.Rows.Add(grupo.Key, grupo.Count(), grupo.Sum(s => s.StockTotal), grupo.Sum(s => s.StockTotal * s.Precio));
        return tabla;
    }
}
