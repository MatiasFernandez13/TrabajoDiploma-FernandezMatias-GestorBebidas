namespace UI
{
    partial class FrmVentas
    {
        private System.ComponentModel.IContainer components = null;
        private System.Windows.Forms.DataGridView dgvProductos;
        private System.Windows.Forms.DataGridView dgvCarrito;
        private System.Windows.Forms.NumericUpDown nudCantidad;
        private System.Windows.Forms.Button btnAgregarProducto;
        private System.Windows.Forms.Button btnRegistrarVenta;
        private System.Windows.Forms.Label lblTotal;

        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null)) components.Dispose();
            base.Dispose(disposing);
        }

        private void InitializeComponent()
        {
            dgvProductos = new DataGridView();
            dgvCarrito = new DataGridView();
            nudCantidad = new NumericUpDown();
            btnAgregarProducto = new Button();
            btnRegistrarVenta = new Button();
            lblTotal = new Label();
            ((System.ComponentModel.ISupportInitialize)dgvProductos).BeginInit();
            ((System.ComponentModel.ISupportInitialize)dgvCarrito).BeginInit();
            ((System.ComponentModel.ISupportInitialize)nudCantidad).BeginInit();
            SuspendLayout();
            // 
            // dgvProductos
            // 
            dgvProductos.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dgvProductos.Location = new Point(20, 20);
            dgvProductos.Name = "dgvProductos";
            dgvProductos.RowHeadersWidth = 51;
            dgvProductos.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            dgvProductos.Size = new Size(862, 200);
            dgvProductos.TabIndex = 0;
            // 
            // dgvCarrito
            // 
            dgvCarrito.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dgvCarrito.Location = new Point(20, 240);
            dgvCarrito.Name = "dgvCarrito";
            dgvCarrito.RowHeadersWidth = 51;
            dgvCarrito.Size = new Size(862, 200);
            dgvCarrito.TabIndex = 3;
            // 
            // nudCantidad
            // 
            nudCantidad.Location = new Point(899, 57);
            nudCantidad.Maximum = new decimal(new int[] { 1000, 0, 0, 0 });
            nudCantidad.Minimum = new decimal(new int[] { 1, 0, 0, 0 });
            nudCantidad.Name = "nudCantidad";
            nudCantidad.Size = new Size(60, 27);
            nudCantidad.TabIndex = 1;
            nudCantidad.Value = new decimal(new int[] { 1, 0, 0, 0 });
            // 
            // btnAgregarProducto
            // 
            btnAgregarProducto.Location = new Point(899, 97);
            btnAgregarProducto.Name = "btnAgregarProducto";
            btnAgregarProducto.Size = new Size(100, 30);
            btnAgregarProducto.TabIndex = 2;
            btnAgregarProducto.Text = "Agregar";
            btnAgregarProducto.Tag = "Agregar";
            btnAgregarProducto.Click += btnAgregarProducto_Click;
            // 
            // btnRegistrarVenta
            // 
            btnRegistrarVenta.Location = new Point(899, 267);
            btnRegistrarVenta.Name = "btnRegistrarVenta";
            btnRegistrarVenta.Size = new Size(100, 40);
            btnRegistrarVenta.TabIndex = 4;
            btnRegistrarVenta.Text = "Registrar";
            btnRegistrarVenta.Tag = "Registrar";
            btnRegistrarVenta.Click += btnRegistrarVenta_Click;
            // 
            // lblTotal
            // 
            lblTotal.Location = new Point(20, 460);
            lblTotal.Name = "lblTotal";
            lblTotal.Size = new Size(300, 30);
            lblTotal.TabIndex = 5;
            lblTotal.Text = "Total: $0";
            lblTotal.Tag = "Total";
            // 
            // FrmVentas
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(1184, 542);
            Controls.Add(dgvProductos);
            Controls.Add(nudCantidad);
            Controls.Add(btnAgregarProducto);
            Controls.Add(dgvCarrito);
            Controls.Add(btnRegistrarVenta);
            Controls.Add(lblTotal);
            Name = "FrmVentas";
            Text = "Gestión de Ventas";
            Load += FrmVentas_Load;
            ((System.ComponentModel.ISupportInitialize)dgvProductos).EndInit();
            ((System.ComponentModel.ISupportInitialize)dgvCarrito).EndInit();
            ((System.ComponentModel.ISupportInitialize)nudCantidad).EndInit();
            ResumeLayout(false);
        }
    }
}
