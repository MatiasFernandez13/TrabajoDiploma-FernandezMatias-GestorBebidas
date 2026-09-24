using BE;
using BLL;
using SERVICIOS;
using System.Data;
using System.Diagnostics;
using System.Globalization;
using UI.Reportes;

namespace UI;
public partial class FrmReportes : FrmBase
{
    private readonly ReportesBLL _reportes = new ReportesBLL();
    private readonly ReporteCalculosBLL _calculos = new ReporteCalculosBLL();
    private readonly ReporteExportador _exportador = new ReporteExportador();
    private static readonly CultureInfo Cultura = CultureInfo.GetCultureInfo("es-AR");
    private List<ReporteVentaItem> _ventas = new();
    private List<ReporteStockItem> _stock = new();
    private ReporteDocumento? _resultado;
    private bool _ocupado, _ajustando, _listo;
    private int _umbralAplicado;
    private readonly ContextMenuStrip _exportaciones = new();
    private readonly Label[] indicadores;
    private readonly Label[] titulosIndicadores;
    public FrmReportes()
    {
        InitializeComponent();
        indicadores = new[]
        {
            indicador0,
            indicador1,
            indicador2,
            indicador3
        };
        titulosIndicadores = new[]
        {
            tituloIndicador0,
            tituloIndicador1,
            tituloIndicador2,
            tituloIndicador3
        };
        if (components == null)
            components = new System.ComponentModel.Container();
        components.Add(_exportaciones);
        cbTipoReporte.SelectedIndex = 0;
        cbPeriodo.SelectedIndex = 0;
        cbEstado.SelectedIndex = 0;
        cbAgrupar.SelectedIndex = 0;
        if (System.ComponentModel.LicenseManager.UsageMode == System.ComponentModel.LicenseUsageMode.Designtime)
            return;
        Load += FrmReportes_Load;
        btnGenerarReporte.Click += btnGenerarReporte_Click;
        btnLimpiar.Click += (_, _) => Restablecer();
        cbTipoReporte.SelectedIndexChanged += (_, _) => CambiarTipo();
        cbPeriodo.SelectedIndexChanged += (_, _) => AplicarPeriodo();
        cbAgrupar.SelectedIndexChanged += (_, _) => ActualizarAnalisis();
        foreach (string formato in new[]
        {
            "pdf",
            "xlsx",
            "csv",
            "html"
        }

        )
            _exportaciones.Items.Add(formato == "xlsx" ? "Excel (.xlsx)" : formato.ToUpperInvariant(), null, (_, _) => Exportar(new SolicitudExportacionReporte { Formato = formato }));
        _exportaciones.Items.Add(new ToolStripSeparator());
        _exportaciones.Items.Add("Abrir PDF para imprimir", null, (_, _) => Exportar(new SolicitudExportacionReporte { Formato = "pdf", AbrirAlFinalizar = true }));
        btnExportar.Click += (_, _) => _exportaciones.Show(btnExportar, new Point(0, btnExportar.Height));
        foreach (ComboBox combo in new[]
        {
            cbZona,
            cbProducto,
            cbCategoria,
            cbEstado
        }

        )
            combo.SelectedIndexChanged += (_, _) => MarcarPendiente();
        foreach (DateTimePicker fecha in new[]
        {
            dtpFechaDesde,
            dtpFechaHasta
        }

        )
            fecha.ValueChanged += (_, _) => FechaEditada();
        foreach (CheckBox check in new[]
        {
            chkFechaDesde,
            chkFechaHasta
        }

        )
            check.CheckedChanged += (_, _) => FechaEditada();
        numUmbral.ValueChanged += (_, _) => MarcarPendiente();
        dgvReporte.DataBindingComplete += (_, _) => EstiloTabla(dgvReporte);
        dgvAnalisis.DataBindingComplete += (_, _) => EstiloTabla(dgvAnalisis);
        FormClosing += (_, e) =>
        {
            if (_ocupado)
                e.Cancel = true;
        };
    }

    protected override void AplicarEstilo(Control control)
    {
        BackColor = Color.FromArgb(244, 247, 245);
        foreach (Button boton in new[]
        {
            btnGenerarReporte,
            btnLimpiar,
            btnExportar
        }

        )
        {
            boton.BackColor = Color.FromArgb(58, 99, 81);
            boton.ForeColor = Color.White;
            boton.FlatAppearance.BorderSize = 0;
            boton.Cursor = Cursors.Hand;
        }

        btnLimpiar.BackColor = Color.FromArgb(230, 237, 233);
        btnLimpiar.ForeColor = Color.FromArgb(40, 65, 52);
    }

