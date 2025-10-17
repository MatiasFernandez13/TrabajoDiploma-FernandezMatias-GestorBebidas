using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BE.Permisos;

namespace BE
{
    public class Rol
    {
        public int Id { get; set; }
        public string Nombre { get; set; }

        public List<IPermiso> Permisos { get; set; } = new List<IPermiso>();

        public override string ToString()
        {
            return Nombre;
        }

        public bool TienePermiso(string nombrePermiso)
        {
            foreach (var permiso in Permisos)
            {
                if (permiso.TienePermiso(nombrePermiso))
                    return true;
            }
            return false;
        }
    }
}
