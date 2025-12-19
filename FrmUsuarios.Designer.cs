namespace UI
{
    partial class FrmUsuarios
    {
        private System.ComponentModel.IContainer components = null;
        private System.Windows.Forms.TextBox txtNombreUsuario;
        private System.Windows.Forms.TextBox txtContraseña;
        // private System.Windows.Forms.ComboBox cbRol;
        private System.Windows.Forms.Button btnAgregar;
        private System.Windows.Forms.Button btnModificar;
        private System.Windows.Forms.Button btnEliminar;
        private System.Windows.Forms.Button btnGrabar;
        private System.Windows.Forms.Button btnCancelar;
        private System.Windows.Forms.DataGridView dgvUsuarios;
        private System.Windows.Forms.Button btnToggleEliminados;

        private void InitializeComponent()
        {
            txtNombreUsuario = new TextBox();
            txtContraseña = new TextBox();
            // cbRol = new ComboBox();
            btnAgregar = new Button();
            btnModificar = new Button();
            btnEliminar = new Button();
            btnGrabar = new Button();
            btnCancelar = new Button();
            dgvUsuarios = new DataGridView();
            btnToggleEliminados = new Button();
            label1 = new Label();
            label2 = new Label();
            // label3 = new Label();
            ((System.ComponentModel.ISupportInitialize)dgvUsuarios).BeginInit();
            SuspendLayout();
            // 
            // txtNombreUsuario
            // 
            txtNombreUsuario.Location = new Point(384, 43);
            txtNombreUsuario.Name = "txtNombreUsuario";
            txtNombreUsuario.Size = new Size(150, 30);
            txtNombreUsuario.TabIndex = 0;
            // 
            // txtContraseña
            // 
            txtContraseña.Location = new Point(384, 89);
            txtContraseña.Name = "txtContraseña";
            txtContraseña.PasswordChar = '*';
            txtContraseña.Size = new Size(150, 30);
            txtContraseña.TabIndex = 1;
            // 
            // btnAgregar
            // 
            btnAgregar.Location = new Point(65, 43);
            btnAgregar.Name = "btnAgregar";
            btnAgregar.Size = new Size(98, 30);
            btnAgregar.TabIndex = 3;
            btnAgregar.Tag = "btnAgregar";
            btnAgregar.Text = "Agregar";
            btnAgregar.Click += btnAgregar_Click;
            // 
            // btnModificar
            // 
            btnModificar.Enabled = false;
            btnModificar.Location = new Point(65, 86);
            btnModificar.Name = "btnModificar";
            btnModificar.Size = new Size(98, 32);
            btnModificar.TabIndex = 4;
            btnModificar.Tag = "btnModificar";
            btnModificar.Text = "Modificar";
            btnModificar.Click += btnModificar_Click;
            // 
            // btnEliminar
            // 
            btnEliminar.Enabled = false;
            btnEliminar.Location = new Point(65, 129);
            btnEliminar.Name = "btnEliminar";
            btnEliminar.Size = new Size(98, 36);
            btnEliminar.TabIndex = 5;
            btnEliminar.Tag = "btnEliminar";
            btnEliminar.Text = "Eliminar";
            btnEliminar.Click += btnEliminar_Click;
            // 
            // btnGrabar
            // 
            btnGrabar.Location = new Point(612, 66);
            btnGrabar.Name = "btnGrabar";
            btnGrabar.Size = new Size(104, 38);
            btnGrabar.TabIndex = 6;
            btnGrabar.Tag = "btnGrabar";
            btnGrabar.Text = "Grabar";
            btnGrabar.Visible = false;
            btnGrabar.Click += btnGrabar_Click;
            // 
            // btnCancelar
            // 
            btnCancelar.Location = new Point(612, 123);
            btnCancelar.Name = "btnCancelar";
            btnCancelar.Size = new Size(104, 34);
            btnCancelar.TabIndex = 7;
            btnCancelar.Tag = "btnCancelar";
            btnCancelar.Text = "Cancelar";
            btnCancelar.Visible = false;
            btnCancelar.Click += btnCancelar_Click;
            // 
            // dgvUsuarios
            // 
            dgvUsuarios.ColumnHeadersHeight = 29;
            dgvUsuarios.Location = new Point(12, 203);
            dgvUsuarios.MultiSelect = false;
            dgvUsuarios.Name = "dgvUsuarios";
            dgvUsuarios.RowHeadersWidth = 51;
            dgvUsuarios.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            dgvUsuarios.Size = new Size(865, 322);
            dgvUsuarios.TabIndex = 8;
            dgvUsuarios.CellClick += dgvUsuarios_CellClick;
            dgvUsuarios.SelectionChanged += dgvUsuarios_SelectionChanged;
            // 
            // btnToggleEliminados
            // 
            btnToggleEliminados.Location = new Point(735, 126);
            btnToggleEliminados.Name = "btnToggleEliminados";
            btnToggleEliminados.Size = new Size(180, 34);
            btnToggleEliminados.TabIndex = 14;
            btnToggleEliminados.Tag = "MostrarEliminados";
            btnToggleEliminados.Text = "Mostrar eliminados";
            btnToggleEliminados.UseVisualStyleBackColor = true;
            btnToggleEliminados.Click += btnToggleEliminados_Click;
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Location = new Point(257, 43);
            label1.Name = "label1";
            label1.Size = new Size(68, 23);
            label1.TabIndex = 9;
            label1.Tag = "lblUsuario";
            label1.Text = "Usuario";
            // 
            // label2
            // 
            label2.AutoSize = true;
            label2.Location = new Point(243, 89);
            label2.Name = "label2";
            label2.Size = new Size(97, 23);
            label2.TabIndex = 10;
            label2.Tag = "lblPassword";
            label2.Text = "Contraseña";
            // 
            // FrmUsuarios
            // 
            ClientSize = new Size(1185, 554);
            // Controls.Add(label3);
            Controls.Add(label2);
            Controls.Add(label1);
            Controls.Add(txtNombreUsuario);
            Controls.Add(txtContraseña);
            // Controls.Add(cbRol);
            Controls.Add(btnAgregar);
            Controls.Add(btnModificar);
            Controls.Add(btnEliminar);
            Controls.Add(btnGrabar);
            Controls.Add(btnCancelar);
            Controls.Add(dgvUsuarios);
            Controls.Add(btnToggleEliminados);
            Font = new Font("Segoe UI", 10F);
            Name = "FrmUsuarios";
            Text = "Gestión de Usuarios";
            FormClosed += FrmUsuarios_FormClosed;
            Load += FrmUsuarios_Load;
            ((System.ComponentModel.ISupportInitialize)dgvUsuarios).EndInit();
            ResumeLayout(false);
            PerformLayout();
        }
        private Label label1;
        private Label label2;
        // private Label label3;
    }
}