    private async void FrmReportes_Load(object? sender, EventArgs e)
    {
        if (DesignMode || System.ComponentModel.LicenseManager.UsageMode == System.ComponentModel.LicenseUsageMode.Designtime)
            return;
        CambiarTipo();
        await CargarFiltros();
    }

    private async Task CargarFiltros()
    {
        Ocupar(new EstadoVistaReporte { Ocupado = true, Mensaje = "Cargando productos y zonas…" });
        try
        {
            CatalogoReportes datos = await Task.Run(() => _reportes.CargarCatalogo());
            _ajustando = true;
            List<KeyValuePair<int, string>> productos = new List<KeyValuePair<int, string>>
            {
                new(0, "Todos los productos")
            };
            productos.AddRange(datos.Productos.Select(p => new KeyValuePair<int, string>(p.Id, p.Nombre)));
            cbProducto.DisplayMember = "Value";
            cbProducto.ValueMember = "Key";
            cbProducto.DataSource = productos;
            cbZona.Items.Clear();
            cbZona.Items.Add("Todas las zonas");
            cbZona.Items.AddRange(datos.Zonas.Distinct().OrderBy(z => z).Cast<object>().ToArray());
            cbZona.SelectedIndex = 0;
            cbCategoria.Items.Clear();
            cbCategoria.Items.Add("Todas las categorías");
            cbCategoria.Items.AddRange(datos.Categorias.Distinct().OrderBy(c => c).Cast<object>().ToArray());
            cbCategoria.SelectedIndex = 0;
            _listo = true;
            _ajustando = false;
            AplicarPeriodo();
            lblEstado.Text = "Elegí los filtros y presioná Generar reporte.";
        }
        catch (Exception ex)
        {
            _listo = false;
            lblEstado.Text = "No se pudieron cargar los filtros. Generar reporte permite reintentar.";
            MostrarError(ex);
        }
        finally
        {
            _ajustando = false;
            Ocupar(new EstadoVistaReporte { Ocupado = false });
        }
    }

    private void CambiarTipo()
    {
        bool ventas = cbTipoReporte.SelectedIndex == 0;
        filtrosVentas.Visible = ventas;
        filtrosStock.Visible = !ventas;
        cbZona.Enabled = ventas;
        _resultado = null;
        _ventas.Clear();
        _stock.Clear();
        dgvReporte.DataSource = null;
        dgvAnalisis.DataSource = null;
        btnExportar.Enabled = false;
        lblVacio.Visible = true;
        lblVacio.Text = "Seleccioná los filtros y generá el reporte.";
        lblContexto.Text = ventas ? "Ventas e ingresos · Consultá un período" : "Inventario actual · Productos activos";
        lblComparacion.Text = "";
        string[] titulos = ventas ? new[]
        {
            "Importe vendido (ARS)",
            "Ventas distintas",
            "Unidades vendidas",
            "Ticket del filtro (ARS)"
        }

        : new[]
        {
            "Valor a precio de venta (ARS)",
            "Productos",
            "Unidades en stock",
            "Productos sin stock"
        };
        for (int i = 0; i < 4; i++)
        {
            titulosIndicadores[i].Text = titulos[i];
            indicadores[i].Text = "—";
        }

        graficoEvolucion.Mostrar(new DatosGraficoReporte { Titulo = "", Puntos = Array.Empty<PuntoReporte>() });
        graficoRanking.Mostrar(new DatosGraficoReporte { Titulo = "", Puntos = Array.Empty<PuntoReporte>() });
        cbAgrupar.Enabled = ventas;
        lblEstado.Text = "Generá el reporte para consultar los resultados.";
    }

    private void AplicarPeriodo()
    {
        if (_ajustando)
            return;
        _ajustando = true;
        DateTime hoy = DateTime.Today;
        if (cbPeriodo.SelectedIndex != 3)
        {
            chkFechaDesde.Checked = chkFechaHasta.Checked = cbPeriodo.SelectedIndex != 4;
            dtpFechaDesde.Value = cbPeriodo.SelectedIndex == 1 ? hoy : new DateTime(hoy.Year, hoy.Month, 1);
            dtpFechaHasta.Value = hoy;
            if (cbPeriodo.SelectedIndex == 2)
            {
                dtpFechaHasta.Value = dtpFechaDesde.Value.AddDays(-1);
                dtpFechaDesde.Value = dtpFechaDesde.Value.AddMonths(-1);
            }
        }

        dtpFechaDesde.Enabled = chkFechaDesde.Checked;
        dtpFechaHasta.Enabled = chkFechaHasta.Checked;
        _ajustando = false;
        MarcarPendiente();
    }

