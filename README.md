# Gestor de Bebidas MF

Trabajo de Diploma — Matías Fernández.

Aplicación de escritorio para gestionar productos, clientes, lotes, inventario, ventas, usuarios, permisos, idiomas, bitácora y reportes. Los reportes permiten exportar a Excel, PDF, CSV y HTML.

## Requisitos

- Windows.
- Visual Studio 2022 con soporte para .NET 8 y la carga de trabajo Desarrollo de escritorio de .NET, o el SDK de .NET 8.
- SQL Server (desarrollo realizado con SQL Server 2022) y SQL Server Management Studio o la herramienta sqlcmd.
- Acceso a Internet para restaurar los paquetes NuGet durante la primera compilación.

## Crear la base de datos

1. Iniciar el servicio de SQL Server.
2. Ejecutar `DB/Instalar.sql` en una instancia donde no exista `BaseGestionBebidasMF`. Con sqlcmd:

   ```powershell
   sqlcmd -S localhost -E -b -i DB/Instalar.sql
   ```

   En Management Studio, activar **Consulta > Modo SQLCMD** antes de ejecutar el archivo para que se interrumpa ante un error.
3. El script crea tablas, relaciones, procedimientos y catálogos iniciales. No incluye usuarios, clientes, productos ni ventas de la base del autor.
4. No ejecutar todos los archivos de `DB/Schema` y `DB/StoredProcedures` después de la instalación: son scripts de mantenimiento y migración de versiones anteriores.

El instalador se detiene si la base ya existe; no elimina una base existente. Para actualizar una instalación previa, revisar cada migración antes de aplicarla.

## Configurar la conexión

La aplicación utiliza autenticación de Windows y la conexión `Data Source=localhost;Initial Catalog=BaseGestionBebidasMF;Integrated Security=True`.

Si la instancia tiene otro nombre, por ejemplo `localhost\SQLEXPRESS`, modificar el servidor tanto en `DAL/ACCESO.cs` como en `UI/App.config` (conexión `MiConexion`). Usar ese mismo servidor al ejecutar el instalador SQL. El usuario de Windows debe tener permisos para crear la base durante la instalación y para acceder a ella al ejecutar la aplicación.

## Compilar y ejecutar

Abrir `UI.sln`, restaurar los paquetes NuGet, seleccionar **UI** como proyecto de inicio y ejecutar con F5.

También se puede utilizar una terminal en la raíz del repositorio:

```powershell
dotnet restore UI.sln
dotnet build UI.sln
dotnet run --project UI/UI.csproj
```

Al iniciar por primera vez se crean los permisos y el administrador inicial:

- Usuario: `admin`
- Contraseña inicial de prueba: `admin123`

Cambiar esta contraseña desde la gestión de usuarios después del primer acceso. La base inicial no contiene operaciones comerciales: crear productos, clientes y lotes desde la aplicación, registrar una venta y luego consultar los reportes. Los reportes vacíos son esperables antes de cargar operaciones.

## Estructura

| Carpeta | Contenido |
| --- | --- |
| BE | Entidades del sistema |
| BLL | Reglas y operaciones de negocio |
| DAL | Acceso a SQL Server |
| INTERFACES | Contratos compartidos |
| SERVICIOS | Seguridad, sesión, integridad e idiomas |
| UI | Formularios Windows Forms y exportación de reportes |
| DB | Instalación de la base, scripts de mantenimiento y documentación |

`bin`, `obj`, `.vs`, `packages` y `artifacts` no forman parte de la entrega: los archivos de compilación y los paquetes se regeneran al restaurar y compilar.

La compilación actual conserva advertencias del código existente. Para detalles funcionales de reportes, consultar `DB/REPORTES.md`.

## Validación de la entrega

Se verificó la compilación de la solución (sin errores, con advertencias existentes), la creación de una base vacía, la creación automática del administrador, un segundo inicio, el login, la integridad y las consultas de reportes sin datos. Estas comprobaciones no sustituyen una prueba manual de todos los formularios.
