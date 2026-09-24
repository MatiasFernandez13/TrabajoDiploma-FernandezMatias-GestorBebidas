using BE;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using INTERFACES;
using BE.Permisos;

namespace SERVICIOS
{
    public abstract class SesionBase : ISesion
    {
        public Usuario UsuarioLogueado { get; protected set; }
        public List<IPermiso> PermisosCompuestos { get; set; } = new List<IPermiso>();
        public HashSet<string> Permisos { get; set; } = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

        public virtual void IniciarSesion(Usuario usuario)
        {
            UsuarioLogueado = usuario;
        }

        public virtual void CerrarSesion()
        {
            UsuarioLogueado = null;
            PermisosCompuestos.Clear();
            Permisos.Clear();
        }
    }
}
