namespace UI
{
    partial class FrmInventario
    {
        private System.ComponentModel.IContainer components = null;
        private System.Windows.Forms.DataGridView dgvStockProductos;
        private System.Windows.Forms.DataGridView dgvStockLotes;
        private System.Windows.Forms.Label lblStockProductos;
        private System.Windows.Forms.Label lblStockLotes;

        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
                components.Dispose();
            base.Dispose(disposing);
        }

        private void InitializeComponent()
        {
            dgvStockProductos = new DataGridView();
            dgvStockLotes = new DataGridView();
            lblStockProductos = new Label();
            lblStockLotes = new Label();
            ((System.ComponentModel.ISupportInitialize)dgvStockProductos).BeginInit();
            ((System.ComponentModel.ISupportInitialize)dgvStockLotes).BeginInit();
            SuspendLayout();
            // 
            // dgvStockProductos
            // 
            dgvStockProductos.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dgvStockProductos.Location = new Point(14, 53);
            dgvStockProductos.Margin = new Padding(3, 4, 3, 4);
            dgvStockProductos.Name = "dgvStockProductos";
            dgvStockProductos.ReadOnly = true;
            dgvStockProductos.RowHeadersWidth = 51;
            dgvStockProductos.Size = new Size(869, 200);
            dgvStockProductos.TabIndex = 0;
            dgvStockProductos.CellContentClick += dgvStockProductos_CellContentClick;
            // 
            // dgvStockLotes
            // 
            dgvStockLotes.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dgvStockLotes.Location = new Point(14, 307);
            dgvStockLotes.Margin = new Padding(3, 4, 3, 4);
            dgvStockLotes.Name = "dgvStockLotes";
            dgvStockLotes.ReadOnly = true;
            dgvStockLotes.RowHeadersWidth = 51;
            dgvStockLotes.Size = new Size(869, 200);
            dgvStockLotes.TabIndex = 1;
            // 
            // lblStockProductos
            // 
            lblStockProductos.AutoSize = true;
            lblStockProductos.Location = new Point(14, 27);
            lblStockProductos.Name = "lblStockProductos";
            lblStockProductos.Size = new Size(136, 20);
            lblStockProductos.TabIndex = 1;
            lblStockProductos.Text = "Stock por Producto";
            // 
            // lblStockLotes
            // 
            lblStockLotes.AutoSize = true;
            lblStockLotes.Location = new Point(14, 280);
            lblStockLotes.Name = "lblStockLotes";
            lblStockLotes.Size = new Size(105, 20);
            lblStockLotes.TabIndex = 0;
            lblStockLotes.Text = "Stock por Lote";
            // 
            // FrmInventario
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(1007, 593);
            Controls.Add(lblStockLotes);
            Controls.Add(lblStockProductos);
            Controls.Add(dgvStockLotes);
            Controls.Add(dgvStockProductos);
            Margin = new Padding(3, 4, 3, 4);
            Name = "FrmInventario";
            Text = "Inventario";
            Load += FrmInventario_Load;
            ((System.ComponentModel.ISupportInitialize)dgvStockProductos).EndInit();
            ((System.ComponentModel.ISupportInitialize)dgvStockLotes).EndInit();
            ResumeLayout(false);
            PerformLayout();
        }
    }
}
