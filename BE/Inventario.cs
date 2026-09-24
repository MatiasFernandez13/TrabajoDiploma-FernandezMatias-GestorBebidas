using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BE
{
    public class Inventario
    {
        public string NombreProducto { get; set; }
        public int CategoriaId { get; set; }
        public string CategoriaNombre { get; set; }
        public int StockTotal { get; set; }
    }
}
