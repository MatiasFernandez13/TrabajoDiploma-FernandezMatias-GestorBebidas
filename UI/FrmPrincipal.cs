using System;
using System.Collections.Generic;
using System.Windows.Forms;
using BE;
using BLL;
using SERVICIOS;

namespace UI
{
    public partial class FrmPrincipal : FrmBase, IObservadorIdioma
    {
        private Usuario _usuarioLogueado;
        private readonly UsuarioBLL _usuarioBLL;
        private readonly IdiomaBLL _idiomaBLL = new IdiomaBLL();
        public FrmPrincipal()
        {
            InitializeComponent();
            _usuarioBLL = new UsuarioBLL();
            _usuarioLogueado = Sesion.Instancia.UsuarioLogueado;
            IdiomaService.Suscribir(this);
        }

        private void FrmPrincipal_Load(object sender, EventArgs e)
        {
            BLL.TagSeeder.Seed();
            if (_usuarioLogueado == null)
                _usuarioLogueado = Sesion.Instancia.UsuarioLogueado;
            menuUsuarioLogueado.Text = $"Usuario: {_usuarioLogueado.NombreUsuario}";
            CargarComboIdiomas();
            if (!string.IsNullOrEmpty(_usuarioLogueado.Idioma))
            {
                cbIdiomas.ComboBox.SelectedValue = _usuarioLogueado.Idioma;
                Dictionary<string, string> traducciones = _idiomaBLL.ObtenerTraducciones(_usuarioLogueado.Idioma);
                try
                {
                    IdiomaService.CambiarIdioma(_usuarioLogueado.Idioma, traducciones);
                }
                catch
                {
                }

                ActualizarIdioma(traducciones);
            }
            else
            {
                cbIdiomas.ComboBox.SelectedValue = "es";
                Dictionary<string, string> traducciones = _idiomaBLL.ObtenerTraducciones("es");
                try
                {
                    IdiomaService.CambiarIdioma("es", traducciones);
                }
                catch
                {
                }

                ActualizarIdioma(traducciones);
            }

            PermissionService.RefreshForCurrentUser();
            AplicarPermisos();
        }

        public void CargarComboIdiomas()
        {
            List<IdiomaDTO> idiomas = _idiomaBLL.ObtenerIdiomas();
            cbIdiomas.ComboBox.DisplayMember = "Nombre";
            cbIdiomas.ComboBox.ValueMember = "Codigo";
            cbIdiomas.ComboBox.DataSource = idiomas;
        }

        public void RecargarIdiomasMenu(string seleccionarCodigo = null)
        {
            string? previo = cbIdiomas.ComboBox.SelectedValue?.ToString();
            CargarComboIdiomas();
            string? target = seleccionarCodigo ?? previo;
            if (!string.IsNullOrEmpty(target))
                cbIdiomas.ComboBox.SelectedValue = target;
        }

        private void cbIdiomas_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (_usuarioLogueado == null)
                return;
            if (cbIdiomas.ComboBox.SelectedItem is IdiomaDTO idioma)
            {
                Dictionary<string, string> traducciones = _idiomaBLL.ObtenerTraducciones(idioma.Codigo);
                try
                {
                    IdiomaService.CambiarIdioma(idioma.Codigo, traducciones);
                }
                catch
                {
                }

                _usuarioBLL.GuardarIdiomaUsuario(_usuarioLogueado.Id, idioma.Codigo);
                ActualizarIdioma(traducciones);
            }
        }

        private void OpenForm(Form form)
        {
            try
            {
                foreach (Form f in MdiChildren)
                    f.Close();
                form.MdiParent = this;
                form.StartPosition = FormStartPosition.CenterScreen;
                form.MinimumSize = new Size(1200, 800);
                form.WindowState = FormWindowState.Maximized;
                form.Load += (s, args) =>
                {
                    if (((Form)s).WindowState != FormWindowState.Maximized)
                        ((Form)s).WindowState = FormWindowState.Maximized;
                };
                form.Shown += (s, args) =>
                {
                    Form? f = (Form)s;
                    try
                    {
                        f.WindowState = FormWindowState.Maximized;
                    }
                    catch
                    {
                    }

                    try
                    {
                        f.BringToFront();
                    }
                    catch
                    {
                    }

                    try
                    {
                        f.Activate();
                    }
                    catch
                    {
                    }
                };
                form.Show();
                try
                {
                    form.WindowState = FormWindowState.Maximized;
                }
                catch
                {
                }
            }
            catch (Exception ex)
            {
                string inner = ex.InnerException != null ? $" → {ex.InnerException.Message}" : "";
                string msg = $"No se pudo abrir el formulario '{form.Text}'.{inner}\n\n" + "Si el error menciona un stored procedure faltante (ej: sp_Clientes_Listar), " + "abrir SSMS, seleccionar la base BaseGestionBebidasMF y ejecutar los scripts " + "de la carpeta BASE/ScriptsClientes en orden (01.sql al 09.sql).";
                MessageBox.Show(msg, "Error al abrir formulario", MessageBoxButtons.OK, MessageBoxIcon.Error);
                try
                {
                    form?.Dispose();
                }
                catch
                {
                }
            }
        }

        private void menuGestionPermisos_Click(object sender, EventArgs e)
        {
            OpenForm(new FrmPermisos());
        }

