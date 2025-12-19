using BE;
using BE.Permisos;
using BLL;
using SERVICIOS;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Windows.Forms;
using System.Linq;

namespace UI
{
    public partial class FrmUsuarios : FrmBase, IObservadorIdioma
    {
        private readonly PermisoBLL _permisoBLL = new PermisoBLL();
        private readonly UsuarioPermisoBLL _usuarioPermisoBLL = new UsuarioPermisoBLL();
        private UsuarioBLL _usuarioBLL = new UsuarioBLL(System.Configuration.ConfigurationManager.ConnectionStrings["MiConexion"].ConnectionString);
        private Usuario _usuarioSeleccionado;
        private bool _modoAgregar = false;
        private bool _mostrarEliminados = false;

        public FrmUsuarios()
        {
            InitializeComponent();
            IdiomaService.Suscribir(this);
        }

        private void FrmUsuarios_Load(object sender, EventArgs e)
        {
            //CargarRoles();
            CargarUsuarios();
            ConfigurarEstadoInicial();
            btnAgregar.Enabled = PermissionService.Has("Usuarios.Alta");
            btnModificar.Enabled = PermissionService.Has("Usuarios.Modificar");
            btnEliminar.Enabled = PermissionService.Has("Usuarios.Baja");
        }

        private void FrmUsuarios_FormClosed(object sender, FormClosedEventArgs e)
        {
            IdiomaService.Desuscribir(this);
        }

        public void ActualizarIdioma(Dictionary<string, string> traducciones)
        {
            foreach (Control control in this.Controls)
            {
                if (control.Tag != null)
                {
                    string tag = control.Tag.ToString();
                    if (traducciones.ContainsKey(tag))
                        control.Text = traducciones[tag];
                }
            }

            if (traducciones.ContainsKey("FrmUsuarios"))
                this.Text = traducciones["FrmUsuarios"];
        }
        /*
        private void CargarRoles()
        {
            List<Rol> listaRoles = new List<Rol>();
            string connectionString = "Data Source=localhost;Initial Catalog=BaseGestionBebidasMF;Integrated Security=True";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT Id, Nombre FROM Roles";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    SqlDataReader reader = cmd.ExecuteReader();
                    while (reader.Read())
                    {
                        listaRoles.Add(new Rol
                        {
                            Id = (int)reader["Id"],
                            Nombre = reader["Nombre"].ToString()
                        });
                    }
                }
            }

            cbRol.DataSource = listaRoles;
            cbRol.DisplayMember = "Nombre";
            cbRol.ValueMember = "Id";
            cbRol.SelectedIndex = -1;
            var rolBasico = listaRoles.FirstOrDefault(r => r.Nombre.Equals("Usuario", StringComparison.OrdinalIgnoreCase));
            if (rolBasico != null)
            {
                cbRol.SelectedValue = rolBasico.Id;
                cbRol.Enabled = false;
            }
        }*/

        private void CargarUsuarios()
        {
            dgvUsuarios.DataSource = null;
            var usuarios = _usuarioBLL.ObtenerTodos();
            var fuente = _mostrarEliminados ? usuarios : usuarios.Where(u => u.Activo).ToList();

            var todosGrupos = _permisoBLL.ObtenerGruposDePermisos().OfType<GrupoPermiso>().ToList();

            dgvUsuarios.DataSource = fuente.Select(u => {
                var gruposIds = _usuarioPermisoBLL.ObtenerGrupos(u.Id);
                var nombresGrupos = todosGrupos
                    .Where(g => gruposIds.Contains(g.Id))
                    .Select(g => g.Nombre)
                    .ToList();
                
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
            btnModificar.Enabled = false;
            btnEliminar.Enabled = false;
            dgvUsuarios.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            dgvUsuarios.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            if (dgvUsuarios.Columns.Contains("Id")) dgvUsuarios.Columns["Id"].HeaderText = "ID";
            if (dgvUsuarios.Columns.Contains("Activo")) dgvUsuarios.Columns["Activo"].HeaderText = "Activo";
        }

        private void ConfigurarEstadoInicial()
        {
            txtNombreUsuario.Enabled = false;
            txtContraseña.Enabled = false;
           
            btnModificar.Enabled = false;
            btnEliminar.Enabled = false;
            btnGrabar.Visible = false;
            btnCancelar.Visible = false;
            dgvUsuarios.ClearSelection();
        }

        private void HabilitarCamposEdicion(bool habilitar)
        {
            txtNombreUsuario.Enabled = habilitar;
            txtContraseña.Enabled = habilitar;
        }

        private void btnAgregar_Click(object sender, EventArgs e)
        {
            _modoAgregar = true;
            HabilitarCamposEdicion(true);
            btnGrabar.Visible = true;
            btnCancelar.Visible = true;
            btnAgregar.Enabled = false;
            LimpiarCampos();
            btnModificar.Enabled = false;
            btnEliminar.Enabled = false;
            dgvUsuarios.Enabled = false;
            btnGrabar.Enabled = true;
        }

        private void btnGrabar_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtNombreUsuario.Text) || string.IsNullOrEmpty(txtContraseña.Text))
            {
                MessageBox.Show("Complete todos los campos.");
                return;
            }

