using BE;
using ClosedXML.Excel;
using MigraDoc.DocumentObjectModel;
using MigraDoc.DocumentObjectModel.Tables;
using MigraDoc.Rendering;
using System.Data;
using System.Globalization;
using System.Net;
using System.Text;
using PdfColor = MigraDoc.DocumentObjectModel.Color;

namespace UI.Reportes;
public class ReporteExportador
{
    private static readonly CultureInfo Cultura = CultureInfo.GetCultureInfo("es-AR");
    public void Guardar(SolicitudExportacionReporte solicitud)
    {
        ReporteDocumento reporte = solicitud.Documento;
        string destino = solicitud.Destino;
        string formato = solicitud.Formato;
        string temporal = Path.Combine(Path.GetDirectoryName(Path.GetFullPath(destino))!, $".{Guid.NewGuid():N}.{formato}");
        try
        {
            switch (formato)
            {
                case "xlsx":
                    Excel(new SolicitudExportacionReporte { Documento = reporte, Destino = temporal, Formato = formato });
                    break;
                case "pdf":
                    Pdf(new SolicitudExportacionReporte { Documento = reporte, Destino = temporal, Formato = formato });
                    break;
                case "html":
                    File.WriteAllText(temporal, Html(reporte), new UTF8Encoding(true));
                    break;
                case "csv":
                    File.WriteAllText(temporal, Csv(reporte), new UTF8Encoding(true));
                    break;
                default:
                    throw new ArgumentException("Formato no compatible.", nameof(formato));
            }

            File.Move(temporal, destino, true);
        }
        finally
        {
            if (File.Exists(temporal))
                File.Delete(temporal);
        }
    }

    private static string Texto(object valor) => valor switch
    {
        DateTime fecha => fecha.ToString("dd/MM/yyyy HH:mm", Cultura),
        decimal numero => numero.ToString("N2", Cultura),
        _ => Convert.ToString(valor, Cultura) ?? ""
    };
    private void Excel(SolicitudExportacionReporte solicitud)
    {
        ReporteDocumento r = solicitud.Documento;
        string path = solicitud.Destino;
        using XLWorkbook libro = new XLWorkbook();
        IXLWorksheet hoja = libro.AddWorksheet("Detalle");
        int columnas = r.Tabla.Columns.Count;
        hoja.Cell(1, 1).Value = "MF Bebidas · " + r.Titulo;
        hoja.Range(1, 1, 1, columnas).Merge().Style.Font.SetBold().Font.SetFontSize(18);
        hoja.Cell(2, 1).Value = r.Filtros;
        hoja.Range(2, 1, 2, columnas).Merge().Style.Alignment.WrapText = true;
        hoja.Row(2).Height = 32;
        hoja.Cell(3, 1).Value = $"Generado: {r.Generado:dd/MM/yyyy HH:mm:ss} · Usuario: {r.Usuario}";
        hoja.Range(3, 1, 3, columnas).Merge();
        IXLTable tabla = hoja.Cell(5, 1).InsertTable(r.Tabla, "Datos", true);
        tabla.Theme = XLTableTheme.TableStyleMedium4;
        foreach (DataColumn columna in r.Tabla.Columns)
        {
            IXLRange rango = hoja.Range(6, columna.Ordinal + 1, Math.Max(6, r.Tabla.Rows.Count + 5), columna.Ordinal + 1);
            if (columna.DataType == typeof(decimal))
                rango.Style.NumberFormat.Format = "#,##0.00";
            if (columna.DataType == typeof(DateTime))
                rango.Style.DateFormat.Format = "dd/mm/yyyy hh:mm";
        }

        hoja.SheetView.FreezeRows(5);
        hoja.Columns().AdjustToContents(5, Math.Min(r.Tabla.Rows.Count + 5, 205), 12, 38);
        hoja.PageSetup.PageOrientation = XLPageOrientation.Landscape;
        hoja.PageSetup.FitToPages(1, 0);
        hoja.PageSetup.SetRowsToRepeatAtTop(5, 5);
        IXLWorksheet resumen = libro.AddWorksheet("Resumen");
        resumen.Cell(1, 1).Value = r.Titulo;
        resumen.Cell(1, 1).Style.Font.SetBold().Font.SetFontSize(18);
        int fila = 3;
        foreach (ReporteIndicador indicador in r.Resumen)
        {
            resumen.Cell(fila, 1).Value = indicador.Nombre;
            resumen.Cell(fila, 2).Value = decimal.Parse(indicador.Valor, NumberStyles.Number, Cultura);
            resumen.Cell(fila, 2).Style.NumberFormat.Format = indicador.Nombre.Contains("ARS") ? "#,##0.00" : "#,##0";
            fila++;
        }

        resumen.Cell(9, 1).Value = r.Filtros;
        resumen.Range(9, 1, 10, 4).Merge().Style.Alignment.WrapText = true;
        resumen.Cell(12, 1).Value = r.Nota;
        resumen.Range(12, 1, 14, 4).Merge().Style.Alignment.WrapText = true;
        resumen.Columns(1, 4).Width = 25;
        resumen.Column(1).Width = 38;
        libro.SaveAs(path);
    }

