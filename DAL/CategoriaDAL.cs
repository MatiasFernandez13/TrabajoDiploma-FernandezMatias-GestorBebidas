using System;
using System.Collections.Generic;
using System.Data;
using BE;

namespace DAL
{
    public class CategoriaDAL
    {
        public List<Categoria> Listar()
        {
            List<Categoria> lista = new List<Categoria>();
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            try
            {
                DataTable tabla;
                try
                {
                    tabla = acceso.Leer("sp_Categorias_Listar");
                }
                catch
                {
                    string sql = "SELECT Id, Nombre FROM Categorias ORDER BY Nombre";
                    tabla = acceso.LeerSQL(sql);
                }

                foreach (DataRow fila in tabla.Rows)
                {
                    lista.Add(new Categoria { Id = Convert.ToInt32(fila["Id"]), Nombre = fila["Nombre"].ToString() });
                }
            }
            finally
            {
                acceso.Cerrar();
            }

            return lista;
        }

        public void SeedDefault()
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            try
            {
                string sql = @"
                            IF NOT EXISTS (SELECT 1 FROM Categorias WHERE Nombre = N'Alcohólica')
                                INSERT INTO Categorias (Nombre) VALUES (N'Alcohólica');
                            IF NOT EXISTS (SELECT 1 FROM Categorias WHERE Nombre = N'No Alcohólica')
                                INSERT INTO Categorias (Nombre) VALUES (N'No Alcohólica');";
                acceso.EscribirSQL(sql);
            }
            catch (Exception ex)
            {
                throw new Exception("Error en CategoriaDAL.SeedDefault", ex);
            }
            finally
            {
                acceso.Cerrar();
            }
        }
    }
}
