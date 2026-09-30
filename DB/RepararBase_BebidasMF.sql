:ON ERROR EXIT
USE [BaseGestionBebidasMF];
GO
SET XACT_ABORT ON;
BEGIN TRANSACTION;
IF OBJECT_ID(N'dbo.Bitacora', N'U') IS NULL THROW 50001, N'La instalacion esta incompleta: falta Bitacora. Utilice el script completo en una instancia vacia.', 1;
IF OBJECT_ID(N'dbo.Categorias', N'U') IS NULL THROW 50001, N'La instalacion esta incompleta: falta Categorias. Utilice el script completo en una instancia vacia.', 1;
IF OBJECT_ID(N'dbo.Clientes', N'U') IS NULL THROW 50001, N'La instalacion esta incompleta: falta Clientes. Utilice el script completo en una instancia vacia.', 1;
IF OBJECT_ID(N'dbo.DetalleVentas', N'U') IS NULL THROW 50001, N'La instalacion esta incompleta: falta DetalleVentas. Utilice el script completo en una instancia vacia.', 1;
IF OBJECT_ID(N'dbo.DigitoVerificador', N'U') IS NULL THROW 50001, N'La instalacion esta incompleta: falta DigitoVerificador. Utilice el script completo en una instancia vacia.', 1;
IF OBJECT_ID(N'dbo.Idiomas', N'U') IS NULL THROW 50001, N'La instalacion esta incompleta: falta Idiomas. Utilice el script completo en una instancia vacia.', 1;
IF OBJECT_ID(N'dbo.Lote', N'U') IS NULL THROW 50001, N'La instalacion esta incompleta: falta Lote. Utilice el script completo en una instancia vacia.', 1;
IF OBJECT_ID(N'dbo.Permiso', N'U') IS NULL THROW 50001, N'La instalacion esta incompleta: falta Permiso. Utilice el script completo en una instancia vacia.', 1;
IF OBJECT_ID(N'dbo.PermisoPermiso', N'U') IS NULL THROW 50001, N'La instalacion esta incompleta: falta PermisoPermiso. Utilice el script completo en una instancia vacia.', 1;
IF OBJECT_ID(N'dbo.ProductoHistorial', N'U') IS NULL THROW 50001, N'La instalacion esta incompleta: falta ProductoHistorial. Utilice el script completo en una instancia vacia.', 1;
IF OBJECT_ID(N'dbo.Productos', N'U') IS NULL THROW 50001, N'La instalacion esta incompleta: falta Productos. Utilice el script completo en una instancia vacia.', 1;
IF OBJECT_ID(N'dbo.Tag', N'U') IS NULL THROW 50001, N'La instalacion esta incompleta: falta Tag. Utilice el script completo en una instancia vacia.', 1;
IF OBJECT_ID(N'dbo.TraduccionT', N'U') IS NULL THROW 50001, N'La instalacion esta incompleta: falta TraduccionT. Utilice el script completo en una instancia vacia.', 1;
IF OBJECT_ID(N'dbo.Usuario_Permiso', N'U') IS NULL THROW 50001, N'La instalacion esta incompleta: falta Usuario_Permiso. Utilice el script completo en una instancia vacia.', 1;
IF OBJECT_ID(N'dbo.Usuarios', N'U') IS NULL THROW 50001, N'La instalacion esta incompleta: falta Usuarios. Utilice el script completo en una instancia vacia.', 1;
IF OBJECT_ID(N'dbo.Ventas', N'U') IS NULL THROW 50001, N'La instalacion esta incompleta: falta Ventas. Utilice el script completo en una instancia vacia.', 1;
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE OR ALTER PROCEDURE dbo.sp_RecalcularDVV
    @Tabla NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @SQL NVARCHAR(MAX);
    DECLARE @SumaDVH DECIMAL(38, 0);

    SET @SQL = 'SELECT @Resultado = COALESCE(SUM(DVH), 0) % 2147483647 FROM ' + QUOTENAME(@Tabla);

    EXEC sp_executesql
        @SQL,
        N'@Resultado DECIMAL(38, 0) OUTPUT',
        @Resultado = @SumaDVH OUTPUT;

    IF EXISTS (SELECT 1 FROM DigitoVerificador WHERE Tabla = @Tabla)
    BEGIN
        UPDATE DigitoVerificador
        SET DVV = @SumaDVH
        WHERE Tabla = @Tabla;
    END
    ELSE
    BEGIN
        INSERT INTO DigitoVerificador (Tabla, DVV)
        VALUES (@Tabla, @SumaDVH);
    END
END
GO

DROP PROCEDURE IF EXISTS dbo.sp_CalcularDVH_Productos;
GO
DROP PROCEDURE IF EXISTS dbo.sp_VerificarIntegridadProductos;
GO
DROP PROCEDURE IF EXISTS dbo.sp_VerificarIntegridadUsuarios;
GO

UPDATE dbo.DigitoVerificador
SET DVV = DVV % 2147483647
WHERE Tabla IN (N'Usuarios', N'Productos', N'Clientes')
  AND DVV >= 2147483647;
