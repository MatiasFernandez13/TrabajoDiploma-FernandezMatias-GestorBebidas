using System.Collections.Generic;
using DAL;

namespace BLL
{
    public static class TagSeeder
    {
        private static readonly string[] Tags = new[]
        {
            "menuUsuarios",
            "menuProductos",
            "menuVentas",
            "menuReportes",
            "menuIdiomas",
            "menuGestionPermisos",
            "menuVerificarIntegridad",
            "menuRecalcularIntegridad",
            "menuBitacora",
            "cerrarSesion",
            "usuario",
            "btnAgregar",
            "btnModificar",
            "btnEliminar",
            "btnGrabar",
            "btnCancelar",
            "btnNuevo",
            "MostrarEliminados",
            "lblUsuario",
            "lblPassword",
            "lblCodigo",
            "lblNombre",
            "lblIdioma",
            "Gestionar",
            "PermisosSimples",
            "CrearPermisoSimple",
            "PermisosCompuestos",
            "SeleccionarSimples",
            "GuardarAsignacion",
            "EliminarGrupo",
            "CrearGrupo",
            "Asignar",
            "SeleccionarUsuario",
            "GruposDisponibles",
            "Agregar",
            "Registrar",
            "Total",
            "GenerarReporte"
        };
        public static void Seed()
        {
            IdiomaAdminDAL dal = new IdiomaAdminDAL();
            dal.AsegurarTags(Tags);
        }
    }
}
