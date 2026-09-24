using BE;
using DAL;
using SERVICIOS;
using System;
using System.Collections.Generic;
using System.Linq;

namespace BLL
{
    public class UsuarioBLL
    {
        private readonly UsuarioDAL _usuarioDAL = new UsuarioDAL();
        public (bool ok, string mensaje, Usuario usuario) IniciarSesion(string nombreUsuario, string contraseña)
        {
            try
            {
                Usuario u = _usuarioDAL.ObtenerPorNombreUsuario(nombreUsuario);
                if (u == null)
                    return (false, "Usuario o contraseña incorrectos", null);
                if (string.IsNullOrEmpty(u.Salt))
                    return (false, "Usuario o contraseña incorrectos", null);
                if (!SeguridadService.VerificarPassword(contraseña, u.ContraseñaHasheada, u.Salt))
                    return (false, "Usuario o contraseña incorrectos", null);
                if (u.DVH != DigitoVerificador.CalcularDVH(u))
                    return (false, $"Integridad comprometida para '{u.NombreUsuario}'. Contacte al administrador.", null);
                bool okUsuarios = DigitoVerificador.VerificarDVV("Usuarios", out _, out _);
                bool okProductos = DigitoVerificador.VerificarDVV("Productos", out _, out _);
                string advertencia = null;
                if (!okUsuarios || !okProductos)
                {
                    advertencia = "ADVERTENCIA: integridad DVV comprometida. Recalcule desde el menú 'Recalcular Integridad'.";
                    BitacoraHelper.Registrar("Integridad", "Alerta DVV", advertencia);
                }

                Sesion.Instancia.IniciarSesion(u);
                PermissionService.RefreshForCurrentUser();
                return (true, advertencia ?? "OK", u);
            }
            catch (Exception ex)
            {
                BitacoraHelper.Registrar("Usuario", "Error", $"Login fallido: {ex.Message}");
                return (false, "Error al iniciar sesión", null);
            }
        }

        public Usuario ObtenerUsuario(string nombreUsuario)
        {
            return _usuarioDAL.ObtenerPorNombreUsuario(nombreUsuario);
        }

        public List<Usuario> ObtenerTodos()
        {
            return _usuarioDAL.ObtenerTodos();
        }

        public void AgregarUsuario(Usuario nuevo, string contraseñaPlana)
        {
            string hash = SeguridadService.GenerarHashConSalt(contraseñaPlana, out string salt);
            nuevo.ContraseñaHasheada = hash;
            nuevo.Salt = salt;
            nuevo.Idioma = string.IsNullOrEmpty(nuevo.Idioma) ? "es" : nuevo.Idioma;
            nuevo.Activo = true;
            nuevo.DVH = DigitoVerificador.CalcularDVH(nuevo);
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                int idGenerado = _usuarioDAL.Insertar(nuevo, acceso);
                nuevo.Id = idGenerado;
                nuevo.DVH = DigitoVerificador.CalcularDVH(nuevo);
                _usuarioDAL.Modificar(nuevo, acceso);
                acceso.RecalcularDVV("Usuarios");
                acceso.ConfirmarTransaccion();
                BitacoraHelper.Registrar("Usuario", "Alta", $"Se creó el usuario '{nuevo.NombreUsuario}' (Id={nuevo.Id})");
            }
            catch (Exception ex)
            {
                acceso.CancelarTransaccion();
                BitacoraHelper.Registrar("Usuario", "Error", $"Alta fallida para '{nuevo.NombreUsuario}': {MensajeCompleto(ex)}");
                throw;
            }
            finally
            {
                acceso.Cerrar();
            }
        }

