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
        private Rol _rol;
        private string _idioma = "es";



        public int Id
        {
            get => _id;
            set
            {
                if (value <= 0)
                    throw new ArgumentException("El ID debe ser mayor a cero.");
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

        public Rol Rol
        {
            get => _rol;
            set
            {
                if (value == null)
                    throw new ArgumentNullException("El rol es obligatorio.");
                _rol = value;
            }
        }

        public string ObtenerRol()
        {
            return Rol?.Nombre ?? "Sin rol";
        }
        public string Idioma
        {
            get => _idioma;
            set => _idioma = string.IsNullOrWhiteSpace(value) ? "es" : value;
        }
    }
}
