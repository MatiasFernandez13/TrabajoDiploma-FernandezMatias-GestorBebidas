using BE;
using BLL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using SERVICIOS;

namespace UI
{
    public partial class FrmVentas : FrmBase
    {
        private ProductoBLL _productoBLL = new ProductoBLL();
        private VentaBLL _ventaBLL;
        private LoteBLL _loteBLL = new LoteBLL();
        private ClienteBLL _clienteBLL = new ClienteBLL();
        private List<VentaDetalle> _carrito = new List<VentaDetalle>();
        public FrmVentas()
        {
            InitializeComponent();
            _ventaBLL = new VentaBLL();
        }

        private void FrmVentas_Load(object sender, EventArgs e)
        {
            try
            {
                CargarVendedor();
                CargarClientes();
                CargarProductos();
                ActualizarCarrito();
            }
            catch (Exception ex)
            {
                string inner = ex.InnerException != null ? $" → {ex.InnerException.Message}" : "";
                string msg = $"Error al inicializar Ventas: {ex.Message}{inner}\n\n" + "Podés seguir usando el formulario en modo 'Venta Mostrador' sin clientes. " + "Para habilitar Clientes y Reportes completos, ejecutar los scripts SQL de BASE/ScriptsClientes (01.sql al 09.sql).";
                MessageBox.Show(msg, "Aviso de inicialización", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
        }

        private void CargarVendedor()
        {
            if (Sesion.Instancia?.UsuarioLogueado != null)
            {
                txtVendedor.Text = Sesion.Instancia.UsuarioLogueado.NombreUsuario;
            }
        }

        private void CargarClientes()
        {
            try
            {
                cbCliente.Items.Clear();
                cbCliente.Items.Add(new { Id = (int? )null, NombreCompleto = "Venta Mostrador" });
                List<Cliente> clientes = _clienteBLL.Listar().Where(c => c.Activo).OrderBy(c => c.NombreCompleto).ToList();
                foreach (Cliente? cli in clientes)
                {
                    cbCliente.Items.Add(new { Id = (int? )cli.Id, NombreCompleto = cli.NombreCompleto });
                }

                cbCliente.DisplayMember = "NombreCompleto";
                cbCliente.ValueMember = "Id";
                cbCliente.SelectedIndex = 0;
                cbCliente.DropDownStyle = ComboBoxStyle.DropDownList;
            }
            catch (Exception ex)
            {
                string inner = ex.InnerException != null ? $" → {ex.InnerException.Message}" : "";
                string msg = $"No se pudo cargar la lista de clientes.{inner}\n\n" + "Solo estará disponible 'Venta Mostrador'. Para ver clientes, ejecutar scripts 01.sql-09.sql en SSMS.";
                MessageBox.Show(msg, "Aviso", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                try
                {
                    if (cbCliente.Items.Count == 0)
                        cbCliente.Items.Add(new { Id = (int? )null, NombreCompleto = "Venta Mostrador" });
                    cbCliente.SelectedIndex = 0;
                    cbCliente.DisplayMember = "NombreCompleto";
                    cbCliente.ValueMember = "Id";
                    cbCliente.DropDownStyle = ComboBoxStyle.DropDownList;
                }
                catch
                {
                }
            }
        }

        private void CargarProductos()
        {
            try
            {
                dgvProductos.DataSource = null;
                dgvProductos.DataSource = _productoBLL.Listar().Where(p => p.Activo).ToList();
                dgvProductos.ClearSelection();
                dgvProductos.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.None;
                dgvProductos.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
                dgvProductos.AllowUserToAddRows = false;
                dgvProductos.AllowUserToDeleteRows = false;
                dgvProductos.RowHeadersVisible = false;
                if (dgvProductos.Columns.Contains("DVH"))
                    dgvProductos.Columns["DVH"].Visible = false;
                if (dgvProductos.Columns.Contains("Id"))
                    dgvProductos.Columns["Id"].HeaderText = "ID";
                if (dgvProductos.Columns.Contains("Nombre"))
                    dgvProductos.Columns["Nombre"].HeaderText = "Producto";
                if (dgvProductos.Columns.Contains("Categoria"))
                    dgvProductos.Columns["Categoria"].Visible = false;
                if (dgvProductos.Columns.Contains("CategoriaNombre"))
                {
                    dgvProductos.Columns["CategoriaNombre"].HeaderText = "Categoría";
                    dgvProductos.Columns["CategoriaNombre"].DisplayIndex = 2;
                }

                if (dgvProductos.Columns.Contains("LitrosPorUnidad"))
                {
                    dgvProductos.Columns["LitrosPorUnidad"].HeaderText = "Litros/Unidad";
                    dgvProductos.Columns["LitrosPorUnidad"].DefaultCellStyle.Format = "N2";
                }

                if (dgvProductos.Columns.Contains("Precio"))
                    dgvProductos.Columns["Precio"].DefaultCellStyle.Format = "N2";
                foreach (DataGridViewColumn col in dgvProductos.Columns)
                    col.ReadOnly = true;
                AjustarColumnasGrid(dgvProductos, "Nombre");
                AplicarEstilo(dgvProductos);
            }
            catch (Exception ex)
            {
                string inner = ex.InnerException != null ? $" → {ex.InnerException.Message}" : "";
                string msg = $"No se pudo cargar la lista de productos.{inner}\n\n" + "Verificar que los stored procedures de Productos existan en la base de datos.";
                MessageBox.Show(msg, "Error al cargar productos", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private Lote ElegirLoteManual(List<Lote> lotes, Producto producto, int cantidad, out bool canceladoPorUsuario)
        {
            canceladoPorUsuario = false;
            using (Form form = new Form())
            {
                form.Text = $"Seleccionar Lote - {producto.Nombre}";
                form.StartPosition = FormStartPosition.CenterScreen;
                form.FormBorderStyle = FormBorderStyle.FixedDialog;
                form.MaximizeBox = false;
                form.MinimizeBox = false;
                form.ClientSize = new Size(540, 350);
                form.Font = new Font("Segoe UI", 9F);
                Label lblInfo = new Label
                {
                    Location = new Point(15, 15),
                    AutoSize = true,
                    Text = $"El producto '{producto.Nombre}' tiene {lotes.Count} lotes activos.\nSeleccione de cuál vender (opcional). Cantidad: {cantidad} unid."};
                ComboBox cmb = new ComboBox
                {
                    Location = new Point(15, 70),
                    Size = new Size(510, 28),
                    DropDownStyle = ComboBoxStyle.DropDownList
                };
                cmb.Items.Add("(No seleccionar lote - usar FIFO automático)");
                foreach (Lote l in lotes)
                    cmb.Items.Add($"Lote N° {l.NumeroLote}   |   Ing: {l.FechaIngreso.ToShortDateString()}   |   Vto: {l.FechaVencimiento.ToShortDateString()}   |   Stock: {l.Cantidad}");
                cmb.SelectedIndex = 0;
                Label lblStock = new Label
                {
                    Location = new Point(15, 110),
                    AutoSize = true,
                    Text = "",
                    ForeColor = ColorTranslator.FromHtml("#3A6351"),
                    Font = new Font("Segoe UI", 9F, FontStyle.Bold)
                };
                cmb.SelectedIndexChanged += (_, __) =>
                {
                    if (cmb.SelectedIndex == 0)
                    {
                        lblStock.Text = "Se aplicará FIFO: primero ingresa → primero sale.";
                    }
                    else
                    {
                        Lote loteElegido = lotes[cmb.SelectedIndex - 1];
                        lblStock.Text = loteElegido.Cantidad >= cantidad ? $"OK: Lote {loteElegido.NumeroLote} tiene stock suficiente ({loteElegido.Cantidad} disponibles)." : $"⚠️ ATENCIÓN: Stock insuficiente en este lote. Dispone: {loteElegido.Cantidad}.";
                    }
                };
                cmb.SelectedIndex = 0;
                Button btnAceptar = new Button
                {
                    Text = "Confirmar",
                    DialogResult = DialogResult.OK,
                    Location = new Point(240, 280),
                    Size = new Size(140, 42),
                    BackColor = ColorTranslator.FromHtml("#3A6351"),
                    ForeColor = Color.White,
                    FlatStyle = FlatStyle.Flat
                };
                btnAceptar.FlatAppearance.BorderSize = 0;
                Button btnCancelarLote = new Button
                {
                    Text = "Cancelar carga",
                    DialogResult = DialogResult.Cancel,
                    Location = new Point(390, 280),
                    Size = new Size(140, 42)
                };
                form.Controls.Add(lblInfo);
                form.Controls.Add(cmb);
                form.Controls.Add(lblStock);
                form.Controls.Add(btnAceptar);
                form.Controls.Add(btnCancelarLote);
                form.AcceptButton = btnAceptar;
                form.CancelButton = btnCancelarLote;
                if (form.ShowDialog() != DialogResult.OK)
                {
                    canceladoPorUsuario = true;
                    return null;
                }

                if (cmb.SelectedIndex == 0)
                    return null;
                return lotes[cmb.SelectedIndex - 1];
            }
        }

        private void btnAgregarProducto_Click(object sender, EventArgs e)
        {
            try
            {
                if (dgvProductos.SelectedRows.Count > 0)
                {
                    Producto producto = (Producto)dgvProductos.SelectedRows[0].DataBoundItem;
                    int cantidad = (int)nudCantidad.Value;
                    List<Lote> lotesActivos = _loteBLL.ListarPorProducto(producto.Id);
                    if (lotesActivos == null || lotesActivos.Count == 0)
                    {
                        MessageBox.Show("Este producto no tiene lotes activos. Cree al menos un lote antes de vender.");
                        return;
                    }

                    int? loteIdFinal = null;
                    string loteNumFinal = null;
                    int? lotePre = LoteBLL.ObtenerLotePreseleccionado(producto.Id);
                    if (lotePre.HasValue)
                    {
                        Lote? loteObj = lotesActivos.FirstOrDefault(l => l.Id == lotePre.Value);
                        if (loteObj != null)
                        {
                            if (loteObj.Cantidad >= cantidad)
                            {
                                loteIdFinal = loteObj.Id;
                                loteNumFinal = loteObj.NumeroLote;
                            }
                            else
                            {
                                if (MessageBox.Show($"El lote pre-seleccionado (N° {loteObj.NumeroLote}) no tiene stock suficiente\n" + $"para {cantidad} unidades (solo hay {loteObj.Cantidad}).\n\n" + "¿Desea elegir otro lote MANUALMENTE?", "Lote pre-seleccionado insuficiente", MessageBoxButtons.YesNo, MessageBoxIcon.Warning) == DialogResult.Yes)
                                {
                                    bool cancelado;
                                    Lote elegido = ElegirLoteManual(lotesActivos, producto, cantidad, out cancelado);
                                    if (cancelado || elegido == null)
                                        return;
                                    loteIdFinal = elegido.Id;
                                    loteNumFinal = elegido.NumeroLote;
                                }
                                else
                                {
                                    LoteBLL.LimpiarLotePreseleccionado(producto.Id);
                                }
                            }
                        }
                        else
                        {
                            LoteBLL.LimpiarLotePreseleccionado(producto.Id);
                        }
                    }

                    if (!loteIdFinal.HasValue && lotesActivos.Count >= 2)
                    {
                        bool canceladoPorUsuario;
                        Lote elegido = ElegirLoteManual(lotesActivos, producto, cantidad, out canceladoPorUsuario);
                        if (canceladoPorUsuario)
                            return;
                        if (elegido != null)
                        {
                            if (elegido.Cantidad < cantidad)
                            {
                                MessageBox.Show($"Stock insuficiente en el lote N° {elegido.NumeroLote}.\n" + $"Dispone de {elegido.Cantidad}, requiere {cantidad}.", "Stock insuficiente", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                                return;
                            }

                            loteIdFinal = elegido.Id;
                            loteNumFinal = elegido.NumeroLote;
                        }
                    }

                    if (!loteIdFinal.HasValue)
                    {
                        Lote? loteFIFO = lotesActivos.OrderBy(l => l.FechaIngreso).ThenBy(l => l.Id).FirstOrDefault(l => l.Cantidad >= cantidad);
                        if (loteFIFO == null)
                        {
                            int totalDisp = lotesActivos.Sum(l => l.Cantidad);
                            MessageBox.Show($"Stock insuficiente (FIFO).\n" + $"Cantidad requerida: {cantidad}.\n" + $"Total disponible en lotes: {totalDisp}.", "Stock insuficiente", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                            return;
                        }

                        loteIdFinal = loteFIFO.Id;
                        loteNumFinal = loteFIFO.NumeroLote;
                    }

                    VentaDetalle? existente = _carrito.FirstOrDefault(x => x.ProductoId == producto.Id);
                    int cantidadActual = existente != null ? existente.Cantidad : 0;
                    if (cantidad + cantidadActual > producto.Stock)
                    {
                        MessageBox.Show("No hay suficiente stock disponible para acumular esa cantidad.");
                        return;
                    }

                    if (existente != null)
                    {
                        existente.Cantidad += cantidad;
                        existente.PrecioUnitario = producto.Precio;
                        if (loteIdFinal.HasValue)
                        {
                            existente.LoteId = loteIdFinal.Value;
                            existente.LoteNumero = loteNumFinal;
                        }
                    }
                    else
                    {
                        _carrito.Add(new VentaDetalle { ProductoId = producto.Id, ProductoNombre = producto.Nombre, Cantidad = cantidad, PrecioUnitario = producto.Precio, LoteId = loteIdFinal, LoteNumero = loteNumFinal });
                    }

                    ActualizarCarrito();
                    CalcularTotal();
                    nudCantidad.Value = 1;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error al agregar producto: {ex.Message}");
            }
        }

        private void btnCancelarCarrito_Click(object sender, EventArgs e)
        {
            _carrito.Clear();
            ActualizarCarrito();
            CalcularTotal();
            dgvProductos.ClearSelection();
            dgvCarrito.ClearSelection();
            nudCantidad.Value = 1;
        }

        private void ActualizarCarrito()
        {
            dgvCarrito.DataSource = null;
            dgvCarrito.DataSource = _carrito.Select(d => new { Producto = d.ProductoNombre, Cantidad = d.Cantidad, PrecioUnitario = d.PrecioUnitario, Subtotal = d.Subtotal, Lote = string.IsNullOrWhiteSpace(d.LoteNumero) ? "(FIFO automático)" : $"Lote N° {d.LoteNumero}" }).ToList();
            dgvCarrito.ClearSelection();
            dgvCarrito.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.None;
            dgvCarrito.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            dgvCarrito.MultiSelect = false;
            dgvCarrito.EditMode = DataGridViewEditMode.EditProgrammatically;
            dgvCarrito.AllowUserToAddRows = false;
            dgvCarrito.AllowUserToDeleteRows = false;
            dgvCarrito.ReadOnly = true;
            dgvCarrito.RowHeadersVisible = false;
            dgvCarrito.SelectionChanged -= dgvCarrito_SelectionChanged;
            dgvCarrito.SelectionChanged += dgvCarrito_SelectionChanged;
            if (dgvCarrito.Columns.Contains("PrecioUnitario"))
                dgvCarrito.Columns["PrecioUnitario"].DefaultCellStyle.Format = "N2";
            if (dgvCarrito.Columns.Contains("Subtotal"))
                dgvCarrito.Columns["Subtotal"].DefaultCellStyle.Format = "N2";
            if (dgvCarrito.Columns.Contains("Lote"))
            {
                dgvCarrito.Columns["Lote"].HeaderText = "Lote";
                dgvCarrito.Columns["Lote"].DefaultCellStyle.ForeColor = ColorTranslator.FromHtml("#3A6351");
            }

            AjustarColumnasGrid(dgvCarrito, "Producto");
            AplicarEstilo(dgvCarrito);
            UpdateRemoveButtonState();
        }

        private void AjustarColumnasGrid(DataGridView grid, string fillColumnName = null)
        {
            if (grid?.Columns == null)
                return;
            foreach (DataGridViewColumn col in grid.Columns)
            {
                if (!string.IsNullOrEmpty(fillColumnName) && string.Equals(col.Name, fillColumnName, StringComparison.OrdinalIgnoreCase))
                {
                    col.AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill;
                    col.FillWeight = 60;
                }
                else
                {
                    col.AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells;
                }
            }
        }

        private void AplicarEstilo(DataGridView grid)
        {
            if (grid == null)
                return;
            grid.AlternatingRowsDefaultCellStyle.BackColor = Color.FromArgb(245, 245, 245);
            grid.ColumnHeadersDefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
            grid.RowTemplate.Height = 30;
            grid.ReadOnly = true;
            grid.MultiSelect = false;
        }

        private void dgvCarrito_SelectionChanged(object sender, EventArgs e)
        {
            UpdateRemoveButtonState();
        }

        private void UpdateRemoveButtonState()
        {
            btnQuitarItem.Enabled = dgvCarrito.SelectedRows.Count > 0;
        }

        private void btnQuitarItem_Click(object sender, EventArgs e)
        {
            if (dgvCarrito.SelectedRows.Count == 0)
                return;
            dynamic item = dgvCarrito.SelectedRows[0].DataBoundItem;
            if (item == null)
                return;
            string nombreProd = item.Producto;
            _carrito.RemoveAll(x => x.ProductoNombre == nombreProd);
            ActualizarCarrito();
            CalcularTotal();
        }

        private void CalcularTotal()
        {
            decimal total = 0;
            foreach (VentaDetalle item in _carrito)
            {
                total += item.PrecioUnitario * item.Cantidad;
            }

            lblTotal.Text = $"Total: ${total}";
        }

        private void btnVerLotes_Click(object sender, EventArgs e)
        {
            if (dgvProductos.SelectedRows.Count == 0)
            {
                MessageBox.Show("Seleccione un producto para ver sus lotes.");
                return;
            }

            Producto producto = (Producto)dgvProductos.SelectedRows[0].DataBoundItem;
            FrmLotes frm = new FrmLotes(producto.Id);
            frm.ShowDialog();
        }

        private void cbCliente_SelectedIndexChanged(object sender, EventArgs e)
        {
            string zonaMostrar = "-";
            try
            {
                if (cbCliente.SelectedItem != null)
                {
                    dynamic sel = cbCliente.SelectedItem;
                    int? clienteId = sel.Id;
                    if (clienteId.HasValue)
                    {
                        Cliente cliente = _clienteBLL.ObtenerPorId(clienteId.Value);
                        if (cliente != null && !string.IsNullOrWhiteSpace(cliente.Zona))
                            zonaMostrar = cliente.Zona.Trim();
                    }
                    else
                    {
                        zonaMostrar = "(Mostrador)";
                    }
                }
            }
            catch
            {
            }

            txtZona.Text = zonaMostrar;
        }

        private void btnRegistrarVenta_Click(object sender, EventArgs e)
        {
            try
            {
                int usuarioId = Sesion.Instancia.UsuarioLogueado.Id;
                int? clienteId = null;
                string clienteNombre = "Venta Mostrador";
                string? zonaVenta = null;
                if (cbCliente.SelectedItem != null)
                {
                    dynamic sel = cbCliente.SelectedItem;
                    clienteId = sel.Id;
                    clienteNombre = sel.NombreCompleto ?? "Venta Mostrador";
                    if (clienteId.HasValue)
                    {
                        try
                        {
                            Cliente cliente = _clienteBLL.ObtenerPorId(clienteId.Value);
                            if (cliente != null && !string.IsNullOrWhiteSpace(cliente.Zona))
                                zonaVenta = cliente.Zona.Trim();
                        }
                        catch
                        {
                        }
                    }
                }

                string vendedor = Sesion.Instancia?.UsuarioLogueado?.NombreUsuario;
                Venta venta = _ventaBLL.ConfirmarVenta(_carrito, usuarioId, clienteId, zonaVenta, vendedor);
                string vendedorNombre = Sesion.Instancia?.UsuarioLogueado?.NombreUsuario ?? "";
                StringBuilder detalle = new StringBuilder();
                detalle.AppendLine($"Venta #{venta.Id} - Fecha: {venta.Fecha}");
                detalle.AppendLine($"Vendedor: {vendedorNombre}");
                detalle.AppendLine($"Cliente: {clienteNombre}");
                if (!string.IsNullOrWhiteSpace(zonaVenta))
                    detalle.AppendLine($"Zona: {zonaVenta}");
                foreach (VentaDetalle? d in venta.Detalles)
                    detalle.AppendLine($"- {d.ProductoNombre} x {d.Cantidad} @ ${d.PrecioUnitario} = ${d.Subtotal}");
                decimal total = venta.Detalles.Sum(x => x.Subtotal);
                detalle.AppendLine($"Total: ${total}");
                MessageBox.Show(detalle.ToString(), "Venta registrada con éxito");
                try
                {
                    StringBuilder html = new StringBuilder();
                    html.Append("<html><head><meta charset='utf-8'><title>Comprobante</title></head><body>");
                    html.Append($"<h2>Venta #{venta.Id}</h2>");
                    html.Append($"<p>Fecha: {venta.Fecha}</p>");
                    html.Append($"<p>Vendedor: {vendedorNombre}</p>");
                    html.Append($"<p>Cliente: {clienteNombre}</p>");
                    html.Append("<ul>");
                    foreach (VentaDetalle? d in venta.Detalles)
                        html.Append($"<li>{d.ProductoNombre} x {d.Cantidad} @ ${d.PrecioUnitario} = ${d.Subtotal}</li>");
                    html.Append($"</ul><h3>Total: ${total}</h3></body></html>");
                    string path = System.IO.Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments), $"Comprobante_Venta_{venta.Id}.html");
                    System.IO.File.WriteAllText(path, html.ToString(), Encoding.UTF8);
                }
                catch
                {
                }

                _carrito.Clear();
                dgvCarrito.DataSource = null;
                lblTotal.Text = "Total: $0";
                cbCliente.SelectedIndex = 0;
            }
            catch (Exception ex)
            {
                StringBuilder sb = new StringBuilder();
                sb.AppendLine($"❌ Error al registrar venta:");
                sb.AppendLine(ex.Message);
                Exception? inEx = ex.InnerException;
                int n = 1;
                while (inEx != null)
                {
                    sb.AppendLine($"\n→ Detalle {n}: {inEx.Message}");
                    inEx = inEx.InnerException;
                    n++;
                }

                sb.AppendLine("\n\n👉 Pasos para solucionar (en SSMS sobre BaseGestionBebidasMF):" + "\n1) Ejecutar: BASE\\ScriptsClientes\\07_AlterTable_Ventas_Zona_Vendedor.sql  (agrega Zona/Vendedor a Ventas)" + "\n2) Ejecutar: BASE\\ScriptsClientes\\08_sp_Ventas_Insertar_ConClienteId.sql" + "\n3) Verificar que existan los SPs: sp_DetalleVentas_Upsert / sp_Lote_ListarPorProducto / sp_Lote_ActualizarStockProducto / sp_Lote_CalcularStockTotal");
                MessageBox.Show(sb.ToString(), "Error en Venta", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }

            CargarProductos();
            ActualizarCarrito();
        }

        public override void ActualizarIdioma(Dictionary<string, string> traducciones)
        {
            base.ActualizarIdioma(traducciones);
            if (traducciones.TryGetValue("Total", out string? txTotal))
            {
                string texto = lblTotal.Text;
                string valor = "0";
                int idx = texto.LastIndexOf('$');
                if (idx >= 0 && idx + 1 < texto.Length)
                    valor = texto.Substring(idx + 1);
                lblTotal.Text = $"{txTotal}: ${valor}";
            }
        }
    }
}
