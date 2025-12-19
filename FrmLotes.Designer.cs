namespace UI
{
    partial class FrmLotes
    {
        private System.ComponentModel.IContainer components = null;
        private System.Windows.Forms.DataGridView dgvLotes;
        private System.Windows.Forms.TextBox txtNumeroLote;
        private System.Windows.Forms.TextBox txtCantidad;
        private System.Windows.Forms.DateTimePicker dtpFechaIngreso;
        private System.Windows.Forms.Button btnAgregar;
        private System.Windows.Forms.Button btnEliminar;
        private System.Windows.Forms.Label lblProducto;
        private System.Windows.Forms.Label lblNumeroLote;
        private System.Windows.Forms.Label lblCantidad;
        private System.Windows.Forms.Label lblFechaIngreso;

        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null)) components.Dispose();
            base.Dispose(disposing);
        }

        private void InitializeComponent()
        {
            dgvLotes = new DataGridView();
            txtNumeroLote = new TextBox();
            txtCantidad = new TextBox();
            dtpFechaIngreso = new DateTimePicker();
            btnAgregar = new Button();
            btnEliminar = new Button();
            lblProducto = new Label();
            lblNumeroLote = new Label();
            lblCantidad = new Label();
            lblFechaIngreso = new Label();
            ((System.ComponentModel.ISupportInitialize)dgvLotes).BeginInit();
            SuspendLayout();
            // 
            // dgvLotes
            // 
            dgvLotes.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dgvLotes.Location = new Point(12, 180);
            dgvLotes.MultiSelect = false;
            dgvLotes.Name = "dgvLotes";
            dgvLotes.RowHeadersWidth = 51;
            dgvLotes.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            dgvLotes.Size = new Size(560, 200);
            dgvLotes.TabIndex = 0;
            // 
            // txtNumeroLote
            // 
            txtNumeroLote.Location = new Point(120, 50);
            txtNumeroLote.Name = "txtNumeroLote";
            txtNumeroLote.Size = new Size(150, 27);
            txtNumeroLote.TabIndex = 1;
            // 
            // txtCantidad
            // 
            txtCantidad.Location = new Point(120, 90);
            txtCantidad.Name = "txtCantidad";
            txtCantidad.Size = new Size(150, 27);
            txtCantidad.TabIndex = 2;
            // 
            // dtpFechaIngreso
            // 
            dtpFechaIngreso.Location = new Point(120, 130);
            dtpFechaIngreso.Name = "dtpFechaIngreso";
            dtpFechaIngreso.Size = new Size(200, 27);
            dtpFechaIngreso.TabIndex = 3;
            // 
            // btnAgregar
            // 
            btnAgregar.Location = new Point(350, 50);
            btnAgregar.Name = "btnAgregar";
            btnAgregar.Size = new Size(100, 30);
            btnAgregar.TabIndex = 4;
            btnAgregar.Text = "Agregar";
            btnAgregar.Click += btnAgregar_Click;
            // 
            // btnEliminar
            // 
            btnEliminar.Location = new Point(350, 90);
            btnEliminar.Name = "btnEliminar";
            btnEliminar.Size = new Size(100, 30);
            btnEliminar.TabIndex = 5;
            btnEliminar.Text = "Eliminar";
            btnEliminar.Click += btnEliminar_Click;
            // 
            // lblProducto
            // 
            lblProducto.Location = new Point(12, 10);
            lblProducto.Name = "lblProducto";
            lblProducto.Size = new Size(400, 25);
            lblProducto.TabIndex = 6;
            lblProducto.Text = "Lotes del producto:";
            // 
            // lblNumeroLote
            // 
            lblNumeroLote.Location = new Point(12, 50);
            lblNumeroLote.Name = "lblNumeroLote";
            lblNumeroLote.Size = new Size(100, 25);
            lblNumeroLote.TabIndex = 7;
            lblNumeroLote.Text = "N° de Lote:";
            // 
            // lblCantidad
            // 
            lblCantidad.Location = new Point(12, 90);
            lblCantidad.Name = "lblCantidad";
            lblCantidad.Size = new Size(100, 25);
            lblCantidad.TabIndex = 8;
            lblCantidad.Text = "Cantidad:";
            // 
            // lblFechaIngreso
            // 
            lblFechaIngreso.Location = new Point(12, 130);
            lblFechaIngreso.Name = "lblFechaIngreso";
            lblFechaIngreso.Size = new Size(100, 25);
            lblFechaIngreso.TabIndex = 9;
            lblFechaIngreso.Text = "Fecha Ingreso:";
            // 
            // FrmLotes
            // 
            ClientSize = new Size(584, 400);
            Controls.Add(dgvLotes);
            Controls.Add(txtNumeroLote);
            Controls.Add(txtCantidad);
            Controls.Add(dtpFechaIngreso);
            Controls.Add(btnAgregar);
            Controls.Add(btnEliminar);
            Controls.Add(lblProducto);
            Controls.Add(lblNumeroLote);
            Controls.Add(lblCantidad);
            Controls.Add(lblFechaIngreso);
            Name = "FrmLotes";
            Text = "Gestión de Lotes";
            ((System.ComponentModel.ISupportInitialize)dgvLotes).EndInit();
            ResumeLayout(false);
            PerformLayout();
        }
    }
}
