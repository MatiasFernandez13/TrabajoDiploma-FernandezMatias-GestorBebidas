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
        private readonly LoteBLL _loteBLL = new LoteBLL();
        private Producto _producto;


        public FrmLotes(Producto producto)
        {
            InitializeComponent();
            _producto = producto;
            lblProducto.Text = $"Lotes del producto: {_producto.Nombre}";
            CargarLotes();
        }


        private void CargarLotes()
        {
            dgvLotes.DataSource = null;
            dgvLotes.DataSource = _loteBLL.ListarPorProducto(_producto.Id);
            dgvLotes.ClearSelection();
        }


        private void btnAgregar_Click(object sender, EventArgs e)
        {
            try
            {
                var lote = new Lote
                {
                    ProductoId = _producto.Id,
                    NumeroLote = txtNumeroLote.Text,
                    Cantidad = int.Parse(txtCantidad.Text),
                    FechaIngreso = dtpFechaIngreso.Value
                };


                _loteBLL.Agregar(lote);
                MessageBox.Show("Lote agregado correctamente.");
                CargarLotes();
                txtNumeroLote.Clear();
                txtCantidad.Clear();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error al agregar lote: {ex.Message}");
            }
        }


        private void btnEliminar_Click(object sender, EventArgs e)
        {
            try
            {
                if (dgvLotes.CurrentRow == null)
                {
                    MessageBox.Show("Seleccione un lote para eliminar.", "Advertencia", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }


                Lote loteSeleccionado = (Lote)dgvLotes.CurrentRow.DataBoundItem;
                var resultado = MessageBox.Show("¿Está seguro de que desea eliminar el lote?", "Confirmación", MessageBoxButtons.YesNo, MessageBoxIcon.Question);


                if (resultado == DialogResult.Yes)
                {
                    _loteBLL.Eliminar(loteSeleccionado.Id, _producto.Id);
                    CargarLotes();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error al eliminar lote: {ex.Message}");
            }
        }
    }
}
