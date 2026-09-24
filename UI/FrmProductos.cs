using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using BE;
using BLL;
using System.Data.SqlClient;

namespace UI
{
    public partial class FrmProductos : FrmBase
    {
        private ProductoBLL _productoBLL = new ProductoBLL();
        private LoteBLL _loteBLL = new LoteBLL();
        private Producto _productoSeleccionado = null;
        private bool _mostrarEliminados = false;
        private bool _modoEdicion = false;
        public FrmProductos()
        {
            InitializeComponent();
        }

        private void FrmProductos_Load_1(object sender, EventArgs e)
        {
            try
            {
                CargarGrilla();
                CargarComboCategorias();
                txtNombre.MaxLength = 100;
                if (cbCategoria.Items.Count == 0)
                {
                    MessageBox.Show("No se encontraron categorías para cargar.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }

                _modoEdicion = false;
                LimpiarCampos();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error al cargar Productos: " + ex.Message);
            }
        }

        private void CargarGrilla()
        {
            dgvProductos.DataSource = null;
            List<Producto> productos = _productoBLL.Listar();
            dgvProductos.DataSource = _mostrarEliminados ? productos : productos.Where(p => p.Activo).ToList();
            dgvProductos.ClearSelection();
            _productoSeleccionado = null;
            if (dgvProductos.Columns.Contains("DVH"))
                dgvProductos.Columns["DVH"].Visible = false;
            if (dgvProductos.Columns.Contains("Id"))
                dgvProductos.Columns["Id"].HeaderText = "ID";
            if (dgvProductos.Columns.Contains("Categoria"))
                dgvProductos.Columns["Categoria"].Visible = false;
            if (dgvProductos.Columns.Contains("CategoriaNombre"))
            {
                dgvProductos.Columns["CategoriaNombre"].HeaderText = "Categoría";
                dgvProductos.Columns["CategoriaNombre"].DisplayIndex = 2;
            }

            dgvProductos.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.None;
            dgvProductos.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            AjustarColumnasGrid(dgvProductos, "Nombre");
            AplicarEstilo(dgvProductos);
            ConfigurarAutocomplete(productos);
            ActualizarEstadoBotones();
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

        private void ConfigurarAutocomplete(List<Producto> productos)
        {
            try
            {
                string[] nombres = productos.Select(p => p.Nombre).Where(n => !string.IsNullOrEmpty(n)).ToArray();
                txtNombre.AutoCompleteMode = AutoCompleteMode.SuggestAppend;
                txtNombre.AutoCompleteSource = AutoCompleteSource.CustomSource;
                AutoCompleteStringCollection source = new AutoCompleteStringCollection();
                source.AddRange(nombres);
                txtNombre.AutoCompleteCustomSource = source;
            }
            catch
            {
            }
        }

        private void CargarComboCategorias()
        {
            CategoriaBLL categoriaBLL = new BLL.CategoriaBLL();
            List<Categoria> categorias = categoriaBLL.ObtenerCategorias();
            cbCategoria.DataSource = categorias;
            cbCategoria.DisplayMember = "Nombre";
            cbCategoria.ValueMember = "Id";
            cbCategoria.SelectedIndex = -1;
        }

        private void CambiarEstadoCampos(bool habilitar)
        {
            txtNombre.ReadOnly = !habilitar;
            cbCategoria.Enabled = habilitar;
            txtLitrosPorUnidad.ReadOnly = !habilitar;
            txtStock.ReadOnly = !habilitar;
            txtPrecio.ReadOnly = !habilitar;
            txtLote.ReadOnly = !habilitar;
            dtpFechaIngreso.Enabled = habilitar;
            dtpFechaVencimiento.Enabled = habilitar;
        }

        private void LimpiarCampos()
        {
            txtNombre.Clear();
            cbCategoria.SelectedIndex = -1;
            txtLitrosPorUnidad.Clear();
            txtStock.Clear();
            txtStock.PlaceholderText = "Cant. Lote inicial";
            txtPrecio.Clear();
            txtLote.Clear();
            dtpFechaIngreso.Value = DateTime.Now;
            dtpFechaVencimiento.Value = DateTime.Now.AddMonths(1);
            _productoSeleccionado = null;
            _modoEdicion = false;
            CambiarEstadoCampos(true);
            ActualizarEstadoBotones();
        }

        private static bool TienePermiso(string key)
        {
            if (SERVICIOS.PermissionService.Has(key))
                return true;
            if (SERVICIOS.PermissionService.Has("Administrador"))
                return true;
            return true;
        }

        private void ActualizarEstadoBotones()
        {
            bool haySeleccion = _productoSeleccionado != null;
            bool esActivo = haySeleccion && _productoSeleccionado.Activo;
            bool permisoAgregar = TienePermiso("Productos.Alta");
            bool permisoModificar = TienePermiso("Productos.Modificar");
            bool permisoEliminar = TienePermiso("Productos.Baja");
            bool permisoVer = TienePermiso("Productos.Ver") || TienePermiso("AccesoProductos");
            if (_modoEdicion)
            {
                btnAgregar.Visible = false;
                btnModificar.Visible = false;
                btnEliminar.Visible = false;
                btnVerLotes.Visible = false;
                btnAgregarStock.Visible = false;
                btnToggleEliminados.Visible = false;
                btnGrabar.Visible = true;
                btnCancelar.Visible = true;
                btnGrabar.Enabled = true;
                btnCancelar.Enabled = true;
            }
            else
            {
                btnAgregar.Visible = true;
                btnModificar.Visible = true;
                btnEliminar.Visible = true;
                btnGrabar.Visible = false;
                btnCancelar.Visible = false;
                btnToggleEliminados.Visible = true;
                btnVerLotes.Visible = haySeleccion;
                btnAgregarStock.Visible = haySeleccion;
                btnAgregar.Enabled = permisoAgregar;
                btnModificar.Enabled = haySeleccion && esActivo && permisoModificar;
                btnEliminar.Enabled = haySeleccion && esActivo && permisoEliminar;
                btnVerLotes.Enabled = haySeleccion;
                btnAgregarStock.Enabled = haySeleccion && esActivo && permisoModificar;
                btnToggleEliminados.Enabled = permisoVer;
            }
        }

        private void btnAgregar_Click(object sender, EventArgs e)
        {
            LimpiarCampos();
            CambiarEstadoCampos(true);
            _modoEdicion = true;
            btnAgregar.Visible = false;
            btnModificar.Visible = false;
            btnEliminar.Visible = false;
            btnToggleEliminados.Visible = false;
            btnVerLotes.Visible = false;
            btnAgregarStock.Visible = false;
            btnGrabar.Visible = true;
            btnCancelar.Visible = true;
            txtNombre.Focus();
            ActualizarEstadoBotones();
        }

        private void btnModificar_Click(object sender, EventArgs e)
        {
            if (_productoSeleccionado == null)
                return;
            CambiarEstadoCampos(true);
            _modoEdicion = true;
            btnAgregar.Visible = false;
            btnModificar.Visible = false;
            btnEliminar.Visible = false;
            btnToggleEliminados.Visible = false;
            btnVerLotes.Visible = false;
            btnAgregarStock.Visible = false;
            btnGrabar.Visible = true;
            btnCancelar.Visible = true;
            txtStock.PlaceholderText = "Cant. nuevo lote (opcional)";
            txtNombre.Focus();
            ActualizarEstadoBotones();
        }

        private void btnEliminar_Click(object sender, EventArgs e)
        {
            if (_productoSeleccionado == null)
            {
                MessageBox.Show("Seleccione un producto para eliminar.");
                return;
            }

            if (MessageBox.Show($"¿Está seguro de eliminar el producto '{_productoSeleccionado.Nombre}'?", "Confirmar", MessageBoxButtons.YesNo) == DialogResult.Yes)
            {
                try
                {
                    _productoBLL.Eliminar(_productoBLL.ObtenerPorId(_productoSeleccionado.Id));
                    CargarGrilla();
                    LimpiarCampos();
                }
                catch (Exception ex)
                {
                    string msg = ex.InnerException != null ? ex.Message + " | " + ex.InnerException.Message : ex.Message;
                    MessageBox.Show("Error al eliminar (baja lógica): " + msg);
                }
            }
        }

        private void btnGrabar_Click(object sender, EventArgs e)
        {
            if (!ValidarCampos())
                return;
            try
            {
                bool esModificacion = _productoSeleccionado != null;
                int categoriaId = cbCategoria.SelectedValue != null ? Convert.ToInt32(cbCategoria.SelectedValue) : 0;
                double litros = double.Parse(txtLitrosPorUnidad.Text.Replace('.', ','));
                decimal precio = decimal.Parse(txtPrecio.Text.Replace('.', ','));
                if (!esModificacion)
                {
                    if (string.IsNullOrWhiteSpace(txtLote.Text))
                    {
                        MessageBox.Show("Debe ingresar un número de lote para el stock inicial.");
                        return;
                    }

                    if (string.IsNullOrWhiteSpace(txtStock.Text) || !int.TryParse(txtStock.Text, out int cantidadInicial) || cantidadInicial <= 0)
                    {
                        MessageBox.Show("Debe ingresar una cantidad válida (Stock) mayor a 0.");
                        return;
                    }

                    List<Producto> productosExistentes = _productoBLL.Listar();
                    Producto? productoExistente = productosExistentes.FirstOrDefault(p => p.Nombre.Equals(txtNombre.Text.Trim(), StringComparison.OrdinalIgnoreCase) && p.Categoria == categoriaId && Math.Abs(p.LitrosPorUnidad - litros) < 0.001 && p.Activo);
                    if (productoExistente != null)
                    {
                        DialogResult result = MessageBox.Show($"Ya existe un producto con el mismo Nombre, Categoría y Capacidad ('{productoExistente.Nombre}').\n¿Desea agregar este lote al stock del producto existente?", "Producto Existente", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
                        if (result == DialogResult.Yes)
                        {
                            productoExistente.Precio = precio;
                            Lote nuevoLote = new Lote
                            {
                                NumeroLote = txtLote.Text.Trim(),
                                FechaIngreso = dtpFechaIngreso.Value,
                                FechaVencimiento = dtpFechaVencimiento.Value,
                                Cantidad = cantidadInicial,
                                ProductoId = productoExistente.Id,
                                Activo = true
                            };
                            _productoBLL.Modificar(productoExistente, nuevoLote);
                            MessageBox.Show("Stock y lote agregados al producto existente con éxito.");
                            CargarGrilla();
                            LimpiarCampos();
                            return;
                        }
                        else
                        {
                            return;
                        }
                    }

                    Producto nuevoProducto = new Producto
                    {
                        Nombre = txtNombre.Text.Trim(),
                        Categoria = categoriaId,
                        LitrosPorUnidad = litros,
                        Stock = 0,
                        Precio = precio
                    };
                    Lote nuevoLoteInicial = new Lote
                    {
                        NumeroLote = txtLote.Text.Trim(),
                        FechaIngreso = dtpFechaIngreso.Value,
                        FechaVencimiento = dtpFechaVencimiento.Value,
                        Cantidad = cantidadInicial,
                        Activo = true
                    };
                    _productoBLL.AgregarConLote(nuevoProducto, nuevoLoteInicial);
                    MessageBox.Show("Producto y stock inicial agregados con éxito.");
                }
                else
                {
                    _productoSeleccionado.Nombre = txtNombre.Text.Trim();
                    _productoSeleccionado.Categoria = categoriaId;
                    _productoSeleccionado.LitrosPorUnidad = litros;
                    _productoSeleccionado.Precio = precio;
                    Lote loteActualizar = null;
                    if (!string.IsNullOrWhiteSpace(txtLote.Text))
                    {
                        if (string.IsNullOrWhiteSpace(txtStock.Text) || !int.TryParse(txtStock.Text, out int cantidad) || cantidad <= 0)
                        {
                            MessageBox.Show("Debe ingresar una cantidad válida para el lote.");
                            return;
                        }

                        loteActualizar = new Lote
                        {
                            NumeroLote = txtLote.Text.Trim(),
                            FechaIngreso = dtpFechaIngreso.Value,
                            FechaVencimiento = dtpFechaVencimiento.Value,
                            Cantidad = cantidad,
                            ProductoId = _productoSeleccionado.Id,
                            Activo = true
                        };
                    }

                    _productoBLL.Modificar(_productoSeleccionado, loteActualizar);
                    MessageBox.Show("Producto actualizado con éxito.");
                }

                CargarGrilla();
                LimpiarCampos();
            }
            catch (Exception ex)
            {
                string msg = ex.InnerException != null ? $"{ex.Message} → {ex.InnerException.Message}" : ex.Message;
                MessageBox.Show($"Error al grabar: {msg}");
            }
        }

        private void btnCancelar_Click(object sender, EventArgs e)
        {
            if (_productoSeleccionado != null)
                CargarDatosSeleccionado();
            LimpiarCampos();
        }

        private void btnToggleEliminados_Click(object sender, EventArgs e)
        {
            _mostrarEliminados = !_mostrarEliminados;
            btnToggleEliminados.Text = _mostrarEliminados ? "Ocultar eliminados" : "Mostrar eliminados";
            btnToggleEliminados.Tag = _mostrarEliminados ? "OcultarEliminados" : "MostrarEliminados";
            CargarGrilla();
        }

        private void dgvProductos_SelectionChanged(object sender, EventArgs e)
        {
            if (dgvProductos.SelectedRows.Count == 0)
            {
                _productoSeleccionado = null;
                ActualizarEstadoBotones();
            }
            else
            {
                CargarDatosSeleccionado();
            }
        }

        private void dgvProductos_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex >= 0)
                CargarDatosSeleccionado();
        }

        private void CargarDatosSeleccionado()
        {
            if (dgvProductos.SelectedRows.Count == 0)
                return;
            DataGridViewRow fila = dgvProductos.SelectedRows[0];
            if (fila.DataBoundItem is not Producto prod)
                return;
            _productoSeleccionado = prod;
            txtNombre.Text = prod.Nombre;
            cbCategoria.SelectedValue = prod.Categoria;
            txtLitrosPorUnidad.Text = prod.LitrosPorUnidad.ToString();
            txtStock.Text = "";
            txtStock.PlaceholderText = "Cant. nuevo lote (opcional)";
            txtPrecio.Text = prod.Precio.ToString();
            CambiarEstadoCampos(false);
            txtLote.Clear();
            dtpFechaIngreso.Value = DateTime.Now;
            dtpFechaVencimiento.Value = DateTime.Now.AddMonths(1);
            _modoEdicion = false;
            ActualizarEstadoBotones();
        }

        private void btnAgregarUnidades_Click(object sender, EventArgs e)
        {
            if (_productoSeleccionado == null)
                return;
            FrmAgregarLote frm = new FrmAgregarLote(_productoSeleccionado.Id, _productoSeleccionado.Nombre);
            frm.ShowDialog();
            if (frm.LoteAgregado)
                CargarGrilla();
        }

        private void btnVerLotes_Click(object sender, EventArgs e)
        {
            if (_productoSeleccionado == null)
            {
                MessageBox.Show("Seleccione un producto para ver sus lotes.");
                return;
            }

            FrmLotes frm = new FrmLotes(_productoSeleccionado.Id);
            frm.ShowDialog();
            CargarGrilla();
        }

        private bool ValidarCampos()
        {
            if (string.IsNullOrWhiteSpace(txtNombre.Text) || cbCategoria.SelectedIndex == -1 || string.IsNullOrWhiteSpace(txtLitrosPorUnidad.Text) || string.IsNullOrWhiteSpace(txtPrecio.Text))
            {
                MessageBox.Show("Todos los campos son obligatorios.");
                return false;
            }

            if (!double.TryParse(txtLitrosPorUnidad.Text.Replace('.', ','), out double capacidad))
            {
                MessageBox.Show("Capacidad debe ser un número válido.");
                return false;
            }

            if (!decimal.TryParse(txtPrecio.Text.Replace('.', ','), out decimal precio))
            {
                MessageBox.Show("Precio debe ser un número decimal válido.");
                return false;
            }

            return true;
        }
    }
}
