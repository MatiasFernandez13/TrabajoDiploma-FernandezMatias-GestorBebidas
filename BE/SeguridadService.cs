using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace BE
{
    public static class SeguridadService
    {
        public static string GenerarHashSHA512(string input)
        {
            using (SHA512 sha512 = SHA512.Create())
            {
                byte[] bytes = Encoding.UTF8.GetBytes(input);
                byte[] hash = sha512.ComputeHash(bytes);
                return Convert.ToBase64String(hash);
            }
        }

        public static string GenerarHashConSalt(string password, out string salt)
        {
            salt = Guid.NewGuid().ToString(); 
            return GenerarHashSHA512(password + salt);
        }

        public static bool VerificarPassword(string passwordIngresada, string hashAlmacenado, string salt)
        {
            string hashIngresado = GenerarHashSHA512(passwordIngresada + salt);
            return hashIngresado == hashAlmacenado;
        }
    }
}