    private void FechaEditada()
    {
        if (_ajustando)
            return;
        _ajustando = true;
        cbPeriodo.SelectedIndex = 3;
        _ajustando = false;
        dtpFechaDesde.Enabled = chkFechaDesde.Checked;
        dtpFechaHasta.Enabled = chkFechaHasta.Checked;
        MarcarPendiente();
    }

    private void MarcarPendiente()
    {
        if (_ajustando || _ocupado)
            return;
        if (_resultado != null)
            lblEstado.Text = "Filtros modificados. Generá nuevamente; pantalla y exportaciones conservan la consulta anterior.";
    }

    private void Restablecer()
    {
        _ajustando = true;
        if (cbProducto.Items.Count > 0)
            cbProducto.SelectedIndex = 0;
        if (cbZona.Items.Count > 0)
            cbZona.SelectedIndex = 0;
        if (cbCategoria.Items.Count > 0)
            cbCategoria.SelectedIndex = 0;
        cbEstado.SelectedIndex = 0;
        numUmbral.Value = 10;
        cbPeriodo.SelectedIndex = 0;
        _ajustando = false;
        AplicarPeriodo();
        CambiarTipo();
    }

    private async void btnGenerarReporte_Click(object? sender, EventArgs e)
    {
        if (_ocupado)
            return;
        if (!_listo)
        {
            await CargarFiltros();
            if (!_listo)
                return;
        }

        bool ventas = cbTipoReporte.SelectedIndex == 0;
        DateTime? desde = chkFechaDesde.Checked ? dtpFechaDesde.Value.Date : null, hasta = chkFechaHasta.Checked ? dtpFechaHasta.Value.Date : null;
        if (ventas && desde > hasta)
        {
            MessageBox.Show(this, "La fecha desde no puede ser posterior a la fecha hasta.", "Revisá las fechas", MessageBoxButtons.OK, MessageBoxIcon.Information);
            return;
        }

        int? producto = cbProducto.SelectedValue is int id && id > 0 ? id : null;
        string? zona = cbZona.SelectedIndex > 0 ? cbZona.Text : null, categoria = cbCategoria.SelectedIndex > 0 ? cbCategoria.Text : null;
        int estado = cbEstado.SelectedIndex, umbral = (int)numUmbral.Value;
        string contexto = ventas ? $"{(desde.HasValue ? desde.Value.ToString("dd/MM/yyyy") : "Inicio del historial")} — {(hasta.HasValue ? hasta.Value.ToString("dd/MM/yyyy") : "Sin fecha final")} · {cbProducto.Text} · {cbZona.Text}" : $"Stock actual · {cbProducto.Text} · {cbCategoria.Text} · {cbEstado.Text} · Umbral bajo: ≤ {umbral} unidades";
        Ocupar(new EstadoVistaReporte { Ocupado = true, Mensaje = "Generando reporte…" });
        try
        {
            List<ReporteVentaItem> ventasNuevas = new();
            List<ReporteStockItem> stockNuevo = new();
            string comparacion;
            if (ventas)
            {
                FiltroReporteVentas filtro = new FiltroReporteVentas
                {
                    Zona = zona!,
                    ProductoId = producto,
                    FechaDesde = desde,
                    FechaHasta = hasta
                };
                ResultadoReporteVentas consulta = await Task.Run(() => _reportes.GenerarVentasComparadas(filtro));
                ventasNuevas = consulta.Actual;
                comparacion = _calculos.Comparacion(new ComparacionReporte { Actual = ventasNuevas.Sum(v => v.Subtotal), Anterior = consulta.Anterior?.Sum(v => v.Subtotal) });
                if (consulta.FechaDesdeAnterior.HasValue)
                    comparacion += $" · Base: {consulta.FechaDesdeAnterior:dd/MM/yyyy} al {consulta.FechaHastaAnterior:dd/MM/yyyy}";
                comparacion += " · Ticket sobre productos filtrados.";
            }
            else
            {
                FiltroReporteStock filtro = new FiltroReporteStock
                {
                    ProductoId = producto,
                    Categoria = categoria!,
                    Estado = (EstadoReporteStock)estado,
                    Umbral = umbral
                };
                stockNuevo = await Task.Run(() => _reportes.GenerarReporteStock(filtro));
                comparacion = $"{stockNuevo.Count(s => s.StockTotal > 0 && s.StockTotal <= umbral)} productos con stock bajo · {stockNuevo.Sum(s => s.LotesPorVencer)} lotes por vencer (30 días) · {stockNuevo.Sum(s => s.LotesVencidos)} lotes vencidos · Valor a precio de venta.";
            }

            DateTime generado = DateTime.Now;
            DataTable tabla = ventas ? _calculos.TablaVentas(ventasNuevas) : _calculos.TablaStock(new AnalisisStockReporte { Stock = stockNuevo, Umbral = umbral });
            ReporteIndicador[] resumen = ventas ? _calculos.ResumenVentas(ventasNuevas) : _calculos.ResumenStock(stockNuevo);
            _resultado = new ReporteDocumento
            {
                Titulo = ventas ? "Reporte de ventas" : "Reporte de stock",
                Filtros = contexto,
                Generado = generado,
                Usuario = Sesion.Instancia.UsuarioLogueado?.NombreUsuario ?? "Sin sesión",
                Tabla = tabla,
                Resumen = resumen,
                Nota = comparacion
            };
            _ventas = ventasNuevas;
            _stock = stockNuevo;
            _umbralAplicado = umbral;
            dgvReporte.DataSource = tabla;
            for (int i = 0; i < 4; i++)
                indicadores[i].Text = resumen[i].Valor;
            lblContexto.Text = contexto;
            lblComparacion.Text = comparacion;
            lblVacio.Visible = tabla.Rows.Count == 0;
            lblVacio.Text = "No se encontraron resultados. Probá ampliar los filtros.";
            lblEstado.Text = $"Actualizado: {generado:dd/MM/yyyy HH:mm:ss} · {tabla.Rows.Count:N0} filas · Usuario: {_resultado.Usuario}";
            ActualizarAnalisis();
            ActualizarGraficos();
        }
        catch (Exception ex)
        {
            lblEstado.Text = _resultado == null ? "No se pudo generar el reporte. Podés reintentar." : "No se pudo actualizar. Se conserva el último reporte generado.";
            MostrarError(ex);
        }
        finally
        {
            Ocupar(new EstadoVistaReporte { Ocupado = false });
        }
    }

