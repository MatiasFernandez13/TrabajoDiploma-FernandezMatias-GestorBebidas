using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;
using BE;
using BLL;
using DAL;
using BE.Permisos;

namespace UI
{
    public partial class FrmAsignarPermisos : FrmBase
    {
        private readonly UsuarioBLL _usuarioBLL =
            new UsuarioBLL("Data Source=localhost;Initial Catalog=BaseGestionBebidasMF;Integrated Security=True");

        private readonly PermisoBLL _permisoBLL = new PermisoBLL();
        private readonly UsuarioPermisoBLL _usuarioPermisoBLL = new UsuarioPermisoBLL();

        private List<Usuario> _usuarios = new List<Usuario>();
        private List<GrupoPermiso> _grupos = new List<GrupoPermiso>();

        public int Id { get; set; }

        public FrmAsignarPermisos()
        {
            InitializeComponent();
        }

        private void FrmAsignarPermisos_Load(object sender, EventArgs e)
        {
            CargarUsuarios();
            CargarGrupos();
        }

        private void CargarUsuarios()
        {
            _usuarios = _usuarioBLL.ObtenerTodos();

            cbUsuarios.DataSource = null;
            cbUsuarios.DataSource = _usuarios;
            cbUsuarios.DisplayMember = "NombreUsuario";
            cbUsuarios.ValueMember = "Id";
        }

        private void CargarGrupos()
        {
            var gruposDesdeDb = _permisoBLL.ObtenerGruposDePermisos();

            _grupos = gruposDesdeDb
                .OfType<GrupoPermiso>()
                .GroupBy(g => g.Nombre)
                .Select(g => g.First())
                .ToList();

            clbGrupos.Items.Clear();

            foreach (var grupo in _grupos)
            {
                clbGrupos.Items.Add(grupo);
            }
        }

        private void cbUsuarios_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (cbUsuarios.SelectedItem is not Usuario usuario)
                return;

            var idsAsignados = _usuarioPermisoBLL.ObtenerGrupos(usuario.Id);

            for (int i = 0; i < clbGrupos.Items.Count; i++)
            {
                if (clbGrupos.Items[i] is GrupoPermiso grupo)
                {
                    clbGrupos.SetItemChecked(i, idsAsignados.Contains(grupo.Id));
                }
            }
        }

        private void btnGuardar_Click(object sender, EventArgs e)
        {
            if (cbUsuarios.SelectedItem is not Usuario usuario)
            {
                MessageBox.Show("Seleccione un usuario.");
                return;
            }

            var seleccionados = new List<int>();

            foreach (var item in clbGrupos.CheckedItems)
            {
                if (item is GrupoPermiso grupo)
                    seleccionados.Add(grupo.Id);
            }

            _usuarioPermisoBLL.AsignarGrupos(usuario.Id, seleccionados);

            MessageBox.Show("Permisos asignados correctamente.");
        }
    }
}