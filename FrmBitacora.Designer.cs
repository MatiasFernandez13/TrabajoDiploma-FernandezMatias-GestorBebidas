namespace UI
{
    partial class FrmBitacora
    {
        private System.ComponentModel.IContainer components = null;
        private System.Windows.Forms.DataGridView dgvBitacora;
        private System.Windows.Forms.ComboBox cbUsuarios;
        private System.Windows.Forms.ComboBox cbAccion;
        private System.Windows.Forms.DateTimePicker dtDesde;
        private System.Windows.Forms.DateTimePicker dtHasta;
        private System.Windows.Forms.Button btnBuscar;
        private System.Windows.Forms.Label lblUsuario;
        private System.Windows.Forms.Label lblAccion;
        private System.Windows.Forms.Label lblDesde;
        private System.Windows.Forms.Label lblHasta;
        private void InitializeComponent()
        {
            dgvBitacora = new DataGridView();
            cbUsuarios = new ComboBox();
            cbAccion = new ComboBox();
            dtDesde = new DateTimePicker();
            dtHasta = new DateTimePicker();
            btnBuscar = new Button();
            lblUsuario = new Label();
            lblAccion = new Label();
            lblDesde = new Label();
            lblHasta = new Label();
            ((System.ComponentModel.ISupportInitialize)dgvBitacora).BeginInit();
            SuspendLayout();
            // 
            // dgvBitacora
            // 
            dgvBitacora.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            dgvBitacora.ColumnHeadersHeight = 29;
            dgvBitacora.Location = new Point(20, 100);
            dgvBitacora.Name = "dgvBitacora";
            dgvBitacora.ReadOnly = true;
            dgvBitacora.RowHeadersWidth = 51;
            dgvBitacora.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            dgvBitacora.Size = new Size(1166, 619);
            dgvBitacora.TabIndex = 9;
            // 
            // cbUsuarios
            // 
            cbUsuarios.DropDownStyle = ComboBoxStyle.DropDownList;
            cbUsuarios.Location = new Point(104, 19);
            cbUsuarios.Name = "cbUsuarios";
            cbUsuarios.Size = new Size(319, 31);
            cbUsuarios.TabIndex = 1;
            // 
            // cbAccion
            // 
            cbAccion.DropDownStyle = ComboBoxStyle.DropDownList;
            cbAccion.Location = new Point(584, 18);
            cbAccion.Name = "cbAccion";
            cbAccion.Size = new Size(310, 31);
            cbAccion.TabIndex = 3;
            // 
            // dtDesde
            // 
            dtDesde.Location = new Point(104, 53);
            dtDesde.Name = "dtDesde";
            dtDesde.Size = new Size(319, 30);
            dtDesde.TabIndex = 5;
            // 
            // dtHasta
            // 
            dtHasta.Location = new Point(584, 52);
            dtHasta.Name = "dtHasta";
            dtHasta.Size = new Size(310, 30);
            dtHasta.TabIndex = 7;
            // 
            // btnBuscar
            // 
            btnBuscar.Location = new Point(983, 20);
            btnBuscar.Name = "btnBuscar";
            btnBuscar.Size = new Size(203, 63);
            btnBuscar.TabIndex = 8;
            btnBuscar.Tag = "Buscar";
            btnBuscar.Text = "Buscar";
            btnBuscar.Click += btnBuscar_Click;
            // 
            // lblUsuario
            // 
            lblUsuario.Location = new Point(20, 20);
            lblUsuario.Name = "lblUsuario";
            lblUsuario.Size = new Size(81, 23);
            lblUsuario.TabIndex = 0;
            lblUsuario.Tag = "Usuario";
            lblUsuario.Text = "Usuario";
            // 
            // lblAccion
            // 
            lblAccion.Location = new Point(519, 17);
            lblAccion.Name = "lblAccion";
            lblAccion.Size = new Size(65, 29);
            lblAccion.TabIndex = 2;
            lblAccion.Tag = "Accion";
            lblAccion.Text = "Acción";
            // 
            // lblDesde
            // 
            lblDesde.Location = new Point(20, 55);
            lblDesde.Name = "lblDesde";
            lblDesde.Size = new Size(81, 23);
            lblDesde.TabIndex = 4;
            lblDesde.Tag = "Desde";
            lblDesde.Text = "Desde";
            // 
            // lblHasta
            // 
            lblHasta.Location = new Point(519, 52);
            lblHasta.Name = "lblHasta";
            lblHasta.Size = new Size(65, 29);
            lblHasta.TabIndex = 6;
            lblHasta.Tag = "Hasta";
            lblHasta.Text = "Hasta";
            // 
            // FrmBitacora
            // 
            ClientSize = new Size(1397, 783);
            Controls.Add(lblUsuario);
            Controls.Add(cbUsuarios);
            Controls.Add(lblAccion);
            Controls.Add(cbAccion);
            Controls.Add(lblDesde);
            Controls.Add(dtDesde);
            Controls.Add(lblHasta);
            Controls.Add(dtHasta);
            Controls.Add(btnBuscar);
            Controls.Add(dgvBitacora);
            Font = new Font("Segoe UI", 10F);
            Name = "FrmBitacora";
            Text = "Bitácora";
            ((System.ComponentModel.ISupportInitialize)dgvBitacora).EndInit();
            ResumeLayout(false);
        }
    }
}
