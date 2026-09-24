using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BE
{
    public class Producto
    {
        private int _id;
        private string _nombre;
        private int _categoria;
        private decimal _precio;
        private double _litrosPorUnidad;
        private int _stock;
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

        public string Nombre
        {
            get => _nombre;
            set
            {
                if (string.IsNullOrWhiteSpace(value))
                    throw new ArgumentException("El nombre del producto es obligatorio.");
                _nombre = value;
            }
        }

        public int Categoria { get => _categoria; set => _categoria = value; }
        public string CategoriaNombre { get; set; }

        public decimal Precio
        {
            get => _precio;
            set
            {
                if (value < 0)
                    throw new ArgumentException("El precio no puede ser negativo.");
                _precio = value;
            }
        }

        public double LitrosPorUnidad
        {
            get => _litrosPorUnidad;
            set
            {
                if (value <= 0)
                    throw new ArgumentException("Los litros por unidad deben ser mayor a cero.");
                _litrosPorUnidad = value;
            }
        }

        public int Stock
        {
            get => _stock;
            set
            {
                if (value < 0)
                    throw new ArgumentException("El stock no puede ser negativo.");
                _stock = value;
            }
        }

        public bool Activo { get => _activo; set => _activo = value; }
        public decimal DVH { get => _dvh; set => _dvh = value; }

        public override string ToString()
        {
            return $"{Nombre} - {LitrosPorUnidad}L - ${Precio}";
        }
    }
}