        private void menuAsignarPermisos_Click(object sender, EventArgs e)
        {
            OpenForm(new FrmPermisos());
        }

        private void menuUsuarios_Click(object sender, EventArgs e) => OpenForm(new FrmUsuarios());
        private void menuClientes_Click(object sender, EventArgs e) => OpenForm(new FrmClientes());
        private void menuProductos_Click(object sender, EventArgs e) => OpenForm(new FrmProductos());
        private void ventasToolStripMenuItem_Click(object sender, EventArgs e) => OpenForm(new FrmVentas());
        private void menuReportes_Click(object sender, EventArgs e) => OpenForm(new FrmReportes());
        private void menuIdiomas_Click(object sender, EventArgs e) => OpenForm(new FrmIdiomas());
        private void menuBitacora_Click(object sender, EventArgs e) => OpenForm(new FrmBitacora());
        private void menuControlCambios_Click(object sender, EventArgs e) => OpenForm(new FrmControlCambiosProductos());
        private void menuVerificarIntegridad_Click(object sender, EventArgs e)
        {
            if (PermissionService.Has("AccesoVerificarIntegridad"))
            {
                bool okUsuarios = DigitoVerificador.VerificarDVV("Usuarios", out decimal calcU, out decimal guardU);
                bool okProductos = DigitoVerificador.VerificarDVV("Productos", out decimal calcP, out decimal guardP);
                if (!okUsuarios)
                    DigitoVerificador.VerificarYAlertar("Usuarios");
                if (!okProductos)
                    DigitoVerificador.VerificarYAlertar("Productos");
                if (okUsuarios && okProductos)
                    MessageBox.Show("Integridad OK para Usuarios y Productos.");
            }
            else
            {
                MessageBox.Show("Acceso restringido. Solo el Administrador puede acceder a esta funcionalidad.");
            }
        }

        private void menuRecalcularIntegridad_Click(object sender, EventArgs e)
        {
            if (PermissionService.Has("AccesoRecalcularIntegridad"))
            {
                DigitoVerificador.RecalcularDVHUsuarios();
                DigitoVerificador.RecalcularDVHProductos();
                MessageBox.Show("Se recalculó la integridad de Usuarios y Productos.");
            }
            else
            {
                MessageBox.Show("Acceso restringido. Solo el Administrador puede acceder a esta funcionalidad.");
            }
        }

        private void cerrarSesionToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Sesion.Instancia.CerrarSesion();
            IdiomaService.Desuscribir(this);
            new FrmLogin().Show();
            Close();
        }

        public override void ActualizarIdioma(Dictionary<string, string> traducciones)
        {
            base.ActualizarIdioma(traducciones);
            string claveUsuario = traducciones.ContainsKey("usuario") ? traducciones["usuario"] : traducciones.ContainsKey("Usuario") ? traducciones["Usuario"] : "Usuario";
            if (_usuarioLogueado != null)
                menuUsuarioLogueado.Text = claveUsuario + ": " + _usuarioLogueado.NombreUsuario;
            if (traducciones.TryGetValue("Usuarios", out string? txUsuarios))
                menuUsuarios.Text = txUsuarios;
            else if (menuUsuarios.Tag is string tagU && traducciones.TryGetValue(tagU, out string? txU))
                menuUsuarios.Text = txU;
            if (traducciones.TryGetValue("Productos", out string? txProductos))
                menuProductos.Text = txProductos;
            else if (menuProductos.Tag is string tagP && traducciones.TryGetValue(tagP, out string? txP))
                menuProductos.Text = txP;
            if (traducciones.TryGetValue("Ventas", out string? txVentas))
                menuVentas.Text = txVentas;
            else if (menuVentas.Tag is string tagV && traducciones.TryGetValue(tagV, out string? txV))
                menuVentas.Text = txV;
            if (traducciones.TryGetValue("Reportes", out string? txReportes))
                menuReportes.Text = txReportes;
            else if (menuReportes.Tag is string tagR && traducciones.TryGetValue(tagR, out string? txR))
                menuReportes.Text = txR;
        }

        private void AplicarPermisos()
        {
            menuUsuarios.Visible = PermissionService.Has("AccesoUsuarios");
            menuProductos.Visible = PermissionService.Has("AccesoProductos");
            menuVentas.Visible = PermissionService.Has("AccesoVentas");
            menuReportes.Visible = PermissionService.Has("AccesoReportes");
            bool verPermisos = PermissionService.Has("AccesoPermisos") || PermissionService.Has("Permisos.Asignar") || PermissionService.Has("Permisos.Gestionar");
            menuGestionPermisos.Visible = verPermisos;
            bool verAdmin = PermissionService.Has("AccesoAdministracion");
            menuBitacora.Visible = verAdmin && PermissionService.Has("AccesoBitacora");
            menuControlCambios.Visible = verAdmin && PermissionService.Has("AccesoControlCambios");
            menuVerificarIntegridad.Visible = verAdmin && PermissionService.Has("AccesoVerificarIntegridad");
            menuRecalcularIntegridad.Visible = verAdmin && PermissionService.Has("AccesoRecalcularIntegridad");
        }

        private void menuStrip1_ItemClicked(object sender, ToolStripItemClickedEventArgs e)
        {
        }

        private void cbIdiomas_Click(object sender, EventArgs e)
        {
        }
    }
}
