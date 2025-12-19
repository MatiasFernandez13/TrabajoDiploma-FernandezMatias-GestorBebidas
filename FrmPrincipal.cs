using System;
using System.Collections.Generic;
using System.Configuration;
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
            string connectionString = ConfigurationManager.ConnectionStrings["MiConexion"].ConnectionString;
            _usuarioBLL = new UsuarioBLL(connectionString);
            _usuarioLogueado = Sesion.Instancia.UsuarioLogueado;
            IdiomaService.Suscribir(this);
        }

        private void FrmPrincipal_Load(object sender, EventArgs e)
        {
            BLL.TagSeeder.Seed();
            if (_usuarioLogueado == null) _usuarioLogueado = Sesion.Instancia.UsuarioLogueado;
            menuUsuarioLogueado.Text = $"Usuario: {_usuarioLogueado.NombreUsuario}";

            // Permisos gobiernan visibilidad y acceso; no se fuerza por rol aquí

            CargarComboIdiomas();

            if (!string.IsNullOrEmpty(_usuarioLogueado.Idioma))
            {
                cbIdiomas.ComboBox.SelectedValue = _usuarioLogueado.Idioma;

                var traducciones = _idiomaBLL.ObtenerTraducciones(_usuarioLogueado.Idioma);
                IdiomaService.CambiarIdioma(_usuarioLogueado.Idioma, traducciones);
                ActualizarIdioma(traducciones);
            }
            else
            {
                cbIdiomas.ComboBox.SelectedValue = "es";
                var traducciones = _idiomaBLL.ObtenerTraducciones("es");
                IdiomaService.CambiarIdioma("es", traducciones);
                ActualizarIdioma(traducciones);
            }
            PermissionService.RefreshForCurrentUser();
            AplicarPermisos();
        }

        private void CargarComboIdiomas()
        {
            var idiomas = _idiomaBLL.ObtenerIdiomas();
            cbIdiomas.ComboBox.DisplayMember = "Nombre";
            cbIdiomas.ComboBox.ValueMember = "Codigo";
            cbIdiomas.ComboBox.DataSource = idiomas;

        }

        private void cbIdiomas_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (_usuarioLogueado == null) return;
            if (cbIdiomas.ComboBox.SelectedItem is IdiomaDTO idioma)
            {
                var traducciones = _idiomaBLL.ObtenerTraducciones(idioma.Codigo);
                IdiomaService.CambiarIdioma(idioma.Codigo, traducciones);
                _usuarioBLL.GuardarIdiomaUsuario(_usuarioLogueado.Id, idioma.Codigo);
                ActualizarIdioma(traducciones);
            }
        }

        private void OpenForm(Form form)
        {
            foreach (Form f in MdiChildren)
                f.Close();

            form.MdiParent = this;
            form.WindowState = FormWindowState.Maximized;
            form.Show();
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

        private void menuProductos_Click(object sender, EventArgs e) => OpenForm(new FrmProductos());

        private void ventasToolStripMenuItem_Click(object sender, EventArgs e) => OpenForm(new FrmVentas());

        private void menuReportes_Click(object sender, EventArgs e) => OpenForm(new FrmReportes());
        private void menuIdiomas_Click(object sender, EventArgs e) => OpenForm(new FrmIdiomas());
        private void menuBitacora_Click(object sender, EventArgs e) => OpenForm(new FrmBitacora());

        private void menuVerificarIntegridad_Click(object sender, EventArgs e)
        {
            if (PermissionService.Has("AccesoVerificarIntegridad"))
            {
                var okUsuarios = DigitoVerificador.VerificarDVV("Usuarios", out var calcU, out var guardU);
                var okProductos = DigitoVerificador.VerificarDVV("Productos", out var calcP, out var guardP);
                if (!okUsuarios) DigitoVerificador.VerificarYAlertar("Usuarios");
                if (!okProductos) DigitoVerificador.VerificarYAlertar("Productos");
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
            var claveUsuario =
                traducciones.ContainsKey("usuario") ? traducciones["usuario"] :
                traducciones.ContainsKey("Usuario") ? traducciones["Usuario"] : "Usuario";
            if (_usuarioLogueado != null)
                menuUsuarioLogueado.Text = claveUsuario + ": " + _usuarioLogueado.NombreUsuario;

            if (traducciones.TryGetValue("Usuarios", out var txUsuarios)) menuUsuarios.Text = txUsuarios;
            else if (menuUsuarios.Tag is string tagU && traducciones.TryGetValue(tagU, out var txU)) menuUsuarios.Text = txU;

            if (traducciones.TryGetValue("Productos", out var txProductos)) menuProductos.Text = txProductos;
            else if (menuProductos.Tag is string tagP && traducciones.TryGetValue(tagP, out var txP)) menuProductos.Text = txP;

            if (traducciones.TryGetValue("Ventas", out var txVentas)) menuVentas.Text = txVentas;
            else if (menuVentas.Tag is string tagV && traducciones.TryGetValue(tagV, out var txV)) menuVentas.Text = txV;

            if (traducciones.TryGetValue("Reportes", out var txReportes)) menuReportes.Text = txReportes;
            else if (menuReportes.Tag is string tagR && traducciones.TryGetValue(tagR, out var txR)) menuReportes.Text = txR;
        }
        private void AplicarPermisos()
        {
            menuUsuarios.Visible = PermissionService.Has("AccesoUsuarios");
            menuProductos.Visible = PermissionService.Has("AccesoProductos");
            menuVentas.Visible = PermissionService.Has("AccesoVentas");
            menuReportes.Visible = PermissionService.Has("AccesoReportes");
            // Idiomas visible para todos según requerimiento
            // Permisos: visible si puede asignar o gestionar
            var verPermisos = PermissionService.Has("AccesoPermisos") || PermissionService.Has("Permisos.Asignar") || PermissionService.Has("Permisos.Gestionar");
            menuGestionPermisos.Visible = verPermisos;
            // Administración
            var verAdmin = PermissionService.Has("AccesoAdministracion");
            // Si están como ítems sueltos, aplica por simple
            menuBitacora.Visible = verAdmin && PermissionService.Has("AccesoBitacora");
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
