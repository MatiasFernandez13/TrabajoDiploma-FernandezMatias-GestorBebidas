using System;
using System.Collections.Generic;
using System.Data;

namespace DAL
{
    public class IdiomaAdminDAL
    {
        public int InsertarIdioma(string codigo, string nombre)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                int id = InsertarIdioma(codigo, nombre, acceso);
                acceso.ConfirmarTransaccion();
                return id;
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

        public void EliminarIdioma(string codigo)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                EliminarIdioma(codigo, acceso);
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

        public void GuardarTraduccion(int idIdioma, int idTag, string traduccion)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                GuardarTraduccion(idIdioma, idTag, traduccion, acceso);
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

        public int InsertarIdioma(string codigo, string nombre, ACCESO acceso)
        {
            List<System.Data.SqlClient.SqlParameter> parametros = new List<System.Data.SqlClient.SqlParameter>
            {
                acceso.CrearParametro("@Codigo", codigo),
                acceso.CrearParametro("@Nombre", nombre)
            };
            object resultado = acceso.EscribirEscalar("sp_Idiomas_Insertar", parametros);
            return resultado != null && resultado != DBNull.Value ? Convert.ToInt32(resultado) : 0;
        }

        public void EliminarIdioma(string codigo, ACCESO acceso)
        {
            acceso.EscribirSQL("IF NOT EXISTS (SELECT 1 FROM Idiomas WHERE Codigo='es') " + "INSERT INTO Idiomas (Codigo, Nombre) VALUES ('es', 'Español');", null);
            List<System.Data.SqlClient.SqlParameter> paramsUpd = new List<System.Data.SqlClient.SqlParameter>
            {
                acceso.CrearParametro("@Codigo", codigo)
            };
            acceso.EscribirSQL("UPDATE Usuarios SET Idioma='es' WHERE Idioma=@Codigo AND @Codigo <> 'es';", paramsUpd);
            List<System.Data.SqlClient.SqlParameter> paramsDel = new List<System.Data.SqlClient.SqlParameter>
            {
                acceso.CrearParametro("@Codigo", codigo)
            };
            acceso.Escribir("sp_Idiomas_Eliminar", paramsDel);
        }

        public void GuardarTraduccion(int idIdioma, int idTag, string traduccion, ACCESO acceso)
        {
            List<System.Data.SqlClient.SqlParameter> parametros = new List<System.Data.SqlClient.SqlParameter>
            {
                acceso.CrearParametro("@IdIdioma", idIdioma),
                acceso.CrearParametro("@IdTag", idTag),
                acceso.CrearParametro("@Traduccion", traduccion)
            };
            acceso.Escribir("sp_Traduccion_Upsert", parametros);
        }

        public DataTable ListarTags()
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            try
            {
                return acceso.Leer("sp_Tag_Listar");
            }
            catch (Exception ex)
            {
                throw new Exception("Error en IdiomaAdminDAL.ListarTags", ex);
            }
            finally
            {
                acceso.Cerrar();
            }
        }

        public int ObtenerIdIdiomaPorCodigo(string codigo)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            try
            {
                List<System.Data.SqlClient.SqlParameter> parametros = new List<System.Data.SqlClient.SqlParameter>
                {
                    acceso.CrearParametro("@Codigo", codigo)
                };
                DataTable dt = acceso.LeerSQL("SELECT Id FROM Idiomas WHERE Codigo=@Codigo", parametros);
                return dt.Rows.Count > 0 ? Convert.ToInt32(dt.Rows[0]["Id"]) : 0;
            }
            catch (Exception ex)
            {
                throw new Exception("Error en IdiomaAdminDAL.ObtenerIdIdiomaPorCodigo", ex);
            }
            finally
            {
                acceso.Cerrar();
            }
        }

        public void AsegurarTags(IEnumerable<string> tags)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            try
            {
                foreach (string t in tags)
                {
                    List<System.Data.SqlClient.SqlParameter> parametros = new List<System.Data.SqlClient.SqlParameter>
                    {
                        acceso.CrearParametro("@Nombre", t)
                    };
                    acceso.EscribirSQL("IF NOT EXISTS (SELECT 1 FROM Tag WHERE Nombre=@Nombre) " + "INSERT INTO Tag (Nombre) VALUES (@Nombre);", parametros);
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error en IdiomaAdminDAL.AsegurarTags", ex);
            }
            finally
            {
                acceso.Cerrar();
            }
        }
    }
}
