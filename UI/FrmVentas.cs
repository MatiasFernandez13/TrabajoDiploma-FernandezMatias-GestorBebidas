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

        private OpcionLotesVenta ElegirLotes(SolicitudSeleccionLotes solicitud)
        {
            List<OpcionLotesVenta> opciones = new SeleccionLotesBLL().CrearOpciones(solicitud);
            if (opciones.Count == 0)
            {
                MessageBox.Show("No hay unidades suficientes en los lotes vigentes, descontando lo que ya agregó al carrito.", "Stock insuficiente", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return null;
            }
            using (Form dialogo = new Form { Text = "Seleccionar lotes", Width = 760, Height = 290, StartPosition = FormStartPosition.CenterParent, FormBorderStyle = FormBorderStyle.FixedDialog, MaximizeBox = false, MinimizeBox = false })
            {
                Label titulo = new Label { Text = $"{solicitud.Producto.Nombre}: {solicitud.Cantidad} unidades", AutoSize = false, Bounds = new Rectangle(20, 20, 700, 35) };
                ComboBox opcionesLotes = new ComboBox { DropDownStyle = ComboBoxStyle.DropDownList, Bounds = new Rectangle(20, 70, 700, 35), DataSource = opciones, DisplayMember = "Descripcion", DropDownWidth = 900 };
                Label explicacion = new Label { AutoSize = false, Bounds = new Rectangle(20, 115, 700, 55), Text = "Las cantidades disponibles ya descuentan las unidades reservadas en este carrito. Se utilizarán únicamente los lotes de la opción elegida." };
                Button aceptar = new Button { Text = "Agregar al carrito", DialogResult = DialogResult.OK, Bounds = new Rectangle(390, 185, 170, 38) };
                Button cancelar = new Button { Text = "Cancelar", DialogResult = DialogResult.Cancel, Bounds = new Rectangle(580, 185, 140, 38) };
                dialogo.Controls.AddRange(new Control[] { titulo, opcionesLotes, explicacion, aceptar, cancelar });
                dialogo.AcceptButton = aceptar;
                dialogo.CancelButton = cancelar;
                return dialogo.ShowDialog(this) == DialogResult.OK ? opcionesLotes.SelectedItem as OpcionLotesVenta : null;
            }
        }

        private void btnAgregarProducto_Click(object sender, EventArgs e)
        {
            try
            {
                if (dgvProductos.SelectedRows.Count == 0 || dgvProductos.SelectedRows[0].DataBoundItem is not Producto producto)
                    return;
                OpcionLotesVenta opcion = ElegirLotes(new SolicitudSeleccionLotes
                {
                    Producto = producto, Cantidad = (int)nudCantidad.Value,
                    LotePreferidoId = LoteBLL.ObtenerLotePreseleccionado(producto.Id),
                    Lotes = _loteBLL.ListarPorProducto(producto.Id), Reservas = _carrito
                });
                if (opcion == null) return;
                foreach (VentaDetalle detalle in opcion.Detalles)
                {
                    VentaDetalle existente = _carrito.FirstOrDefault(d => d.ProductoId == detalle.ProductoId && d.LoteId == detalle.LoteId && d.PrecioUnitario == detalle.PrecioUnitario);
                    if (existente == null) _carrito.Add(detalle);
                    else existente.Cantidad = checked(existente.Cantidad + detalle.Cantidad);
                }
                ActualizarCarrito();
                CalcularTotal();
                nudCantidad.Value = 1;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "No se pudo agregar el producto", MessageBoxButtons.OK, MessageBoxIcon.Warning);
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
            dgvCarrito.DataSource = _carrito.ToList();
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

            foreach (string oculta in new string[] { "ProductoId", "LoteId" })
                if (dgvCarrito.Columns.Contains(oculta)) dgvCarrito.Columns[oculta].Visible = false;
            dgvCarrito.Columns["ProductoNombre"].HeaderText = "Producto";
            dgvCarrito.Columns["LoteNumero"].HeaderText = "Lote";
            AjustarColumnasGrid(dgvCarrito, "ProductoNombre");
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
            if (dgvCarrito.SelectedRows[0].DataBoundItem is VentaDetalle item)
                _carrito.Remove(item);
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
                Venta venta = _ventaBLL.ConfirmarVenta(new Venta { Detalles = _carrito, UsuarioId = usuarioId, ClienteId = clienteId, Zona = zonaVenta, Vendedor = vendedor });
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
                MessageBox.Show(ex.Message, "No se pudo registrar la venta", MessageBoxButtons.OK, MessageBoxIcon.Warning);
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
