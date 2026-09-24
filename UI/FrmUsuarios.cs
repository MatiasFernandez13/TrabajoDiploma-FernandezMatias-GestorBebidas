using BE;
using BE.Permisos;
using BLL;
using SERVICIOS;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Windows.Forms;
using System.Linq;

namespace UI
{
    public partial class FrmUsuarios : FrmBase, IObservadorIdioma
    {
        private readonly PermisoBLL _permisoBLL = new PermisoBLL();
        private readonly UsuarioPermisoBLL _usuarioPermisoBLL = new UsuarioPermisoBLL();
        private readonly UsuarioBLL _usuarioBLL = new UsuarioBLL();
        private Usuario _usuarioSeleccionado = null;
        private bool _mostrarEliminados = false;
        private bool _modoEdicion = false;
        public FrmUsuarios()
        {
            InitializeComponent();
            IdiomaService.Suscribir(this);
        }

        private void FrmUsuarios_Load(object sender, EventArgs e)
        {
            try
            {
                CargarGrilla();
                txtNombreUsuario.MaxLength = 50;
                txtContraseña.MaxLength = 50;
                _modoEdicion = false;
                LimpiarCampos();
            }
            catch (Exception ex)
            {
                string inner = ex.InnerException != null ? $" → {ex.InnerException.Message}" : "";
                string msg = $"Error al abrir Usuarios: {ex.Message}{inner}\n\n" + "Causa probable: stored procedures faltantes.\n" + "Abrir SSMS, seleccionar BaseGestionBebidasMF y ejecutar los scripts " + "de la carpeta BASE/ScriptsClientes.\n\n" + "Se cerrará el formulario.";
                MessageBox.Show(msg, "Error de base de datos", MessageBoxButtons.OK, MessageBoxIcon.Error);
                Close();
            }
        }

        private void FrmUsuarios_FormClosed(object sender, FormClosedEventArgs e)
        {
            IdiomaService.Desuscribir(this);
        }

        public void ActualizarIdioma(Dictionary<string, string> traducciones)
        {
            foreach (Control control in Controls)
            {
                if (control.Tag != null)
                {
                    string tag = control.Tag.ToString();
                    if (traducciones.TryGetValue(tag, out string? val))
                        control.Text = val;
                }
            }

            if (traducciones.TryGetValue("FrmUsuarios", out string? t))
                Text = t;
        }