GO
DECLARE @ClientesReparados int = 0;
UPDATE dbo.Clientes SET DVH = 6491190686089612601 WHERE Id = 1 AND DVH = 0 AND Activo = 1 AND CONVERT(varbinary(max),ISNULL([NombreCompleto],N'')) = CONVERT(varbinary(max),N'Juan Pérez') AND CONVERT(varbinary(max),ISNULL([Direccion],N'')) = CONVERT(varbinary(max),N'') AND CONVERT(varbinary(max),ISNULL([Telefono],N'')) = CONVERT(varbinary(max),N'') AND CONVERT(varbinary(max),ISNULL([Email],N'')) = CONVERT(varbinary(max),N'') AND CONVERT(varbinary(max),ISNULL([Zona],N'')) = CONVERT(varbinary(max),N'Centro');
SET @ClientesReparados += @@ROWCOUNT;
UPDATE dbo.Clientes SET DVH = 6950164950606709194 WHERE Id = 2 AND DVH = 0 AND Activo = 1 AND CONVERT(varbinary(max),ISNULL([NombreCompleto],N'')) = CONVERT(varbinary(max),N'María González') AND CONVERT(varbinary(max),ISNULL([Direccion],N'')) = CONVERT(varbinary(max),N'') AND CONVERT(varbinary(max),ISNULL([Telefono],N'')) = CONVERT(varbinary(max),N'') AND CONVERT(varbinary(max),ISNULL([Email],N'')) = CONVERT(varbinary(max),N'') AND CONVERT(varbinary(max),ISNULL([Zona],N'')) = CONVERT(varbinary(max),N'Norte');
SET @ClientesReparados += @@ROWCOUNT;
UPDATE dbo.Clientes SET DVH = 5804301795869395250 WHERE Id = 3 AND DVH = 0 AND Activo = 1 AND CONVERT(varbinary(max),ISNULL([NombreCompleto],N'')) = CONVERT(varbinary(max),N'Carlos López') AND CONVERT(varbinary(max),ISNULL([Direccion],N'')) = CONVERT(varbinary(max),N'') AND CONVERT(varbinary(max),ISNULL([Telefono],N'')) = CONVERT(varbinary(max),N'') AND CONVERT(varbinary(max),ISNULL([Email],N'')) = CONVERT(varbinary(max),N'') AND CONVERT(varbinary(max),ISNULL([Zona],N'')) = CONVERT(varbinary(max),N'Sur');
SET @ClientesReparados += @@ROWCOUNT;
UPDATE dbo.Clientes SET DVH = 3483121921036141040 WHERE Id = 4 AND DVH = 0 AND Activo = 1 AND CONVERT(varbinary(max),ISNULL([NombreCompleto],N'')) = CONVERT(varbinary(max),N'Ana Fernández') AND CONVERT(varbinary(max),ISNULL([Direccion],N'')) = CONVERT(varbinary(max),N'') AND CONVERT(varbinary(max),ISNULL([Telefono],N'')) = CONVERT(varbinary(max),N'') AND CONVERT(varbinary(max),ISNULL([Email],N'')) = CONVERT(varbinary(max),N'') AND CONVERT(varbinary(max),ISNULL([Zona],N'')) = CONVERT(varbinary(max),N'Este');
SET @ClientesReparados += @@ROWCOUNT;
UPDATE dbo.Clientes SET DVH = 993899767157773483 WHERE Id = 5 AND DVH = 0 AND Activo = 1 AND CONVERT(varbinary(max),ISNULL([NombreCompleto],N'')) = CONVERT(varbinary(max),N'Jorge Martínez') AND CONVERT(varbinary(max),ISNULL([Direccion],N'')) = CONVERT(varbinary(max),N'') AND CONVERT(varbinary(max),ISNULL([Telefono],N'')) = CONVERT(varbinary(max),N'') AND CONVERT(varbinary(max),ISNULL([Email],N'')) = CONVERT(varbinary(max),N'') AND CONVERT(varbinary(max),ISNULL([Zona],N'')) = CONVERT(varbinary(max),N'Oeste');
SET @ClientesReparados += @@ROWCOUNT;
UPDATE dbo.Clientes SET DVH = 5732668763541191245 WHERE Id = 7 AND DVH = 5849139928171462506 AND Activo = 1 AND CONVERT(varbinary(max),ISNULL([NombreCompleto],N'')) = CONVERT(varbinary(max),N'carlitos tevez') AND CONVERT(varbinary(max),ISNULL([Direccion],N'')) = CONVERT(varbinary(max),N'av falsa 123') AND CONVERT(varbinary(max),ISNULL([Telefono],N'')) = CONVERT(varbinary(max),N'11-1234-4342') AND CONVERT(varbinary(max),ISNULL([Email],N'')) = CONVERT(varbinary(max),N'magoya@gmail.com') AND CONVERT(varbinary(max),ISNULL([Zona],N'')) = CONVERT(varbinary(max),N'Norte');
SET @ClientesReparados += @@ROWCOUNT;
UPDATE dbo.Clientes SET DVH = 2920357738009587220 WHERE Id = 8 AND DVH = 5736759490488607613 AND Activo = 1 AND CONVERT(varbinary(max),ISNULL([NombreCompleto],N'')) = CONVERT(varbinary(max),N'Mailen Barrera') AND CONVERT(varbinary(max),ISNULL([Direccion],N'')) = CONVERT(varbinary(max),N'Calle falsa 1122') AND CONVERT(varbinary(max),ISNULL([Telefono],N'')) = CONVERT(varbinary(max),N'11-425-785965') AND CONVERT(varbinary(max),ISNULL([Email],N'')) = CONVERT(varbinary(max),N'barrera_22@gmail.com') AND CONVERT(varbinary(max),ISNULL([Zona],N'')) = CONVERT(varbinary(max),N'Oeste');
SET @ClientesReparados += @@ROWCOUNT;
IF @ClientesReparados > 0 EXEC dbo.sp_RecalcularDVV N'Clientes';
GO

COMMIT TRANSACTION;
GO