    private void Pdf(SolicitudExportacionReporte solicitud)
    {
        ReporteDocumento r = solicitud.Documento;
        string path = solicitud.Destino;
        Document doc = new Document();
        doc.Info.Title = r.Titulo;
        doc.Info.Author = r.Usuario;
        Style normal = doc.Styles[StyleNames.Normal]!;
        normal.Font.Name = "Segoe UI";
        normal.Font.Size = 8;
        Section seccion = doc.AddSection();
        seccion.PageSetup.PageFormat = PageFormat.A4;
        seccion.PageSetup.Orientation = MigraDoc.DocumentObjectModel.Orientation.Landscape;
        seccion.PageSetup.TopMargin = Unit.FromCentimeter(1.5);
        seccion.PageSetup.BottomMargin = Unit.FromCentimeter(1.5);
        seccion.PageSetup.LeftMargin = Unit.FromCentimeter(1.2);
        seccion.PageSetup.RightMargin = Unit.FromCentimeter(1.2);
        Paragraph titulo = seccion.AddParagraph("MF Bebidas · " + r.Titulo);
        titulo.Format.Font.Size = 18;
        titulo.Format.Font.Bold = true;
        titulo.Format.Font.Color = PdfColor.FromRgb(58, 99, 81);
        titulo.Format.SpaceAfter = 8;
        seccion.AddParagraph(r.Filtros);
        seccion.AddParagraph($"Generado: {r.Generado:dd/MM/yyyy HH:mm:ss} · Usuario: {r.Usuario}").Format.SpaceAfter = 10;
        Table resumen = seccion.AddTable();
        for (int i = 0; i < 4; i++)
            resumen.AddColumn(Unit.FromCentimeter(6.825));
        Row filaResumen = resumen.AddRow();
        filaResumen.Shading.Color = PdfColor.FromRgb(237, 244, 239);
        for (int i = 0; i < 4; i++)
        {
            filaResumen.Cells[i].AddParagraph(r.Resumen[i].Nombre);
            Paragraph p = filaResumen.Cells[i].AddParagraph(r.Resumen[i].Valor);
            p.Format.Font.Size = 14;
            p.Format.Font.Bold = true;
        }

        seccion.AddParagraph(r.Nota).Format.SpaceAfter = 8;
        Table tabla = seccion.AddTable();
        tabla.Borders.Width = .25;
        tabla.Borders.Color = PdfColor.FromRgb(220, 228, 223);
        double[] pesos = r.Tabla.Columns.Cast<DataColumn>().Select(c => c.DataType == typeof(string) ? 1.5 : c.DataType == typeof(DateTime) ? 1.25 : 1.0).ToArray();
        foreach (double peso in pesos)
            tabla.AddColumn(Unit.FromCentimeter(27.3 * peso / pesos.Sum()));
        Row cabecera = tabla.AddRow();
        cabecera.HeadingFormat = true;
        cabecera.Shading.Color = PdfColor.FromRgb(58, 99, 81);
        cabecera.Format.Font.Color = Colors.White;
        cabecera.Format.Font.Bold = true;
        foreach (DataColumn c in r.Tabla.Columns)
            cabecera.Cells[c.Ordinal].AddParagraph(c.ColumnName);
        int indice = 0;
        foreach (DataRow dato in r.Tabla.Rows)
        {
            Row fila = tabla.AddRow();
            fila.TopPadding = 4;
            fila.BottomPadding = 4;
            if (indice++ % 2 == 1)
                fila.Shading.Color = PdfColor.FromRgb(245, 248, 246);
            foreach (DataColumn c in r.Tabla.Columns)
            {
                fila.Cells[c.Ordinal].AddParagraph(Texto(dato[c]));
                if (c.DataType == typeof(decimal) || c.DataType == typeof(int))
                    fila.Cells[c.Ordinal].Format.Alignment = ParagraphAlignment.Right;
            }
        }

        Paragraph pie = seccion.Footers.Primary.AddParagraph();
        pie.Format.Alignment = ParagraphAlignment.Right;
        pie.AddText("MF Bebidas · Página ");
        pie.AddPageField();
        pie.AddText(" de ");
        pie.AddNumPagesField();
        PdfDocumentRenderer render = new PdfDocumentRenderer
        {
            Document = doc
        };
        render.RenderDocument();
        render.PdfDocument.Save(path);
        render.PdfDocument.Dispose();
    }

