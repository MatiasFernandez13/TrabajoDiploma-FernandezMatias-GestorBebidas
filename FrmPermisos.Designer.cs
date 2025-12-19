namespace UI
{
    partial class FrmPermisos
    {
        private System.ComponentModel.IContainer components = null;
        private System.Windows.Forms.TabControl tabControl;
        private System.Windows.Forms.TabPage tabGestionar;
        private System.Windows.Forms.TabPage tabAsignar;
        private System.Windows.Forms.ListBox lstSimples;
        private System.Windows.Forms.ListBox lstCompuestos;
        private System.Windows.Forms.TextBox txtPermisoSimpleNombre;
        private System.Windows.Forms.Button btnCrearSimple;
        private System.Windows.Forms.TextBox txtGrupoNombre;
        private System.Windows.Forms.CheckedListBox clbSimplesParaGrupo;
        private System.Windows.Forms.Button btnCrearGrupo;
        private System.Windows.Forms.ListBox lstUsuarios;
        private System.Windows.Forms.CheckedListBox clbGruposAsignar;
        private System.Windows.Forms.Button btnGuardarAsignacion;
        private System.Windows.Forms.Label lblSimples;
        private System.Windows.Forms.Label lblCompuestos;
        private System.Windows.Forms.Label lblUsuario;
        private System.Windows.Forms.Label lblSeleccionPermisos;
        private System.Windows.Forms.TreeView tvPermisos;
        private System.Windows.Forms.Button btnGuardarGrupo;
        private System.Windows.Forms.Button btnEliminarGrupo;
        private void InitializeComponent()
        {
            tabControl = new TabControl();
            tabGestionar = new TabPage();
            lblSimples = new Label();
            lstSimples = new ListBox();
            txtPermisoSimpleNombre = new TextBox();
            btnCrearSimple = new Button();
            lblCompuestos = new Label();
            lstCompuestos = new ListBox();
            lblSeleccionPermisos = new Label();
            clbSimplesParaGrupo = new CheckedListBox();
            txtGrupoNombre = new TextBox();
            btnCrearGrupo = new Button();
            tabAsignar = new TabPage();
            lblUsuario = new Label();
            lstUsuarios = new ListBox();
            clbGruposAsignar = new CheckedListBox();
            btnGuardarAsignacion = new Button();
            tvPermisos = new TreeView();
            btnGuardarGrupo = new Button();
            btnEliminarGrupo = new Button();
            tabControl.SuspendLayout();
            tabGestionar.SuspendLayout();
            tabAsignar.SuspendLayout();
            SuspendLayout();
            // 
            // tabControl
            // 
            tabControl.Controls.Add(tabGestionar);
            tabControl.Controls.Add(tabAsignar);
            tabControl.Dock = DockStyle.Fill;
            tabControl.Location = new Point(0, 0);
            tabControl.Name = "tabControl";
            tabControl.SelectedIndex = 0;
            tabControl.Size = new Size(1553, 798);
            tabControl.TabIndex = 0;
            // 
            // tabGestionar
            // 
            tabGestionar.Controls.Add(lblSimples);
            tabGestionar.Controls.Add(lstSimples);
            tabGestionar.Controls.Add(txtPermisoSimpleNombre);
            tabGestionar.Controls.Add(btnCrearSimple);
            tabGestionar.Controls.Add(lblCompuestos);
            tabGestionar.Controls.Add(lstCompuestos);
            tabGestionar.Controls.Add(lblSeleccionPermisos);
            tabGestionar.Controls.Add(clbSimplesParaGrupo);
            tabGestionar.Controls.Add(tvPermisos);
            tabGestionar.Controls.Add(btnGuardarGrupo);
            tabGestionar.Controls.Add(btnEliminarGrupo);
            tabGestionar.Controls.Add(txtGrupoNombre);
            tabGestionar.Controls.Add(btnCrearGrupo);
            tabGestionar.Location = new Point(4, 32);
            tabGestionar.Name = "tabGestionar";
            tabGestionar.Size = new Size(1545, 762);
            tabGestionar.TabIndex = 0;
            tabGestionar.Tag = "Gestionar";
            tabGestionar.Text = "Gestionar";
            // 
            // lblSimples
            // 
            lblSimples.Location = new Point(102, 19);
            lblSimples.Name = "lblSimples";
            lblSimples.Size = new Size(180, 23);
            lblSimples.TabIndex = 0;
            lblSimples.Tag = "PermisosSimples";
            lblSimples.Text = "Permisos Simples";
            lblSimples.Visible = false;
            // 
            // lstSimples
            // 
            lstSimples.ItemHeight = 23;
            lstSimples.Location = new Point(20, 45);
            lstSimples.Name = "lstSimples";
            lstSimples.Size = new Size(309, 579);
            lstSimples.TabIndex = 1;
            lstSimples.Visible = false;
            // 
            // txtPermisoSimpleNombre
            // 
            txtPermisoSimpleNombre.Location = new Point(19, 656);
            txtPermisoSimpleNombre.Name = "txtPermisoSimpleNombre";
            txtPermisoSimpleNombre.Size = new Size(180, 30);
            txtPermisoSimpleNombre.TabIndex = 2;
            // 
            // btnCrearSimple
            // 
            btnCrearSimple.Location = new Point(209, 654);
            btnCrearSimple.Name = "btnCrearSimple";
            btnCrearSimple.Size = new Size(120, 30);
            btnCrearSimple.TabIndex = 3;
            btnCrearSimple.Tag = "CrearPermisoSimple";
            btnCrearSimple.Text = "Crear Simple";
            btnCrearSimple.Click += btnCrearSimple_Click;
            // 
            // lblCompuestos
            // 
            lblCompuestos.Location = new Point(422, 19);
            lblCompuestos.Name = "lblCompuestos";
            lblCompuestos.Size = new Size(216, 23);
            lblCompuestos.TabIndex = 4;
            lblCompuestos.Tag = "PermisosCompuestos";
            lblCompuestos.Text = "Permisos Compuestos";
            // 
            // lstCompuestos
            // 
            lstCompuestos.ItemHeight = 23;
            lstCompuestos.Location = new Point(375, 45);
            lstCompuestos.Name = "lstCompuestos";
            lstCompuestos.Size = new Size(310, 579);
            lstCompuestos.TabIndex = 5;
            lstCompuestos.SelectedIndexChanged += lstCompuestos_SelectedIndexChanged;
            // 
            // lblSeleccionPermisos
            // 
            lblSeleccionPermisos.Location = new Point(986, 19);
            lblSeleccionPermisos.Name = "lblSeleccionPermisos";
            lblSeleccionPermisos.Size = new Size(100, 23);
            lblSeleccionPermisos.TabIndex = 6;
            lblSeleccionPermisos.Tag = "SeleccionarSimples";
            lblSeleccionPermisos.Text = "Catálogo de permisos";
            // 
            // tvPermisos
            // 
            tvPermisos.CheckBoxes = true;
            tvPermisos.Location = new Point(720, 45);
            tvPermisos.Name = "tvPermisos";
            tvPermisos.Size = new Size(430, 579);
            tvPermisos.TabIndex = 10;
            tvPermisos.AfterCheck += tvPermisos_AfterCheck;
            // 
            // btnGuardarGrupo
            // 
            btnGuardarGrupo.Location = new System.Drawing.Point(720, 640);
            btnGuardarGrupo.Name = "btnGuardarGrupo";
            btnGuardarGrupo.Size = new System.Drawing.Size(180, 32);
            btnGuardarGrupo.TabIndex = 11;
            btnGuardarGrupo.Text = "Guardar Cambios";
            btnGuardarGrupo.Tag = "GuardarAsignacion";
            btnGuardarGrupo.Click += btnGuardarGrupo_Click;
            // 
            // btnEliminarGrupo
            // 
            btnEliminarGrupo.Location = new System.Drawing.Point(565, 690);
            btnEliminarGrupo.Name = "btnEliminarGrupo";
            btnEliminarGrupo.Size = new System.Drawing.Size(120, 30);
            btnEliminarGrupo.TabIndex = 12;
            btnEliminarGrupo.Tag = "EliminarGrupo";
            btnEliminarGrupo.Text = "Eliminar Grupo";
            btnEliminarGrupo.Click += btnEliminarGrupo_Click;
            // 
            // clbSimplesParaGrupo
            // 
            clbSimplesParaGrupo.Location = new Point(1160, 45);
            clbSimplesParaGrupo.Name = "clbSimplesParaGrupo";
            clbSimplesParaGrupo.Size = new Size(360, 429);
            clbSimplesParaGrupo.TabIndex = 7;
            clbSimplesParaGrupo.Visible = false;
            // 
            // txtGrupoNombre
            // 
            txtGrupoNombre.Location = new Point(375, 656);
            txtGrupoNombre.Name = "txtGrupoNombre";
            txtGrupoNombre.Size = new Size(180, 30);
            txtGrupoNombre.TabIndex = 8;
            // 
            // btnCrearGrupo
            // 
            btnCrearGrupo.Location = new Point(565, 654);
            btnCrearGrupo.Name = "btnCrearGrupo";
            btnCrearGrupo.Size = new Size(120, 30);
            btnCrearGrupo.TabIndex = 9;
            btnCrearGrupo.Tag = "CrearGrupo";
            btnCrearGrupo.Text = "Crear Grupo";
            btnCrearGrupo.Click += btnCrearGrupo_Click;
            // 
            // tabAsignar
            // 
            tabAsignar.Controls.Add(lblUsuario);
            tabAsignar.Controls.Add(lstUsuarios);
            tabAsignar.Controls.Add(clbGruposAsignar);
            tabAsignar.Controls.Add(btnGuardarAsignacion);
            tabAsignar.Location = new Point(4, 32);
            tabAsignar.Name = "tabAsignar";
            tabAsignar.Size = new Size(1130, 762);
            tabAsignar.TabIndex = 1;
            tabAsignar.Tag = "Asignar";
            tabAsignar.Text = "Asignar";
            // 
            // lblUsuario
            // 
            lblUsuario.Location = new Point(20, 20);
            lblUsuario.Name = "lblUsuario";
            lblUsuario.Size = new Size(100, 23);
            lblUsuario.TabIndex = 0;
            lblUsuario.Tag = "Usuario";
            lblUsuario.Text = "Usuario";
            // 
            // lstUsuarios
            // 
            lstUsuarios.FormattingEnabled = true;
            lstUsuarios.ItemHeight = 23;
            lstUsuarios.Location = new Point(20, 60);
            lstUsuarios.Name = "lstUsuarios";
            lstUsuarios.Size = new Size(300, 379);
            lstUsuarios.TabIndex = 1;
            lstUsuarios.SelectedIndexChanged += lstUsuarios_SelectedIndexChanged;
            // 
            // clbGruposAsignar
            // 
            clbGruposAsignar.CheckOnClick = true;
            clbGruposAsignar.Location = new Point(340, 60);
            clbGruposAsignar.Name = "clbGruposAsignar";
            clbGruposAsignar.Size = new Size(420, 379);
            clbGruposAsignar.TabIndex = 2;
            // 
            // btnGuardarAsignacion
            // 
            btnGuardarAsignacion.Location = new Point(20, 460);
            btnGuardarAsignacion.Name = "btnGuardarAsignacion";
            btnGuardarAsignacion.Size = new Size(180, 32);
            btnGuardarAsignacion.TabIndex = 3;
            btnGuardarAsignacion.Tag = "GuardarAsignacion";
            btnGuardarAsignacion.Text = "Guardar Asignación";
            btnGuardarAsignacion.Click += btnGuardarAsignacion_Click;
            // 
            // FrmPermisos
            // 
            ClientSize = new Size(1553, 798);
            Controls.Add(tabControl);
            Font = new Font("Segoe UI", 10F);
            Name = "FrmPermisos";
            Text = "Permisos";
            tabControl.ResumeLayout(false);
            tabGestionar.ResumeLayout(false);
            tabGestionar.PerformLayout();
            tabAsignar.ResumeLayout(false);
            ResumeLayout(false);
        }
    }
}
