using System;
using System.Windows.Forms;
using BE;
using BLL;

namespace UI
{
    public partial class FrmAgregarLote : FrmBase
    {
        private int _productoId;
        private LoteBLL _loteBLL = new LoteBLL();
        public bool LoteAgregado { get; private set; } = false;

        public FrmAgregarLote(int productoId, string nombreProducto)
        {
            InitializeComponent();
            _productoId = productoId;
            txtNumeroLote.MaxLength = 50;
            dtpFechaIngreso.Value = DateTime.Today;
            dtpFechaVencimiento.Value = DateTime.Today.AddMonths(1);
            txtNumeroLote.Leave += ValidarNumeroLote;
            this.Text = $"Agregar Unidades a: {nombreProducto}";
        }

        private void ValidarNumeroLote(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtNumeroLote.Text)) return;
            try
            {
                Lote existente = _loteBLL.BuscarExistente(new Lote { ProductoId = _productoId, NumeroLote = txtNumeroLote.Text });
                if (existente != null)
                {
                    dtpFechaVencimiento.Value = existente.FechaVencimiento;
                    Text = $"Sumar unidades al lote {existente.NumeroLote} (actuales: {existente.Cantidad})";
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "No se pudo consultar el lote", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
        }

        private void btnGuardar_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtNumeroLote.Text))
            {
                MessageBox.Show("Ingrese el número de lote.");
                return;
            }

            if (nudCantidad.Value <= 0)
            {
                MessageBox.Show("La cantidad debe ser mayor a 0.");
                return;
            }

            try
            {
                Lote lote = new Lote
                {
                    NumeroLote = txtNumeroLote.Text.Trim(),
                    FechaIngreso = dtpFechaIngreso.Value,
                    FechaVencimiento = dtpFechaVencimiento.Value,
                    Cantidad = (int)nudCantidad.Value,
                    ProductoId = _productoId,
                    Activo = true
                };
                ResultadoIngresoLote resultado = _loteBLL.Agregar(lote);
                MessageBox.Show(resultado.Consolidado ? "Las unidades se sumaron al lote existente." : "Lote creado y unidades agregadas correctamente.");
                LoteAgregado = true;
                this.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error al agregar lote: {ex.Message}");
            }
        }

        private void btnCancelar_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
