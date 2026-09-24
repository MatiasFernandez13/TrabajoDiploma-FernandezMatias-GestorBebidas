using BE.Permisos;
using DAL;
using System;
using System.Collections.Generic;
using System.Linq;

namespace BLL
{
    public class PermisoBLL
    {
        private readonly PermisoDAL _permisoDal = new PermisoDAL();
        private static List<IPermiso> _cacheArbolPermisos;
        private static readonly object _lockCache = new object ();
        private static readonly HashSet<string> ValidSimples = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
        {
            "AccesoUsuarios",
            "Usuarios.Alta",
            "Usuarios.Modificar",
            "Usuarios.Baja",
            "AccesoProductos",
            "Productos.Ver",
            "Productos.Agregar",
            "Productos.Modificar",
            "Productos.Eliminar",
            "AccesoVentas",
            "Ventas.Realizar",
            "AccesoReportes",
            "Reportes.Ver",
            "Reportes.Modificar",
            "Reportes.Eliminar",
            "AccesoIdiomas",
            "AccesoPermisos",
            "Permisos.Asignar",
            "Permisos.Gestionar",
            "AccesoAdministracion",
            "AccesoBitacora",
            "AccesoVerificarIntegridad",
            "AccesoRecalcularIntegridad",
            "AccesoControlCambios"
        };
        private static readonly HashSet<string> ValidGrupos = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
        {
            "Gestion Usuarios",
            "Gestion Productos",
            "Gestion Reportes",
            "Gestion Idioma",
            "Gestion Permisos",
            "Gestion",
            "Gestion Venta",
            "Administracion",
            "Base",
            "Supervisor",
            "Administrador",
            "Vendedor"
        };
        public void SeedSistemaPermisos()
        {
            try
            {
                ACCESO acc = new ACCESO();
                acc.Abrir();
                acc.IniciarTransaccion();
                try
                {
                    _permisoDal.NormalizarPermisos(acc);
                    acc.ConfirmarTransaccion();
                }
                catch
                {
                    acc.CancelarTransaccion();
                }
                finally
                {
                    acc.Cerrar();
                }
            }
            catch
            {
            }

            InvalidarCache();
            GrupoPermiso administracion = new GrupoPermiso
            {
                Nombre = "Administracion"
            };
            administracion.Agregar(new PermisoSimple { Nombre = "AccesoAdministracion" });
            administracion.Agregar(new PermisoSimple { Nombre = "AccesoBitacora" });
            administracion.Agregar(new PermisoSimple { Nombre = "AccesoVerificarIntegridad" });
            administracion.Agregar(new PermisoSimple { Nombre = "AccesoRecalcularIntegridad" });
            administracion.Agregar(new PermisoSimple { Nombre = "AccesoControlCambios" });
            CrearGrupoPermiso(administracion);
            GrupoPermiso gUsuarios = new GrupoPermiso
            {
                Nombre = "Gestion Usuarios"
            };
            gUsuarios.Agregar(new PermisoSimple { Nombre = "AccesoUsuarios" });
            gUsuarios.Agregar(new PermisoSimple { Nombre = "Usuarios.Alta" });
            gUsuarios.Agregar(new PermisoSimple { Nombre = "Usuarios.Modificar" });
            gUsuarios.Agregar(new PermisoSimple { Nombre = "Usuarios.Baja" });
            CrearGrupoPermiso(gUsuarios);
            GrupoPermiso gProductos = new GrupoPermiso
            {
                Nombre = "Gestion Productos"
            };
            gProductos.Agregar(new PermisoSimple { Nombre = "AccesoProductos" });
            gProductos.Agregar(new PermisoSimple { Nombre = "Productos.Ver" });
            gProductos.Agregar(new PermisoSimple { Nombre = "Productos.Agregar" });
            gProductos.Agregar(new PermisoSimple { Nombre = "Productos.Modificar" });
            gProductos.Agregar(new PermisoSimple { Nombre = "Productos.Eliminar" });
            CrearGrupoPermiso(gProductos);
            GrupoPermiso gReportes = new GrupoPermiso
            {
                Nombre = "Gestion Reportes"
            };
            gReportes.Agregar(new PermisoSimple { Nombre = "AccesoReportes" });
            gReportes.Agregar(new PermisoSimple { Nombre = "Reportes.Ver" });
            gReportes.Agregar(new PermisoSimple { Nombre = "Reportes.Modificar" });
            gReportes.Agregar(new PermisoSimple { Nombre = "Reportes.Eliminar" });
            CrearGrupoPermiso(gReportes);
            GrupoPermiso gIdioma = new GrupoPermiso
            {
                Nombre = "Gestion Idioma"
            };
            gIdioma.Agregar(new PermisoSimple { Nombre = "AccesoIdiomas" });
            CrearGrupoPermiso(gIdioma);
            GrupoPermiso gPermisos = new GrupoPermiso
            {
                Nombre = "Gestion Permisos"
            };
            gPermisos.Agregar(new PermisoSimple { Nombre = "AccesoPermisos" });
            gPermisos.Agregar(new PermisoSimple { Nombre = "Permisos.Asignar" });
            gPermisos.Agregar(new PermisoSimple { Nombre = "Permisos.Gestionar" });
            CrearGrupoPermiso(gPermisos);
            GrupoPermiso gVenta = new GrupoPermiso
            {
                Nombre = "Gestion Venta"
            };
            gVenta.Agregar(new PermisoSimple { Nombre = "AccesoVentas" });
            gVenta.Agregar(new PermisoSimple { Nombre = "Ventas.Realizar" });
            CrearGrupoPermiso(gVenta);
            GrupoPermiso gestion = new GrupoPermiso
            {
                Nombre = "Gestion"
            };
            gestion.Agregar(new GrupoPermiso { Nombre = "Gestion Usuarios" });
            gestion.Agregar(new GrupoPermiso { Nombre = "Gestion Productos" });
            gestion.Agregar(new GrupoPermiso { Nombre = "Gestion Reportes" });
            gestion.Agregar(new GrupoPermiso { Nombre = "Gestion Idioma" });
            gestion.Agregar(new GrupoPermiso { Nombre = "Gestion Permisos" });
            gestion.Agregar(new GrupoPermiso { Nombre = "Gestion Venta" });
            CrearGrupoPermiso(gestion);
            GrupoPermiso basePerfil = new GrupoPermiso
            {
                Nombre = "Base"
            };
            basePerfil.Agregar(new PermisoSimple { Nombre = "AccesoProductos" });
            basePerfil.Agregar(new PermisoSimple { Nombre = "Productos.Ver" });
            basePerfil.Agregar(new PermisoSimple { Nombre = "AccesoIdiomas" });
            CrearGrupoPermiso(basePerfil);
            GrupoPermiso vendedor = new GrupoPermiso
            {
                Nombre = "Vendedor"
            };
            vendedor.Agregar(new GrupoPermiso { Nombre = "Gestion Venta" });
            vendedor.Agregar(new GrupoPermiso { Nombre = "Base" });
            CrearGrupoPermiso(vendedor);
            GrupoPermiso supervisor = new GrupoPermiso
            {
                Nombre = "Supervisor"
            };
            supervisor.Agregar(new PermisoSimple { Nombre = "AccesoUsuarios" });
            supervisor.Agregar(new PermisoSimple { Nombre = "Usuarios.Alta" });
            supervisor.Agregar(new PermisoSimple { Nombre = "Usuarios.Modificar" });
            supervisor.Agregar(new PermisoSimple { Nombre = "Usuarios.Baja" });
            supervisor.Agregar(new PermisoSimple { Nombre = "AccesoProductos" });
            supervisor.Agregar(new PermisoSimple { Nombre = "Productos.Ver" });
            supervisor.Agregar(new PermisoSimple { Nombre = "Productos.Modificar" });
            supervisor.Agregar(new PermisoSimple { Nombre = "Productos.Eliminar" });
            supervisor.Agregar(new PermisoSimple { Nombre = "AccesoReportes" });
            supervisor.Agregar(new PermisoSimple { Nombre = "Reportes.Ver" });
            supervisor.Agregar(new PermisoSimple { Nombre = "Reportes.Modificar" });
            supervisor.Agregar(new PermisoSimple { Nombre = "Reportes.Eliminar" });
            supervisor.Agregar(new PermisoSimple { Nombre = "AccesoIdiomas" });
            supervisor.Agregar(new PermisoSimple { Nombre = "AccesoAdministracion" });
            CrearGrupoPermiso(supervisor);
            GrupoPermiso admin = new GrupoPermiso
            {
                Nombre = "Administrador"
            };
            admin.Agregar(new PermisoSimple { Nombre = "AccesoUsuarios" });
            admin.Agregar(new PermisoSimple { Nombre = "Usuarios.Alta" });
            admin.Agregar(new PermisoSimple { Nombre = "Usuarios.Modificar" });
            admin.Agregar(new PermisoSimple { Nombre = "Usuarios.Baja" });
            admin.Agregar(new PermisoSimple { Nombre = "AccesoProductos" });
            admin.Agregar(new PermisoSimple { Nombre = "Productos.Ver" });
            admin.Agregar(new PermisoSimple { Nombre = "Productos.Agregar" });
            admin.Agregar(new PermisoSimple { Nombre = "Productos.Modificar" });
            admin.Agregar(new PermisoSimple { Nombre = "Productos.Eliminar" });
            admin.Agregar(new PermisoSimple { Nombre = "AccesoVentas" });
            admin.Agregar(new PermisoSimple { Nombre = "Ventas.Realizar" });
            admin.Agregar(new PermisoSimple { Nombre = "AccesoReportes" });
            admin.Agregar(new PermisoSimple { Nombre = "Reportes.Ver" });
            admin.Agregar(new PermisoSimple { Nombre = "Reportes.Modificar" });
            admin.Agregar(new PermisoSimple { Nombre = "Reportes.Eliminar" });
            admin.Agregar(new PermisoSimple { Nombre = "AccesoIdiomas" });
            admin.Agregar(new PermisoSimple { Nombre = "AccesoPermisos" });
            admin.Agregar(new PermisoSimple { Nombre = "Permisos.Asignar" });
            admin.Agregar(new PermisoSimple { Nombre = "Permisos.Gestionar" });
            admin.Agregar(new PermisoSimple { Nombre = "AccesoAdministracion" });
            admin.Agregar(new PermisoSimple { Nombre = "AccesoBitacora" });
            admin.Agregar(new PermisoSimple { Nombre = "AccesoVerificarIntegridad" });
            admin.Agregar(new PermisoSimple { Nombre = "AccesoRecalcularIntegridad" });
            admin.Agregar(new PermisoSimple { Nombre = "AccesoControlCambios" });
            CrearGrupoPermiso(admin);
        }

