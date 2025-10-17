using BE;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DAL;

namespace SERVICIOS
{
    public class Sesion
    {
        private static Sesion _instancia;
        public Usuario UsuarioLogueado { get; private set; }

        
        private Sesion() { }

       
        public static Sesion Instancia
        {
            get
            {
                if (_instancia == null)
                    _instancia = new Sesion();
                return _instancia;
            }
        }

        
        public void IniciarSesion(Usuario usuario)
        {
            UsuarioLogueado = usuario;

            try
            {
                var dal = new BitacoraDAL();
                dal.Insertar(new BE.Bitacora
                {
                    FechaRegistro = DateTime.Now,
                    UsuarioId = usuario.Id, 
                    Entidad = "Sesion",
                    Accion = "LOGIN",
                    Detalle = $"Ingreso al sistema con usuario {usuario.NombreUsuario}"
                });
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error al registrar en bitácora: {ex.Message}");
            }
        }

        public void CerrarSesion()
        {
            if (UsuarioLogueado == null) return;

            try
            {
                var dal = new BitacoraDAL();
                dal.Insertar(new BE.Bitacora
                {
                    FechaRegistro = DateTime.Now,
                    UsuarioId = UsuarioLogueado.Id,  
                    Entidad = "Sesion",
                    Accion = "LOGOUT",
                    Detalle = $"Salida del sistema del usuario {UsuarioLogueado.NombreUsuario}"
                });
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error al registrar en bitácora: {ex.Message}");
            }
            UsuarioLogueado = null;
        }
    }
}

