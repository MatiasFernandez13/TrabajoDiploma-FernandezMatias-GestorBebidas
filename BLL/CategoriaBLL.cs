using System;
using System.Collections.Generic;
using DAL;
using BE;
using System.Configuration;

namespace BLL
{
    public class CategoriaBLL
    {
        private readonly CategoriaDAL _dal = new CategoriaDAL();
        public List<Categoria> ObtenerCategorias()
        {
            List<Categoria> cats = _dal.Listar();
            if (cats.Count == 0)
            {
                _dal.SeedDefault();
                cats = _dal.Listar();
            }

            return cats;
        }
    }
}
