using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Net.Mail;
using System.Windows.Forms;
using BE;
using BLL;

namespace UI
{
    public partial class FrmClientes : FrmBase
    {
        private readonly ClienteBLL _clienteBLL = new ClienteBLL();
        private Cliente _clienteSeleccionado = null;
        private bool _mostrarEliminados = false;
        private bool _modoEdicion = false;
        public FrmClientes()
        {
            InitializeComponent();
        }

        private void FrmClientes_Load(object sender, EventArgs e)
        {
            try
            {
                CargarComboZonas();
                CargarGrilla();
                txtNombreCompleto.MaxLength = 100;
                txtDireccion.MaxLength = 255;
                txtTelefono.MaxLength = 50;
                txtEmail.MaxLength = 150;
                _modoEdicion = false;
                LimpiarCampos();
            }
            catch (Exception ex)
            {
                string inner = ex.InnerException != null ? $" → {ex.InnerException.Message}" : "";
                string msg = $"Error al abrir Clientes: {ex.Message}{inner}\n\n" + "Causa probable: falta ejecutar los stored procedures de Clientes.\n" + "Abrir SSMS, seleccionar BaseGestionBebidasMF y ejecutar los scripts " + "de la carpeta BASE/ScriptsClientes en orden (01.sql al 09.sql).\n\n" + "Se cerrará el formulario.";
                MessageBox.Show(msg, "Error de base de datos", MessageBoxButtons.OK, MessageBoxIcon.Error);
                this.Close();
            }
        }

        private void CargarComboZonas()
        {
            cbZona.Items.Clear();
            List<string> zonasPredefinidas = new List<string>
            {
                "Centro",
                "Norte",
                "Sur",
                "Este",
                "Oeste",
                "Noroeste",
                "Noreste",
                "Sudoeste",
                "Sudeste"
            };
            try
            {
                List<string> zonasBD = _clienteBLL.ListarZonas() ?? new List<string>();
                foreach (string z in zonasPredefinidas)
                    if (!cbZona.Items.Contains(z))
                        cbZona.Items.Add(z);
                foreach (string? z in zonasBD)
                    if (!string.IsNullOrWhiteSpace(z) && !cbZona.Items.Contains(z.Trim()))
                        cbZona.Items.Add(z.Trim());
            }
            catch
            {
                foreach (string z in zonasPredefinidas)
                    if (!cbZona.Items.Contains(z))
                        cbZona.Items.Add(z);
            }

            if (cbZona.Items.Count > 0)
                cbZona.SelectedIndex = 0;
            else
                cbZona.SelectedIndex = -1;
        }

