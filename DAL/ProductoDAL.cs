using BE;
using System;
using System.Collections.Generic;
using System.Data;

namespace DAL
{
    public class ProductoDAL : MAPPER<Producto>
    {
        public override int Insertar(Producto objeto)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                int id = Insertar(objeto, acceso);
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

        public override int Modificar(Producto objeto)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                int filas = Modificar(objeto, acceso);
                acceso.ConfirmarTransaccion();
                return filas;
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

        public override int Eliminar(Producto objeto)
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            acceso.IniciarTransaccion();
            try
            {
                int filas = Eliminar(objeto, acceso);
                acceso.ConfirmarTransaccion();
                return filas;
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

        public override List<Producto> ListarTodos()
        {
            ACCESO acceso = new ACCESO();
            acceso.Abrir();
            try
            {
                DataTable tabla = acceso.Leer("sp_ListarProductos");
                List<Producto> lista = new List<Producto>();
                foreach (DataRow fila in tabla.Rows)
                    lista.Add(MapearDesdeListar(fila));
                return lista;
            }
            catch (Exception ex)
            {
                throw new Exception("Error en ProductoDAL.ListarTodos", ex);
            }
            finally
            {
                acceso.Cerrar();
            }
        }

        public int Insertar(Producto objeto, ACCESO acceso)
        {
            List<System.Data.SqlClient.SqlParameter> parametros = new List<System.Data.SqlClient.SqlParameter>
            {
                acceso.CrearParametro("@Nombre", objeto.Nombre),
                acceso.CrearParametro("@CategoriaId", objeto.Categoria),
                acceso.CrearParametro("@Precio", objeto.Precio),
                acceso.CrearParametro("@LitrosPorUnidad", objeto.LitrosPorUnidad),
                acceso.CrearParametro("@Stock", objeto.Stock),
                acceso.CrearParametro("@Activo", objeto.Activo),
                acceso.CrearParametro("@DVH", objeto.DVH)
            };
            try
            {
                object resultado = acceso.EscribirEscalar("sp_InsertarProducto", parametros);
                return Convert.ToInt32(resultado);
            }
            catch (Exception ex)
            {
                throw new Exception("Error en ProductoDAL.Insertar", ex);
            }
        }

        public int Modificar(Producto objeto, ACCESO acceso)
        {
            List<System.Data.SqlClient.SqlParameter> parametros = new List<System.Data.SqlClient.SqlParameter>
            {
                acceso.CrearParametro("@Id", objeto.Id),
                acceso.CrearParametro("@Nombre", objeto.Nombre),
                acceso.CrearParametro("@CategoriaId", objeto.Categoria),
                acceso.CrearParametro("@Precio", objeto.Precio),
                acceso.CrearParametro("@LitrosPorUnidad", objeto.LitrosPorUnidad),
                acceso.CrearParametro("@Stock", objeto.Stock),
                acceso.CrearParametro("@DVH", objeto.DVH)
            };
            try
            {
                return acceso.Escribir("sp_ModificarProducto", parametros);
            }
            catch (Exception ex)
            {
                throw new Exception("Error en ProductoDAL.Modificar", ex);
            }
        }

        public int Eliminar(Producto objeto, ACCESO acceso)
        {
            List<System.Data.SqlClient.SqlParameter> parametros = new List<System.Data.SqlClient.SqlParameter>
            {
                acceso.CrearParametro("@Id", objeto.Id)
            };
            try
            {
                return acceso.Escribir("sp_EliminarProducto", parametros);
            }
            catch (Exception ex)
            {
                throw new Exception("Error en ProductoDAL.Eliminar", ex);
            }
        }

        public Producto ObtenerPorId(int id, ACCESO acceso = null)
        {
            bool propioAcceso = acceso == null;
            if (propioAcceso)
            {
                acceso = new ACCESO();
                acceso.Abrir();
            }

            try
            {
                List<System.Data.SqlClient.SqlParameter> parametros = new List<System.Data.SqlClient.SqlParameter>
                {
                    acceso.CrearParametro("@Id", id)
                };
                DataTable tabla = acceso.Leer("sp_ObtenerProductoPorId", parametros);
                return tabla.Rows.Count > 0 ? MapearDesdeDetalle(tabla.Rows[0]) : null;
            }
            catch (Exception ex)
            {
                throw new Exception("Error en ProductoDAL.ObtenerPorId", ex);
            }
            finally
            {
                if (propioAcceso)
                    acceso.Cerrar();
            }
        }

        private static Producto MapearDesdeListar(DataRow fila) => Mapear(fila);
        private static Producto MapearDesdeDetalle(DataRow fila) => Mapear(fila);
        private static Producto Mapear(DataRow fila)
        {
            return new Producto
            {
                Id = Convert.ToInt32(fila["Id"]),
                Nombre = fila["Nombre"].ToString(),
                Categoria = Convert.ToInt32(fila["CategoriaId"]),
                CategoriaNombre = fila.Table.Columns.Contains("CategoriaNombre") && fila["CategoriaNombre"] != DBNull.Value ? fila["CategoriaNombre"].ToString() : string.Empty,
                Precio = Convert.ToDecimal(fila["Precio"]),
                LitrosPorUnidad = Convert.ToDouble(fila["LitrosPorUnidad"]),
                Stock = Convert.ToInt32(fila["Stock"]),
                Activo = Convert.ToBoolean(fila["Activo"]),
                DVH = fila["DVH"] != DBNull.Value ? Convert.ToDecimal(fila["DVH"]) : 0
            };
        }
    }
}
