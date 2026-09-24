using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BE
{
    public class Cliente
    {
        private int _id;
        private string _nombreCompleto;
        private string _direccion;
        private string _telefono;
        private string _email;
        private string _zona;
        private bool _activo = true;
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

        public string NombreCompleto
        {
            get => _nombreCompleto;
            set
            {
                if (string.IsNullOrWhiteSpace(value))
                    throw new ArgumentException("El nombre completo es obligatorio.");
                _nombreCompleto = value;
            }
        }

        public string Direccion { get => _direccion; set => _direccion = value ?? string.Empty; }
        public string Telefono { get => _telefono; set => _telefono = value ?? string.Empty; }
        public string Email { get => _email; set => _email = value ?? string.Empty; }
        public string Zona { get => _zona; set => _zona = value ?? string.Empty; }
        public bool Activo { get => _activo; set => _activo = value; }
        public decimal DVH { get => _dvh; set => _dvh = value; }

        public override string ToString()
        {
            return string.IsNullOrWhiteSpace(Zona) ? NombreCompleto : $"{NombreCompleto} ({Zona})";
        }
    }
}