        private void CargarGrilla()
        {
            try
            {
                dgvClientes.DataSource = null;
                List<Cliente> clientes = _clienteBLL.Listar();
                dgvClientes.DataSource = _mostrarEliminados ? clientes : clientes.Where(c => c.Activo).ToList();
                dgvClientes.ClearSelection();
                _clienteSeleccionado = null;
                if (dgvClientes.Columns.Contains("DVH"))
                    dgvClientes.Columns["DVH"].Visible = false;
                if (dgvClientes.Columns.Contains("Id"))
                    dgvClientes.Columns["Id"].HeaderText = "ID";
                if (dgvClientes.Columns.Contains("NombreCompleto"))
                    dgvClientes.Columns["NombreCompleto"].HeaderText = "Nombre Completo";
                if (dgvClientes.Columns.Contains("Direccion"))
                    dgvClientes.Columns["Direccion"].HeaderText = "Dirección";
                if (dgvClientes.Columns.Contains("Telefono"))
                    dgvClientes.Columns["Telefono"].HeaderText = "Teléfono";
                if (dgvClientes.Columns.Contains("Email"))
                    dgvClientes.Columns["Email"].HeaderText = "Email";
                if (dgvClientes.Columns.Contains("Zona"))
                    dgvClientes.Columns["Zona"].HeaderText = "Zona";
                if (dgvClientes.Columns.Contains("Activo"))
                    dgvClientes.Columns["Activo"].HeaderText = "Activo";
                dgvClientes.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.None;
                dgvClientes.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
                AjustarColumnasGrid(dgvClientes, "NombreCompleto");
                AplicarEstilo(dgvClientes);
                ActualizarEstadoBotones();
            }
            catch (Exception ex)
            {
                string inner = ex.InnerException != null ? $" → {ex.InnerException.Message}" : "";
                string msg = $"No se pudo cargar la lista de clientes.{inner}\n\n" + "Causa probable: stored procedure sp_Clientes_Listar no encontrado.\n" + "Ejecutar los scripts 01.sql a 09.sql en BASE/ScriptsClientes.";
                MessageBox.Show(msg, "Error al cargar grilla", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
        }

        private static void AjustarColumnasGrid(DataGridView grid, string fillColumnName = null)
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

        private static void AplicarEstilo(DataGridView grid)
        {
            if (grid == null)
                return;
            grid.AlternatingRowsDefaultCellStyle.BackColor = Color.FromArgb(245, 245, 245);
            grid.ColumnHeadersDefaultCellStyle.BackColor = ColorTranslator.FromHtml("#3A6351");
            grid.ColumnHeadersDefaultCellStyle.ForeColor = Color.White;
            grid.ColumnHeadersDefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
            grid.EnableHeadersVisualStyles = false;
            grid.RowTemplate.Height = 30;
            grid.ReadOnly = true;
            grid.MultiSelect = false;
            grid.RowHeadersVisible = false;
        }

        private void CambiarEstadoCampos(bool habilitar)
        {
            txtNombreCompleto.ReadOnly = !habilitar;
            txtDireccion.ReadOnly = !habilitar;
            txtTelefono.ReadOnly = !habilitar;
            txtEmail.ReadOnly = !habilitar;
            cbZona.Enabled = habilitar;
            chkActivo.Enabled = habilitar;
        }

        private void LimpiarCampos()
        {
            txtNombreCompleto.Clear();
            txtDireccion.Clear();
            txtTelefono.Clear();
            txtEmail.Clear();
            if (cbZona.Items.Count > 0)
                cbZona.SelectedIndex = 0;
            else
                cbZona.SelectedIndex = -1;
            chkActivo.Checked = true;
            _clienteSeleccionado = null;
            _modoEdicion = false;
            CambiarEstadoCampos(false);
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
            bool haySeleccion = _clienteSeleccionado != null;
            bool esActivo = haySeleccion && _clienteSeleccionado.Activo;
            bool permisoAgregar = TienePermiso("Clientes.Alta");
            bool permisoModificar = TienePermiso("Clientes.Modificar");
            bool permisoEliminar = TienePermiso("Clientes.Baja");
            bool permisoVer = TienePermiso("Clientes.Ver") || TienePermiso("AccesoClientes");
            if (_modoEdicion)
            {
                btnAgregar.Visible = false;
                btnModificar.Visible = false;
                btnEliminar.Visible = false;
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
                btnToggleEliminados.Visible = true;
                btnGrabar.Visible = false;
                btnCancelar.Visible = false;
                btnAgregar.Enabled = permisoAgregar;
                btnModificar.Enabled = haySeleccion && esActivo && permisoModificar;
                btnEliminar.Enabled = haySeleccion && esActivo && permisoEliminar;
                btnToggleEliminados.Enabled = permisoVer;
            }
        }

        private bool ValidarCampos()
        {
            if (string.IsNullOrWhiteSpace(txtNombreCompleto.Text))
            {
                MessageBox.Show("El nombre completo es obligatorio.", "Validación", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                txtNombreCompleto.Focus();
                return false;
            }

            if (!string.IsNullOrWhiteSpace(txtEmail.Text))
            {
                try
                {
                    MailAddress addr = new MailAddress(txtEmail.Text.Trim());
                    if (addr.Address != txtEmail.Text.Trim())
                        throw new FormatException();
                }
                catch
                {
                    MessageBox.Show("El formato del email no es válido.", "Validación", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    txtEmail.Focus();
                    return false;
                }
            }

            return true;
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
            btnGrabar.Visible = true;
            btnCancelar.Visible = true;
            txtNombreCompleto.Focus();
            ActualizarEstadoBotones();
        }

        private void btnModificar_Click(object sender, EventArgs e)
        {
            if (_clienteSeleccionado == null)
                return;
            CambiarEstadoCampos(true);
            _modoEdicion = true;
            btnAgregar.Visible = false;
            btnModificar.Visible = false;
            btnEliminar.Visible = false;
            btnToggleEliminados.Visible = false;
            btnGrabar.Visible = true;
            btnCancelar.Visible = true;
            txtNombreCompleto.Focus();
            ActualizarEstadoBotones();
        }

        private void btnEliminar_Click(object sender, EventArgs e)
        {
            if (_clienteSeleccionado == null)
                return;
            DialogResult resp = MessageBox.Show($"¿Está seguro de eliminar al cliente '{_clienteSeleccionado.NombreCompleto}'?", "Confirmación", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
            if (resp != DialogResult.Yes)
                return;
            try
            {
                _clienteBLL.Eliminar(_clienteSeleccionado);
                MessageBox.Show("Cliente eliminado correctamente.", "Éxito", MessageBoxButtons.OK, MessageBoxIcon.Information);
                LimpiarCampos();
                CargarGrilla();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error al eliminar: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void btnGrabar_Click(object sender, EventArgs e)
        {
            if (!ValidarCampos())
                return;
            try
            {
                bool esModificacion = _clienteSeleccionado != null;
                Cliente cliente = esModificacion ? _clienteSeleccionado : new Cliente();
                cliente.NombreCompleto = txtNombreCompleto.Text.Trim();
                cliente.Direccion = txtDireccion.Text.Trim();
                cliente.Telefono = txtTelefono.Text.Trim();
                cliente.Email = txtEmail.Text.Trim();
                cliente.Zona = cbZona.SelectedItem?.ToString()?.Trim() ?? string.Empty;
                cliente.Activo = chkActivo.Checked;
                if (esModificacion)
                {
                    _clienteBLL.Modificar(cliente);
                    MessageBox.Show("Cliente modificado correctamente.", "Éxito", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
                else
                {
                    _clienteBLL.Agregar(cliente);
                    MessageBox.Show("Cliente agregado correctamente.", "Éxito", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }

                CargarGrilla();
                LimpiarCampos();
            }
            catch (Exception ex)
            {
                string msg = ex.InnerException != null ? $"{ex.Message} → {ex.InnerException.Message}" : ex.Message;
                MessageBox.Show($"Error al grabar: {msg}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void btnCancelar_Click(object sender, EventArgs e)
        {
            if (_clienteSeleccionado != null)
                CargarDatosSeleccionado();
            LimpiarCampos();
        }

        private void btnToggleEliminados_Click(object sender, EventArgs e)
        {
            _mostrarEliminados = !_mostrarEliminados;
            btnToggleEliminados.Text = _mostrarEliminados ? "Ocultar eliminados" : "Mostrar eliminados";
            CargarGrilla();
        }

        private void dgvClientes_SelectionChanged(object sender, EventArgs e)
        {
            if (dgvClientes.SelectedRows.Count == 0)
            {
                _clienteSeleccionado = null;
                ActualizarEstadoBotones();
            }
            else
            {
                CargarDatosSeleccionado();
            }
        }

        private void dgvClientes_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex >= 0)
                CargarDatosSeleccionado();
        }

        private void CargarDatosSeleccionado()
        {
            if (dgvClientes.SelectedRows.Count == 0)
                return;
            if (dgvClientes.SelectedRows[0].DataBoundItem is not Cliente c)
                return;
            _clienteSeleccionado = c;
            txtNombreCompleto.Text = c.NombreCompleto;
            txtDireccion.Text = c.Direccion;
            txtTelefono.Text = c.Telefono;
            txtEmail.Text = c.Email;
            if (!string.IsNullOrWhiteSpace(c.Zona))
            {
                int idx = cbZona.Items.IndexOf(c.Zona.Trim());
                if (idx >= 0)
                    cbZona.SelectedIndex = idx;
                else
                {
                    cbZona.Items.Add(c.Zona.Trim());
                    cbZona.SelectedIndex = cbZona.Items.Count - 1;
                }
            }
            else if (cbZona.Items.Count > 0)
            {
                cbZona.SelectedIndex = 0;
            }

            chkActivo.Checked = c.Activo;
            CambiarEstadoCampos(false);
            _modoEdicion = false;
            ActualizarEstadoBotones();
        }
    }
}
