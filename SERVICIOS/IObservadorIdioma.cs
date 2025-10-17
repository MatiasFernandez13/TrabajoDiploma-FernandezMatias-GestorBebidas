using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SERVICIOS
{
    public interface IObservadorIdioma
    {
        void ActualizarIdioma(Dictionary<string, string> traducciones);

    }

}
