using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace DAL
{
    public class ACCESO
    {
        private const string CONNECTION_STRING = "Data Source=localhost;Initial Catalog=BaseGestionBebidasMF;Integrated Security=True";
        private SqlConnection conexion;
        private SqlTransaction transaccion;
        public void Abrir()
        {
            conexion = new SqlConnection(CONNECTION_STRING);
            conexion.Open();
        }

        public void Cerrar()
        {
            if (conexion != null)
            {
                conexion.Close();
                conexion = null;
            }
        }

        public void IniciarTransaccion()
        {
            transaccion = conexion.BeginTransaction();
        }

        public void ConfirmarTransaccion()
        {
            transaccion.Commit();
            transaccion = null;
        }

        public void CancelarTransaccion()
        {
            try
            {
                transaccion?.Rollback();
            }
            catch
            {
            }

            transaccion = null;
        }

        private SqlCommand CrearComando(string sql, List<SqlParameter> parametros, CommandType tipo)
        {
            SqlCommand cmd = new SqlCommand(sql, conexion)
            {
                CommandType = tipo
            };
            if (transaccion != null)
                cmd.Transaction = transaccion;
            if (parametros != null)
                cmd.Parameters.AddRange(parametros.ToArray());
            return cmd;
        }

        public int Escribir(string nombreSP, List<SqlParameter> parametros = null)
        {
            SqlCommand cmd = CrearComando(nombreSP, parametros, CommandType.StoredProcedure);
            try
            {
                return cmd.ExecuteNonQuery();
            }
            finally
            {
                cmd.Parameters.Clear();
            }
        }

        public object EscribirEscalar(string nombreSP, List<SqlParameter> parametros = null)
        {
            SqlCommand cmd = CrearComando(nombreSP, parametros, CommandType.StoredProcedure);
            try
            {
                return cmd.ExecuteScalar();
            }
            finally
            {
                cmd.Parameters.Clear();
            }
        }

        public DataTable Leer(string nombreSP, List<SqlParameter> parametros = null)
        {
            SqlDataAdapter adaptador = new SqlDataAdapter(CrearComando(nombreSP, parametros, CommandType.StoredProcedure));
            DataTable tabla = new DataTable();
            adaptador.Fill(tabla);
            return tabla;
        }

        public int EscribirSQL(string sql, List<SqlParameter> parametros = null)
        {
            SqlCommand cmd = CrearComando(sql, parametros, CommandType.Text);
            try
            {
                return cmd.ExecuteNonQuery();
            }
            finally
            {
                cmd.Parameters.Clear();
            }
        }

        public DataTable LeerSQL(string sql, List<SqlParameter> parametros = null)
        {
            SqlDataAdapter adaptador = new SqlDataAdapter(CrearComando(sql, parametros, CommandType.Text));
            DataTable tabla = new DataTable();
            adaptador.Fill(tabla);
            return tabla;
        }

        public void RecalcularDVV(string tabla)
        {
            List<SqlParameter> parametros = new List<SqlParameter>
            {
                CrearParametro("@Tabla", tabla)
            };
            Escribir("sp_RecalcularDVV", parametros);
        }

        public SqlParameter CrearParametro(string nombre, string valor) => new SqlParameter(nombre, DbType.String)
        {
            Value = (object)valor ?? DBNull.Value
        };
        public SqlParameter CrearParametro(string nombre, int valor) => new SqlParameter(nombre, DbType.Int32)
        {
            Value = valor
        };
        public SqlParameter CrearParametro(string nombre, decimal valor)
        {
            SqlParameter p = new SqlParameter(nombre, System.Data.SqlDbType.Decimal)
            {
                Value = valor,
                Precision = 38,
                Scale = 0
            };
            return p;
        }

        public SqlParameter CrearParametro(string nombre, double valor) => new SqlParameter(nombre, DbType.Double)
        {
            Value = valor
        };
        public SqlParameter CrearParametro(string nombre, float valor) => new SqlParameter(nombre, DbType.Single)
        {
            Value = valor
        };
        public SqlParameter CrearParametro(string nombre, bool valor) => new SqlParameter(nombre, DbType.Boolean)
        {
            Value = valor
        };
        public SqlParameter CrearParametro(string nombre, DateTime valor) => new SqlParameter(nombre, DbType.DateTime)
        {
            Value = valor
        };
        public SqlParameter CrearParametro(string nombre, int? valor) => new SqlParameter(nombre, DbType.Int32)
        {
            Value = (object)valor ?? DBNull.Value
        };
        public SqlParameter CrearParametro(string nombre, decimal? valor)
        {
            SqlParameter p = new SqlParameter(nombre, System.Data.SqlDbType.Decimal)
            {
                Value = (object)valor ?? DBNull.Value,
                Precision = 38,
                Scale = 0
            };
            return p;
        }

        public SqlParameter CrearParametro(string nombre, DateTime? valor) => new SqlParameter(nombre, DbType.DateTime)
        {
            Value = (object)valor ?? DBNull.Value
        };
        public SqlParameter CrearParametro(string nombre, bool? valor) => new SqlParameter(nombre, DbType.Boolean)
        {
            Value = (object)valor ?? DBNull.Value
        };
    }
}
