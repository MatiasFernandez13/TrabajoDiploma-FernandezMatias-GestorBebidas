# Gestor de Bebidas MF

Trabajo de Diploma — Matías Fernández.

Aplicación de escritorio para gestionar productos, clientes, lotes, inventario, ventas, usuarios, permisos, idiomas, bitácora y reportes. Los reportes permiten exportar a Excel, PDF, CSV y HTML.

## Requisitos

- Windows.
- Visual Studio 2022 con soporte para .NET 8 y la carga de trabajo Desarrollo de escritorio de .NET, o el SDK de .NET 8.
- SQL Server (desarrollo realizado con SQL Server 2022) y SQL Server Management Studio o la herramienta sqlcmd.
- Acceso a Internet para restaurar los paquetes NuGet durante la primera compilación.

## Base completa con datos ficticios (recomendada para evaluar)

`DB/BaseGestionBebidasMF-completa.zip` contiene el respaldo `BaseGestionBebidasMF.bak` con la estructura completa y todos los datos ficticios del proyecto: clientes, ventas, detalles, productos, lotes, usuarios, permisos, idiomas, traducciones, bitácora e historial. Conserva el estado de la base del autor, incluidos los usuarios y sus contraseñas almacenadas como hashes.

El respaldo se creó con SQL Server 2022 Express. Restaurarlo en SQL Server 2022 o una versión posterior; no se puede restaurar este respaldo en versiones anteriores.

1. Descargar y descomprimir `DB/BaseGestionBebidasMF-completa.zip`.
2. Copiar el `.bak` en una carpeta del equipo donde corre SQL Server a la que su servicio tenga acceso (por ejemplo, su carpeta de respaldos).
3. En SQL Server Management Studio, conectarse a la instancia, hacer clic derecho en **Bases de datos > Restaurar base de datos**, seleccionar **Dispositivo**, agregar el `.bak` y usar como destino `BaseGestionBebidasMF`.
4. En **Archivos**, elegir las carpetas de datos y registros de la instancia del profesor, mediante la opción de reubicar los archivos. Las rutas del equipo del autor no tienen que existir en el equipo del profesor.
5. Confirmar la restauración, configurar la conexión como se explica abajo y ejecutar `UI.sln`.

También se puede utilizar `DB/RestaurarCompleta.sql`: cambiar el valor de `RutaRespaldo` por la ubicación del `.bak` y ejecutarlo con **Modo SQLCMD** activado en Management Studio, o desde una terminal:

```powershell
sqlcmd -S localhost -E -b -i DB/RestaurarCompleta.sql
```

El script obtiene automáticamente las carpetas de datos y registros de la instancia y se detiene si la base ya existe. No sobrescribir una base existente para probar la entrega: usar una instancia independiente o respaldar y gestionar esa base por separado.

**No ejecutar `Instalar.sql` después de restaurar el respaldo.** La copia completa ya contiene el esquema y los datos. No es necesario ejecutar las migraciones de `DB/Schema` ni todos los procedimientos de `DB/StoredProcedures`.

## Alternativa: instalar una base vacía

Para comenzar sin operaciones comerciales, usar `DB/Instalar.sql` en lugar del respaldo completo, en una instancia donde no exista `BaseGestionBebidasMF`:

```powershell
sqlcmd -S localhost -E -b -i DB/Instalar.sql
```

En Management Studio, activar **Consulta > Modo SQLCMD** antes de ejecutar el archivo. Este instalador crea la estructura y los catálogos iniciales, sin los usuarios, clientes, productos ni ventas del autor. Se detiene si la base ya existe. Incluye las correcciones documentadas durante la preparación de la instalación vacía; el respaldo completo conserva la base original sin aplicar esas modificaciones.

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

Cambiar la contraseña inicial desde la gestión de usuarios después del primer acceso. En la base vacía, crear productos, clientes y lotes, registrar una venta y luego consultar los reportes. En la base completa ya existen operaciones; para ver las ventas históricas, seleccionar un período que incluya sus fechas.

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

La copia completa se verificó mediante restauración en una base temporal y comprobación de integridad con DBCC CHECKDB. Contiene 7 clientes, 30 ventas, 53 detalles de venta, 31 productos y 29 usuarios, además del resto de las tablas.
