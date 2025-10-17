using BE;       
using DAL;       
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static BLL.BitacoraBLL;
using SERVICIOS;


namespace BLL
{
    public class UsuarioBLL
    {
        private readonly UsuarioDAL _usuarioDAL;

        public UsuarioBLL(string connectionString)
        {
            _usuarioDAL = new UsuarioDAL(connectionString);
        }

        public bool VerificarLogin(string nombreUsuario, string contraseña)
        {
            var usuario = _usuarioDAL.ObtenerPorNombreUsuario(nombreUsuario);

            if (usuario == null)
                return false;

            string salt = _usuarioDAL.ObtenerSaltPorUsuario(nombreUsuario);
            if (string.IsNullOrEmpty(salt))
                return false;

            return SeguridadService.VerificarPassword(contraseña, usuario.ContraseñaHasheada, salt);
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

            string datosConcatenados = $"{nuevo.NombreUsuario}{nuevo.ContraseñaHasheada}{salt}{nuevo.Rol.Id}{nuevo.Idioma ?? "es"}";

            long dvh = DigitoVerificador.CalcularDVH(datosConcatenados);

            _usuarioDAL.Insertar(nuevo, salt, dvh);

            DigitoVerificador.RecalcularDVV("Usuarios");

            BitacoraHelper.Registrar("Usuario", "Alta", $"Se creó el usuario {nuevo.NombreUsuario} con rol {nuevo.Rol.Nombre}");
        }
        public void SeedAdmin()
        {
            var usuarioExistente = _usuarioDAL.ObtenerPorNombreUsuario("admin");

            if (usuarioExistente == null)
            {
                string hash = SeguridadService.GenerarHashConSalt("admin123", out string salt);
                var rolAdmin = new Rol { Id = 1, Nombre = "Administrador" }; 

                var nuevoUsuario = new Usuario
                {
                    NombreUsuario = "admin",
                    ContraseñaHasheada = hash,
                    Rol = rolAdmin,
                    Idioma = "es"
                };
                string datosConcatenados = $"{nuevoUsuario.NombreUsuario}{nuevoUsuario.ContraseñaHasheada}{salt}{nuevoUsuario.Rol.Id}{nuevoUsuario.Idioma}";
                long dvh = DigitoVerificador.CalcularDVH(datosConcatenados);

                _usuarioDAL.Insertar(nuevoUsuario, salt, dvh);

                DigitoVerificador.RecalcularDVV("Usuarios");
            }
        }
        public void ModificarUsuario(Usuario usuario)
        {
            string datosConcatenados = $"{usuario.NombreUsuario}{usuario.ContraseñaHasheada}{usuario.Rol.Id}{usuario.Idioma ?? "es"}";
            long dvh = DigitoVerificador.CalcularDVH(datosConcatenados);

            _usuarioDAL.Modificar(usuario, dvh);

            DigitoVerificador.RecalcularDVV("Usuarios");

            BitacoraHelper.Registrar("Usuario", "Modificar", $"Se modificó el usuario {usuario.NombreUsuario}, rol: {usuario.Rol.Nombre}");
        }

        public void EliminarUsuario(int id)
        {
            _usuarioDAL.Eliminar(id);
            BitacoraHelper.Registrar("Usuario","Eliminar", $"Se eliminó el usuario con Id={id}");
        }

        public void GuardarIdiomaUsuario(int idUsuario, string idioma)
        {
            _usuarioDAL.GuardarIdioma(idUsuario, idioma);
        }
    }
}
