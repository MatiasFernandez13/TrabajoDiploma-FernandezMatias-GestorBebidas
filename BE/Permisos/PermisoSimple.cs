using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BE.Permisos
{
    public class PermisoSimple : IPermiso
    {
        public string Nombre { get; set; }

        public List<IPermiso> Hijos => new List<IPermiso>();

        public void Agregar(IPermiso permiso) { }
        public void Eliminar(IPermiso permiso) { }

        public bool TienePermiso(string nombrePermiso)
        {
            return Nombre.Equals(nombrePermiso);
        }
    }
}
