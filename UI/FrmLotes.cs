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

namespace UI
{
    public partial class FrmLotes : FrmBase
    {
        private LoteBLL _loteBLL = new LoteBLL();
        private ProductoBLL _productoBLL = new ProductoBLL();
        private int _productoId;
        private Lote _loteSeleccionado = null;
        public FrmLotes(int productoId)
        {
            InitializeComponent();
            _productoId = productoId;
        }

        private void ActualizarEstadoBotones()
        {
            bool haySeleccion = _loteSeleccionado != null;
            btnEliminar.Enabled = haySeleccion;
            btnSeleccionarParaVenta.Enabled = haySeleccion;
        }

        private void ActualizarLabelSeleccionado()
        {
            int? loteIdSel = LoteBLL.ObtenerLotePreseleccionado(_productoId);
            if (loteIdSel.HasValue)
            {
                Lote? lote = _loteBLL.ListarPorProducto(_productoId).FirstOrDefault(l => l.Id == loteIdSel.Value);
                if (lote != null)
                {
                    lblSeleccionado.Text = $"✅ Seleccionado para Venta: Lote N° {lote.NumeroLote} (stock: {lote.Cantidad})";
                    return;
                }
                else
                {
                    LoteBLL.LimpiarLotePreseleccionado(_productoId);
                }
            }

            lblSeleccionado.Text = "(sin lote preseleccionado: al vender usará FIFO)";
        }

        private void FrmLotes_Load(object sender, EventArgs e)
        {
            Producto producto = _productoBLL.ObtenerPorId(_productoId);
            this.Text = $"Lotes de: {producto.Nombre}";
            CargarLotes(_productoId);
            ActualizarEstadoBotones();
            ActualizarLabelSeleccionado();
        }

        private void CargarLotes(int productoId)
        {
            dgvLotes.DataSource = null;
            List<Lote> lista = _loteBLL.ListarPorProducto(productoId);
            dgvLotes.DataSource = lista;
            dgvLotes.ClearSelection();
            _loteSeleccionado = null;
            int? loteIdSel = LoteBLL.ObtenerLotePreseleccionado(productoId);
            if (loteIdSel.HasValue)
            {
                foreach (DataGridViewRow fila in dgvLotes.Rows)
                {
                    if (fila.DataBoundItem is Lote l && l.Id == loteIdSel.Value)
                    {
                        fila.Selected = true;
                        fila.DefaultCellStyle.BackColor = Color.FromArgb(220, 245, 220);
                        _loteSeleccionado = l;
                        break;
                    }
                }
            }

            dgvLotes.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.None;
            foreach (DataGridViewColumn col in dgvLotes.Columns)
                col.AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells;
            if (dgvLotes.Columns.Contains("ProductoId"))
                dgvLotes.Columns["ProductoId"].Visible = false;
            if (dgvLotes.Columns.Contains("Id"))
                dgvLotes.Columns["Id"].Visible = false;
            ActualizarEstadoBotones();
        }

        private void dgvLotes_SelectionChanged(object sender, EventArgs e)
        {
            if (dgvLotes.SelectedRows.Count == 0)
            {
                _loteSeleccionado = null;
            }
            else
            {
                DataGridViewRow fila = dgvLotes.SelectedRows[0];
                if (fila.DataBoundItem is Lote lote)
                {
                    _loteSeleccionado = lote;
                }
            }

            ActualizarEstadoBotones();
        }

        private void btnEliminar_Click(object sender, EventArgs e)
        {
            if (_loteSeleccionado == null)
            {
                MessageBox.Show("Seleccione un lote para eliminar.");
                return;
            }

            if (MessageBox.Show("¿Está seguro de eliminar este lote? Esto descontará el stock del producto.", "Confirmar", MessageBoxButtons.YesNo) == DialogResult.Yes)
            {
                try
                {
                    int pId = _loteSeleccionado.ProductoId;
                    int? loteSel = LoteBLL.ObtenerLotePreseleccionado(pId);
                    if (loteSel.HasValue && loteSel.Value == _loteSeleccionado.Id)
                        LoteBLL.LimpiarLotePreseleccionado(pId);
                    _loteBLL.Eliminar(_loteSeleccionado.Id, pId);
                    CargarLotes(pId);
                    ActualizarLabelSeleccionado();
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"Error al eliminar lote: {ex.Message}");
                }
            }
        }

        private void btnSeleccionarParaVenta_Click(object sender, EventArgs e)
        {
            if (_loteSeleccionado == null)
            {
                MessageBox.Show("Seleccione primero un lote de la grilla.");
                return;
            }

            LoteBLL.EstablecerLotePreseleccionado(_productoId, _loteSeleccionado.Id);
            ActualizarLabelSeleccionado();
            CargarLotes(_productoId);
            MessageBox.Show($"Lote N° {_loteSeleccionado.NumeroLote} pre-seleccionado correctamente.\n\n" + "Cuando agregue este producto al carrito de ventas, se descontará automáticamente de ESTE lote.", "Lote seleccionado", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        private void cbProducto_SelectedIndexChanged(object sender, EventArgs e)
        {
        }

        private void btnAgregar_Click(object sender, EventArgs e)
        {
        }
    }
}
