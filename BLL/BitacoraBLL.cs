using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BE;
using DAL;
using SERVICIOS;

namespace BLL
{
    public class BitacoraBLL
    {
        private readonly BitacoraDAL _dal = new BitacoraDAL();
        public void Registrar(Bitacora entrada)
        {
            try
            {
                _dal.Insertar(entrada);
            }
            catch (Exception ex)
            {
                throw new Exception("Error en BitacoraBLL.Registrar", ex);
            }
        }

        public List<Bitacora> Buscar(DateTime? desde, DateTime? hasta, string usuario, string accion)
        {
            try
            {
                return _dal.Buscar(desde, hasta, usuario, accion);
            }
            catch (Exception ex)
            {
                throw new Exception("Error en BitacoraBLL.Buscar", ex);
            }
        }
    }
}
