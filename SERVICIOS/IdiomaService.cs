using System;
using System.Collections.Generic;
using System.Globalization;
using System.Threading;

namespace SERVICIOS
{
    public static class IdiomaService
    {
        private static readonly List<IObservadorIdioma> _observadores = new List<IObservadorIdioma>();
        public static string IdiomaActual { get; private set; } = "es";

        private static Dictionary<string, string> _traduccionesActuales = new Dictionary<string, string>();
        public static void CambiarIdioma(string idioma, Dictionary<string, string> traducciones)
        {
            IdiomaActual = idioma;
            _traduccionesActuales = traducciones ?? new Dictionary<string, string>();
            Thread.CurrentThread.CurrentUICulture = new CultureInfo(idioma);
            Thread.CurrentThread.CurrentCulture = new CultureInfo(idioma);
            foreach (IObservadorIdioma observador in _observadores)
                observador.ActualizarIdioma(_traduccionesActuales);
        }

        public static string ObtenerIdiomaActual()
        {
            return IdiomaActual;
        }

        public static Dictionary<string, string> ObtenerTraduccionesActuales()
        {
            return _traduccionesActuales ?? new Dictionary<string, string>();
        }

        public static void Suscribir(IObservadorIdioma observador)
        {
            if (!_observadores.Contains(observador))
                _observadores.Add(observador);
        }

        public static void Desuscribir(IObservadorIdioma observador)
        {
            if (_observadores.Contains(observador))
                _observadores.Remove(observador);
        }
    }
}
