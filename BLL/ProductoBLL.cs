using BE;
using DAL;
using SERVICIOS;
using System;
using System.Collections.Generic;
using System.Linq;

namespace BLL
{
    public class ProductoBLL
    {
        private readonly ProductoDAL _productoDal = new ProductoDAL();
        private readonly LoteDAL _loteDal = new LoteDAL();
        private readonly ProductoHistorialBLL _historialBll = new ProductoHistorialBLL();
        public List<Producto> Listar()
        {
            try
            {
                return _productoDal.ListarTodos();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar productos", ex);
            }
        }

        public Producto ObtenerPorId(int id)
        {
            try
            {
                return _productoDal.ObtenerPorId(id);
            }
            catch (Exception ex)
            {
                throw new Exception($"Error al obtener el producto con Id={id}", ex);
            }
        }

        public void Agregar(Producto producto)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                ValidarProducto(producto, acceso);
                producto.DVH = DigitoVerificador.CalcularDVH(producto);
                int idGenerado = _productoDal.Insertar(producto, acceso);
                producto.Id = idGenerado;
                producto.DVH = DigitoVerificador.CalcularDVH(producto);
                _productoDal.Modificar(producto, acceso);
                acceso.RecalcularDVV("Productos");
                acceso.ConfirmarTransaccion();
                BitacoraHelper.Registrar("Producto", "Alta", $"Se agregó el producto '{producto.Nombre}' (Id={producto.Id})");
            }
            catch (Exception ex)
            {
                acceso.CancelarTransaccion();
                BitacoraHelper.Registrar("Producto", "Error", $"Alta fallida para '{producto.Nombre}': {MensajeCompleto(ex)}");
                throw;
            }
            finally
            {
                acceso.Cerrar();
            }
        }

        public void AgregarConLote(SolicitudProducto solicitud)
        {
            if (solicitud?.Producto == null) throw new ArgumentNullException(nameof(solicitud));
            Producto producto = solicitud.Producto;
            Lote lote = solicitud.Lote;
            LoteBLL.ValidarIngreso(lote);
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                ValidarProducto(producto, acceso);
                producto.DVH = DigitoVerificador.CalcularDVH(producto);
                int idGenerado = _productoDal.Insertar(producto, acceso);
                producto.Id = idGenerado;
                lote.ProductoId = idGenerado;
                _loteDal.Agregar(lote, acceso);
                _loteDal.ActualizarStockEnProducto(idGenerado, acceso);
                Producto productoPersistido = _productoDal.ObtenerPorId(idGenerado, acceso);
                productoPersistido.DVH = DigitoVerificador.CalcularDVH(productoPersistido);
                _productoDal.Modificar(productoPersistido, acceso);
                acceso.RecalcularDVV("Productos");
                acceso.ConfirmarTransaccion();
                BitacoraHelper.Registrar("Producto", "Alta con Lote", $"Se agregó '{producto.Nombre}' (Id={idGenerado}) con lote '{lote.NumeroLote}'");
            }
            catch (Exception ex)
            {
                acceso.CancelarTransaccion();
                BitacoraHelper.Registrar("Producto", "Error", $"Alta con lote fallida para '{producto.Nombre}': {MensajeCompleto(ex)}");
                throw;
            }
            finally
            {
                acceso.Cerrar();
            }
        }

        public void Modificar(SolicitudProducto solicitud)
        {
            if (solicitud?.Producto == null) throw new ArgumentNullException(nameof(solicitud));
            Producto producto = solicitud.Producto;
            Lote lote = solicitud.Lote;
            if (lote != null)
            {
                lote.ProductoId = producto.Id;
                LoteBLL.ValidarIngreso(lote);
            }
            Producto estadoAnterior = _productoDal.ObtenerPorId(producto.Id);
            if (estadoAnterior != null)
                _historialBll.RegistrarSnapshot(estadoAnterior, "Modificar");
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                Producto actual = _productoDal.Bloquear(producto, acceso);
                if (!actual.Activo) throw new ArgumentException("El producto está dado de baja.");
                producto.Stock = _loteDal.CalcularStockTotal(producto.Id, acceso);
                ValidarProducto(producto, acceso);
                producto.DVH = DigitoVerificador.CalcularDVH(producto);
                _productoDal.Modificar(producto, acceso);
                if (lote != null)
                {
                    _loteDal.Agregar(lote, acceso);
                    _loteDal.ActualizarStockEnProducto(producto.Id, acceso);
                    Producto productoActualizado = _productoDal.ObtenerPorId(producto.Id, acceso);
                    productoActualizado.DVH = DigitoVerificador.CalcularDVH(productoActualizado);
                    _productoDal.Modificar(productoActualizado, acceso);
                }

                acceso.RecalcularDVV("Productos");
                acceso.ConfirmarTransaccion();
                BitacoraHelper.Registrar("Producto", "Modificación", $"Se modificó el producto '{producto.Nombre}' (Id={producto.Id})");
            }
            catch (Exception ex)
            {
                acceso.CancelarTransaccion();
                BitacoraHelper.Registrar("Producto", "Error", $"Modificación fallida para Id={producto.Id}: {MensajeCompleto(ex)}");
                throw;
            }
            finally
            {
                acceso.Cerrar();
            }
        }

        public void Eliminar(Producto objeto)
        {
            Producto estadoAnterior = _productoDal.ObtenerPorId(objeto.Id);
            if (estadoAnterior != null)
                _historialBll.RegistrarSnapshot(estadoAnterior, "Eliminar");
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                _productoDal.Eliminar(objeto, acceso);
                acceso.RecalcularDVV("Productos");
                acceso.ConfirmarTransaccion();
                BitacoraHelper.Registrar("Producto", "Baja lógica", $"Se dio de baja el producto (Id={objeto.Id})");
            }
            catch (Exception ex)
            {
                acceso.CancelarTransaccion();
                BitacoraHelper.Registrar("Producto", "Error", $"Baja fallida para Id={objeto.Id}: {MensajeCompleto(ex)}");
                throw;
            }
            finally
            {
                acceso.Cerrar();
            }
        }

        public void RevertirA(Producto snapshot)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                _productoDal.Bloquear(snapshot, acceso);
                snapshot.Stock = _loteDal.CalcularStockTotal(snapshot.Id, acceso);
                ValidarProducto(snapshot, acceso);
                snapshot.DVH = DigitoVerificador.CalcularDVH(snapshot);
                _productoDal.Modificar(snapshot, acceso);
                acceso.RecalcularDVV("Productos");
                acceso.ConfirmarTransaccion();
                BitacoraHelper.Registrar("Producto", "Rollback", $"Se revirtió el producto (Id={snapshot.Id}) a estado anterior");
            }
            catch (Exception ex)
            {
                acceso.CancelarTransaccion();
                BitacoraHelper.Registrar("Producto", "Error", $"Rollback fallido para Id={snapshot.Id}: {MensajeCompleto(ex)}");
                throw;
            }
            finally
            {
                acceso.Cerrar();
            }
        }

        private void ValidarProducto(Producto producto, ACCESO acceso)
        {
            if (producto == null || string.IsNullOrWhiteSpace(producto.Nombre) || producto.Nombre.Trim().Length > 100)
                throw new ArgumentException("Ingrese un nombre de producto de hasta 100 caracteres.");
            if (producto.Categoria <= 0 || producto.Precio < 0 || producto.LitrosPorUnidad <= 0 || double.IsInfinity(producto.LitrosPorUnidad) || double.IsNaN(producto.LitrosPorUnidad))
                throw new ArgumentException("Verifique la categoría, el precio y la presentación del producto.");
            producto.Nombre = producto.Nombre.Trim();
            _productoDal.ValidarIdentidad(producto, acceso);
        }

        private static string MensajeCompleto(Exception ex)
        {
            return ex.InnerException != null ? $"{ex.Message} → {ex.InnerException.Message}" : ex.Message;
        }
    }
}
