using System;
using System.Collections.Generic;
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
            _usuarioBLL = new UsuarioBLL();
            IdiomaService.Suscribir(this);
        }

        private void FrmLogin_Load(object sender, EventArgs e)
        {
            List<IdiomaDTO> idiomas = _idiomaBLL.ObtenerIdiomas();
            cbIdiomas.DataSource = idiomas;
            cbIdiomas.DisplayMember = "Nombre";
            cbIdiomas.ValueMember = "Codigo";
            if (idiomas.Count > 0)
            {
                int idx = idiomas.FindIndex(x => x.Codigo == "es");
                if (idx >= 0)
                {
                    cbIdiomas.SelectedValue = "es";
                    Dictionary<string, string> traducciones = _idiomaBLL.ObtenerTraducciones("es");
                    try
                    {
                        IdiomaService.CambiarIdioma("es", traducciones);
                    }
                    catch
                    {
                    }
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
                Dictionary<string, string> traducciones = _idiomaBLL.ObtenerTraducciones(idioma.Codigo);
                try
                {
                    IdiomaService.CambiarIdioma(idioma.Codigo, traducciones);
                }
                catch
                {
                }
            }
        }

        private void btnLogin_Click(object sender, EventArgs e)
        {
            string user = txtUsuario.Text.Trim();
            string pass = txtPassword.Text.Trim();
            (bool ok, string mensaje, Usuario usuario) res = _usuarioBLL.IniciarSesion(user, pass);
            if (res.ok && res.usuario != null)
            {
                Usuario usuarioLogueado = res.usuario;
                string idiomaSeleccionado = cbIdiomas.SelectedValue?.ToString() ?? "es";
                string idiomaGuardado = usuarioLogueado.Idioma;
                if (!string.IsNullOrEmpty(idiomaGuardado) && idiomaGuardado != idiomaSeleccionado)
                {
                    DialogResult respuesta = MessageBox.Show($"El usuario {usuarioLogueado.NombreUsuario} usó el idioma '{idiomaGuardado}' previamente.\n¿Desea continuar con ese idioma?", "Idioma detectado", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
                    if (respuesta == DialogResult.Yes)
                    {
                        idiomaSeleccionado = idiomaGuardado;
                        cbIdiomas.SelectedValue = idiomaSeleccionado;
                    }
                }

                _usuarioBLL.GuardarIdiomaUsuario(usuarioLogueado.Id, idiomaSeleccionado);
                usuarioLogueado.Idioma = idiomaSeleccionado;
                Dictionary<string, string> traducciones = _idiomaBLL.ObtenerTraducciones(idiomaSeleccionado);
                IdiomaService.CambiarIdioma(idiomaSeleccionado, traducciones);
                MessageBox.Show(traducciones.TryGetValue("msgBienvenida", out string? msg) ? msg : "¡Bienvenido a Total Drinks Pro!");
                if (res.mensaje != null && res.mensaje.StartsWith("ADVERTENCIA"))
                    MessageBox.Show(res.mensaje, "Integridad DVV", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                FrmPrincipal principal = new FrmPrincipal();
                principal.Show();
                this.Hide();
            }
            else
            {
                MessageBox.Show(res.mensaje);
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
