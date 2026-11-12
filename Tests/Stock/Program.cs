using System;
using System.IO;
using System.Configuration;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;
using BE;
using BLL;
using SERVICIOS;

internal static class Program
{
    private static readonly string Conexion = ConfigurationManager.ConnectionStrings["MiConexion"].ConnectionString;
    private static int pruebas;
    private static readonly ProductoBLL Productos = new ProductoBLL();
    private static readonly LoteBLL Lotes = new LoteBLL();
    private static readonly VentaBLL Ventas = new VentaBLL();
    private static int usuario;
    [STAThread]
    private static void Main(string[] args)
    {
        SqlConnectionStringBuilder configuracion = new SqlConnectionStringBuilder(Conexion);
        if (!configuracion.InitialCatalog.StartsWith("GestorBebidasPruebasStock_", StringComparison.Ordinal))
            throw new InvalidOperationException("Las pruebas solo pueden ejecutarse en su base temporal.");
        string salida = args.Length > 0 ? args[0] : Path.GetTempPath();
        Directory.CreateDirectory(salida);
        Application.SetHighDpiMode(HighDpiMode.PerMonitorV2);
        Application.EnableVisualStyles();
        (bool ok, string mensaje, Usuario usuario) login = new UsuarioBLL().IniciarSesion("admin", "admin123");
        Verificar(login.ok, "login");
        usuario = login.usuario.Id;
        string sufijo = Guid.NewGuid().ToString("N").Substring(0, 8);
        Producto producto = NuevoProducto("Bebída Árbol " + sufijo, 1, 5, "L-1");
        Lote primero = Lotes.ListarPorProducto(producto.Id).Single();
        Rechazar(() => NuevoProducto(" BEBIDA-ARBOL" + sufijo + " ", 1, 1, "OTRO"), "duplicado normalizado");
        Producto presentacion = NuevoProducto("Bebída Árbol " + sufijo, 2, 2, "L-1");
        Verificar(presentacion.Id != producto.Id, "presentación distinta");
        presentacion.LitrosPorUnidad = 1;
        Rechazar(() => Productos.Modificar(new SolicitudProducto { Producto = presentacion }), "duplicado al modificar");
        ResultadoIngresoLote ingreso = Lotes.Agregar(NuevoLote(producto.Id, " l 1 ", 3));
        Verificar(ingreso.Consolidado && ingreso.Lote.Id == primero.Id, "mismo lote se consolida");
        Verificar(StockLote(primero.Id) == 8 && Lotes.ListarPorProducto(producto.Id).Count == 1, "suma sin reemplazar ni duplicar");
        Lote conflicto = NuevoLote(producto.Id, "L-1", 4); conflicto.FechaVencimiento = DateTime.Today.AddDays(31);
        Rechazar(() => Lotes.Agregar(conflicto), "rechaza vencimiento diferente");
        Verificar(StockLote(primero.Id) == 8, "rechazo no altera stock");
        Lote futuro = NuevoLote(producto.Id, "FUTURO", 2); futuro.FechaIngreso = DateTime.Today.AddDays(1);
        Rechazar(() => Lotes.Agregar(futuro), "rechaza ingreso futuro");
        Rechazar(() => Lotes.Agregar(NuevoLote(producto.Id, "VACIO", 0)), "rechaza cantidad cero");
        Lote segundo = NuevoLote(producto.Id, "L-2", 6); Lotes.Agregar(segundo);
        SeleccionLotesBLL seleccion = new SeleccionLotesBLL();
        SolicitudSeleccionLotes solicitud = new SolicitudSeleccionLotes { Producto = Productos.ObtenerPorId(producto.Id), Cantidad = 11, LotePreferidoId = primero.Id, Lotes = Lotes.ListarPorProducto(producto.Id) };
        OpcionLotesVenta combinada = seleccion.CrearOpciones(solicitud).Single();
        Verificar(combinada.Detalles.Count == 2 && combinada.Detalles.Sum(d => d.Cantidad) == 11, "sugiere combinación suficiente");
        Verificar(combinada.Detalles.Single(d => d.LoteId == primero.Id).Cantidad == 8, "respeta límite del lote preferido");
        solicitud.Reservas = combinada.Detalles; solicitud.Cantidad = 4;
        Verificar(seleccion.CrearOpciones(solicitud).Count == 0, "descuenta reservas del carrito");
        solicitud.Cantidad = 3;
        Verificar(seleccion.CrearOpciones(solicitud).Single().Detalles.Single().LoteId == segundo.Id, "sugiere saldo de otro lote");
        Venta venta = Ventas.ConfirmarVenta(new Venta { UsuarioId = usuario, Detalles = combinada.Detalles });
        Verificar(StockLote(primero.Id) == 0 && StockLote(segundo.Id) == 3, "venta descuenta exactamente la combinación elegida");
        Verificar(Escalar("SELECT COUNT(*) FROM dbo.DetalleVentaLote WHERE VentaId=" + venta.Id) == 2, "persiste lotes de venta");
        Verificar(Productos.ObtenerPorId(producto.Id).Stock == 3, "sincroniza stock de producto");
        Verificar(DigitoVerificador.VerificarDVV("Productos", out decimal calculado, out decimal guardado), "integridad después de alta de lotes y venta");
        int ventasAntes = Escalar("SELECT COUNT(*) FROM dbo.Ventas");
        Rechazar(() => Ventas.ConfirmarVenta(new Venta { UsuarioId = usuario, Detalles = new List<VentaDetalle> { Detalle(producto, segundo, 2), Detalle(producto, primero, 1) } }), "stock agotado revierte toda la venta");
        Verificar(StockLote(segundo.Id) == 3 && Escalar("SELECT COUNT(*) FROM dbo.Ventas") == ventasAntes, "rollback sin venta parcial");
        Rechazar(() => Ventas.ConfirmarVenta(new Venta { UsuarioId = usuario, Detalles = new List<VentaDetalle> { Detalle(presentacion, segundo, 1) } }), "rechaza lote de otro producto");
        Rechazar(() => Ventas.ConfirmarVenta(new Venta { UsuarioId = usuario, Detalles = new List<VentaDetalle> { new VentaDetalle { ProductoId = producto.Id, Cantidad = 1, PrecioUnitario = 10 } } }), "no pierde selección de lote");
        using (SqlConnection conexion = new SqlConnection(Conexion))
        {
            conexion.Open();
            using (SqlTransaction transaccion = conexion.BeginTransaction())
            using (SqlCommand comando = new SqlCommand("UPDATE dbo.Lote SET FechaVencimiento=DATEADD(day,-1,CONVERT(date,GETDATE())) WHERE Id=" + segundo.Id, conexion, transaccion))
            {
                comando.ExecuteNonQuery(); transaccion.Commit();
            }
        }
        solicitud.Reservas.Clear(); solicitud.Lotes = Lotes.ListarPorProducto(producto.Id); solicitud.Cantidad = 1;
        Verificar(seleccion.CrearOpciones(solicitud).Count == 0, "no ofrece lotes vencidos");
        Rechazar(() => Ventas.ConfirmarVenta(new Venta { UsuarioId = usuario, Detalles = new List<VentaDetalle> { Detalle(producto, segundo, 1) } }), "base rechaza venta de lote vencido");
        Producto concurrente = NuevoProducto("Concurrente " + sufijo, 1, 5, "C1");
        Lote loteConcurrente = Lotes.ListarPorProducto(concurrente.Id).Single();
        Barrier barrera = new Barrier(2);
        Task<bool>[] tareas = new Task<bool>[2];
        for (int i = 0; i < 2; i++)
            tareas[i] = Task.Run(() => { barrera.SignalAndWait(); try { new VentaBLL().ConfirmarVenta(new Venta { UsuarioId = usuario, Detalles = new List<VentaDetalle> { Detalle(concurrente, loteConcurrente, 4) } }); return true; } catch { return false; } });
        Task.WaitAll(tareas);
        Verificar(tareas.Count(t => t.Result) == 1 && StockLote(loteConcurrente.Id) == 1, "dos ventas simultáneas no sobrevendan");
        Rechazar(() => Ejecutar("INSERT dbo.Lote(ProductoId,NumeroLote,FechaIngreso,FechaVencimiento,Cantidad,Activo) VALUES(" + producto.Id + ",N'l1',CONVERT(date,GETDATE()),DATEADD(day,30,CONVERT(date,GETDATE())),1,1)"), "restricción única de lote");
        Rechazar(() => Ejecutar("UPDATE dbo.Lote SET Cantidad=-1 WHERE Id=" + primero.Id), "restricción no negativo");
        Producto parcial = NuevoProducto("Rollback " + sufijo, 1, 5, "R1");
        Lote loteA = Lotes.ListarPorProducto(parcial.Id).Single();
        Lote loteB = NuevoLote(parcial.Id, "R2", 1); Lotes.Agregar(loteB);
        int ventasPrevias = Escalar("SELECT COUNT(*) FROM dbo.Ventas");
        Rechazar(() => Ventas.ConfirmarVenta(new Venta { UsuarioId = usuario, Detalles = new List<VentaDetalle> { Detalle(parcial,loteA,2), Detalle(parcial,loteB,2) } }), "falla después de descontar el primer lote");
        Verificar(StockLote(loteA.Id)==5 && StockLote(loteB.Id)==1 && Escalar("SELECT COUNT(*) FROM dbo.Ventas")==ventasPrevias, "revierte descuentos y encabezado completos");
        Productos.Modificar(new SolicitudProducto { Producto=Productos.ObtenerPorId(parcial.Id), Lote=NuevoLote(parcial.Id,"R1",3) });
        Verificar(StockLote(loteA.Id)==8, "editar producto también suma al lote existente");
        Verificar(Lotes.BuscarExistente(new Lote { ProductoId=parcial.Id, NumeroLote="r 1" }).Id==loteA.Id, "consulta lote equivalente para completar vencimiento");
        Lotes.ActualizarCantidad(new Lote { Id=loteB.Id, ProductoId=parcial.Id, Cantidad=4 });
        Verificar(Productos.ObtenerPorId(parcial.Id).Stock==12, "ajuste de lote sincroniza stock");
        Rechazar(() => Lotes.Eliminar(new Lote { Id=loteB.Id, ProductoId=producto.Id }), "rechaza baja de lote de otro producto");
        Lotes.Eliminar(loteB);
        Verificar(Productos.ObtenerPorId(parcial.Id).Stock==8 && DigitoVerificador.VerificarDVV("Productos",out decimal c,out decimal g), "baja de lote sincroniza stock e integridad");
        Rechazar(() => Lotes.Agregar(NuevoLote(parcial.Id,"R2",1)), "no reutiliza lote dado de baja");
        Lote expirado = NuevoLote(parcial.Id,"X",1); expirado.FechaIngreso=DateTime.Today.AddDays(-10);expirado.FechaVencimiento=DateTime.Today.AddDays(-1);
        Rechazar(() => Lotes.Agregar(expirado), "rechaza alta de lote vencido");
        Rechazar(() => Ejecutar("INSERT dbo.Productos(Nombre,CategoriaId,Precio,LitrosPorUnidad,Stock,Activo,DVH) VALUES(N'BEBIDA-ARBOL"+sufijo+"',1,10,1,0,1,0)"), "base rechaza duplicado directo");
        using (UI.FrmProductos formulario = new UI.FrmProductos())
        {
            formulario.WindowState = FormWindowState.Normal; formulario.ClientSize = new Size(1440, 900);
            formulario.ShowInTaskbar = false; formulario.StartPosition = FormStartPosition.Manual; formulario.Location = new Point(-20000,-20000);
            formulario.Show(); Application.DoEvents(); formulario.PerformLayout();
            TableLayoutPanel panel = formulario.Controls.OfType<TableLayoutPanel>().Single();
            Verificar(panel.ColumnCount == 8 && panel.RowCount == 2, "formulario alineado en filas y columnas");
            using (Bitmap captura = new Bitmap(formulario.Width, formulario.Height))
            {
                formulario.DrawToBitmap(captura, new Rectangle(Point.Empty, captura.Size));
                captura.Save(Path.Combine(salida,"productos.png"));
            }
        }
        Console.WriteLine("TOTAL: " + pruebas + " pruebas aprobadas");
    }
    private static Producto NuevoProducto(string nombre, double litros, int cantidad, string numero)
    {
        Producto producto = new Producto { Nombre = nombre, Categoria = 1, Precio = 10, LitrosPorUnidad = litros, Activo = true };
        Productos.AgregarConLote(new SolicitudProducto { Producto = producto, Lote = NuevoLote(0, numero, cantidad) });
        return Productos.ObtenerPorId(producto.Id);
    }
    private static Lote NuevoLote(int producto, string numero, int cantidad) => new Lote { ProductoId = producto, NumeroLote = numero, Cantidad = cantidad, FechaIngreso = DateTime.Today, FechaVencimiento = DateTime.Today.AddDays(30), Activo = true };
    private static VentaDetalle Detalle(Producto producto, Lote lote, int cantidad) => new VentaDetalle { ProductoId = producto.Id, ProductoNombre = producto.Nombre, PrecioUnitario = producto.Precio, LoteId = lote.Id, LoteNumero = lote.NumeroLote, Cantidad = cantidad };
    private static int StockLote(int lote) => Escalar("SELECT Cantidad FROM dbo.Lote WHERE Id=" + lote);
    private static int Escalar(string sql) { using (SqlConnection c = new SqlConnection(Conexion)) { c.Open(); using (SqlCommand cmd = new SqlCommand(sql,c)) return Convert.ToInt32(cmd.ExecuteScalar()); } }
    private static void Ejecutar(string sql) { using (SqlConnection c = new SqlConnection(Conexion)) { c.Open(); using (SqlCommand cmd = new SqlCommand(sql,c)) cmd.ExecuteNonQuery(); } }
    private static void Verificar(bool condicion, string nombre) { if (!condicion) throw new Exception("FALLO: " + nombre); pruebas++; Console.WriteLine("OK: " + nombre); }
    private static void Rechazar(Action accion, string nombre) { bool rechazo = false; try { accion(); } catch { rechazo = true; } Verificar(rechazo,nombre); }
}
