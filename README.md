# Gestor de Bebidas MF

Trabajo de Diploma — Matías Fernández.

Aplicación de escritorio para gestionar productos, clientes, lotes, inventario, ventas, usuarios, permisos, idiomas, bitácora y reportes. Los reportes permiten exportar a Excel, PDF, CSV y HTML.

## Requisitos

- Windows.
- Visual Studio 2022 con soporte para .NET 8 y la carga de trabajo Desarrollo de escritorio de .NET, o el SDK de .NET 8.
- SQL Server (desarrollo realizado con SQL Server 2022) y SQL Server Management Studio o la herramienta sqlcmd.
- Acceso a Internet para restaurar los paquetes NuGet durante la primera compilación.

## Entrega corregida al profesor (30/09/2026)

Descargar `DB/EntregaProfesor_Corregida.zip` y seguir `LEEME_CORRECCION.md` dentro del paquete.

- **Si ya ejecutó el script anterior y recibió el error de `RolId`:** ejecutar `DB/RepararBase_BebidasMF.sql` con **Consulta > Modo SQLCMD** activado. No borrar la base ni volver a cargar los datos.
- **Para una instalación nueva con todos los datos ficticios:** ejecutar `DB/GeneraBase_BebidasMF_Corregida.sql` con **Modo SQLCMD** en una instancia donde no exista `BaseGestionBebidasMF`. No ejecutar también el parche.

Ambos caminos fueron probados con SQL Server 2022 Express. La entrega contiene 7 clientes, 30 ventas, 53 detalles de venta, 31 productos y 29 usuarios, además del resto de las tablas. Se conservaron las contraseñas y los datos comerciales del archivo original; se corrigieron procedimientos obsoletos y verificadores técnicos de integridad. Los detalles y las pruebas están en `DB/LEEME_CORRECCION.md`.

Desde una terminal, para una instalación nueva:

```powershell
sqlcmd -S localhost -E -b -i DB/GeneraBase_BebidasMF_Corregida.sql
```

El instalador no sobrescribe bases existentes y utiliza las carpetas predeterminadas de SQL Server. Si el parche indica que falta una tabla, revisar la instalación parcial antes de continuar; no reconstruye tablas ni repone datos faltantes.

## Otras opciones de instalación

- `DB/Instalar.sql`: instalación vacía, solamente esquema y catálogos iniciales. No ejecutar sobre una base que ya contiene datos.
- `DB/BaseGestionBebidasMF-completa.zip`: respaldo histórico del 24/09, para SQL Server 2022 o posterior. Después de restaurarlo mediante `DB/RestaurarCompleta.sql` o el asistente de Management Studio, **aplicar `DB/RepararBase_BebidasMF.sql`**. El respaldo original no incorpora las correcciones del 30/09.

No ejecutar todos los scripts de `DB/Schema` o `DB/StoredProcedures`: contienen migraciones y mantenimiento de versiones anteriores.

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

**Con la base completa**, se conservan las cuentas y contraseñas que ya se utilizaban en el proyecto. El arranque no cambia la contraseña de un administrador existente.

**Con la instalación vacía**, al iniciar por primera vez se crean los permisos y el administrador inicial:

- Usuario: `admin`
- Contraseña inicial de prueba: `admin123`

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
