using BE.Permisos;
using DAL;
using System.Collections.Generic;
using static BLL.BitacoraBLL;

namespace BLL
{
    public class PermisoBLL
    {
        private readonly PermisoDAL _permisoDal;

        public PermisoBLL()
        {
            _permisoDal = new PermisoDAL();
        }

        public void SeedPermisosSimples()
        {
            var lista = new List<PermisoSimple>
            {
                new PermisoSimple { Nombre = "Agregar Usuario" },
                new PermisoSimple { Nombre = "Modificar Usuario" },
                new PermisoSimple { Nombre = "Eliminar Usuario" },
                new PermisoSimple { Nombre = "Ver Reportes" },
                new PermisoSimple { Nombre = "Gestionar Productos" },
                new PermisoSimple { Nombre = "Realizar Venta" }
            };

            foreach (var permiso in lista)
            {
                _permisoDal.CrearPermisoSimple(permiso);
            }
        }

        public void AsignarPermisosARol(int idRol, List<IPermiso> permisos)
        {
            _permisoDal.AsignarPermisosARol(idRol, permisos);
            BitacoraHelper.Registrar(
                "Permisos",
                "Asignar",
                $"Se asignaron permisos al rol Id={idRol}"
            );
        }

        //obtengo los grupos del sql y guardo
        public List<IPermiso> ObtenerGruposDePermisos()
        {
            return _permisoDal.ObtenerGruposDePermisos();
        }

        public int CrearGrupoPermiso(GrupoPermiso grupo)
        {
            return _permisoDal.CrearGrupoPermiso(grupo);
        }
    }
}