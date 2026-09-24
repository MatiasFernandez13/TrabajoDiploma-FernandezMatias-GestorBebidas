using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BE
{
    public class Usuario
    {
        private int _id;
        private string _nombreUsuario;
        private string _contraseñaHasheada;
        private string _idioma = "es";
        private string _salt;
        private bool _activo;
        private decimal _dvh;
        public int Id
        {
            get => _id;
            set
            {
                if (value < 0)
                    throw new ArgumentException("El ID no puede ser negativo.");
                _id = value;
            }
        }

        public string NombreUsuario
        {
            get => _nombreUsuario;
            set
            {
                if (string.IsNullOrWhiteSpace(value))
                    throw new ArgumentException("El nombre de usuario es obligatorio.");
                _nombreUsuario = value;
            }
        }

        public string ContraseñaHasheada
        {
            get => _contraseñaHasheada;
            set
            {
                if (string.IsNullOrWhiteSpace(value))
                    throw new ArgumentException("La contraseña no puede estar vacía.");
                _contraseñaHasheada = value;
            }
        }

        public string Permisos { get; set; }
        public string Idioma { get => _idioma; set => _idioma = string.IsNullOrWhiteSpace(value) ? "es" : value; }

        public string Salt
        {
            get => _salt;
            set
            {
                if (string.IsNullOrWhiteSpace(value))
                    throw new ArgumentException("El salt no puede estar vacío.");
                _salt = value;
            }
        }

        public bool Activo { get => _activo; set => _activo = value; }
        public decimal DVH { get => _dvh; set => _dvh = value; }
    }
}
