using BE.Permisos;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace DAL
{
    public class PermisoDAL
    {
        public int CrearGrupoPermiso(GrupoPermiso grupo)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                int id = CrearGrupoPermiso(grupo, acceso);
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

        public void EliminarGrupoPorNombre(string nombreGrupo)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                EliminarGrupoPorNombre(nombreGrupo, acceso);
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

        public void SetGrupoPermisoSimples(string nombreGrupo, List<string> simples)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                SetGrupoPermisoSimples(nombreGrupo, simples, acceso);
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

        public void SetGrupoPermisoSubgrupos(string nombreGrupo, List<string> subgrupos)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                SetGrupoPermisoSubgrupos(nombreGrupo, subgrupos, acceso);
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

        public int CrearGrupoPermiso(GrupoPermiso grupo, ACCESO acceso)
        {
            List<System.Data.SqlClient.SqlParameter> paramsGrupo = new List<System.Data.SqlClient.SqlParameter>
            {
                acceso.CrearParametro("@Nombre", grupo.Nombre)
            };
            int idGrupo = Convert.ToInt32(acceso.EscribirEscalar("sp_Permiso_CrearGrupo", paramsGrupo));
            foreach (IPermiso hijo in grupo.Hijos)
            {
                if (hijo is PermisoSimple simple)
                {
                    List<System.Data.SqlClient.SqlParameter> p = new List<System.Data.SqlClient.SqlParameter>
                    {
                        acceso.CrearParametro("@IdPermisoPadre", idGrupo),
                        acceso.CrearParametro("@NombreSimple", simple.Nombre)
                    };
                    acceso.Escribir("sp_Permiso_AgregarSimple", p);
                }
                else if (hijo is GrupoPermiso subGrupo)
                {
                    List<System.Data.SqlClient.SqlParameter> p = new List<System.Data.SqlClient.SqlParameter>
                    {
                        acceso.CrearParametro("@IdPermisoPadre", idGrupo),
                        acceso.CrearParametro("@NombreSubgrupo", subGrupo.Nombre)
                    };
                    acceso.Escribir("sp_Permiso_AgregarSubgrupo", p);
                }
            }

            return idGrupo;
        }

        public void EliminarGrupoPorNombre(string nombreGrupo, ACCESO acceso)
        {
            List<System.Data.SqlClient.SqlParameter> paramsGet = new List<System.Data.SqlClient.SqlParameter>
            {
                acceso.CrearParametro("@Nombre", nombreGrupo)
            };
            DataTable dt = acceso.LeerSQL("SELECT Id FROM Permiso WHERE Nombre=@Nombre AND EsPadre=1", paramsGet);
            if (dt.Rows.Count == 0)
                return;
            int id = Convert.ToInt32(dt.Rows[0]["Id"]);
            acceso.EscribirSQL("DELETE FROM Usuario_Permiso  WHERE IdPermiso=@Id", new List<System.Data.SqlClient.SqlParameter> { acceso.CrearParametro("@Id", id) });
            acceso.EscribirSQL("DELETE FROM PermisoPermiso   WHERE IdPermisoPadre=@Id", new List<System.Data.SqlClient.SqlParameter> { acceso.CrearParametro("@Id", id) });
            acceso.EscribirSQL("DELETE FROM PermisoPermiso   WHERE IdPermisoHijo=@Id", new List<System.Data.SqlClient.SqlParameter> { acceso.CrearParametro("@Id", id) });
            acceso.EscribirSQL("DELETE FROM Permiso          WHERE Id=@Id", new List<System.Data.SqlClient.SqlParameter> { acceso.CrearParametro("@Id", id) });
        }

        public void SetGrupoPermisoSimples(string nombreGrupo, List<string> simples, ACCESO acceso)
        {
            DataTable dt = acceso.LeerSQL("SELECT Id FROM Permiso WHERE Nombre=@Nombre AND EsPadre=1", new List<System.Data.SqlClient.SqlParameter> { acceso.CrearParametro("@Nombre", nombreGrupo) });
            if (dt.Rows.Count == 0)
                return;
            int idPadre = Convert.ToInt32(dt.Rows[0]["Id"]);
            acceso.EscribirSQL(@"DELETE pp FROM PermisoPermiso pp
                  JOIN Permiso ps ON ps.Id = pp.IdPermisoHijo AND ps.EsPadre = 0
                  WHERE pp.IdPermisoPadre = @IdPadre", new List<System.Data.SqlClient.SqlParameter> { acceso.CrearParametro("@IdPadre", idPadre) });
            foreach (string nombre in simples.Distinct(StringComparer.OrdinalIgnoreCase))
            {
                acceso.Escribir("sp_Permiso_AgregarSimple", new List<System.Data.SqlClient.SqlParameter> { acceso.CrearParametro("@IdPermisoPadre", idPadre), acceso.CrearParametro("@NombreSimple", nombre) });
            }
        }

        public void SetGrupoPermisoSubgrupos(string nombreGrupo, List<string> subgrupos, ACCESO acceso)
        {
            DataTable dt = acceso.LeerSQL("SELECT Id FROM Permiso WHERE Nombre=@Nombre AND EsPadre=1", new List<System.Data.SqlClient.SqlParameter> { acceso.CrearParametro("@Nombre", nombreGrupo) });
            if (dt.Rows.Count == 0)
                return;
            int idPadre = Convert.ToInt32(dt.Rows[0]["Id"]);
            acceso.EscribirSQL(@"DELETE pp FROM PermisoPermiso pp
                  JOIN Permiso ph ON ph.Id = pp.IdPermisoHijo AND ph.EsPadre = 1
                  WHERE pp.IdPermisoPadre = @IdPadre", new List<System.Data.SqlClient.SqlParameter> { acceso.CrearParametro("@IdPadre", idPadre) });
            foreach (string nombre in subgrupos.Distinct(StringComparer.OrdinalIgnoreCase))
            {
                acceso.Escribir("sp_Permiso_AgregarSubgrupo", new List<System.Data.SqlClient.SqlParameter> { acceso.CrearParametro("@IdPermisoPadre", idPadre), acceso.CrearParametro("@NombreSubgrupo", nombre) });
            }
        }

        public void NormalizarPermisos(ACCESO acceso)
        {
            acceso.EscribirSQL(@";WITH d AS (
                    SELECT Id, ROW_NUMBER() OVER(PARTITION BY Nombre ORDER BY Id) rn
                    FROM Permiso
                  )
                  DELETE FROM d WHERE rn > 1;", null);
            acceso.EscribirSQL("IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='UX_Permiso_Nombre' " + "AND object_id=OBJECT_ID('dbo.Permiso')) " + "CREATE UNIQUE INDEX UX_Permiso_Nombre ON dbo.Permiso(Nombre);", null);
        }

        public List<IPermiso> ObtenerGruposDePermisos()
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            try
            {
                DataTable dtTodos = acceso.Leer("sp_Permiso_ObtenerTodos");
                DataTable dtRelaciones = acceso.Leer("sp_Permiso_ObtenerRelaciones");
                Dictionary<int, GrupoPermiso> grupos = new Dictionary<int, GrupoPermiso>();
                Dictionary<int, PermisoSimple> permisos = new Dictionary<int, PermisoSimple>();
                foreach (DataRow fila in dtTodos.Rows)
                {
                    int id = Convert.ToInt32(fila["Id"]);
                    string nombre = fila["Nombre"].ToString();
                    bool esPadre = Convert.ToBoolean(fila["EsPadre"]);
                    if (esPadre)
                        grupos[id] = new GrupoPermiso
                        {
                            Id = id,
                            Nombre = nombre
                        };
                    else
                        permisos[id] = new PermisoSimple
                        {
                            Nombre = nombre
                        };
                }

                foreach (DataRow rel in dtRelaciones.Rows)
                {
                    int idPadre = Convert.ToInt32(rel["IdPermisoPadre"]);
                    int idHijo = Convert.ToInt32(rel["IdPermisoHijo"]);
                    if (!grupos.TryGetValue(idPadre, out GrupoPermiso padre))
                        continue;
                    if (permisos.TryGetValue(idHijo, out PermisoSimple ps))
                        padre.Agregar(ps);
                    else if (grupos.TryGetValue(idHijo, out GrupoPermiso hijo))
                        padre.Agregar(hijo);
                }

                return grupos.Values.Cast<IPermiso>().ToList();
            }
            catch (Exception ex)
            {
                throw new Exception("Error en PermisoDAL.ObtenerGruposDePermisos", ex);
            }
            finally
            {
                acceso.Cerrar();
            }
        }

        public List<PermisoSimple> ObtenerPermisosSimples()
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            try
            {
                DataTable dt = acceso.Leer("sp_Permiso_ObtenerTodos");
                List<PermisoSimple> lista = new List<PermisoSimple>();
                foreach (DataRow fila in dt.Rows)
                    lista.Add(new PermisoSimple { Nombre = fila["Nombre"].ToString() });
                return lista;
            }
            catch (Exception ex)
            {
                throw new Exception("Error en PermisoDAL.ObtenerPermisosSimples", ex);
            }
            finally
            {
                acceso.Cerrar();
            }
        }
    }
}
