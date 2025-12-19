namespace UI
{
    partial class FrmLogin
    {
        private System.ComponentModel.IContainer components = null;
        private System.Windows.Forms.Label lblUsuario;
        private System.Windows.Forms.Label lblPassword;
        private System.Windows.Forms.TextBox txtUsuario;
        private System.Windows.Forms.TextBox txtPassword;
        private System.Windows.Forms.Button btnLogin;
        private System.Windows.Forms.ComboBox cbIdiomas;
        private System.Windows.Forms.Label lblIdioma;

        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null)) components.Dispose();
            base.Dispose(disposing);
        }

        private void InitializeComponent()
        {
            this.lblUsuario = new System.Windows.Forms.Label();
            this.lblPassword = new System.Windows.Forms.Label();
            this.txtUsuario = new System.Windows.Forms.TextBox();
            this.txtPassword = new System.Windows.Forms.TextBox();
            this.btnLogin = new System.Windows.Forms.Button();
            this.cbIdiomas = new System.Windows.Forms.ComboBox();
            this.lblIdioma = new System.Windows.Forms.Label();
            this.SuspendLayout();

            // lblIdioma
            this.lblIdioma.AutoSize = true;
            this.lblIdioma.Location = new System.Drawing.Point(40, 20);
            this.lblIdioma.Name = "lblIdioma";
            this.lblIdioma.Size = new System.Drawing.Size(45, 13);
            this.lblIdioma.Text = "Idioma:";
            this.lblIdioma.Tag = "lblIdioma";

            // cbIdiomas
            this.cbIdiomas.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbIdiomas.FormattingEnabled = true;
            // Nota: NO agregamos Items.AddRange, ya que lo llenamos en FrmLogin_Load
            this.cbIdiomas.Location = new System.Drawing.Point(130, 17);
            this.cbIdiomas.Name = "cbIdiomas";
            this.cbIdiomas.Size = new System.Drawing.Size(150, 21);
            this.cbIdiomas.SelectedIndexChanged += new System.EventHandler(this.cbIdiomas_SelectedIndexChanged);

            this.cbIdiomas.Location = new System.Drawing.Point(130, 17);
            this.cbIdiomas.Name = "cbIdiomas";
            this.cbIdiomas.Size = new System.Drawing.Size(150, 21);
            this.cbIdiomas.SelectedIndexChanged += new System.EventHandler(this.cbIdiomas_SelectedIndexChanged);

            // lblUsuario
            this.lblUsuario.AutoSize = true;
            this.lblUsuario.Location = new System.Drawing.Point(40, 55);
            this.lblUsuario.Name = "lblUsuario";
            this.lblUsuario.Size = new System.Drawing.Size(55, 13);
            this.lblUsuario.Text = "Usuario:";
            this.lblUsuario.Tag = "lblUsuario";

            // txtUsuario
            this.txtUsuario.Location = new System.Drawing.Point(130, 52);
            this.txtUsuario.Name = "txtUsuario";
            this.txtUsuario.Size = new System.Drawing.Size(150, 20);

            // lblPassword
            this.lblPassword.AutoSize = true;
            this.lblPassword.Location = new System.Drawing.Point(40, 90);
            this.lblPassword.Name = "lblPassword";
            this.lblPassword.Size = new System.Drawing.Size(64, 13);
            this.lblPassword.Text = "Contraseña:";
            this.lblPassword.Tag = "lblPassword";

            // txtPassword
            this.txtPassword.Location = new System.Drawing.Point(130, 87);
            this.txtPassword.Name = "txtPassword";
            this.txtPassword.Size = new System.Drawing.Size(150, 20);
            this.txtPassword.UseSystemPasswordChar = true;

            // btnLogin
            this.btnLogin.Location = new System.Drawing.Point(130, 120);
            this.btnLogin.Name = "btnLogin";
            this.btnLogin.Size = new System.Drawing.Size(100, 30);
            this.btnLogin.Text = "Iniciar Sesión";
            this.btnLogin.Tag = "btnLogin";
            this.btnLogin.UseVisualStyleBackColor = true;
            this.btnLogin.Click += new System.EventHandler(this.btnLogin_Click);

            // FrmLogin
            this.AcceptButton = this.btnLogin;
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(340, 180);
            this.Controls.Add(this.lblIdioma);
            this.Controls.Add(this.cbIdiomas);
            this.Controls.Add(this.lblUsuario);
            this.Controls.Add(this.txtUsuario);
            this.Controls.Add(this.lblPassword);
            this.Controls.Add(this.txtPassword);
            this.Controls.Add(this.btnLogin);
            this.Name = "FrmLogin";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Login - Gestión de Bebidas";
            this.Load += new System.EventHandler(this.FrmLogin_Load);
            this.Tag = "FrmLogin";
            this.ResumeLayout(false);
            this.PerformLayout();
        }
    }
}