using DAL;
using System;
using System.Collections.Generic;

namespace BLL
{
    public class UsuarioPermisoBLL
    {
        private readonly UsuarioPermisoDAL _dal = new UsuarioPermisoDAL();
        public void AsignarGrupos(int idUsuario, List<int> idGrupos)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                _dal.AsignarGruposAUsuario(idUsuario, idGrupos, acceso);
                acceso.ConfirmarTransaccion();
                BitacoraHelper.Registrar("Permisos", "Asignar", $"Se asignaron grupos de permisos al usuario Id={idUsuario}");
            }
            catch (Exception ex)
            {
                acceso.CancelarTransaccion();
                BitacoraHelper.Registrar("Permisos", "Error", $"Asignación fallida para UsuarioId={idUsuario}: {ex.Message}");
                throw;
            }
            finally
            {
                acceso.Cerrar();
            }
        }

        public List<int> ObtenerGrupos(int idUsuario)
        {
            return _dal.ObtenerGruposDeUsuario(idUsuario);
        }
    }
}