        public void ModificarUsuario(Usuario usuario, string nuevaContrasena = null)
        {
            if (!string.IsNullOrEmpty(nuevaContrasena))
            {
                string hash = SeguridadService.GenerarHashConSalt(nuevaContrasena, out string salt);
                usuario.ContraseñaHasheada = hash;
                usuario.Salt = salt;
            }

            usuario.Idioma = string.IsNullOrEmpty(usuario.Idioma) ? "es" : usuario.Idioma;
            usuario.DVH = DigitoVerificador.CalcularDVH(usuario);
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                _usuarioDAL.Modificar(usuario, acceso);
                acceso.RecalcularDVV("Usuarios");
                acceso.ConfirmarTransaccion();
                BitacoraHelper.Registrar("Usuario", "Modificación", $"Se modificó el usuario '{usuario.NombreUsuario}' (Id={usuario.Id})");
            }
            catch (Exception ex)
            {
                acceso.CancelarTransaccion();
                BitacoraHelper.Registrar("Usuario", "Error", $"Modificación fallida para '{usuario.NombreUsuario}': {MensajeCompleto(ex)}");
                throw;
            }
            finally
            {
                acceso.Cerrar();
            }
        }

        public void EliminarUsuario(int id)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                _usuarioDAL.Eliminar(id, acceso);
                acceso.RecalcularDVV("Usuarios");
                acceso.ConfirmarTransaccion();
                BitacoraHelper.Registrar("Usuario", "Baja lógica", $"Se dio de baja el usuario con Id={id}");
            }
            catch (Exception ex)
            {
                acceso.CancelarTransaccion();
                BitacoraHelper.Registrar("Usuario", "Error", $"Baja fallida para Id={id}: {MensajeCompleto(ex)}");
                throw;
            }
            finally
            {
                acceso.Cerrar();
            }
        }

        public void GuardarIdiomaUsuario(int idUsuario, string idioma)
        {
            try
            {
                if (string.IsNullOrEmpty(idioma))
                    idioma = "es";
                _usuarioDAL.GuardarIdioma(idUsuario, idioma);
            }
            catch (Exception ex)
            {
                BitacoraHelper.Registrar("Usuario", "Error", $"Guardar idioma fallido para Id={idUsuario}: {MensajeCompleto(ex)}");
                throw;
            }
        }

        public void SeedAdmin()
        {
            try
            {
                PermisoBLL permisoBLL = new PermisoBLL();
                permisoBLL.SeedSistemaPermisos();
                Usuario existente = _usuarioDAL.ObtenerPorNombreUsuario("admin");
                int adminId = 0;
                if (existente == null)
                {
                    Usuario nuevoAdmin = new Usuario
                    {
                        NombreUsuario = "admin",
                        Idioma = "es",
                        Activo = true
                    };
                    AgregarUsuario(nuevoAdmin, "admin123");
                    adminId = nuevoAdmin.Id;
                }
                else
                {
                    adminId = existente.Id;
                }

                if (adminId > 0)
                {
                    UsuarioPermisoBLL usuarioPermisoBLL = new UsuarioPermisoBLL();
                    List<int> gruposAsignados = usuarioPermisoBLL.ObtenerGrupos(adminId);
                    List<BE.Permisos.GrupoPermiso> todosGrupos = permisoBLL.ObtenerGruposDePermisos().OfType<BE.Permisos.GrupoPermiso>().ToList();
                    BE.Permisos.GrupoPermiso grupoAdmin = todosGrupos.FirstOrDefault(g => g.Nombre.Equals("Administrador", StringComparison.OrdinalIgnoreCase));
                    if (grupoAdmin != null && !gruposAsignados.Contains(grupoAdmin.Id))
                    {
                        List<int> nuevosGrupos = new List<int>(gruposAsignados)
                        {
                            grupoAdmin.Id
                        };
                        usuarioPermisoBLL.AsignarGrupos(adminId, nuevosGrupos);
                    }
                }
            }
            catch (Exception ex)
            {
                BitacoraHelper.Registrar("Usuario", "Error", $"Seed admin fallido: {MensajeCompleto(ex)}");
                throw;
            }
        }

        public bool VerificarLogin(string nombreUsuario, string contraseña)
        {
            Usuario u = _usuarioDAL.ObtenerPorNombreUsuario(nombreUsuario);
            if (u == null || string.IsNullOrEmpty(u.Salt))
                return false;
            return SeguridadService.VerificarPassword(contraseña, u.ContraseñaHasheada, u.Salt);
        }

        public bool Autenticar(string nombreUsuario, string contraseña, out bool dvhValido, out Usuario usuarioOut)
        {
            dvhValido = false;
            usuarioOut = null;
            Usuario u = _usuarioDAL.ObtenerPorNombreUsuario(nombreUsuario);
            if (u == null || string.IsNullOrEmpty(u.Salt))
                return false;
            if (!SeguridadService.VerificarPassword(contraseña, u.ContraseñaHasheada, u.Salt))
                return false;
            dvhValido = u.DVH == DigitoVerificador.CalcularDVH(u);
            usuarioOut = u;
            return true;
        }

        private static string MensajeCompleto(Exception ex) => ex.InnerException != null ? $"{ex.Message} → {ex.InnerException.Message}" : ex.Message;
    }
}
