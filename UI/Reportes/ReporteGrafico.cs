using BE;
using System.Drawing.Drawing2D;
using System.Globalization;

namespace UI.Reportes;
public sealed class ReporteGrafico : Control
{
    private PuntoReporte[] _datos = Array.Empty<PuntoReporte>();
    private string _titulo = "";
    private bool _evolucion;
    public ReporteGrafico()
    {
        DoubleBuffered = true;
        BackColor = Color.White;
        Margin = new Padding(3, 3, 6, 8);
        ResizeRedraw = true;
    }

    public void Mostrar(DatosGraficoReporte grafico)
    {
        _titulo = grafico.Titulo;
        _datos = grafico.Puntos;
        _evolucion = grafico.EsEvolucion;
        AccessibleName = grafico.Titulo;
        AccessibleDescription = string.Join("; ", _datos.Select(d => $"{d.Etiqueta}: {d.Valor}"));
        Invalidate();
    }

    protected override void OnPaint(PaintEventArgs e)
    {
        base.OnPaint(e);
        Graphics g = e.Graphics;
        g.SmoothingMode = SmoothingMode.AntiAlias;
        using Font titulo = new Font("Segoe UI", 10, FontStyle.Bold);
        using Font texto = new Font("Segoe UI", 9);
        using SolidBrush verde = new SolidBrush(Color.FromArgb(58, 99, 81));
        using SolidBrush gris = new SolidBrush(Color.DimGray);
        g.DrawString(_titulo, titulo, Brushes.Black, 12, 10);
        if (_datos.Length == 0)
        {
            g.DrawString("Sin datos para graficar", texto, gris, 12, 60);
            return;
        }

        decimal maximo = Math.Max(1, _datos.Max(d => d.Valor));
        if (_evolucion)
        {
            float izquierda = 80, derecha = Math.Max(izquierda + 1, Width - 28), arriba = 48, abajo = Math.Max(arriba + 1, Height - 30);
            using Pen linea = new Pen(Color.FromArgb(58, 99, 81), 2);
            using Pen guia = new Pen(Color.FromArgb(230, 235, 232));
            g.DrawLine(guia, izquierda, arriba, derecha, arriba);
            g.DrawLine(guia, izquierda, abajo, derecha, abajo);
            g.DrawString(maximo.ToString("N0", CultureInfo.GetCultureInfo("es-AR")), texto, gris, 8, arriba - 7);
            g.DrawString("0", texto, gris, 8, abajo - 7);
            PointF[] puntos = _datos.Select((d, i) => new PointF(_datos.Length == 1 ? (izquierda + derecha) / 2 : izquierda + i * (derecha - izquierda) / (_datos.Length - 1), abajo - (float)(d.Valor / maximo) * (abajo - arriba))).ToArray();
            if (puntos.Length > 1)
                g.DrawLines(linea, puntos);
            foreach (PointF p in puntos)
                g.FillEllipse(verde, p.X - 2, p.Y - 2, 4, 4);
            g.DrawString(_datos[0].Etiqueta, texto, gris, izquierda, abajo + 6);
            if (_datos.Length > 1)
                g.DrawString(_datos[^1].Etiqueta, texto, gris, derecha - 42, abajo + 6);
        }
        else
        {
            int alto = Math.Max(20, (Height - 48) / Math.Max(1, _datos.Length));
            float etiquetas = Math.Min(180, Width * .38f), ancho = Math.Max(1, Width - etiquetas - 94);
            using StringFormat formato = new StringFormat
            {
                Trimming = StringTrimming.EllipsisCharacter,
                FormatFlags = StringFormatFlags.NoWrap
            };
            for (int i = 0; i < _datos.Length; i++)
            {
                PuntoReporte d = _datos[i];
                float y = 42 + i * alto;
                g.DrawString(d.Etiqueta, texto, gris, new RectangleF(12, y, etiquetas - 18, alto), formato);
                g.FillRectangle(verde, etiquetas, y + 2, (float)(d.Valor / maximo) * ancho, 12);
                g.DrawString(d.Valor.ToString("N0", CultureInfo.GetCultureInfo("es-AR")), texto, gris, etiquetas + ancho + 8, y);
            }
        }
    }
}
