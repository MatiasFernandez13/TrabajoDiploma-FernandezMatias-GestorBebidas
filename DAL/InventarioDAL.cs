using BE;
using System;
using System.Collections.Generic;
using System.Data;

namespace DAL
{
    public class InventarioDAL
    {
        public List<Inventario> ObtenerStockPorProducto()
        {
            List<Inventario> lista = new List<Inventario>();
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            try
            {
                DataTable tabla = acceso.Leer("sp_Inventario_ObtenerStockPorProducto");
                foreach (DataRow fila in tabla.Rows)
                {
                    lista.Add(new Inventario { NombreProducto = fila["NombreProducto"].ToString(), CategoriaId = Convert.ToInt32(fila["CategoriaId"]), CategoriaNombre = fila["CategoriaNombre"].ToString(), StockTotal = fila["StockTotal"] != DBNull.Value ? Convert.ToInt32(fila["StockTotal"]) : 0 });
                }
            }
            finally
            {
                acceso.Cerrar();
            }

            return lista;
        }
    }
}
