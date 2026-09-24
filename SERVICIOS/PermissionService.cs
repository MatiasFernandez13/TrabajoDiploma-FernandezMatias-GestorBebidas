using System;
using System.Collections.Generic;
using System.Linq;
using DAL;
using BE.Permisos;

namespace SERVICIOS
{
    public static class PermissionService
    {
        private static HashSet<string> _permisos = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        private static readonly UsuarioPermisoDAL _usuarioPermisoDal = new UsuarioPermisoDAL();
        private static readonly PermisoDAL _permisoDal = new PermisoDAL();
        public static void RefreshForCurrentUser()
        {
            _permisos.Clear();
            BE.Usuario usuario = Sesion.Instancia.UsuarioLogueado;
            if (usuario == null)
                return;
            List<int> ids = _usuarioPermisoDal.ObtenerGruposDeUsuario(usuario.Id);
            Dictionary<int, GrupoPermiso> gruposAll = _permisoDal.ObtenerGruposDePermisos().OfType<GrupoPermiso>().ToDictionary(g => g.Id);
            List<IPermiso> compuestos = new List<IPermiso>();
            bool esAdmin = false;
            foreach (int id in ids)
            {
                if (gruposAll.TryGetValue(id, out GrupoPermiso g))
                {
                    if (g.Nombre.Equals("Administrador", StringComparison.OrdinalIgnoreCase))
                    {
                        esAdmin = true;
                    }

                    compuestos.Add(g);
                    _permisos.Add(g.Nombre);
                    foreach (PermisoSimple s in CollectSimplesSafe(g))
                        _permisos.Add(s.Nombre);
                }
            }

            if (esAdmin)
            {
                foreach (GrupoPermiso g in gruposAll.Values)
                {
                    compuestos.Add(g);
                    _permisos.Add(g.Nombre);
                    foreach (PermisoSimple h in CollectSimplesSafe(g))
                        _permisos.Add(h.Nombre);
                }
            }

            Sesion.Instancia.PermisosCompuestos = compuestos;
            Sesion.Instancia.Permisos = new HashSet<string>(_permisos, StringComparer.OrdinalIgnoreCase);
        }

        private static IEnumerable<PermisoSimple> CollectSimplesSafe(GrupoPermiso grupo)
        {
            return CollectSimplesInternal(grupo, new HashSet<string>(StringComparer.OrdinalIgnoreCase));
        }

        private static IEnumerable<PermisoSimple> CollectSimplesInternal(GrupoPermiso grupo, HashSet<string> visited)
        {
            if (!visited.Add(grupo.Nombre))
                yield break;
            foreach (IPermiso h in grupo.Hijos)
            {
                if (h is PermisoSimple s)
                    yield return s;
                else if (h is GrupoPermiso g)
                {
                    foreach (PermisoSimple sp in CollectSimplesInternal(g, visited))
                        yield return sp;
                }
            }
        }

        public static bool Has(string permisoNombre)
        {
            return _permisos.Contains(permisoNombre);
        }

        public static IEnumerable<string> All() => _permisos.ToArray();
        public static IEnumerable<IPermiso> Tree() => Sesion.Instancia.PermisosCompuestos?.ToArray() ?? Array.Empty<IPermiso>();
    }
}
