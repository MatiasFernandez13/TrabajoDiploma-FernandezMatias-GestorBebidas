using System;
using System.Collections.Generic;
using System.Data;
using DAL;

namespace BLL
{
    public class IdiomaAdminBLL
    {
        private readonly IdiomaAdminDAL _dal = new IdiomaAdminDAL();
        public int CrearIdiomaConTraducciones(string codigo, string nombre, Dictionary<int, string> traduccionesPorTag)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                int idIdioma = _dal.InsertarIdioma(codigo, nombre, acceso);
                foreach (KeyValuePair<int, string> kv in traduccionesPorTag)
                    _dal.GuardarTraduccion(idIdioma, kv.Key, kv.Value, acceso);
                acceso.ConfirmarTransaccion();
                BitacoraHelper.Registrar("Idioma", "Alta", $"Se creó el idioma '{nombre}' ({codigo})");
                return idIdioma;
            }
            catch (Exception ex)
            {
                acceso.CancelarTransaccion();
                BitacoraHelper.Registrar("Idioma", "Error", $"Alta fallida para '{codigo}': {ex.Message}");
                throw;
            }
            finally
            {
                acceso.Cerrar();
            }
        }

        public void EliminarIdioma(string codigo)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                _dal.EliminarIdioma(codigo, acceso);
                acceso.ConfirmarTransaccion();
                BitacoraHelper.Registrar("Idioma", "Baja", $"Se eliminó el idioma '{codigo}'");
            }
            catch (Exception ex)
            {
                acceso.CancelarTransaccion();
                BitacoraHelper.Registrar("Idioma", "Error", $"Baja fallida para '{codigo}': {ex.Message}");
                throw;
            }
            finally
            {
                acceso.Cerrar();
            }
        }

        public void GuardarTodasLasTraducciones(int idIdioma, Dictionary<int, string> traducciones)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                foreach (KeyValuePair<int, string> kv in traducciones)
                    _dal.GuardarTraduccion(idIdioma, kv.Key, kv.Value, acceso);
                acceso.ConfirmarTransaccion();
                BitacoraHelper.Registrar("Idioma", "Modificación", $"Se actualizaron traducciones para IdIdioma={idIdioma}");
            }
            catch (Exception ex)
            {
                acceso.CancelarTransaccion();
                BitacoraHelper.Registrar("Idioma", "Error", $"Actualización de traducciones fallida: {ex.Message}");
                throw;
            }
            finally
            {
                acceso.Cerrar();
            }
        }

        public DataTable ListarTags() => _dal.ListarTags();
        public int ObtenerIdIdiomaPorCodigo(string codigo) => _dal.ObtenerIdIdiomaPorCodigo(codigo);
    }
}
