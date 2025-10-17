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
        private double _capacidadLitros;
        private int _stock;

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

        public int Categoria
        {
            get => _categoria;
            set { _categoria = value; }
         
        }

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

        public double Capacidad
        {
            get => _capacidadLitros;
            set
            {
                if (value <= 0)
                    throw new ArgumentException("La capacidad debe ser mayor a cero.");
                _capacidadLitros = value;
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

        public override string ToString()
        {
            return $"{Nombre} - {Capacidad}L - ${Precio}";
        }
    }

}
