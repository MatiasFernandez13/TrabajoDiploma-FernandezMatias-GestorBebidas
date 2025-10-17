using System;
using System.Collections.Generic;
using System.Globalization;
using System.Threading;


namespace SERVICIOS
{
    public static class IdiomaService
    {
        private static List<IObservadorIdioma> _observadores = new List<IObservadorIdioma>();
        private static string _idiomaActual = "es";
    


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

        public static void CambiarIdioma(string idioma, Dictionary<string, string> traducciones)
        {
            _idiomaActual = idioma;

            Thread.CurrentThread.CurrentUICulture = new CultureInfo(idioma);
            Thread.CurrentThread.CurrentCulture = new CultureInfo(idioma);

            Notificar(traducciones);
        }
   

        public static string ObtenerIdiomaActual()
        {
            return _idiomaActual;
        }
        
        public static void Notificar(Dictionary<string, string> traducciones)
        {
            foreach (var obs in _observadores)
                obs.ActualizarIdioma(traducciones);
            
            foreach (var kv in traducciones)
            {
                Console.WriteLine($"{kv.Key} => {kv.Value}");
            }
        }

    }
}