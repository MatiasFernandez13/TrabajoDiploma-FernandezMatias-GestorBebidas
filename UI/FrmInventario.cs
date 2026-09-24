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
                Ajustar(dgvStockProductos);
                Ajustar(dgvStockLotes);
                AplicarEstilo(dgvStockProductos);
                AplicarEstilo(dgvStockLotes);
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error al cargar el inventario: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void Ajustar(DataGridView grid)
        {
            if (grid == null)
                return;
            grid.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.None;
            foreach (DataGridViewColumn col in grid.Columns)
                col.AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells;
        }

        private void AplicarEstilo(DataGridView grid)
        {
            if (grid == null)
                return;
            grid.AlternatingRowsDefaultCellStyle.BackColor = System.Drawing.Color.FromArgb(245, 245, 245);
            grid.ColumnHeadersDefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
            grid.RowTemplate.Height = 30;
            grid.ReadOnly = true;
            grid.MultiSelect = false;
        }

        private void dgvStockProductos_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
        }
    }
}
