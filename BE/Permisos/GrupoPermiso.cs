using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BE.Permisos
{
    public class GrupoPermiso : IPermiso
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public List<IPermiso> Hijos { get; private set; } = new List<IPermiso>();

        public void Agregar(IPermiso permiso)
        {
            Hijos.Add(permiso);
        }

        public void Eliminar(IPermiso permiso)
        {
            Hijos.Remove(permiso);
        }

        public override string ToString()
        {
            return Nombre;
        }

        public bool TienePermiso(string nombrePermiso)
        {
            return Hijos.Any(p => p.TienePermiso(nombrePermiso));
        }
    }
}