            var nuevoUsuario = new Usuario
            {
                NombreUsuario = txtNombreUsuario.Text,
                Permisos = string.Empty 
            };

            _usuarioBLL.AgregarUsuario(nuevoUsuario, txtContraseña.Text);

            MessageBox.Show("Usuario agregado exitosamente.");
            MessageBox.Show("Recuerde asignar los permisos del usuario desde el menú de permisos.");
            LimpiarCampos();
            CargarUsuarios();
            ConfigurarEstadoInicial();
            btnAgregar.Enabled = true;
        }

        private void btnModificar_Click(object sender, EventArgs e)
        {
            if (_usuarioSeleccionado == null)
            {
                MessageBox.Show("Seleccione un usuario para modificar.");
                return;
            }

            btnGrabar.Enabled = false;
            btnCancelar.Enabled = true;
            btnModificar.Enabled = false;
            _usuarioSeleccionado.NombreUsuario = txtNombreUsuario.Text;
            // _usuarioSeleccionado.Rol.Id = (int)cbRol.SelectedValue;
            // _usuarioSeleccionado.Rol.Nombre = cbRol.Text;

            string nuevaPass = string.IsNullOrEmpty(txtContraseña.Text) ? null : txtContraseña.Text;
            _usuarioBLL.ModificarUsuario(_usuarioSeleccionado, nuevaPass);

            MessageBox.Show("Usuario modificado correctamente.");
            LimpiarCampos();
            CargarUsuarios();
            ConfigurarEstadoInicial();
        }

        private void btnEliminar_Click(object sender, EventArgs e)
        {
            if (_usuarioSeleccionado == null)
            {
                MessageBox.Show("Seleccione un usuario para eliminar.");
                return;
            }

            _usuarioBLL.EliminarUsuario(_usuarioSeleccionado.Id);

            MessageBox.Show("Usuario eliminado correctamente.");
            LimpiarCampos();
            CargarUsuarios();
            ConfigurarEstadoInicial();
        }

        private void btnCancelar_Click(object sender, EventArgs e)
        {
            LimpiarCampos();
            ConfigurarEstadoInicial();
            btnAgregar.Enabled = true;
            dgvUsuarios.Enabled = true;
            btnEliminar.Enabled = false;
            btnModificar.Enabled = false;
            btnGrabar.Enabled = false;
            btnCancelar.Enabled = false;
            CargarUsuarios();
        }

        private void dgvUsuarios_SelectionChanged(object sender, EventArgs e)
        {
            if (dgvUsuarios.SelectedRows.Count > 0)
            {
                var fila = dgvUsuarios.SelectedRows[0];
                int id = (int)fila.Cells["Id"].Value;
                _usuarioSeleccionado = _usuarioBLL.ObtenerTodos().First(u => u.Id == id);
                txtNombreUsuario.Text = _usuarioSeleccionado.NombreUsuario;
                // cbRol.SelectedValue = _usuarioSeleccionado.Rol.Id;

                btnModificar.Enabled = true;
                btnEliminar.Enabled = true;
                btnCancelar.Visible = true;
                btnCancelar.Enabled = true;
                btnGrabar.Visible=true;
                txtNombreUsuario.Enabled = true;
                txtContraseña.Enabled = true;
                txtContraseña.Clear();
            }
            else
            {

            }
        }

        private void LimpiarCampos()
        {
            txtNombreUsuario.Clear();
            txtContraseña.Clear();
            // cbRol.SelectedIndex = -1;
            _usuarioSeleccionado = null;
        }

        private void cbRol_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void label3_Click(object sender, EventArgs e)
        {

        }

        private void dgvUsuarios_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            btnModificar.Enabled = true;
            btnEliminar.Enabled = true;
            
        }
        private void btnToggleEliminados_Click(object sender, EventArgs e)
        {
            _mostrarEliminados = !_mostrarEliminados;
            btnToggleEliminados.Text = _mostrarEliminados ? "Ocultar eliminados" : "Mostrar eliminados";
            btnToggleEliminados.Tag = _mostrarEliminados ? "OcultarEliminados" : "MostrarEliminados";
            CargarUsuarios();
        }
    }


}
