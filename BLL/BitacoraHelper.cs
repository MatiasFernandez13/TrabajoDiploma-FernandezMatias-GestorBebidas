using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BE;
using SERVICIOS;
using System;

namespace BLL
{
    public static class BitacoraHelper
    {
        private static readonly BitacoraBLL _bll = new BitacoraBLL();
        public static void Registrar(string entidad, string accion, string detalle)
        {
            Usuario usuario = Sesion.Instancia.UsuarioLogueado;
            Bitacora entrada = new Bitacora
            {
                UsuarioId = usuario != null ? usuario.Id : 0,
                FechaRegistro = DateTime.Now,
                Entidad = entidad,
                Accion = accion,
                Detalle = detalle
            };
            try
            {
                _bll.Registrar(entrada);
            }
            catch
            {
            }
        }
    }
}
