using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BE
{
    public class Bitacora
    {
        public int Id { get; set; }
        public int UsuarioId { get; set; }
        public string UsuarioNombre { get; set; }
        public DateTime FechaRegistro { get; set; }
        public string Entidad { get; set; }
        public string Accion { get; set; }
        public string Detalle { get; set; }
    }
}
