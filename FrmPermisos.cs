using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;
using BLL;
using BE;
using BE.Permisos;
namespace UI
{
    public partial class FrmPermisos : FrmBase
    {
        private readonly PermisoBLL _permisoBLL = new PermisoBLL();
        private readonly UsuarioBLL _usuarioBLL = new UsuarioBLL(System.Configuration.ConfigurationManager.ConnectionStrings["MiConexion"].ConnectionString);
        private readonly UsuarioPermisoBLL _usuarioPermisoBLL = new UsuarioPermisoBLL();
        private List<PermisoSimple> _simples = new List<PermisoSimple>();
        private List<GrupoPermiso> _grupos = new List<GrupoPermiso>();
        private List<Usuario> _usuarios = new List<Usuario>();
        public FrmPermisos()
        {
            InitializeComponent();
        }
        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);
            lstCompuestos.Format += (s, ev) =>
            {
                if (ev.ListItem is GrupoPermiso gp)
                    ev.Value = gp.Nombre.Equals("Administracion", StringComparison.OrdinalIgnoreCase) ? "Gestion Administracion" : gp.Nombre;
            };
            clbGruposAsignar.Format += (s, ev) =>
            {
                if (ev.ListItem is GrupoPermiso gp)
                    ev.Value = gp.Nombre.Equals("Administracion", StringComparison.OrdinalIgnoreCase) ? "Gestion Administracion" : gp.Nombre;
            };
            CargarDatos();
            // Tab gating por permisos
            var puedeAsignar = SERVICIOS.PermissionService.Has("Permisos.Asignar") || SERVICIOS.PermissionService.Has("AccesoPermisos");
            var puedeGestionar = SERVICIOS.PermissionService.Has("Permisos.Gestionar");
            foreach (TabPage tp in tabControl.TabPages)
            {
                if (tp.Tag?.ToString() == "Asignar") tp.Enabled = puedeAsignar;
                if (tp.Tag?.ToString() == "Gestionar") tp.Enabled = puedeGestionar;
            }
            // eliminar pestaña Asignar para gestión unificada
            // var asignar = tabControl.TabPages.Cast<TabPage>().FirstOrDefault(t => t.Tag?.ToString() == "Asignar");
            // if (asignar != null) tabControl.TabPages.Remove(asignar);
        }
        private void CargarDatos()
        {
            _simples = _permisoBLL.ObtenerPermisosSimples();
            var borrar = new[]{
                "FullUser","GrupeteTest","ModElim","Pruebita","ReportesLectura","test1","Vender"
            };
            foreach (var n in borrar) _permisoBLL.EliminarGrupoPorNombre(n);
            _grupos = _permisoBLL.ObtenerGruposDePermisos().OfType<GrupoPermiso>().GroupBy(g=>g.Nombre).Select(g=>g.First()).ToList();
            var orden = new List<string>{
                "Gestion Usuarios","Gestion Productos","Gestion Venta","Gestion Reportes",
                "Gestion Idioma","Gestion Permisos","Administracion","Base","Vendedor","Supervisor","Administrador"
            };
            _grupos = _grupos
                .OrderBy(g => {
                    var idx = orden.FindIndex(o => o.Equals(g.Nombre, StringComparison.OrdinalIgnoreCase));
                    return idx >= 0 ? idx : int.MaxValue;
                })
                .ThenBy(g => g.Nombre)
                .ToList();
            _usuarios = _usuarioBLL.ObtenerTodos().Where(u=>u.Activo).ToList();
            lstSimples.DataSource = null;
            lstCompuestos.DataSource = null;
            lstCompuestos.DataSource = _grupos;
            lstCompuestos.DisplayMember = "Nombre";
            ConstruirArbolPermisos();
            lstUsuarios.DataSource = null;
            lstUsuarios.DataSource = _usuarios;
            lstUsuarios.DisplayMember = "NombreUsuario";
            lstUsuarios.ValueMember = "Id";
            clbGruposAsignar.Items.Clear();
            foreach (var g in _grupos) clbGruposAsignar.Items.Add(g);
            clbGruposAsignar.DisplayMember = "Nombre";
        }
        private void ConstruirArbolPermisos()
        {
            tvPermisos.BeginUpdate();
            tvPermisos.Nodes.Clear();
            var raiz = new TreeNode("Catálogo");
            var catalogo = new Dictionary<string, List<string>>
            {
                { "Usuarios", new List<string>{ "AccesoUsuarios","Usuarios.Alta","Usuarios.Modificar","Usuarios.Baja" } },
                { "Productos", new List<string>{ "AccesoProductos","Productos.Ver","Productos.Agregar","Productos.Modificar","Productos.Eliminar" } },
                { "Ventas", new List<string>{ "AccesoVentas","Ventas.Realizar" } },
                { "Reportes", new List<string>{ "AccesoReportes","Reportes.Ver","Reportes.Modificar","Reportes.Eliminar" } },
                { "Idiomas", new List<string>{ "AccesoIdiomas" } },
                { "Permisos", new List<string>{ "AccesoPermisos","Permisos.Asignar","Permisos.Gestionar" } },
                { "Administracion", new List<string>{ "AccesoAdministracion","AccesoBitacora","AccesoVerificarIntegridad","AccesoRecalcularIntegridad" } }
            };
            var disponibles = _simples.Select(s => s.Nombre).ToHashSet(StringComparer.OrdinalIgnoreCase);
            foreach (var kv in catalogo)
            {
                var nodoCat = new TreeNode(kv.Key);
                foreach (var nombre in kv.Value)
                {
                    // muestra aunque no exista aún en DB
                    if (disponibles.Contains(nombre) || true)
                        nodoCat.Nodes.Add(new TreeNode(nombre){ Tag = new PermisoSimple{ Nombre = nombre } });
                }
                raiz.Nodes.Add(nodoCat);
            }
            tvPermisos.Nodes.Add(raiz);
            tvPermisos.ExpandAll();
            tvPermisos.EndUpdate();
        }
        private void tvPermisos_AfterCheck(object sender, TreeViewEventArgs e)
        {
            // marcar/desmarcar hijos
            foreach (TreeNode child in e.Node.Nodes)
                child.Checked = e.Node.Checked;
        }
        private void lstCompuestos_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (lstCompuestos.SelectedItem is GrupoPermiso grupoSel)
            {
                var simplesGrupo = grupoSel.Hijos.OfType<PermisoSimple>().Select(h => h.Nombre).ToHashSet(StringComparer.OrdinalIgnoreCase);
                foreach (TreeNode root in tvPermisos.Nodes)
                {
                    foreach (TreeNode n in root.Nodes)
                    {
                        foreach (TreeNode c in n.Nodes)
                            c.Checked = simplesGrupo.Contains(c.Text);
                    }
                }
            }
        }
        private void btnCrearSimple_Click(object sender, EventArgs e)
        {
            var nombre = txtPermisoSimpleNombre.Text.Trim();
            if (string.IsNullOrEmpty(nombre))
            {
                MessageBox.Show("Ingrese nombre del permiso simple.");
                return;
            }
            try
            {
                var simple = new PermisoSimple { Nombre = nombre };
                _permisoBLL.CrearPermisoSimple(simple);
                CargarDatos();
                txtPermisoSimpleNombre.Clear();
                MessageBox.Show("Permiso simple creado.");
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error al crear permiso simple: " + ex.Message);
            }
        }
        private void btnCrearGrupo_Click(object sender, EventArgs e)
        {
            var nombre = txtGrupoNombre.Text.Trim();
            if (string.IsNullOrEmpty(nombre))
            {
                MessageBox.Show("Ingrese nombre del grupo.");
                return;
            }
            // selecciona simples desde el árbol catálogo
            var seleccionados = new List<string>();
            foreach (TreeNode root in tvPermisos.Nodes)
            {
                foreach (TreeNode n in root.Nodes)
                {
                    foreach (TreeNode c in n.Nodes)
                    {
                        if (c.Checked && c.Tag is PermisoSimple ps)
                            seleccionados.Add(ps.Nombre);
                    }
                }
            }
            if (seleccionados.Count == 0)
            {
                MessageBox.Show("Seleccione al menos un permiso simple.");
                return;
            }
            try
            {
                var grupo = new GrupoPermiso { Nombre = nombre };
                foreach (var nom in seleccionados) grupo.Agregar(new PermisoSimple { Nombre = nom });
                _permisoBLL.CrearGrupoPermiso(grupo);
                CargarDatos();
                txtGrupoNombre.Clear();
                foreach (TreeNode root in tvPermisos.Nodes)
                {
                    foreach (TreeNode n in root.Nodes)
                        n.Checked = false;
                }
                MessageBox.Show("Grupo creado.");
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error al crear grupo: " + ex.Message);
            }
        }
        private void btnGuardarGrupo_Click(object sender, EventArgs e)
        {
            if (lstCompuestos.SelectedItem is not GrupoPermiso grupoSel)
            {
                MessageBox.Show("Seleccione un grupo para actualizar.");
                return;
            }
            var seleccionados = new List<string>();
            foreach (TreeNode root in tvPermisos.Nodes)
            {
                foreach (TreeNode n in root.Nodes)
                {
                    foreach (TreeNode c in n.Nodes)
                    {
                        if (c.Checked && c.Tag is PermisoSimple ps)
                            seleccionados.Add(ps.Nombre);
                    }
                }
            }
            try
            {
                _permisoBLL.ActualizarGrupoSimples(grupoSel.Nombre, seleccionados);
                CargarDatos();
                MessageBox.Show("Grupo actualizado.");
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error al actualizar grupo: " + ex.Message);
            }
        }
        private void btnEliminarGrupo_Click(object sender, EventArgs e)
        {
            if (lstCompuestos.SelectedItem is not GrupoPermiso grupoSel)
            {
                MessageBox.Show("Seleccione un grupo para eliminar.");
                return;
            }
            var r = MessageBox.Show($"¿Eliminar el grupo \"{grupoSel.Nombre}\"?", "Confirmar", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
            if (r != DialogResult.Yes) return;
            try
            {
                _permisoBLL.EliminarGrupoPorNombre(grupoSel.Nombre);
                CargarDatos();
                MessageBox.Show("Grupo eliminado.");
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error al eliminar grupo: " + ex.Message);
            }
        }
        private void lstUsuarios_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (lstUsuarios.SelectedItem is Usuario u)
            {
                var idsAsignados = new UsuarioPermisoBLL().ObtenerGrupos(u.Id);
                for (int i = 0; i < clbGruposAsignar.Items.Count; i++)
                {
                    if (clbGruposAsignar.Items[i] is GrupoPermiso g)
                        clbGruposAsignar.SetItemChecked(i, idsAsignados.Contains(g.Id));
                }
            }
        }
        private void btnGuardarAsignacion_Click(object sender, EventArgs e)
        {
            if (lstUsuarios.SelectedItem is not Usuario usuario)
            {
                MessageBox.Show("Seleccione un usuario.");
                return;
            }
            var seleccionados = new List<int>();
            foreach (var item in clbGruposAsignar.CheckedItems)
            {
                if (item is GrupoPermiso g) seleccionados.Add(g.Id);
            }
            try
            {
                _usuarioPermisoBLL.AsignarGrupos(usuario.Id, seleccionados);
                MessageBox.Show("Permisos asignados.");
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error al asignar permisos: " + ex.Message);
            }
        }
    }
}
