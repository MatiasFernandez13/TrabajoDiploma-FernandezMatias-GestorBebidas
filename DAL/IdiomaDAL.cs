using BE;
using System;
using System.Collections.Generic;
using System.Data;

namespace DAL
{
    public class IdiomaDAL
    {
        public List<IdiomaDTO> ObtenerIdiomas()
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            try
            {
                DataTable dt = acceso.Leer("sp_Idiomas_Listar");
                List<IdiomaDTO> lista = new List<IdiomaDTO>();
                foreach (DataRow fila in dt.Rows)
                    lista.Add(new IdiomaDTO { Codigo = fila["Codigo"].ToString(), Nombre = fila["Nombre"].ToString() });
                return lista;
            }
            catch (Exception ex)
            {
                throw new Exception("Error en IdiomaDAL.ObtenerIdiomas", ex);
            }
            finally
            {
                acceso.Cerrar();
            }
        }

        public Dictionary<string, string> ObtenerTraducciones(string codigoIdioma)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            try
            {
                List<System.Data.SqlClient.SqlParameter> parametros = new List<System.Data.SqlClient.SqlParameter>
                {
                    acceso.CrearParametro("@Codigo", codigoIdioma)
                };
                DataTable dt = acceso.Leer("sp_Traducciones_PorCodigo", parametros);
                Dictionary<string, string> traducciones = new Dictionary<string, string>();
                foreach (DataRow fila in dt.Rows)
                    traducciones[fila["Tag"].ToString()] = fila["Traduccion"].ToString();
                return traducciones;
            }
            catch (Exception ex)
            {
                throw new Exception("Error en IdiomaDAL.ObtenerTraducciones", ex);
            }
            finally
            {
                acceso.Cerrar();
            }
        }
    }
}
