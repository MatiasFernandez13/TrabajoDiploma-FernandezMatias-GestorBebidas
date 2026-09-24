using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;
using BLL;
using BE;
using System.Drawing;

namespace UI
{
    public partial class FrmControlCambiosProductos : Form
    {
        private readonly ProductoBLL _productoBLL = new ProductoBLL();
        private readonly ProductoHistorialBLL _historialBLL = new ProductoHistorialBLL();
        private List<Producto> _productos = new List<Producto>();
        private List<(int IdHistorial, DateTime Fecha, Producto Snapshot)> _historial = new List<(int, DateTime, Producto)>();
        public FrmControlCambiosProductos()
        {
            InitializeComponent();
        }

        private void FrmControlCambiosProductos_Load(object sender, EventArgs e)
        {
            _productos = _productoBLL.Listar();
            cbProductos.DataSource = _productos;
            cbProductos.DisplayMember = "Nombre";
            cbProductos.ValueMember = "Id";
            AplicarEstilo(dgvHistorial);
            AplicarEstilo(dgvActual);
        }

        private void btnCargar_Click(object sender, EventArgs e)
        {
            try
            {
                if (cbProductos.SelectedItem is Producto p)
                {
                    _historial = _historialBLL.ListarPorProducto(p.Id);
                    btnRevertir.Enabled = false;
                    dgvHistorial.DataSource = _historial.Select(h => new { h.IdHistorial, h.Fecha, h.Snapshot.Nombre, h.Snapshot.Categoria, h.Snapshot.Precio, h.Snapshot.LitrosPorUnidad, h.Snapshot.Stock, h.Snapshot.Activo }).ToList();
                    CargarActual(p.Id);
                    MarcarDiferenciasConSeleccion();
                }
            }
            catch (Exception ex)
            {
                BLL.BitacoraHelper.Registrar("Producto", "Error", "Cargar historial: " + ex.Message);
                MessageBox.Show("Error al cargar historial: " + ex.Message);
            }
        }

        private void CargarActual(int idProducto)
        {
            Producto actual = _productoBLL.ObtenerPorId(idProducto);
            if (actual == null)
            {
                dgvActual.DataSource = null;
                return;
            }

            dgvActual.DataSource = new[]
            {
                new
                {
                    IdHistorial = 0,
                    Fecha = DateTime.Now,
                    actual.Nombre,
                    Categoria = actual.Categoria,
                    actual.Precio,
                    LitrosPorUnidad = actual.LitrosPorUnidad,
                    actual.Stock,
                    actual.Activo
                }
            }.ToList();
            AjustarColumnas(dgvActual);
        }

        private void dgvHistorial_SelectionChanged(object sender, EventArgs e)
        {
            btnRevertir.Enabled = dgvHistorial.SelectedRows.Count > 0;
            MarcarDiferenciasConSeleccion();
        }

        private void MarcarDiferenciasConSeleccion()
        {
            if (dgvHistorial.DataSource == null || dgvHistorial.Rows.Count == 0 || dgvActual.DataSource == null || dgvActual.Rows.Count == 0)
                return;
            DataGridViewRow refRow = dgvActual.Rows[0];
            foreach (DataGridViewRow row in dgvHistorial.Rows)
            {
                foreach (DataGridViewCell cell in row.Cells)
                {
                    cell.Style.BackColor = Color.White;
                    cell.Style.ForeColor = Color.Black;
                    cell.Style.Font = dgvHistorial.DefaultCellStyle.Font;
                }
            }

            if (dgvHistorial.SelectedRows.Count == 0)
                return;
            DataGridViewRow sel = dgvHistorial.SelectedRows[0];
            for (int i = 0; i < sel.Cells.Count && i < refRow.Cells.Count; i++)
            {
                string left = sel.Cells[i].Value?.ToString() ?? "";
                string right = refRow.Cells[i].Value?.ToString() ?? "";
                if (!string.Equals(left, right, StringComparison.OrdinalIgnoreCase))
                {
                    sel.Cells[i].Style.BackColor = Color.MistyRose;
                    sel.Cells[i].Style.ForeColor = Color.DarkRed;
                    sel.Cells[i].Style.Font = new Font(dgvHistorial.Font, FontStyle.Bold);
                }
            }
        }

        private void AplicarEstilo(DataGridView grid)
        {
            grid.ReadOnly = true;
            grid.MultiSelect = false;
            grid.RowTemplate.Height = 30;
            grid.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.AllCells;
            grid.AutoSizeRowsMode = DataGridViewAutoSizeRowsMode.None;
            grid.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            grid.AlternatingRowsDefaultCellStyle.BackColor = Color.FromArgb(245, 245, 245);
            grid.ColumnHeadersDefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
        }

        private void AjustarColumnas(DataGridView grid)
        {
            if (grid == null || grid.DataSource == null)
                return;
            foreach (DataGridViewColumn col in grid.Columns)
            {
                if (string.Equals(col.Name, "Nombre", StringComparison.OrdinalIgnoreCase))
                {
                    col.AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill;
                    col.FillWeight = 50;
                }
                else
                    col.AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells;
            }
        }

        private void btnRevertir_Click(object sender, EventArgs e)
        {
            if (dgvHistorial.SelectedRows.Count == 0)
            {
                MessageBox.Show("Seleccione una fila del historial");
                return;
            }

            int idHist = (int)dgvHistorial.SelectedRows[0].Cells["IdHistorial"].Value;
            (int IdHistorial, DateTime Fecha, Producto Snapshot) entry = _historial.FirstOrDefault(h => h.IdHistorial == idHist);
            if (entry.Snapshot == null)
            {
                MessageBox.Show("No se encontró el snapshot seleccionado.");
                return;
            }

            DialogResult r = MessageBox.Show($"¿Revertir el producto '{entry.Snapshot.Nombre}' al estado de {entry.Fecha:G}?", "Confirmar reversión", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
            if (r != DialogResult.Yes)
                return;
            try
            {
                _productoBLL.RevertirA(entry.Snapshot);
                MessageBox.Show("Reversión aplicada.");
                btnCargar_Click(sender, e);
            }
            catch (Exception ex)
            {
                BLL.BitacoraHelper.Registrar("Producto", "Error", "Rollback historial: " + ex.Message);
                MessageBox.Show("Error al revertir: " + ex.Message);
            }
        }
    }
}
