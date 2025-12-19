namespace UI
{
    partial class FrmPrincipal
    {
        private System.ComponentModel.IContainer components = null;
        private System.Windows.Forms.MenuStrip menuStrip1;
        private System.Windows.Forms.ToolStripMenuItem menuUsuarios;
        private System.Windows.Forms.ToolStripMenuItem menuProductos;
        private System.Windows.Forms.ToolStripMenuItem menuVentas;
        private System.Windows.Forms.ToolStripMenuItem menuReportes;
        private System.Windows.Forms.ToolStripMenuItem menuGestionPermisos;
        private System.Windows.Forms.ToolStripMenuItem menuAsignarPermisos; // NUEVO
        private System.Windows.Forms.ToolStripMenuItem menuVerificarIntegridad;
        private System.Windows.Forms.ToolStripMenuItem menuRecalcularIntegridad;
        private System.Windows.Forms.ToolStripMenuItem menuIdiomas;
        private System.Windows.Forms.ToolStripMenuItem menuBitacora;
        private System.Windows.Forms.ToolStripComboBox cbIdiomas;
        private System.Windows.Forms.ToolStripMenuItem menuUsuarioLogueado;
        private System.Windows.Forms.ToolStripMenuItem cerrarSesionToolStripMenuItem;

        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null)) components.Dispose();
            base.Dispose(disposing);
        }

        private void InitializeComponent()
        {
            menuStrip1 = new MenuStrip();
            menuUsuarios = new ToolStripMenuItem();
            menuProductos = new ToolStripMenuItem();
            menuVentas = new ToolStripMenuItem();
            menuReportes = new ToolStripMenuItem();
            menuIdiomas = new ToolStripMenuItem();
            menuGestionPermisos = new ToolStripMenuItem();
            menuVerificarIntegridad = new ToolStripMenuItem();
            menuRecalcularIntegridad = new ToolStripMenuItem();
            menuBitacora = new ToolStripMenuItem();
            cbIdiomas = new ToolStripComboBox();
            menuUsuarioLogueado = new ToolStripMenuItem();
            cerrarSesionToolStripMenuItem = new ToolStripMenuItem();
            menuAsignarPermisos = new ToolStripMenuItem();
            menuStrip1.SuspendLayout();
            SuspendLayout();
            // 
            // menuStrip1
            // 
            menuStrip1.ImageScalingSize = new Size(20, 20);
            menuStrip1.Items.AddRange(new ToolStripItem[] { menuUsuarios, menuProductos, menuVentas, menuReportes, menuIdiomas, menuGestionPermisos, menuVerificarIntegridad, menuRecalcularIntegridad, menuBitacora, cbIdiomas, menuUsuarioLogueado });
            menuStrip1.Location = new Point(0, 0);
            menuStrip1.Name = "menuStrip1";
            menuStrip1.Padding = new Padding(8, 3, 0, 3);
            menuStrip1.Size = new Size(1199, 34);
            menuStrip1.TabIndex = 0;
            menuStrip1.Text = "menuStrip1";
            // 
            // menuUsuarios
            // 
            menuUsuarios.Name = "menuUsuarios";
            menuUsuarios.Size = new Size(79, 28);
            menuUsuarios.Tag = "menuUsuarios";
            menuUsuarios.Text = "Usuarios";
            menuUsuarios.Click += menuUsuarios_Click;
            // 
            // menuProductos
            // 
            menuProductos.Name = "menuProductos";
            menuProductos.Size = new Size(89, 28);
            menuProductos.Tag = "menuProductos";
            menuProductos.Text = "Productos";
            menuProductos.Click += menuProductos_Click;
            // 
            // menuVentas
            // 
            menuVentas.Name = "menuVentas";
            menuVentas.Size = new Size(66, 28);
            menuVentas.Tag = "menuVentas";
            menuVentas.Text = "Ventas";
            menuVentas.Click += ventasToolStripMenuItem_Click;
            // 
            // menuReportes
            // 
            menuReportes.Name = "menuReportes";
            menuReportes.Size = new Size(82, 28);
            menuReportes.Tag = "menuReportes";
            menuReportes.Text = "Reportes";
            menuReportes.Click += menuReportes_Click;
            // 
            // menuIdiomas
            // 
            menuIdiomas.Name = "menuIdiomas";
            menuIdiomas.Size = new Size(76, 28);
            menuIdiomas.Tag = "menuIdiomas";
            menuIdiomas.Text = "Idiomas";
            menuIdiomas.Click += menuIdiomas_Click;
            // 
            // menuGestionPermisos
            // 
            menuGestionPermisos.Name = "menuGestionPermisos";
            menuGestionPermisos.Size = new Size(81, 28);
            menuGestionPermisos.Tag = "menuGestionPermisos";
            menuGestionPermisos.Text = "Permisos";
            menuGestionPermisos.Click += menuGestionPermisos_Click;
            // 
            // menuVerificarIntegridad
            // 
            menuVerificarIntegridad.Name = "menuVerificarIntegridad";
            menuVerificarIntegridad.Size = new Size(150, 28);
            menuVerificarIntegridad.Tag = "menuVerificarIntegridad";
            menuVerificarIntegridad.Text = "Verificar Integridad";
            menuVerificarIntegridad.Click += menuVerificarIntegridad_Click;
            // 
            // menuRecalcularIntegridad
            // 
            menuRecalcularIntegridad.Name = "menuRecalcularIntegridad";
            menuRecalcularIntegridad.Size = new Size(164, 28);
            menuRecalcularIntegridad.Tag = "menuRecalcularIntegridad";
            menuRecalcularIntegridad.Text = "Recalcular Integridad";
            menuRecalcularIntegridad.Click += menuRecalcularIntegridad_Click;
            // 
            // menuBitacora
            // 
            menuBitacora.Name = "menuBitacora";
            menuBitacora.Size = new Size(78, 28);
            menuBitacora.Tag = "menuBitacora";
            menuBitacora.Text = "Bitácora";
            menuBitacora.Click += menuBitacora_Click;
            // 
            // cbIdiomas
            // 
            cbIdiomas.DropDownStyle = ComboBoxStyle.DropDownList;
            cbIdiomas.Name = "cbIdiomas";
            cbIdiomas.Size = new Size(168, 28);
            cbIdiomas.SelectedIndexChanged += cbIdiomas_SelectedIndexChanged;
            cbIdiomas.Click += cbIdiomas_Click;
            // 
            // menuUsuarioLogueado
            // 
            menuUsuarioLogueado.BackColor = SystemColors.Info;
            menuUsuarioLogueado.DropDownItems.AddRange(new ToolStripItem[] { cerrarSesionToolStripMenuItem });
            menuUsuarioLogueado.Name = "menuUsuarioLogueado";
            menuUsuarioLogueado.Size = new Size(87, 28);
            menuUsuarioLogueado.Text = "Usuario: ?";
            // 
            // cerrarSesionToolStripMenuItem
            // 
            cerrarSesionToolStripMenuItem.Name = "cerrarSesionToolStripMenuItem";
            cerrarSesionToolStripMenuItem.Size = new Size(177, 26);
            cerrarSesionToolStripMenuItem.Tag = "cerrarSesion";
            cerrarSesionToolStripMenuItem.Text = "Cerrar sesión";
            cerrarSesionToolStripMenuItem.Click += cerrarSesionToolStripMenuItem_Click;
            // 
            // menuAsignarPermisos
            // 
            menuAsignarPermisos.Name = "menuAsignarPermisos";
            menuAsignarPermisos.Size = new Size(135, 28);
            menuAsignarPermisos.Tag = "menuAsignarPermisos";
            menuAsignarPermisos.Text = "Asignar Permisos";
            menuAsignarPermisos.Click += menuAsignarPermisos_Click;
            // 
            // FrmPrincipal
            // 
            AutoScaleDimensions = new SizeF(9F, 23F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(1199, 796);
            Controls.Add(menuStrip1);
            Font = new Font("Segoe UI", 10F);
            IsMdiContainer = true;
            MainMenuStrip = menuStrip1;
            Margin = new Padding(3, 5, 3, 5);
            Name = "FrmPrincipal";
            Text = "Gestión de Bebidas";
            WindowState = FormWindowState.Maximized;
            Load += FrmPrincipal_Load;
            menuStrip1.ResumeLayout(false);
            menuStrip1.PerformLayout();
            ResumeLayout(false);
            PerformLayout();
        }
    }
}
