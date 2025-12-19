namespace UI
{
    partial class FrmIdiomas
    {
        private System.ComponentModel.IContainer components = null;
        private System.Windows.Forms.TextBox txtCodigo;
        private System.Windows.Forms.TextBox txtNombre;
        private System.Windows.Forms.Button btnNuevo;
        private System.Windows.Forms.Button btnGuardar;
        private System.Windows.Forms.Button btnEliminar;
        private System.Windows.Forms.Button btnCancelar;
        private System.Windows.Forms.DataGridView dgvTags;
        private System.Windows.Forms.ComboBox cbIdiomas;
        private System.Windows.Forms.Label lblCodigo;
        private System.Windows.Forms.Label lblNombre;
        private System.Windows.Forms.Label lblIdioma;

        private void InitializeComponent()
        {
            txtCodigo = new TextBox();
            txtNombre = new TextBox();
            btnNuevo = new Button();
            btnGuardar = new Button();
            btnEliminar = new Button();
            btnCancelar = new Button();
            dgvTags = new DataGridView();
            cbIdiomas = new ComboBox();
            lblCodigo = new Label();
            lblNombre = new Label();
            lblIdioma = new Label();
            ((System.ComponentModel.ISupportInitialize)dgvTags).BeginInit();
            SuspendLayout();
            // 
            // txtCodigo
            // 
            txtCodigo.Location = new Point(363, 41);
            txtCodigo.Name = "txtCodigo";
            txtCodigo.Size = new Size(120, 30);
            txtCodigo.TabIndex = 3;
            // 
            // txtNombre
            // 
            txtNombre.Location = new Point(503, 41);
            txtNombre.Name = "txtNombre";
            txtNombre.Size = new Size(180, 30);
            txtNombre.TabIndex = 5;
            // 
            // btnNuevo
            // 
            btnNuevo.Location = new Point(703, 39);
            btnNuevo.Name = "btnNuevo";
            btnNuevo.Size = new Size(100, 30);
            btnNuevo.TabIndex = 6;
            btnNuevo.Tag = "btnNuevo";
            btnNuevo.Text = "Nuevo";
            btnNuevo.Click += btnNuevo_Click;
            // 
            // btnGuardar
            // 
            btnGuardar.Location = new Point(813, 39);
            btnGuardar.Name = "btnGuardar";
            btnGuardar.Size = new Size(100, 30);
            btnGuardar.TabIndex = 7;
            btnGuardar.Tag = "btnGrabar";
            btnGuardar.Text = "Guardar";
            btnGuardar.Click += btnGuardar_Click;
            // 
            // btnEliminar
            // 
            btnEliminar.Location = new Point(923, 39);
            btnEliminar.Name = "btnEliminar";
            btnEliminar.Size = new Size(100, 30);
            btnEliminar.TabIndex = 8;
            btnEliminar.Tag = "btnEliminar";
            btnEliminar.Text = "Eliminar";
            btnEliminar.Click += btnEliminar_Click;
            // 
            // btnCancelar
            // 
            btnCancelar.Location = new Point(1033, 39);
            btnCancelar.Name = "btnCancelar";
            btnCancelar.Size = new Size(100, 30);
            btnCancelar.TabIndex = 9;
            btnCancelar.Tag = "btnCancelar";
            btnCancelar.Text = "Cancelar";
            btnCancelar.Enabled = false;
            btnCancelar.Click += btnCancelar_Click;
            // 
            // dgvTags
            // 
            dgvTags.AllowUserToAddRows = false;
            dgvTags.AllowUserToDeleteRows = false;
            dgvTags.ColumnHeadersHeight = 29;
            dgvTags.Location = new Point(20, 110);
            dgvTags.Name = "dgvTags";
            dgvTags.RowHeadersWidth = 51;
            dgvTags.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            dgvTags.Size = new Size(704, 765);
            dgvTags.TabIndex = 10;
            dgvTags.CellEndEdit += dgvTags_CellEndEdit;
            // 
            // cbIdiomas
            // 
            cbIdiomas.DropDownStyle = ComboBoxStyle.DropDownList;
            cbIdiomas.Location = new Point(71, 38);
            cbIdiomas.Name = "cbIdiomas";
            cbIdiomas.Size = new Size(240, 31);
            cbIdiomas.TabIndex = 1;
            cbIdiomas.SelectedIndexChanged += cbIdiomas_SelectedIndexChanged;
            // 
            // lblCodigo
            // 
            lblCodigo.Location = new Point(363, 21);
            lblCodigo.Name = "lblCodigo";
            lblCodigo.Size = new Size(100, 23);
            lblCodigo.TabIndex = 2;
            lblCodigo.Tag = "lblCodigo";
            lblCodigo.Text = "Código";
            // 
            // lblNombre
            // 
            lblNombre.Location = new Point(503, 21);
            lblNombre.Name = "lblNombre";
            lblNombre.Size = new Size(100, 23);
            lblNombre.TabIndex = 4;
            lblNombre.Tag = "lblNombre";
            lblNombre.Text = "Nombre";
            // 
            // lblIdioma
            // 
            lblIdioma.Location = new Point(94, -1);
            lblIdioma.Name = "lblIdioma";
            lblIdioma.Size = new Size(100, 23);
            lblIdioma.TabIndex = 0;
            lblIdioma.Tag = "lblIdioma";
            lblIdioma.Text = "Idioma";
            // 
            // FrmIdiomas
            // 
            ClientSize = new Size(1122, 816);
            Controls.Add(lblIdioma);
            Controls.Add(cbIdiomas);
            Controls.Add(lblCodigo);
            Controls.Add(txtCodigo);
            Controls.Add(lblNombre);
            Controls.Add(txtNombre);
            Controls.Add(btnNuevo);
            Controls.Add(btnGuardar);
            Controls.Add(btnEliminar);
            Controls.Add(btnCancelar);
            Controls.Add(dgvTags);
            Font = new Font("Segoe UI", 10F);
            Name = "FrmIdiomas";
            Text = "Gestión de Idiomas";
            ((System.ComponentModel.ISupportInitialize)dgvTags).EndInit();
            ResumeLayout(false);
            PerformLayout();
        }
    }
}
