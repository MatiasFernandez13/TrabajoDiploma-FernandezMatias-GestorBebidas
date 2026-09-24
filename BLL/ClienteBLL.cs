using BE;
using DAL;
using SERVICIOS;
using System;
using System.Collections.Generic;
using System.Linq;

namespace BLL
{
    public class ClienteBLL
    {
        private readonly ClienteDAL _clienteDal = new ClienteDAL();
        public List<Cliente> Listar()
        {
            try
            {
                return _clienteDal.ListarTodos();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar clientes", ex);
            }
        }

        public List<Cliente> ListarActivos()
        {
            return Listar().Where(c => c.Activo).ToList();
        }

        public List<string> ListarZonas()
        {
            try
            {
                return _clienteDal.ListarZonas();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar zonas", ex);
            }
        }

        public Cliente ObtenerPorId(int id)
        {
            try
            {
                return _clienteDal.ObtenerPorId(id);
            }
            catch (Exception ex)
            {
                throw new Exception($"Error al obtener el cliente con Id={id}", ex);
            }
        }

        public void Agregar(Cliente cliente)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                cliente.DVH = DigitoVerificador.CalcularDVH(cliente);
                int idGenerado = _clienteDal.Insertar(cliente, acceso);
                cliente.Id = idGenerado;
                cliente.DVH = DigitoVerificador.CalcularDVH(cliente);
                _clienteDal.Modificar(cliente, acceso);
                acceso.RecalcularDVV("Clientes");
                acceso.ConfirmarTransaccion();
                BitacoraHelper.Registrar("Cliente", "Alta", $"Se agregó el cliente '{cliente.NombreCompleto}' (Id={cliente.Id}, Zona={cliente.Zona})");
            }
            catch (Exception ex)
            {
                acceso.CancelarTransaccion();
                BitacoraHelper.Registrar("Cliente", "Error", $"Alta fallida para '{cliente.NombreCompleto}': {MensajeCompleto(ex)}");
                throw;
            }
            finally
            {
                acceso.Cerrar();
            }
        }

        public void Modificar(Cliente cliente)
        {
            Cliente estadoAnterior = _clienteDal.ObtenerPorId(cliente.Id);
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                cliente.DVH = DigitoVerificador.CalcularDVH(cliente);
                _clienteDal.Modificar(cliente, acceso);
                acceso.RecalcularDVV("Clientes");
                acceso.ConfirmarTransaccion();
                BitacoraHelper.Registrar("Cliente", "Modificación", $"Se modificó el cliente Id={cliente.Id} ('{cliente.NombreCompleto}')");
            }
            catch (Exception ex)
            {
                acceso.CancelarTransaccion();
                BitacoraHelper.Registrar("Cliente", "Error", $"Modificación fallida para Id={cliente.Id}: {MensajeCompleto(ex)}");
                throw;
            }
            finally
            {
                acceso.Cerrar();
            }
        }

        public void Eliminar(Cliente cliente)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                _clienteDal.Eliminar(cliente, acceso);
                acceso.RecalcularDVV("Clientes");
                acceso.ConfirmarTransaccion();
                BitacoraHelper.Registrar("Cliente", "Baja", $"Se eliminó (baja lógica) el cliente '{cliente.NombreCompleto}' (Id={cliente.Id})");
            }
            catch (Exception ex)
            {
                acceso.CancelarTransaccion();
                BitacoraHelper.Registrar("Cliente", "Error", $"Baja fallida para Id={cliente.Id}: {MensajeCompleto(ex)}");
                throw;
            }
            finally
            {
                acceso.Cerrar();
            }
        }

        private static string MensajeCompleto(Exception ex) => ex.InnerException != null ? $"{ex.Message} → {ex.InnerException.Message}" : ex.Message;
    }
}
