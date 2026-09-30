# Corrección para la entrega al profesor — 30/09/2026

## Si ya ejecutó el archivo anterior y apareció el error de RolId

1. Abrir `RepararBase_BebidasMF.sql` en SQL Server Management Studio y conectarse a la instancia donde se creó `BaseGestionBebidasMF`.
2. Activar **Consulta > Modo SQLCMD** y ejecutar el archivo completo con F5.
3. Abrir `UI.sln`, verificar la conexión y ejecutar el proyecto UI. Se comprobó el acceso con usuario `admin` y contraseña `admin123` para los datos de esta entrega.

No borrar la base, no ejecutar nuevamente el archivo original y no ejecutar también el instalador completo. El parche conserva los datos comerciales y las contraseñas. Se puede ejecutar más de una vez. Si informa que falta una tabla, la instalación quedó incompleta por otro error: usar una instancia vacía para la instalación completa o comunicar el mensaje antes de continuar; el parche no reconstruye tablas ni repone registros faltantes.

Desde una terminal también se puede ejecutar:

```powershell
sqlcmd -S localhost -E -b -i RepararBase_BebidasMF.sql
```

Usar el nombre real de la instancia en lugar de `localhost` si corresponde, por ejemplo `localhost\SQLEXPRESS`.

## Para instalar desde cero

Usar solamente `GeneraBase_BebidasMF_Corregida.sql` en una instancia donde no exista `BaseGestionBebidasMF`. Incluye el esquema y todos los datos ficticios del archivo enviado originalmente: 7 clientes, 30 ventas, 53 detalles de venta, 31 productos, 29 usuarios y el resto de las tablas.

Activar **Consulta > Modo SQLCMD** en Management Studio y ejecutar el archivo completo. Alternativamente:

```powershell
sqlcmd -S localhost -E -b -i GeneraBase_BebidasMF_Corregida.sql
```

No ejecutar el parche después: el instalador ya incluye las correcciones. El script se detiene si la base existe y utiliza las carpetas predeterminadas de la instancia, sin rutas del equipo del autor. Fue probado en SQL Server 2022 Express.

## Ejecutar el programa

Requisitos: Windows, SQL Server y Visual Studio con desarrollo de escritorio de .NET 8 (o SDK .NET 8).

Configurar el mismo servidor en `DAL/ACCESO.cs` y en `UI/App.config`, conexión `MiConexion`. Abrir `UI.sln`, restaurar paquetes NuGet, seleccionar UI como proyecto de inicio y ejecutar. En reportes, elegir un período que incluya las ventas históricas; el mes actual puede no contener ventas.

## Qué se corrigió

- Se retiraron tres procedimientos antiguos que el programa actual no utiliza: `sp_CalcularDVH_Productos`, `sp_VerificarIntegridadProductos` y `sp_VerificarIntegridadUsuarios`. El último referenciaba la columna eliminada `RolId`. Los tres duplicaban en SQL un cálculo distinto del que realiza C#; quitar solo la columna no resolvía esa incompatibilidad. La aplicación conserva su verificación y recálculo en `SERVICIOS/DigitoVerificador.cs`.
- `sp_RecalcularDVV`, que sí utiliza la aplicación, ahora guarda la suma reducida módulo 2147483647 y admite tablas vacías, de acuerdo con C#.
- El valor agregado de integridad de clientes estaba guardado como suma sin reducir. Se adapta su formato.
- Se corrigen los verificadores individuales de seis clientes del archivo original (IDs 2, 3, 4, 5, 7 y 8), calculados con el código real de la aplicación. El parche comprueba ID, verificador anterior y cada campo utilizado en el cálculo antes de aplicar cada corrección. Si el registro cambió desde la exportación, esa corrección se omite. No cambia nombres, domicilios, ventas, stock, usuarios ni contraseñas.
- El parche aplica los cambios en una transacción. El instalador no sobrescribe bases existentes.

## Pruebas realizadas

- Se reprodujo el error `Invalid column name 'RolId'` usando el archivo original en una base temporal.
- El instalador definitivo se ejecutó desde cero sin errores y pasó DBCC CHECKDB.
- El parche se probó sobre la instalación del archivo original y se repitió sin producir cambios adicionales.
- Se compararon todos los registros de las 16 tablas: la instalación corregida y la reparación de la instalación anterior producen los mismos datos. Las instrucciones INSERT del archivo original se conservaron; las únicas actualizaciones de datos son los verificadores técnicos documentados arriba.
- Con el código C# del proyecto y configuración regional es-AR: verificadores individuales y agregados de usuarios, productos y clientes correctos; arranque, login admin y consultas de reportes correctos (53 detalles de ventas y 24 productos activos).
- El procedimiento de integridad se probó también con una tabla vacía y con una suma mayor al máximo de Int64.
- Se verificó que el instalador se detenga si la base ya existe y que el parche respete un cliente modificado después de la exportación.

Estas pruebas no equivalen a recorrer manualmente todos los formularios. La base original del autor no fue modificada.

El respaldo `.bak` publicado anteriormente conserva el estado previo a esta corrección. Si se utiliza ese respaldo, aplicar después `RepararBase_BebidasMF.sql`. Para esta entrega se recomienda utilizar los archivos de este paquete.
