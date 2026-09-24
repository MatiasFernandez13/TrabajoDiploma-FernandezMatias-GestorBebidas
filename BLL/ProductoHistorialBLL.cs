using System;
using System.Collections.Generic;
using DAL;
using BE;

namespace BLL
{
    public class ProductoHistorialBLL
    {
        private readonly ProductoHistorialDAL _dal = new ProductoHistorialDAL();
        public void RegistrarSnapshot(Producto p, string accion)
        {
            _dal.InsertarSnapshot(p, accion);
        }

        public List<(int IdHistorial, DateTime Fecha, Producto Snapshot)> ListarPorProducto(int idProducto)
        {
            return _dal.ListarPorProducto(idProducto);
        }
    }
}
