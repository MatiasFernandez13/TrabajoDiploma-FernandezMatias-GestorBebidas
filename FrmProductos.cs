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
        private Producto _productoSeleccionado = null;
        private bool _mostrarEliminados = false;

        public FrmProductos()
        {
            InitializeComponent();
        }

        private void FrmProductos_Load1(object sender, EventArgs e)
        {
            CargarGrilla();
            CargarComboCategorias();
            txtNombre.MaxLength = 100;
            if (cbCategoria.Items.Count == 0)
            {
                MessageBox.Show("No se encontraron categorías para cargar.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            CambiarEstadoCampos(true);
            btnAgregar.Enabled = SERVICIOS.PermissionService.Has("Productos.Agregar");
            btnModificar.Enabled = SERVICIOS.PermissionService.Has("Productos.Modificar");
            btnEliminar.Enabled = SERVICIOS.PermissionService.Has("Productos.Eliminar");
            btnToggleEliminados.Enabled = SERVICIOS.PermissionService.Has("Productos.Ver");
        }

        private void CargarGrilla()
        {
            dgvProductos.DataSource = null;
            var productos = _productoBLL.Listar();
            dgvProductos.DataSource = _mostrarEliminados ? productos : productos.Where(p => p.Activo).ToList();
            dgvProductos.ClearSelection();
            if (dgvProductos.Columns.Contains("DVH"))
                dgvProductos.Columns["DVH"].Visible = false;
            if (dgvProductos.Columns.Contains("Id"))
                dgvProductos.Columns["Id"].HeaderText = "ID";
            dgvProductos.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            dgvProductos.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
        }
        private void CargarComboCategorias()
        {
            var categoriaBLL = new BLL.CategoriaBLL();
            var categorias = categoriaBLL.ObtenerCategorias();
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
        }

        private void LimpiarCampos()
        {
            txtNombre.Clear();
            cbCategoria.SelectedIndex = -1;
            txtLitrosPorUnidad.Clear();
            txtStock.Clear();
            txtPrecio.Clear();
            _productoSeleccionado = null;
            CambiarEstadoCampos(true);


            btnAgregar.Visible = true;
            btnModificar.Enabled = false;
            btnGrabar.Visible = false;
            btnCancelar.Visible = false;
        }

        private void btnAgregar_Click(object sender, EventArgs e)
        {
            if (!ValidarCampos()) return;

            var nuevoProducto = new Producto
            {
                Nombre = txtNombre.Text.Trim(),
                Categoria = cbCategoria.SelectedValue != null ? Convert.ToInt32(cbCategoria.SelectedValue) : 0,
                LitrosPorUnidad = double.Parse(txtLitrosPorUnidad.Text.Replace('.', ',')),
                Stock = int.Parse(txtStock.Text),
                Precio = decimal.Parse(txtPrecio.Text.Replace('.', ','))
            };

            try
            {
                _productoBLL.Agregar(nuevoProducto);
                MessageBox.Show("Producto agregado con éxito.");
                CargarGrilla();
                LimpiarCampos();
            }
            catch (Exception ex)
            {
                var msg = ex.InnerException != null ? ex.Message + " | " + ex.InnerException.Message : ex.Message;
                MessageBox.Show($"Error al agregar producto: {msg}");
            }
        }

        private void btnGrabar_Click(object sender, EventArgs e)
        {
            if (_productoSeleccionado == null || !ValidarCampos()) return;


            try
            {
                _productoSeleccionado.Nombre = txtNombre.Text.Trim();
                _productoSeleccionado.Categoria = (int)cbCategoria.SelectedValue;
                _productoSeleccionado.LitrosPorUnidad = double.Parse(txtLitrosPorUnidad.Text.Replace('.', ','));
                _productoSeleccionado.Stock = int.Parse(txtStock.Text);
                _productoSeleccionado.Precio = decimal.Parse(txtPrecio.Text.Replace('.', ','));


                _productoBLL.Modificar(_productoSeleccionado);
                MessageBox.Show("Producto modificado con éxito.");
                CargarGrilla();
                LimpiarCampos();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error al modificar producto: {ex.Message}");
            }
        }

        private void dgvProductos_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex >= 0)
            {
                _productoSeleccionado = (Producto)dgvProductos.CurrentRow.DataBoundItem;
                txtNombre.Text = _productoSeleccionado.Nombre;
                cbCategoria.SelectedValue = _productoSeleccionado.Categoria;
                txtLitrosPorUnidad.Text = _productoSeleccionado.LitrosPorUnidad.ToString();
                txtStock.Text = _productoSeleccionado.Stock.ToString();
                txtPrecio.Text = _productoSeleccionado.Precio.ToString();

                CambiarEstadoCampos(false);
                btnAgregar.Visible = false;
                btnModificar.Enabled = true;
                btnGrabar.Visible = false;
                btnCancelar.Visible = true;
            }
        }

        private void btnModificar_Click(object sender, EventArgs e)
        {
            if (_productoSeleccionado == null) return;
            CambiarEstadoCampos(true);
            btnGrabar.Visible = true;
            btnModificar.Enabled = false;
        }

        private void btnEliminar_Click(object sender, EventArgs e)
        {
            if (_productoSeleccionado == null)
            {
                MessageBox.Show("Seleccione un producto para eliminar.");
                return;
            }

            if (MessageBox.Show("¿Está seguro de eliminar este producto?", "Confirmar", MessageBoxButtons.YesNo) == DialogResult.Yes)
            {
                try
                {
                    _productoBLL.Eliminar(_productoSeleccionado.Id);
                    CargarGrilla();
                    LimpiarCampos();
                }
                catch (Exception ex)
                {
                    var msg = ex.InnerException != null ? ex.Message + " | " + ex.InnerException.Message : ex.Message;
                    MessageBox.Show("Error al eliminar (baja lógica): " + msg);
                }
            }
        }

        private void btnCancelar_Click(object sender, EventArgs e)
        {
            LimpiarCampos();
            CargarGrilla();
        }
        private void btnToggleEliminados_Click(object sender, EventArgs e)
        {
            _mostrarEliminados = !_mostrarEliminados;
            btnToggleEliminados.Text = _mostrarEliminados ? "Ocultar eliminados" : "Mostrar eliminados";
            btnToggleEliminados.Tag = _mostrarEliminados ? "OcultarEliminados" : "MostrarEliminados";
            CargarGrilla();
        }

        private void FrmProductos_Load_1(object sender, EventArgs e)
        {
            CargarGrilla();
            CargarComboCategorias();
            txtNombre.MaxLength = 100;
            if (cbCategoria.Items.Count == 0)
            {
                MessageBox.Show("No se encontraron categorías para cargar.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            CambiarEstadoCampos(true);
            btnAgregar.Enabled = SERVICIOS.PermissionService.Has("Productos.Agregar");
            btnModificar.Enabled = SERVICIOS.PermissionService.Has("Productos.Modificar");
            btnEliminar.Enabled = SERVICIOS.PermissionService.Has("Productos.Eliminar");
            btnToggleEliminados.Enabled = SERVICIOS.PermissionService.Has("Productos.Ver");
        }

        private bool ValidarCampos()
        {
            if (string.IsNullOrWhiteSpace(txtNombre.Text) ||
                cbCategoria.SelectedIndex == -1 ||
                string.IsNullOrWhiteSpace(txtLitrosPorUnidad.Text) ||
                string.IsNullOrWhiteSpace(txtStock.Text) ||
                string.IsNullOrWhiteSpace(txtPrecio.Text))
            {
                MessageBox.Show("Todos los campos son obligatorios.");
                return false;
            }

            if (!double.TryParse(txtLitrosPorUnidad.Text.Replace('.', ','), out double capacidad))
            {
                MessageBox.Show("Capacidad debe ser un número válido.");
                return false;
            }

            if (!int.TryParse(txtStock.Text, out int stock))
            {
                MessageBox.Show("Stock debe ser un número entero.");
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
