using BLL;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace UI
{
    public partial class FrmBitacora : FrmBase
    {
        private readonly BitacoraBLL _bll = new BitacoraBLL();
        private readonly UsuarioBLL _usuarioBLL = new UsuarioBLL();
        private List<BE.Bitacora> _datosBase = new List<BE.Bitacora>();
        private bool _updating = false;
        private bool _sortAsc = true;
        public FrmBitacora()
        {
            InitializeComponent();
        }

        private void FrmBitacora_Load(object sender, EventArgs e)
        {
            cbUsuarios.SelectedIndexChanged += cbUsuarios_SelectedIndexChanged;
            cbAccion.SelectedIndexChanged += cbAccion_SelectedIndexChanged;
            dtDesde.ValueChanged += Fechas_ValueChanged;
            dtHasta.ValueChanged += Fechas_ValueChanged;
            dtDesde.Value = new DateTime(2025, 1, 1);
            dtHasta.Value = DateTime.Today;
            try
            {
                CargarTodo();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error al cargar bitácora: {ex.Message}\n\nDetalles: {ex.StackTrace}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void btnBuscar_Click(object sender, EventArgs e)
        {
            CargarBitacora();
        }

        private void CargarFiltrosIniciales()
        {
            List<string> usuariosActivos = _usuarioBLL.ObtenerTodos().Where(u => u.Activo).Select(u => u.NombreUsuario).Distinct().OrderBy(n => n).ToList();
            cbUsuarios.Items.Clear();
            cbUsuarios.Items.AddRange(usuariosActivos.Cast<object>().ToArray());
            cbUsuarios.SelectedIndex = -1;
            try
            {
                List<string> todasAcciones = _bll.Buscar(null, null, null, null).Select(b => b.Accion).Distinct().OrderBy(a => a).ToList();
                cbAccion.Items.Clear();
                cbAccion.Items.AddRange(todasAcciones.Cast<object>().ToArray());
                cbAccion.SelectedIndex = -1;
            }
            catch
            {
                cbAccion.Items.Clear();
                cbAccion.SelectedIndex = -1;
            }
        }

        private void CargarTodo()
        {
            try
            {
                _updating = true;
                DateTime desdeDef = new DateTime(2025, 1, 1);
                DateTime hastaDef = DateTime.Today.AddDays(1).AddTicks(-1);
                _datosBase = _bll.Buscar(desdeDef, hastaDef, null, null);
                string[] usuarios = _datosBase.Select(b => b.UsuarioNombre).Distinct().OrderBy(n => n).ToArray();
                cbUsuarios.Items.Clear();
                cbUsuarios.Items.AddRange(usuarios.Cast<object>().ToArray());
                cbUsuarios.SelectedIndex = -1;
                string[] acciones = _datosBase.Select(b => b.Accion).Distinct().OrderBy(a => a).ToArray();
                cbAccion.Items.Clear();
                cbAccion.Items.AddRange(acciones.Cast<object>().ToArray());
                cbAccion.SelectedIndex = -1;
                dgvBitacora.DataSource = _datosBase;
                if (dgvBitacora.Columns["UsuarioId"] != null)
                    dgvBitacora.Columns["UsuarioId"].Visible = false;
                if (dgvBitacora.Columns["DVH"] != null)
                    dgvBitacora.Columns["DVH"].Visible = false;
                if (dgvBitacora.Columns["UsuarioNombre"] != null)
                    dgvBitacora.Columns["UsuarioNombre"].HeaderText = "Usuario";
                AjustarColumnas();
                AplicarEstilo(dgvBitacora);
                _updating = false;
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error en CargarTodo: {ex.Message}\n\nDetalles: {ex.StackTrace}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void btnCancelar_Click(object sender, EventArgs e)
        {
            cbUsuarios.SelectedIndex = -1;
            cbAccion.SelectedIndex = -1;
            CargarTodo();
        }

        private void CargarBitacora()
        {
            try
            {
                DateTime? desde = dtDesde.Value.Date;
                DateTime? hasta = dtHasta.Value.Date.AddDays(1).AddTicks(-1);
                string usuario = cbUsuarios.SelectedIndex >= 0 ? cbUsuarios.SelectedItem?.ToString() : null;
                string accion = cbAccion.SelectedIndex >= 0 ? cbAccion.SelectedItem?.ToString() : null;
                _datosBase = _bll.Buscar(desde, hasta, null, null);
                IEnumerable<BE.Bitacora> datos = _datosBase.AsEnumerable();
                if (!string.IsNullOrEmpty(usuario))
                    datos = datos.Where(b => b.UsuarioNombre.Equals(usuario, StringComparison.OrdinalIgnoreCase));
                if (!string.IsNullOrEmpty(accion))
                    datos = datos.Where(b => string.Equals(b.Accion, accion, StringComparison.OrdinalIgnoreCase));
                dgvBitacora.DataSource = datos.ToList();
                if (dgvBitacora.Columns["UsuarioId"] != null)
                    dgvBitacora.Columns["UsuarioId"].Visible = false;
                if (dgvBitacora.Columns["UsuarioNombre"] != null)
                    dgvBitacora.Columns["UsuarioNombre"].HeaderText = "Usuario";
                AjustarColumnas();
                AplicarEstilo(dgvBitacora);
                _updating = true;
                string[] usuariosCombo = (string.IsNullOrEmpty(accion) ? _datosBase : _datosBase.Where(b => string.Equals(b.Accion, accion, StringComparison.OrdinalIgnoreCase))).Select(b => b.UsuarioNombre).Distinct().OrderBy(n => n).ToArray();
                string[] accionesCombo = (string.IsNullOrEmpty(usuario) ? _datosBase : _datosBase.Where(b => b.UsuarioNombre.Equals(usuario, StringComparison.OrdinalIgnoreCase))).Select(b => b.Accion).Distinct().OrderBy(a => a).ToArray();
                string? selU = usuario;
                string? selA = accion;
                cbUsuarios.Items.Clear();
                cbUsuarios.Items.AddRange(usuariosCombo.Cast<object>().ToArray());
                cbAccion.Items.Clear();
                cbAccion.Items.AddRange(accionesCombo.Cast<object>().ToArray());
                cbUsuarios.SelectedIndex = !string.IsNullOrEmpty(selU) ? Array.IndexOf(usuariosCombo, selU) : -1;
                cbAccion.SelectedIndex = !string.IsNullOrEmpty(selA) ? Array.IndexOf(accionesCombo, selA) : -1;
                _updating = false;
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error en CargarBitacora: {ex.Message}\n\nDetalles: {ex.StackTrace}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void AjustarColumnas()
        {
            if (dgvBitacora.DataSource == null)
                return;
            foreach (DataGridViewColumn col in dgvBitacora.Columns)
            {
                if (string.Equals(col.Name, "Detalle", StringComparison.OrdinalIgnoreCase))
                {
                    col.AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill;
                    col.FillWeight = 60;
                }
                else
                {
                    col.AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells;
                }
            }

            if (dgvBitacora.Columns.Contains("FechaRegistro"))
            {
                dgvBitacora.Columns["FechaRegistro"].DefaultCellStyle.Format = "dd/MM/yyyy HH:mm";
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

        private void cbUsuarios_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (_updating)
                return;
            CargarBitacora();
        }

        private void cbAccion_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (_updating)
                return;
            CargarBitacora();
        }

        private void Fechas_ValueChanged(object sender, EventArgs e)
        {
            if (_updating)
                return;
            CargarBitacora();
        }

        private void btnOrdenar_Click(object sender, EventArgs e)
        {
            if (dgvBitacora.DataSource is List<BE.Bitacora> lista)
            {
                List<BE.Bitacora> ordenada = _sortAsc ? lista.OrderBy(b => b.FechaRegistro).ToList() : lista.OrderByDescending(b => b.FechaRegistro).ToList();
                _sortAsc = !_sortAsc;
                dgvBitacora.DataSource = ordenada;
                AjustarColumnas();
            }
        }
    }
}
