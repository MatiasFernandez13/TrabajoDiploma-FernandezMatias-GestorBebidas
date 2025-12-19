using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;
using BE;

namespace UI
{
    public partial class FrmReportes : FrmBase
    {
        private readonly DAL.ReportesDAL _dal = new DAL.ReportesDAL();

        public FrmReportes()
        {
            InitializeComponent();
        }

        private void FrmReportes_Load(object sender, EventArgs e)
        {
            CargarZonas();
            CargarProductos();
        }

        private void CargarZonas()
        {
            var dt = _dal.ListarZonas();
            cbZona.DataSource = dt;
            cbZona.DisplayMember = "Zona";
            cbZona.ValueMember = "Zona";
            cbZona.SelectedIndex = -1;
        }

        private void CargarProductos()
        {
            var dt = _dal.ListarProductosBasicos();
            cbProducto.DataSource = dt;
            cbProducto.DisplayMember = "Nombre";
            cbProducto.ValueMember = "Id";
            cbProducto.SelectedIndex = -1;
        }

        private void btnGenerarReporte_Click(object sender, EventArgs e)
        {
            var zona = cbZona.SelectedValue as string;
            int? productoId = cbProducto.SelectedValue is int id ? id : (int?)null;
            DateTime? fecha = dtpFecha.Value.Date;
            var dt = _dal.GenerarReporte(zona, productoId, fecha);
            dgvReporte.DataSource = dt;
        }
    }
}
