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
            Dictionary<string, string> tr = _idiomaDAL.ObtenerTraducciones(codigoIdioma);
            try
            {
                Dictionary<string, string> es = _idiomaDAL.ObtenerTraducciones("es");
                foreach (KeyValuePair<string, string> kv in es)
                {
                    if (!tr.ContainsKey(kv.Key) || string.IsNullOrWhiteSpace(tr[kv.Key]))
                        tr[kv.Key] = kv.Value;
                }
            }
            catch
            {
            }

            return tr;
        }
    }
}
