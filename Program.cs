using BLL;
using System.Configuration;
using System;
using System.Data.SqlClient;
using System.Windows.Forms;
using BLL;

namespace UI
{
    static class Program
    {

        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            ApplicationConfiguration.Initialize();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.SetUnhandledExceptionMode(UnhandledExceptionMode.CatchException);
            Application.ThreadException += (s, e) =>
            {
                try { BitacoraHelper.Registrar("Sistema", "Error", e.Exception.Message); } catch { }
                MessageBox.Show("Ocurrió un error no controlado: " + e.Exception.Message);
            };
            AppDomain.CurrentDomain.UnhandledException += (s, e) =>
            {
                var ex = e.ExceptionObject as Exception;
                var msg = ex != null ? ex.Message : "Error desconocido";
                try { BitacoraHelper.Registrar("Sistema", "Error", msg); } catch { }
                MessageBox.Show("Ocurrió un error no controlado: " + msg);
            };
            string connStr = ConfigurationManager.ConnectionStrings["MiConexion"].ConnectionString;
            var usuarioBLL = new UsuarioBLL(connStr);
            usuarioBLL.SeedAdmin();
            Application.Run(new FrmLogin());
        }
    }
}