        private void CargarGrilla()
        {
            try
            {
                dgvUsuarios.DataSource = null;
                List<Usuario> usuarios = _usuarioBLL.ObtenerTodos();
                List<Usuario> fuente = _mostrarEliminados ? usuarios : usuarios.Where(u => u.Activo).ToList();
                List<GrupoPermiso> todosGrupos = _permisoBLL.ObtenerGruposDePermisos().OfType<GrupoPermiso>().ToList();
                dgvUsuarios.DataSource = fuente.Select(u =>
                {
                    List<int> gruposIds = _usuarioPermisoBLL.ObtenerGrupos(u.Id);
                    List<string> nombresGrupos = todosGrupos.Where(g => gruposIds.Contains(g.Id)).Select(g => g.Nombre).ToList();
                    u.Permisos = nombresGrupos.Any() ? string.Join(", ", nombresGrupos) : "Sin permisos";
                    return new
                    {
                        u.Id,
                        u.NombreUsuario,
                        Rol = u.Permisos,
                        u.Activo
                    };
                }).ToList();
                dgvUsuarios.ClearSelection();
                _usuarioSeleccionado = null;
                dgvUsuarios.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.None;
                dgvUsuarios.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
                if (dgvUsuarios.Columns.Contains("Id"))
                    dgvUsuarios.Columns["Id"].HeaderText = "ID";
                if (dgvUsuarios.Columns.Contains("NombreUsuario"))
                    dgvUsuarios.Columns["NombreUsuario"].HeaderText = "Nombre Usuario";
                if (dgvUsuarios.Columns.Contains("Rol"))
                    dgvUsuarios.Columns["Rol"].HeaderText = "Rol / Grupos";
                if (dgvUsuarios.Columns.Contains("Activo"))
                    dgvUsuarios.Columns["Activo"].HeaderText = "Activo";
                AjustarColumnasGrid(dgvUsuarios, "NombreUsuario");
                AplicarEstilo(dgvUsuarios);
                ActualizarEstadoBotones();
            }
            catch (Exception ex)
            {
                string inner = ex.InnerException != null ? $" → {ex.InnerException.Message}" : "";
                MessageBox.Show($"No se pudo cargar la lista de usuarios.{inner}", "Error al cargar grilla", MessageBoxButtons.OK, MessageBoxIcon.Warning);
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
            txtNombreUsuario.ReadOnly = !habilitar;
            txtContraseña.ReadOnly = !habilitar;
            txtNombreUsuario.BackColor = habilitar ? Color.White : Color.FromArgb(245, 245, 245);
            txtContraseña.BackColor = habilitar ? Color.White : Color.FromArgb(245, 245, 245);
        }

        private void LimpiarCampos()
        {
            txtNombreUsuario.Clear();
            txtContraseña.Clear();
            _usuarioSeleccionado = null;
            _modoEdicion = false;
            dgvUsuarios.ClearSelection();
            CambiarEstadoCampos(false);
            ActualizarEstadoBotones();
        }

        private static bool TienePermiso(string key)
        {
            if (PermissionService.Has(key))
                return true;
            if (PermissionService.Has("Administrador"))
                return true;
            return true;
        }

        private void ActualizarEstadoBotones()
        {
            bool haySeleccion = _usuarioSeleccionado != null;
            bool esActivo = haySeleccion && _usuarioSeleccionado.Activo;
            bool estaEliminado = haySeleccion && !_usuarioSeleccionado.Activo;
            bool permisoAgregar = TienePermiso("Usuarios.Alta");
            bool permisoModificar = TienePermiso("Usuarios.Modificar");
            bool permisoEliminar = TienePermiso("Usuarios.Baja");
            bool permisoVer = TienePermiso("Usuarios.Ver") || TienePermiso("AccesoUsuarios");
            btnAgregar.Visible = true;
            btnModificar.Visible = true;
            btnEliminar.Visible = true;
            btnToggleEliminados.Visible = true;
            btnGrabar.Visible = true;
            btnCancelar.Visible = true;
            btnReactivar.Visible = _mostrarEliminados;
            if (_modoEdicion)
            {
                btnAgregar.Enabled = false;
                btnModificar.Enabled = false;
                btnEliminar.Enabled = false;
                btnToggleEliminados.Enabled = false;
                btnReactivar.Enabled = false;
                btnGrabar.Enabled = true;
                btnCancelar.Enabled = true;
            }
            else
            {
                btnAgregar.Enabled = permisoAgregar && !haySeleccion;
                btnModificar.Enabled = haySeleccion && esActivo && permisoModificar;
                btnEliminar.Enabled = haySeleccion && esActivo && permisoEliminar;
                btnToggleEliminados.Enabled = permisoVer;
                btnReactivar.Enabled = _mostrarEliminados && haySeleccion && estaEliminado && permisoModificar;
                btnGrabar.Enabled = false;
                btnCancelar.Enabled = haySeleccion;
            }
        }

        private bool ValidarCampos()
        {
            if (string.IsNullOrWhiteSpace(txtNombreUsuario.Text))
            {
                MessageBox.Show("El nombre de usuario es obligatorio.", "Validación", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                txtNombreUsuario.Focus();
                return false;
            }

            if (_usuarioSeleccionado == null && string.IsNullOrWhiteSpace(txtContraseña.Text))
            {
                MessageBox.Show("La contraseña es obligatoria para crear un usuario nuevo.", "Validación", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                txtContraseña.Focus();
                return false;
            }

            return true;
        }

        private void btnAgregar_Click(object sender, EventArgs e)
        {
            _usuarioSeleccionado = null;
            _modoEdicion = true;
            txtNombreUsuario.Clear();
            txtContraseña.Clear();
            CambiarEstadoCampos(true);
            ActualizarEstadoBotones();
            txtNombreUsuario.Focus();
        }

        private void btnModificar_Click(object sender, EventArgs e)
        {
            if (_usuarioSeleccionado == null)
            {
                MessageBox.Show("Seleccione un usuario para modificar.", "Aviso", MessageBoxButtons.OK, MessageBoxIcon.Information);
                return;
            }

            _modoEdicion = true;
            txtContraseña.Clear();
            CambiarEstadoCampos(true);
            ActualizarEstadoBotones();
            txtNombreUsuario.Focus();
        }

        private void btnEliminar_Click(object sender, EventArgs e)
        {
            if (_usuarioSeleccionado == null)
            {
                MessageBox.Show("Seleccione un usuario para eliminar.", "Aviso", MessageBoxButtons.OK, MessageBoxIcon.Information);
                return;
            }

            DialogResult r = MessageBox.Show($"¿Está seguro que desea eliminar el usuario '{_usuarioSeleccionado.NombreUsuario}'?", "Confirmar eliminación", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
            if (r != DialogResult.Yes)
                return;
            try
            {
                _usuarioBLL.EliminarUsuario(_usuarioSeleccionado.Id);
                MessageBox.Show("Usuario eliminado correctamente.");
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error al eliminar usuario: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }

            LimpiarCampos();
            CargarGrilla();
        }

        private void btnGrabar_Click(object sender, EventArgs e)
        {
            if (!ValidarCampos())
                return;
            try
            {
                if (_usuarioSeleccionado == null)
                {
                    Usuario nuevo = new Usuario
                    {
                        NombreUsuario = txtNombreUsuario.Text.Trim(),
                        Permisos = string.Empty
                    };
                    _usuarioBLL.AgregarUsuario(nuevo, txtContraseña.Text);
                    MessageBox.Show("Usuario agregado exitosamente.\n\nRecuerde asignar los permisos del usuario desde el menú Gestión de Permisos.");
                }
                else
                {
                    _usuarioSeleccionado.NombreUsuario = txtNombreUsuario.Text.Trim();
                    string nuevaPass = string.IsNullOrWhiteSpace(txtContraseña.Text) ? null : txtContraseña.Text;
                    _usuarioBLL.ModificarUsuario(_usuarioSeleccionado, nuevaPass);
                    MessageBox.Show("Usuario modificado correctamente.");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error al grabar: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            LimpiarCampos();
            CargarGrilla();
        }

        private void btnCancelar_Click(object sender, EventArgs e)
        {
            LimpiarCampos();
        }

        private void CargarDatosSeleccionado()
        {
            if (dgvUsuarios.SelectedRows.Count == 0)
            {
                _usuarioSeleccionado = null;
                return;
            }

            DataGridViewRow fila = dgvUsuarios.SelectedRows[0];
            if (fila.Cells["Id"]?.Value == null)
                return;
            int id = Convert.ToInt32(fila.Cells["Id"].Value);
            try
            {
                Usuario? encontrado = _usuarioBLL.ObtenerTodos().FirstOrDefault(u => u.Id == id);
                if (encontrado == null)
                {
                    _usuarioSeleccionado = null;
                    return;
                }

                _usuarioSeleccionado = encontrado;
                txtNombreUsuario.Text = encontrado.NombreUsuario;
                txtContraseña.Clear();
                _modoEdicion = false;
                CambiarEstadoCampos(false);
                ActualizarEstadoBotones();
            }
            catch
            {
                _usuarioSeleccionado = null;
            }
        }

        private void dgvUsuarios_SelectionChanged(object sender, EventArgs e)
        {
            if (_modoEdicion)
                return;
            CargarDatosSeleccionado();
        }

        private void dgvUsuarios_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if (_modoEdicion)
                return;
            CargarDatosSeleccionado();
        }

        private void btnToggleEliminados_Click(object sender, EventArgs e)
        {
            _mostrarEliminados = !_mostrarEliminados;
            btnToggleEliminados.Text = _mostrarEliminados ? "Ocultar eliminados" : "Mostrar eliminados";
            btnToggleEliminados.Tag = _mostrarEliminados ? "OcultarEliminados" : "MostrarEliminados";
            CargarGrilla();
        }

        private void btnReactivar_Click(object sender, EventArgs e)
        {
            if (_usuarioSeleccionado == null)
            {
                MessageBox.Show("Seleccione un usuario eliminado.", "Aviso", MessageBoxButtons.OK, MessageBoxIcon.Information);
                return;
            }

            if (_usuarioSeleccionado.Activo)
            {
                MessageBox.Show("El usuario ya está activo.");
                return;
            }

            DialogResult r = MessageBox.Show($"¿Reactivar el usuario '{_usuarioSeleccionado.NombreUsuario}'?", "Confirmar reactivación", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
            if (r != DialogResult.Yes)
                return;
            try
            {
                _usuarioSeleccionado.Activo = true;
                _usuarioBLL.ModificarUsuario(_usuarioSeleccionado, null);
                MessageBox.Show("Usuario reactivado.");
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error al reactivar: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }

            CargarGrilla();
            ActualizarEstadoBotones();
        }
    }
}
