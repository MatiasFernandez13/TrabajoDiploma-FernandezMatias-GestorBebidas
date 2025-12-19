namespace UI
{
    partial class FrmReportes
    {
        private System.ComponentModel.IContainer components = null;
        private System.Windows.Forms.ComboBox cbZona;
        private System.Windows.Forms.ComboBox cbProducto;
        private System.Windows.Forms.DateTimePicker dtpFecha;
        private System.Windows.Forms.Button btnGenerarReporte;
        private System.Windows.Forms.DataGridView dgvReporte;

        private void InitializeComponent()
        {
            cbZona = new ComboBox();
            cbProducto = new ComboBox();
            dtpFecha = new DateTimePicker();
            btnGenerarReporte = new Button();
            dgvReporte = new DataGridView();
            ((System.ComponentModel.ISupportInitialize)dgvReporte).BeginInit();
            SuspendLayout();
            // 
            // cbZona
            // 
            cbZona.Location = new Point(20, 20);
            cbZona.Name = "cbZona";
            cbZona.Size = new Size(150, 31);
            cbZona.TabIndex = 0;
            // 
            // cbProducto
            // 
            cbProducto.Location = new Point(200, 20);
            cbProducto.Name = "cbProducto";
            cbProducto.Size = new Size(150, 31);
            cbProducto.TabIndex = 1;
            // 
            // dtpFecha
            // 
            dtpFecha.Location = new Point(380, 20);
            dtpFecha.Name = "dtpFecha";
            dtpFecha.Size = new Size(309, 30);
            dtpFecha.TabIndex = 2;
            // 
            // btnGenerarReporte
            // 
            btnGenerarReporte.Location = new Point(721, 16);
            btnGenerarReporte.Name = "btnGenerarReporte";
            btnGenerarReporte.Size = new Size(156, 34);
            btnGenerarReporte.TabIndex = 3;
            btnGenerarReporte.Tag = "GenerarReporte";
            btnGenerarReporte.Text = "Generar Reporte";
            btnGenerarReporte.Click += btnGenerarReporte_Click;
            // 
            // dgvReporte
            // 
            dgvReporte.ColumnHeadersHeight = 29;
            dgvReporte.Location = new Point(20, 60);
            dgvReporte.Name = "dgvReporte";
            dgvReporte.RowHeadersWidth = 51;
            dgvReporte.Size = new Size(1051, 635);
            dgvReporte.TabIndex = 4;
            // 
            // FrmReportes
            // 
            ClientSize = new Size(1159, 755);
            Controls.Add(cbZona);
            Controls.Add(cbProducto);
            Controls.Add(dtpFecha);
            Controls.Add(btnGenerarReporte);
            Controls.Add(dgvReporte);
            Font = new Font("Segoe UI", 10F);
            Name = "FrmReportes";
            Text = "Reporte de Ventas";
            ((System.ComponentModel.ISupportInitialize)dgvReporte).EndInit();
            ResumeLayout(false);
        }
    }
}
