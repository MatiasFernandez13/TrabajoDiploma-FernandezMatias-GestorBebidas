using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BE.Permisos;
using BE;

namespace INTERFACES
{
    public interface ISesion
    {
        Usuario UsuarioLogueado { get; }

        void IniciarSesion(Usuario usuario);
        void CerrarSesion();
    }
}
