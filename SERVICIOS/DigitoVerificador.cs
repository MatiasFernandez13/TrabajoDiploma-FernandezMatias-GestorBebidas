using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;
using System.Data;


namespace SERVICIOS
{
    public static class DigitoVerificador
    {
        private static readonly string _connectionString = ConfigurationManager.ConnectionStrings["MiConexion"].ConnectionString;
        public static long CalcularDVH(string datos)
        {
            if (string.IsNullOrEmpty(datos))
                return 0;

            using (SHA256 sha = SHA256.Create())
            {
                byte[] bytes = Encoding.UTF8.GetBytes(datos);
                byte[] hash = sha.ComputeHash(bytes);

                long dvh = BitConverter.ToInt64(hash, 0);
                return dvh < 0 ? -dvh : dvh; 
            }
        }

        public static void RecalcularDVV(string tabla)
        {
            long sumaDVH = 0;

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                conn.Open();

                using (SqlCommand cmd = new SqlCommand($"SELECT SUM(DVH) FROM {tabla}", conn))
                {
                    var result = cmd.ExecuteScalar();
                    sumaDVH = result != DBNull.Value ? Convert.ToInt64(result) : 0;
                }

                string query = @"
                    IF EXISTS (SELECT 1 FROM DVV WHERE Tabla = @Tabla)
                        UPDATE DVV SET ValorDVV = @ValorDVV WHERE Tabla = @Tabla
                    ELSE
                        INSERT INTO DVV (Tabla, ValorDVV) VALUES (@Tabla, @ValorDVV)";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Tabla", tabla);
                    cmd.Parameters.AddWithValue("@ValorDVV", sumaDVH);
                    cmd.ExecuteNonQuery();
                }
            }
        }
    }
}
