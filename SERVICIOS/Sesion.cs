using BE;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DAL;
using INTERFACES;

namespace SERVICIOS
{
    public class Sesion : SesionBase
    {
        private static Sesion _instancia;
        private Sesion()
        {
        }

        public static Sesion Instancia
        {
            get
            {
                if (_instancia == null)
                    _instancia = new Sesion();
                return _instancia;
            }
        }

        public override void IniciarSesion(Usuario usuario)
        {
            base.IniciarSesion(usuario);
            try
            {
                BitacoraDAL dal = new BitacoraDAL();
                dal.Insertar(new BE.Bitacora { FechaRegistro = DateTime.Now, UsuarioId = usuario.Id, Entidad = "Sesion", Accion = "LOGIN", Detalle = $"Ingreso al sistema con usuario {usuario.NombreUsuario}" });
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error al registrar en bitácora: {ex.Message}");
            }
        }

        public override void CerrarSesion()
        {
            if (UsuarioLogueado == null)
                return;
            try
            {
                BitacoraDAL dal = new BitacoraDAL();
                dal.Insertar(new BE.Bitacora { FechaRegistro = DateTime.Now, UsuarioId = UsuarioLogueado.Id, Entidad = "Sesion", Accion = "LOGOUT", Detalle = $"Salida del sistema del usuario {UsuarioLogueado.NombreUsuario}" });
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error al registrar en bitácora: {ex.Message}");
            }

            base.CerrarSesion();
        }
    }
}
