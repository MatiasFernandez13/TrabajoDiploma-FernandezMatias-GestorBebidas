using DAL;
using System.Collections.Generic;
using static BLL.BitacoraBLL;

namespace BLL
{
    public class UsuarioPermisoBLL
    {
        private readonly UsuarioPermisoDAL _dal = new UsuarioPermisoDAL();

        public void AsignarGrupos(int idUsuario, List<int> idGrupos)
        {
            _dal.AsignarGruposAUsuario(idUsuario, idGrupos);
            BitacoraHelper.Registrar("Permisos","Asignar", $"Se asignaron grupos de permisos al usuario Id={idUsuario}");
        }

        public List<int> ObtenerGrupos(int idUsuario)
        {
            return _dal.ObtenerGruposDeUsuario(idUsuario);
        }
    }
}