    private void ActualizarAnalisis()
    {
        if (_resultado == null)
            return;
        dgvAnalisis.DataSource = cbTipoReporte.SelectedIndex == 0 ? _calculos.AgruparVentas(new AnalisisVentasReporte { Ventas = _ventas, Agrupacion = cbAgrupar.Text }) : _calculos.AgruparStock(_stock);
    }

    private void ActualizarGraficos()
    {
        if (cbTipoReporte.SelectedIndex == 0)
        {
            bool mensual = _ventas.Count > 0 && (_ventas.Max(v => v.Fecha) - _ventas.Min(v => v.Fecha)).TotalDays > 60;
            graficoEvolucion.Mostrar(new DatosGraficoReporte { Titulo = mensual ? "Evolución mensual · ARS" : "Evolución diaria · ARS", Puntos = _calculos.Evolucion(new AnalisisVentasReporte { Ventas = _ventas, Mensual = mensual }), EsEvolucion = true });
            graficoRanking.Mostrar(_calculos.RankingVentas(new AnalisisVentasReporte { Ventas = _ventas }));
        }
        else
        {
            AnalisisStockReporte solicitud = new AnalisisStockReporte
            {
                Stock = _stock,
                Umbral = _umbralAplicado
            };
            graficoEvolucion.Mostrar(_calculos.CategoriasStock(solicitud));
            graficoRanking.Mostrar(_calculos.EstadosStock(solicitud));
        }
    }

