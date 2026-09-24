using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BE;
using DAL;

namespace BLL
{
    public class InventarioBLL
    {
        private readonly InventarioDAL _inventarioDAL = new InventarioDAL();
        public List<Inventario> ObtenerStockPorProducto()
        {
            try
            {
                return _inventarioDAL.ObtenerStockPorProducto();
            }
            catch (Exception ex)
            {
                throw new ApplicationException("Error al obtener el inventario de productos.", ex);
            }
        }
    }
}
