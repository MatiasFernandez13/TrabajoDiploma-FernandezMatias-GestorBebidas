using BE;
using DAL;
using SERVICIOS;
using System;
using System.Collections.Generic;

namespace BLL
{
    public class LoteBLL
    {
        private static readonly Dictionary<int, int> _loteSeleccionadoPorProducto = new Dictionary<int, int>();
        public static void EstablecerLotePreseleccionado(int productoId, int loteId)
        {
            _loteSeleccionadoPorProducto[productoId] = loteId;
        }

        public static int? ObtenerLotePreseleccionado(int productoId)
        {
            if (_loteSeleccionadoPorProducto.TryGetValue(productoId, out int loteId))
                return loteId;
            return null;
        }

        public static void LimpiarLotePreseleccionado(int productoId)
        {
            if (_loteSeleccionadoPorProducto.ContainsKey(productoId))
                _loteSeleccionadoPorProducto.Remove(productoId);
        }

        private readonly LoteDAL _loteDAL = new LoteDAL();
        public ResultadoIngresoLote Agregar(Lote lote)
        {
            ValidarIngreso(lote);
            if (lote.ProductoId <= 0) throw new ArgumentException("Seleccione un producto válido.");
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                ResultadoIngresoLote resultado = _loteDAL.Agregar(lote, acceso);
                SincronizarProducto(new Producto { Id = lote.ProductoId }, acceso);
                acceso.ConfirmarTransaccion();
                return resultado;
            }
            catch
            {
                acceso.CancelarTransaccion();
                throw;
            }
            finally
            {
                acceso.Cerrar();
            }
        }

        public static void ValidarIngreso(Lote lote)
        {
            if (lote == null) throw new ArgumentNullException(nameof(lote));
            if (string.IsNullOrWhiteSpace(lote.NumeroLote) || lote.NumeroLote.Trim().Length > 50)
                throw new ArgumentException("Ingrese un número de lote de hasta 50 caracteres.");
            if (lote.Cantidad <= 0) throw new ArgumentException("La cantidad debe ser mayor a cero.");
            if (lote.FechaIngreso.Date > DateTime.Today || lote.FechaVencimiento.Date < lote.FechaIngreso.Date || lote.FechaVencimiento.Date < DateTime.Today)
                throw new ArgumentException("Verifique las fechas: el ingreso no puede ser futuro y el lote no debe estar vencido.");
            lote.NumeroLote = lote.NumeroLote.Trim();
            lote.FechaIngreso = lote.FechaIngreso.Date;
            lote.FechaVencimiento = lote.FechaVencimiento.Date;
        }

        private void SincronizarProducto(Producto referencia, ACCESO acceso)
        {
            _loteDAL.ActualizarStockEnProducto(referencia.Id, acceso);
            ProductoDAL productos = new ProductoDAL();
            Producto producto = productos.ObtenerPorId(referencia.Id, acceso);
            producto.DVH = DigitoVerificador.CalcularDVH(producto);
            productos.Modificar(producto, acceso);
            acceso.RecalcularDVV("Productos");
        }

        public Lote BuscarExistente(Lote referencia)
        {
            return _loteDAL.BuscarExistente(referencia);
        }

        public List<Lote> ListarPorProducto(int productoId)
        {
            return _loteDAL.ListarPorProducto(productoId);
        }

        public void Eliminar(Lote lote)
        {
            if (lote == null || lote.Id <= 0 || lote.ProductoId <= 0)
                throw new ArgumentException("Seleccione un lote válido.");
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                new ProductoDAL().Bloquear(new Producto { Id = lote.ProductoId }, acceso);
                _loteDAL.Eliminar(lote, acceso);
                SincronizarProducto(new Producto { Id = lote.ProductoId }, acceso);
                acceso.ConfirmarTransaccion();
            }
            catch
            {
                acceso.CancelarTransaccion();
                throw;
            }
            finally
            {
                acceso.Cerrar();
            }
        }

        public int CalcularStockTotal(int productoId)
        {
            return _loteDAL.CalcularStockTotal(productoId);
        }

        public void ActualizarCantidad(Lote solicitud)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                if (solicitud == null || solicitud.Id <= 0 || solicitud.ProductoId <= 0 || solicitud.Cantidad < 0)
                    throw new ArgumentException("Indique un lote válido y una cantidad no negativa.");
                new ProductoDAL().Bloquear(new Producto { Id = solicitud.ProductoId }, acceso);
                _loteDAL.ActualizarCantidad(solicitud, acceso);
                SincronizarProducto(new Producto { Id = solicitud.ProductoId }, acceso);
                acceso.ConfirmarTransaccion();
            }
            catch
            {
                acceso.CancelarTransaccion();
                throw;
            }
            finally
            {
                acceso.Cerrar();
            }
        }
    }
}