        public int CrearGrupoPermiso(GrupoPermiso grupo)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                int id = _permisoDal.CrearGrupoPermiso(grupo, acceso);
                acceso.ConfirmarTransaccion();
                InvalidarCache();
                BitacoraHelper.Registrar("Permisos", "Alta", $"Se creó el grupo '{grupo.Nombre}'");
                return id;
            }
            catch (Exception ex)
            {
                acceso.CancelarTransaccion();
                BitacoraHelper.Registrar("Permisos", "Error", $"Creación de grupo fallida '{grupo.Nombre}': {ex.Message}");
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
                _permisoDal.EliminarGrupoPorNombre(nombreGrupo, acceso);
                acceso.ConfirmarTransaccion();
                InvalidarCache();
                BitacoraHelper.Registrar("Permisos", "Baja", $"Se eliminó el grupo '{nombreGrupo}'");
            }
            catch (Exception ex)
            {
                acceso.CancelarTransaccion();
                BitacoraHelper.Registrar("Permisos", "Error", $"Baja de grupo fallida '{nombreGrupo}': {ex.Message}");
                throw;
            }
            finally
            {
                acceso.Cerrar();
            }
        }

        public void ActualizarGrupoSimples(string nombreGrupo, List<string> simples)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                _permisoDal.SetGrupoPermisoSimples(nombreGrupo, simples, acceso);
                acceso.ConfirmarTransaccion();
                InvalidarCache();
                BitacoraHelper.Registrar("Permisos", "Modificación", $"Se actualizaron permisos simples de '{nombreGrupo}'");
            }
            catch (Exception ex)
            {
                acceso.CancelarTransaccion();
                BitacoraHelper.Registrar("Permisos", "Error", $"Actualización fallida para '{nombreGrupo}': {ex.Message}");
                throw;
            }
            finally
            {
                acceso.Cerrar();
            }
        }

        public void ActualizarGrupoSubgrupos(string nombreGrupo, List<string> subgrupos)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                _permisoDal.SetGrupoPermisoSubgrupos(nombreGrupo, subgrupos, acceso);
                acceso.ConfirmarTransaccion();
                InvalidarCache();
                BitacoraHelper.Registrar("Permisos", "Modificación", $"Se actualizaron subgrupos de '{nombreGrupo}'");
            }
            catch (Exception ex)
            {
                acceso.CancelarTransaccion();
                BitacoraHelper.Registrar("Permisos", "Error", $"Actualización de subgrupos fallida para '{nombreGrupo}': {ex.Message}");
                throw;
            }
            finally
            {
                acceso.Cerrar();
            }
        }

        public List<IPermiso> ObtenerGruposDePermisos()
        {
            lock (_lockCache)
            {
                if (_cacheArbolPermisos == null)
                {
                    _cacheArbolPermisos = _permisoDal.ObtenerGruposDePermisos();
                }

                return _cacheArbolPermisos;
            }
        }

        private void InvalidarCache()
        {
            lock (_lockCache)
            {
                _cacheArbolPermisos = null;
            }
        }
    }
}
