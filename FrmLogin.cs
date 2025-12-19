using System;
using System.Collections.Generic;
using System.Configuration;
using System.Windows.Forms;
using BLL;
using SERVICIOS;
using BE;

namespace UI
{
    public partial class FrmLogin : FrmBase, IObservadorIdioma
    {
        private readonly UsuarioBLL _usuarioBLL;
        private readonly IdiomaBLL _idiomaBLL = new IdiomaBLL();

        public FrmLogin()
        {
            InitializeComponent();
            string connectionString = ConfigurationManager.ConnectionStrings["MiConexion"].ConnectionString;
            _usuarioBLL = new UsuarioBLL(connectionString);
            IdiomaService.Suscribir(this);
        }

        private void FrmLogin_Load(object sender, EventArgs e)
        {
            var idiomas = _idiomaBLL.ObtenerIdiomas();

            cbIdiomas.DataSource = idiomas;
            cbIdiomas.DisplayMember = "Nombre";
            cbIdiomas.ValueMember = "Codigo";

            if (idiomas.Count > 0)
            {
                var idx = idiomas.FindIndex(x => x.Codigo == "es");
                if (idx >= 0)
                {
                    cbIdiomas.SelectedValue = "es";
                    var traducciones = _idiomaBLL.ObtenerTraducciones("es");
                    IdiomaService.CambiarIdioma("es", traducciones);
                }
                else
                {
                    cbIdiomas.SelectedIndex = 0;
                }
            }
        }

        private void cbIdiomas_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (cbIdiomas.SelectedItem is IdiomaDTO idioma)
            {
                var traducciones = _idiomaBLL.ObtenerTraducciones(idioma.Codigo);
                IdiomaService.CambiarIdioma(idioma.Codigo, traducciones);
            }
        }

        private void btnLogin_Click(object sender, EventArgs e)
        {
            string user = txtUsuario.Text.Trim();
            string pass = txtPassword.Text.Trim();

            var resultado = _usuarioBLL.VerificarLogin(user, pass);

            if (resultado)
            {
                var usuarioLogueado = _usuarioBLL.ObtenerUsuario(user);
                Sesion.Instancia.IniciarSesion(usuarioLogueado);

                string idiomaSeleccionado = cbIdiomas.SelectedValue?.ToString() ?? "es";
                string idiomaGuardado = usuarioLogueado.Idioma;

                // Preguntar si quiere usar su idioma anterior
                if (!string.IsNullOrEmpty(idiomaGuardado) && idiomaGuardado != idiomaSeleccionado)
                {
                    var respuesta = MessageBox.Show(
                        $"El usuario {usuarioLogueado.NombreUsuario} usó el idioma '{idiomaGuardado}' previamente.\n¿Desea continuar con ese idioma?",
                        "Idioma detectado", MessageBoxButtons.YesNo, MessageBoxIcon.Question);

                    if (respuesta == DialogResult.Yes)
                    {
                        idiomaSeleccionado = idiomaGuardado;
                        cbIdiomas.SelectedValue = idiomaSeleccionado;
                    }
                }

                // Guardar idioma actualizado
                _usuarioBLL.GuardarIdiomaUsuario(usuarioLogueado.Id, idiomaSeleccionado);
                usuarioLogueado.Idioma = idiomaSeleccionado;

                var traducciones = _idiomaBLL.ObtenerTraducciones(idiomaSeleccionado);
                IdiomaService.CambiarIdioma(idiomaSeleccionado, traducciones);

                MessageBox.Show(traducciones.TryGetValue("msgBienvenida", out var msg)
                    ? msg
                    : "¡Bienvenido a Total Drinks Pro!");

                var principal = new FrmPrincipal();
                principal.Show();
                this.Hide();
            }
            else
            {
                MessageBox.Show("Usuario o contraseña incorrectos");
            }
        }

        public void ActualizarIdioma(Dictionary<string, string> traducciones)
        {
            foreach (Control control in this.Controls)
            {
                if (control.Tag is string tag && traducciones.ContainsKey(tag))
                {
                    control.Text = traducciones[tag];
                }
            }

            if (traducciones.ContainsKey("FrmLogin"))
                this.Text = traducciones["FrmLogin"];
        }
    }
}
