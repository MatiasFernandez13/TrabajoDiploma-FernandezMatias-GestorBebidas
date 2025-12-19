using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using BLL;

namespace UI
{
    public partial class FrmInventario : FrmBase
    {
        private readonly InventarioBLL _inventarioBLL = new InventarioBLL();
        public FrmInventario()
        {
            InitializeComponent();
        }

        private void FrmInventario_Load(object sender, EventArgs e)
        {
            try
            {
                dgvStockProductos.DataSource = _inventarioBLL.ObtenerStockPorProducto();
                dgvStockLotes.DataSource = _inventarioBLL.ObtenerStockPorProducto();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error al cargar el inventario: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void dgvStockProductos_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }
    }
}