    private static void EstiloTabla(DataGridView grid)
    {
        grid.EnableHeadersVisualStyles = false;
        grid.ColumnHeadersDefaultCellStyle.BackColor = Color.FromArgb(58, 99, 81);
        grid.ColumnHeadersDefaultCellStyle.ForeColor = Color.White;
        grid.ColumnHeadersDefaultCellStyle.SelectionBackColor = Color.FromArgb(58, 99, 81);
        grid.ColumnHeadersDefaultCellStyle.SelectionForeColor = Color.White;
        grid.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
        grid.BackgroundColor = Color.White;
        grid.GridColor = Color.FromArgb(223, 230, 226);
        grid.AlternatingRowsDefaultCellStyle.BackColor = Color.FromArgb(246, 249, 247);
        grid.DefaultCellStyle.SelectionBackColor = Color.FromArgb(218, 233, 224);
        grid.DefaultCellStyle.SelectionForeColor = Color.Black;
        grid.DefaultCellStyle.FormatProvider = Cultura;
        grid.RowTemplate.Height = 30;
        foreach (DataGridViewColumn columna in grid.Columns)
        {
            columna.MinimumWidth = columna.ValueType == typeof(string) ? 100 : 78;
            columna.FillWeight = columna.ValueType == typeof(string) ? 140 : 100;
            if (columna.ValueType == typeof(decimal))
            {
                columna.DefaultCellStyle.Format = "N2";
                columna.DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;
            }

            if (columna.ValueType == typeof(int))
            {
                columna.DefaultCellStyle.Format = "N0";
                columna.DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;
            }

            if (columna.ValueType == typeof(DateTime))
            {
                columna.DefaultCellStyle.Format = "dd/MM/yyyy HH:mm";
                columna.MinimumWidth = 145;
            }
        }

        foreach (DataGridViewRow row in grid.Rows)
            if (grid.Columns.Contains("Estado") && row.Cells["Estado"].Value is string estado && estado != "Disponible")
                row.Cells["Estado"].Style.ForeColor = estado == "Sin stock" ? Color.Firebrick : Color.FromArgb(151, 95, 15);
    }

    private void Ocupar(EstadoVistaReporte estado)
    {
        if (estado.Ocupado)
            _ocupado = true;
        panelFiltros.Enabled = !estado.Ocupado;
        UseWaitCursor = estado.Ocupado;
        btnExportar.Enabled = !estado.Ocupado && _resultado?.Tabla.Rows.Count > 0;
        if (estado.Mensaje != null)
            lblEstado.Text = estado.Mensaje;
        _ocupado = estado.Ocupado;
    }

    private async void Exportar(SolicitudExportacionReporte solicitud)
    {
        ReporteDocumento? documento = _resultado;
        string formato = solicitud.Formato;
        if (_ocupado || documento == null || documento.Tabla.Rows.Count == 0)
            return;
        using SaveFileDialog guardar = new SaveFileDialog
        {
            Filter = $"Archivo {formato.ToUpperInvariant()} (*.{formato})|*.{formato}",
            FileName = $"{documento.Titulo.Replace(' ', '_')}_{documento.Generado:yyyyMMdd_HHmmss}.{formato}",
            AddExtension = true,
            DefaultExt = formato
        };
        if (guardar.ShowDialog(this) != DialogResult.OK)
            return;
        Ocupar(new EstadoVistaReporte { Ocupado = true, Mensaje = "Exportando reporte…" });
        try
        {
            solicitud.Documento = documento;
            solicitud.Destino = guardar.FileName;
            await Task.Run(() => _exportador.Guardar(solicitud));
            BitacoraHelper.Registrar("Reporte", "Exportar", $"{documento.Titulo} · {formato} · {documento.Tabla.Rows.Count} filas · {documento.Filtros}");
            lblEstado.Text = $"Archivo guardado: {guardar.FileName}";
            if (solicitud.AbrirAlFinalizar)
                Process.Start(new ProcessStartInfo(guardar.FileName) { UseShellExecute = true });
        }
        catch (Exception ex)
        {
            lblEstado.Text = "No se pudo completar la exportación.";
            MostrarError(ex);
        }
        finally
        {
            Ocupar(new EstadoVistaReporte { Ocupado = false });
        }
    }

    private void MostrarError(Exception ex)
    {
        Trace.TraceError(ex.ToString());
        MessageBox.Show(this, "No se pudo completar la operación. Verificá la conexión con la base de datos o la disponibilidad del archivo y volvé a intentar.", "Reportes", MessageBoxButtons.OK, MessageBoxIcon.Warning);
    }

    private void btnGenerarReporte_Click_1(object sender, EventArgs e)
    {
    }

    private void lblFiltro1_Click(object sender, EventArgs e)
    {
    }
}
