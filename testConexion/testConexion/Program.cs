using System;
using System.Data.SqlClient;
using System.Data;

class Program
{
    static void Main()
    {
        string connectionString = "Data Source=localhost;Initial Catalog=BaseGestionBebidasMF;Integrated Security=True";

        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            try
            {
                connection.Open();
                Console.WriteLine("Conexión exitosa a la base de datos.");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}");
            }
        }

        Console.ReadLine();
    }
}
