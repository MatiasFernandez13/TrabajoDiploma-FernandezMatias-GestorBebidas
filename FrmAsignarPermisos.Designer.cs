namespace UI
{
    partial class FrmAsignarPermisos
    {
        private System.ComponentModel.IContainer components = null;
        private System.Windows.Forms.ComboBox cbUsuarios;
        private System.Windows.Forms.CheckedListBox clbGrupos;
        private System.Windows.Forms.Button btnGuardar;
        private System.Windows.Forms.Label lblUsuario;
        private System.Windows.Forms.Label lblGrupos;

        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null)) components.Dispose();
            base.Dispose(disposing);
        }

        private void InitializeComponent()
        {
            cbUsuarios = new ComboBox();
            clbGrupos = new CheckedListBox();
            btnGuardar = new Button();
            lblUsuario = new Label();
            lblGrupos = new Label();
            SuspendLayout();
            // 
            // cbUsuarios
            // 
            cbUsuarios.DropDownStyle = ComboBoxStyle.DropDownList;
            cbUsuarios.FormattingEnabled = true;
            cbUsuarios.Location = new Point(20, 40);
            cbUsuarios.Name = "cbUsuarios";
            cbUsuarios.Size = new Size(250, 28);
            cbUsuarios.TabIndex = 0;
            cbUsuarios.SelectedIndexChanged += cbUsuarios_SelectedIndexChanged;
            // 
            // clbGrupos
            // 
            clbGrupos.CheckOnClick = true;
            clbGrupos.FormattingEnabled = true;
            clbGrupos.Location = new Point(20, 110);
            clbGrupos.Name = "clbGrupos";
            clbGrupos.Size = new Size(545, 378);
            clbGrupos.TabIndex = 1;
            // 
            // btnGuardar
            // 
            btnGuardar.Location = new Point(315, 38);
            btnGuardar.Name = "btnGuardar";
            btnGuardar.Size = new Size(250, 30);
            btnGuardar.TabIndex = 2;
            btnGuardar.Text = "Guardar Asignación";
            btnGuardar.Tag = "GuardarAsignacion";
            btnGuardar.UseVisualStyleBackColor = true;
            btnGuardar.Click += btnGuardar_Click;
            // 
            // lblUsuario
            // 
            lblUsuario.AutoSize = true;
            lblUsuario.Location = new Point(20, 20);
            lblUsuario.Name = "lblUsuario";
            lblUsuario.Size = new Size(142, 20);
            lblUsuario.TabIndex = 3;
            lblUsuario.Text = "Seleccionar Usuario:";
            lblUsuario.Tag = "SeleccionarUsuario";
            // 
            // lblGrupos
            // 
            lblGrupos.AutoSize = true;
            lblGrupos.Location = new Point(20, 85);
            lblGrupos.Name = "lblGrupos";
            lblGrupos.Size = new Size(224, 20);
            lblGrupos.TabIndex = 4;
            lblGrupos.Text = "Grupos de permisos disponibles:";
            lblGrupos.Tag = "GruposDisponibles";
            // 
            // FrmAsignarPermisos
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(911, 453);
            Controls.Add(lblGrupos);
            Controls.Add(lblUsuario);
            Controls.Add(btnGuardar);
            Controls.Add(clbGrupos);
            Controls.Add(cbUsuarios);
            Name = "FrmAsignarPermisos";
            Text = "Asignar Permisos a Usuario";
            Load += FrmAsignarPermisos_Load;
            ResumeLayout(false);
            PerformLayout();
        }
    }
}
