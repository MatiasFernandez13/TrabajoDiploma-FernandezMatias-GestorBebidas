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
            _dal.Insertar(entrada);
        }

        public List<Bitacora> Buscar(DateTime? desde, DateTime? hasta, string usuario, string accion)
        {
            return _dal.Buscar(desde, hasta, usuario, accion);
        }
    }
}
