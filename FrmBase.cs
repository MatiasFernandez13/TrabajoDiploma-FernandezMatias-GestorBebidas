using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SERVICIOS;
using System.Drawing;
using System.Windows.Forms;

namespace UI
{
    public class FrmBase : Form, IObservadorIdioma
    {
        protected FrmBase()
        {
            IdiomaService.Suscribir(this);
            this.Load += FrmBase_Load;
        }

        private void FrmBase_Load(object sender, EventArgs e)
        {
            AplicarEstilo(this);

            var idioma = IdiomaService.IdiomaActual;
            if (!string.IsNullOrEmpty(idioma))
            {
                var traducciones = IdiomaService.ObtenerTraduccionesActuales();
                ActualizarIdioma(traducciones);
            }
        }

        protected override void OnFormClosed(FormClosedEventArgs e)
        {
            IdiomaService.Desuscribir(this);
            base.OnFormClosed(e);
        }

        public virtual void ActualizarIdioma(Dictionary<string, string> traducciones)
        {
            TraducirControles(this.Controls, traducciones);
        }

        private void TraducirControles(Control.ControlCollection controls, Dictionary<string, string> traducciones)
        {
            foreach (Control control in controls)
            {
                if (control.Tag is string tag && traducciones.ContainsKey(tag))
                    control.Text = traducciones[tag];

                if (control is MenuStrip ms)
                {
                    TraducirMenuItems(ms.Items, traducciones);
                }

                if (control.HasChildren)
                    TraducirControles(control.Controls, traducciones);
            }
        }

        private void TraducirMenuItems(ToolStripItemCollection items, Dictionary<string, string> traducciones)
        {
            foreach (ToolStripItem item in items)
            {
                if (item.Tag is string tag && traducciones.ContainsKey(tag))
                    item.Text = traducciones[tag];

                if (item is ToolStripMenuItem mi && mi.HasDropDownItems)
                    TraducirMenuItems(mi.DropDownItems, traducciones);
            }
        }

        protected virtual void AplicarEstilo(Control control)
        {
            this.BackColor = ColorTranslator.FromHtml("#F4F4F4");
            this.Font = new Font("Segoe UI", 10F);

            foreach (Control c in control.Controls)
            {
                if (c is Button btn)
                {
                    btn.BackColor = ColorTranslator.FromHtml("#3A6351");
                    btn.ForeColor = Color.White;
                    btn.FlatStyle = FlatStyle.Flat;
                    btn.Font = new Font("Segoe UI", 10F, FontStyle.Bold);
                    btn.Height = 35;
                    btn.Cursor = Cursors.Hand;

                    btn.MouseEnter += (s, e) => btn.BackColor = ColorTranslator.FromHtml("#2D4D3A");
                    btn.MouseLeave += (s, e) => btn.BackColor = ColorTranslator.FromHtml("#3A6351");
                }

                if (c is Label lbl)
                {
                    lbl.Font = new Font("Segoe UI", 10F);
                    lbl.ForeColor = ColorTranslator.FromHtml("#333333");
                }

                if (c is DataGridView dgv)
                {
                    dgv.BackgroundColor = Color.White;
                    dgv.GridColor = ColorTranslator.FromHtml("#CCCCCC");
                    dgv.DefaultCellStyle.Font = new Font("Segoe UI", 10F);
                    dgv.DefaultCellStyle.ForeColor = Color.Black;
                    dgv.DefaultCellStyle.BackColor = Color.White;
                    dgv.ColumnHeadersDefaultCellStyle.BackColor = ColorTranslator.FromHtml("#3A6351");
                    dgv.ColumnHeadersDefaultCellStyle.ForeColor = Color.White;
                    dgv.EnableHeadersVisualStyles = false;
                }

                if (c.HasChildren)
                    AplicarEstilo(c);
            }
        }
    }
}
