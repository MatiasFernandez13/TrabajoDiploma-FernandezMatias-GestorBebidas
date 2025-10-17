using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BE.Permisos
{
    public interface IPermiso
    {
        string Nombre { get; set; }
        List<IPermiso> Hijos { get; }
        void Agregar(IPermiso permiso);
        void Eliminar(IPermiso permiso);
        bool TienePermiso(string nombrePermiso);
    }
}