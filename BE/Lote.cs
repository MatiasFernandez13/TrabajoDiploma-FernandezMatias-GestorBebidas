using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BE
{
    public class Lote
    {
        public int Id { get; set; }
        public string NumeroLote { get; set; }
        public DateTime FechaIngreso { get; set; }
        public DateTime FechaVencimiento { get; set; }
        public int Cantidad { get; set; }
        public int ProductoId { get; set; }
        public bool Activo { get; set; }
    }
}
