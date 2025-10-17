using DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BE;

namespace BLL
{
    public class IdiomaBLL
    {
        private readonly IdiomaDAL _idiomaDAL = new IdiomaDAL();
        private static IdiomaBLL _idiomaBLL = new IdiomaBLL();


        public List<IdiomaDTO> ObtenerIdiomas()
        {
            return _idiomaDAL.ObtenerIdiomas();
        }

        public Dictionary<string, string> ObtenerTraducciones(string codigoIdioma)
        {
            return _idiomaDAL.ObtenerTraducciones(codigoIdioma);
        }
    }
}
