using BE;
using DAL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static BLL.BitacoraBLL;

namespace BLL
{
    public class ProductoBLL
    {
        private readonly ProductoDAL _productoDal;

        public ProductoBLL()
        {
            _productoDal = new ProductoDAL();
        }

        public List<Producto> Listar()
        {
            return _productoDal.Listar();
        }

        public Producto ObtenerPorId(int id)
        {
            return _productoDal.ObtenerPorId(id);
        }

        public void Agregar(Producto producto)
        {

            _productoDal.Agregar(producto);
            BitacoraHelper.Registrar("Producto", "Alta", $"Se agregó el producto {producto.Nombre}");
        }

        public void Modificar(Producto producto)
        {
            _productoDal.Modificar(producto);
            BitacoraHelper.Registrar("Producto", "Modificación", $"Se modificó el producto {producto.Nombre}");
        }

        public void Eliminar(int id)
        {
            _productoDal.Eliminar(id);
            BitacoraHelper.Registrar("Producto", "Baja", $"Se eliminó el producto con Id={id}");
        }
    }
}
