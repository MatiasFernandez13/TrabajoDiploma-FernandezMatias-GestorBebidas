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
        private readonly UsuarioBLL _usuarioBLL = new UsuarioBLL(System.Configuration.ConfigurationManager.ConnectionStrings["MiConexion"].ConnectionString);

        public FrmBitacora()
        {
            InitializeComponent();
        }

        private void FrmBitacora_Load(object sender, EventArgs e)
        {
            // Set date pickers to today by default
            dtDesde.Value = DateTime.Today;
            dtHasta.Value = DateTime.Today.AddDays(1).AddSeconds(-1); // End of today

            cbUsuarios.DataSource = _usuarioBLL.ObtenerTodos();
            cbUsuarios.DisplayMember = "NombreUsuario";
            cbUsuarios.ValueMember = "NombreUsuario";
            cbUsuarios.SelectedIndex = -1;
            cbAccion.Items.Clear();
            cbAccion.Items.AddRange(new object[] { "Alta", "Modificar", "Eliminar", "Asignar", "Error", "Venta" });
            cbAccion.SelectedIndex = -1;
            CargarBitacora();
        }

        private void btnBuscar_Click(object sender, EventArgs e)
        {
            CargarBitacora();
        }
        private void CargarBitacora()
        {
            // Use full day range for filtering
            DateTime? desde = dtDesde.Value.Date;
            DateTime? hasta = dtHasta.Value.Date.AddDays(1).AddTicks(-1);
            
            string usuario = cbUsuarios.SelectedIndex >= 0 ? cbUsuarios.SelectedValue?.ToString() : null;
            string accion = cbAccion.SelectedIndex >= 0 ? cbAccion.SelectedItem?.ToString() : null;

            var datos = _bll.Buscar(desde, hasta, usuario, accion);

            dgvBitacora.DataSource = datos;

            if (dgvBitacora.Columns["UsuarioId"] != null)
                dgvBitacora.Columns["UsuarioId"].Visible = false;

            if (dgvBitacora.Columns["UsuarioNombre"] != null)
                dgvBitacora.Columns["UsuarioNombre"].HeaderText = "Usuario";
        }
    }
}