    public string Html(ReporteDocumento r)
    {
        static string E(string s) => WebUtility.HtmlEncode(s);
        StringBuilder html = new StringBuilder("<!doctype html><html lang='es'><meta charset='utf-8'><title>").Append(E(r.Titulo)).Append("</title><style>body{font:14px 'Segoe UI',sans-serif;color:#263c30;margin:32px}h1{color:#3a6351}table{border-collapse:collapse;width:100%;margin-top:20px}th{background:#3a6351;color:white}td,th{padding:9px;text-align:left;border-bottom:1px solid #ddd}tr:nth-child(even){background:#f4f7f5}.cards{display:flex;gap:24px;background:#edf4ef;padding:18px}.cards strong{display:block;font-size:22px}thead{display:table-header-group}@media print{body{margin:0;font-size:10px}}</style><h1>MF Bebidas · ").Append(E(r.Titulo)).Append("</h1><p>").Append(E(r.Filtros)).Append("</p><p>").Append(E($"Generado: {r.Generado:dd/MM/yyyy HH:mm:ss} · Usuario: {r.Usuario}")).Append("</p><div class='cards'>");
        foreach (ReporteIndicador i in r.Resumen)
            html.Append("<div>").Append(E(i.Nombre)).Append("<strong>").Append(E(i.Valor)).Append("</strong></div>");
        html.Append("</div><p>").Append(E(r.Nota)).Append("</p><table><thead><tr>");
        foreach (DataColumn c in r.Tabla.Columns)
            html.Append("<th>").Append(E(c.ColumnName)).Append("</th>");
        html.Append("</tr></thead><tbody>");
        foreach (DataRow fila in r.Tabla.Rows)
        {
            html.Append("<tr>");
            foreach (object v in fila.ItemArray)
                html.Append("<td>").Append(E(Texto(v!))).Append("</td>");
            html.Append("</tr>");
        }

        return html.Append("</tbody></table></html>").ToString();
    }

    public string Csv(ReporteDocumento r)
    {
        static string Celda(object valor)
        {
            string texto = Texto(valor);
            if (valor is string && texto.TrimStart().Length > 0 && "=+-@".Contains(texto.TrimStart()[0]))
                texto = "'" + texto;
            return "\"" + texto.Replace("\"", "\"\"") + "\"";
        }

        StringBuilder csv = new StringBuilder();
        object[] contexto = new object[]
        {
            r.Titulo,
            r.Filtros,
            r.Generado,
            r.Usuario
        };
        csv.AppendLine(string.Join(";", r.Tabla.Columns.Cast<DataColumn>().Select(c => Celda(c.ColumnName)).Concat(new[] { "Reporte", "Filtros aplicados", "Generado", "Usuario" }.Select(c => Celda(c)))));
        foreach (DataRow fila in r.Tabla.Rows)
            csv.AppendLine(string.Join(";", fila.ItemArray.Concat(contexto).Select(v => Celda(v!))));
        return csv.ToString();
    }
}
