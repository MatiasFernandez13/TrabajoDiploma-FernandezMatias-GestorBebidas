using System;
using System.Collections.Generic;

namespace DAL
{
    public static class DigitoVerificadorDAL
    {
        public static void RecalcularDVV(string tabla, ACCESO acceso)
        {
            if (string.IsNullOrWhiteSpace(tabla))
                throw new ArgumentException("El nombre de tabla es obligatorio.", nameof(tabla));
            List<System.Data.SqlClient.SqlParameter> parametros = new List<System.Data.SqlClient.SqlParameter>
            {
                acceso.CrearParametro("@Tabla", tabla)
            };
            try
            {
                acceso.Escribir("sp_RecalcularDVV", parametros);
            }
            catch (Exception ex)
            {
                throw new Exception($"Error al recalcular DVV de la tabla '{tabla}'", ex);
            }
        }
    }
}
