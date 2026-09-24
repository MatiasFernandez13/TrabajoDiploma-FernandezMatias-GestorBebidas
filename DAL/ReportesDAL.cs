using BE;
using System;
using System.Collections.Generic;
using System.Data;

namespace DAL
{
    public class ReportesDAL
    {
        public List<string> ListarZonas()
        {
            List<string> lista = new List<string>();
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            try
            {
                DataTable dt = acceso.Leer("sp_Reporte_Zonas_Analisis");
                foreach (DataRow fila in dt.Rows)
                {
                    string zona = fila["Zona"]?.ToString();
                    if (!string.IsNullOrWhiteSpace(zona))
                        lista.Add(zona);
                }
            }
            finally
            {
                acceso.Cerrar();
            }

            return lista;
        }

        public List<Producto> ListarProductosBasicos()
        {
            List<Producto> lista = new List<Producto>();
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            try
            {
                DataTable dt = acceso.Leer("sp_Productos_Listar_IdNombre");
                foreach (DataRow fila in dt.Rows)
                {
                    lista.Add(new Producto { Id = Convert.ToInt32(fila["Id"]), Nombre = fila["Nombre"].ToString() });
                }
            }
            finally
            {
                acceso.Cerrar();
            }

            return lista;
        }

        public List<ReporteVentaItem> GenerarReporteVentas(FiltroReporteVentas filtro)
        {
            if (filtro == null)
                throw new ArgumentNullException(nameof(filtro));
            List<ReporteVentaItem> lista = new List<ReporteVentaItem>();
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            try
            {
                List<System.Data.SqlClient.SqlParameter> parametros = new List<System.Data.SqlClient.SqlParameter>
                {
                    acceso.CrearParametro("@Zona", filtro.Zona ?? string.Empty),
                    acceso.CrearParametro("@ProductoId", filtro.ProductoId.GetValueOrDefault()),
                    acceso.CrearParametro("@FechaDesde", filtro.FechaDesde.GetValueOrDefault()),
                    acceso.CrearParametro("@FechaHasta", filtro.FechaHasta.GetValueOrDefault())
                };
                if (string.IsNullOrWhiteSpace(filtro.Zona))
                    parametros[0].Value = DBNull.Value;
                if (filtro.ProductoId == null)
                    parametros[1].Value = DBNull.Value;
                if (filtro.FechaDesde == null)
                    parametros[2].Value = DBNull.Value;
                if (filtro.FechaHasta == null)
                    parametros[3].Value = DBNull.Value;
                DataTable dt = acceso.Leer("sp_Reporte_Ventas_Analisis", parametros);
                foreach (DataRow fila in dt.Rows)
                {
                    ReporteVentaItem item = new ReporteVentaItem
                    {
                        VentaId = Convert.ToInt32(fila["VentaId"]),
                        Fecha = Convert.ToDateTime(fila["Fecha"]),
                        Vendedor = fila.Table.Columns.Contains("Vendedor") ? (fila["Vendedor"]?.ToString() ?? "") : "",
                        Cantidad = Convert.ToInt32(fila["Cantidad"]),
                        Producto = fila["Producto"]?.ToString(),
                        Cliente = fila["Cliente"]?.ToString(),
                        Zona = fila["Zona"]?.ToString()
                    };
                    if (fila.Table.Columns.Contains("PrecioUnitario") && fila["PrecioUnitario"] != DBNull.Value)
                        item.PrecioUnitario = Convert.ToDecimal(fila["PrecioUnitario"]);
                    if (fila.Table.Columns.Contains("Subtotal") && fila["Subtotal"] != DBNull.Value)
                        item.Subtotal = Convert.ToDecimal(fila["Subtotal"]);
                    else
                        item.Subtotal = item.PrecioUnitario * item.Cantidad;
                    lista.Add(item);
                }
            }
            finally
            {
                acceso.Cerrar();
            }

            return lista;
        }

        public List<ReporteStockItem> GenerarReporteStock()
        {
            List<ReporteStockItem> lista = new List<ReporteStockItem>();
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            try
            {
                DataTable dt = acceso.Leer("sp_Reporte_Stock_Analisis");
                foreach (DataRow fila in dt.Rows)
                {
                    ReporteStockItem item = new ReporteStockItem
                    {
                        LotesPorVencer = Convert.ToInt32(fila["LotesPorVencer"]),
                        LotesVencidos = Convert.ToInt32(fila["LotesVencidos"]),
                        ProductoId = Convert.ToInt32(fila["ProductoId"]),
                        Producto = fila["Producto"]?.ToString(),
                        Categoria = fila["Categoria"]?.ToString(),
                        StockTotal = fila["StockTotal"] != DBNull.Value ? Convert.ToInt32(fila["StockTotal"]) : 0,
                        LotesActivos = fila["LotesActivos"] != DBNull.Value ? Convert.ToInt32(fila["LotesActivos"]) : 0
                    };
                    if (fila.Table.Columns.Contains("Precio") && fila["Precio"] != DBNull.Value)
                        item.Precio = Convert.ToDecimal(fila["Precio"]);
                    if (fila.Table.Columns.Contains("LitrosPorUnidad") && fila["LitrosPorUnidad"] != DBNull.Value)
                        item.LitrosPorUnidad = Convert.ToDouble(fila["LitrosPorUnidad"]);
                    lista.Add(item);
                }
            }
            finally
            {
                acceso.Cerrar();
            }

            return lista;
        }
    }
}
