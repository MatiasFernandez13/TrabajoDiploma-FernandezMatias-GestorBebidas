:ON ERROR EXIT
USE [BaseGestionBebidasMF];
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET NUMERIC_ROUNDABORT OFF;
SET XACT_ABORT ON;
BEGIN TRANSACTION;
GO
IF OBJECT_ID(N'dbo.NormalizarIdentificador', N'FN') IS NULL
    EXEC(N'CREATE FUNCTION dbo.NormalizarIdentificador(@Texto nvarchar(100))
RETURNS nvarchar(100)
WITH SCHEMABINDING
AS
BEGIN
    RETURN UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(@Texto,N''''),N'' '',N''''),NCHAR(9),N''''),NCHAR(10),N''''),NCHAR(13),N''''),NCHAR(160),N''''),N''-'',N''''),N''–'',N''''),N''—'',N''''),N''_'',N'''')) COLLATE Latin1_General_100_CI_AI;
END;');
GO
IF COL_LENGTH(N'dbo.Productos', N'NombreClave') IS NULL
    ALTER TABLE dbo.Productos ADD NombreClave AS (dbo.NormalizarIdentificador(Nombre) COLLATE Latin1_General_100_CI_AI) PERSISTED;
IF COL_LENGTH(N'dbo.Lote', N'NumeroLoteClave') IS NULL
    ALTER TABLE dbo.Lote ADD NumeroLoteClave AS (dbo.NormalizarIdentificador(NumeroLote) COLLATE Latin1_General_100_CI_AI) PERSISTED;
GO
IF EXISTS (SELECT 1 FROM dbo.Lote GROUP BY ProductoId, NumeroLoteClave HAVING COUNT(*) > 1)
    THROW 50010, N'Existen lotes equivalentes para el mismo producto. Revise sus cantidades y fechas antes de instalar la restriccion; no se modificaron los registros.', 1;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID(N'dbo.Lote') AND name=N'UQ_Lote_Producto_Numero')
    CREATE UNIQUE INDEX UQ_Lote_Producto_Numero ON dbo.Lote(ProductoId, NumeroLoteClave);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID(N'dbo.Lote') AND name=N'UQ_Lote_Id_Producto')
    CREATE UNIQUE INDEX UQ_Lote_Id_Producto ON dbo.Lote(Id, ProductoId);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID(N'dbo.Productos') AND name=N'IX_Productos_Identidad')
    CREATE INDEX IX_Productos_Identidad ON dbo.Productos(NombreClave, LitrosPorUnidad, Activo);
IF OBJECT_ID(N'dbo.CK_Lote_Cantidad_NoNegativa', N'C') IS NULL
    ALTER TABLE dbo.Lote WITH CHECK ADD CONSTRAINT CK_Lote_Cantidad_NoNegativa CHECK (Cantidad >= 0);
IF OBJECT_ID(N'dbo.CK_Lote_Numero_NoVacio', N'C') IS NULL
    ALTER TABLE dbo.Lote WITH CHECK ADD CONSTRAINT CK_Lote_Numero_NoVacio CHECK (LEN(NumeroLoteClave) > 0);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID(N'dbo.DetalleVentas') AND name=N'UQ_DetalleVentas_Venta_Producto')
    CREATE UNIQUE INDEX UQ_DetalleVentas_Venta_Producto ON dbo.DetalleVentas(VentaId, ProductoId);
IF OBJECT_ID(N'dbo.DetalleVentaLote', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.DetalleVentaLote
    (
        VentaId int NOT NULL,
        ProductoId int NOT NULL,
        LoteId int NOT NULL,
        Cantidad int NOT NULL,
        CONSTRAINT PK_DetalleVentaLote PRIMARY KEY (VentaId, ProductoId, LoteId),
        CONSTRAINT FK_DetalleVentaLote_Detalle FOREIGN KEY (VentaId, ProductoId) REFERENCES dbo.DetalleVentas(VentaId, ProductoId),
        CONSTRAINT FK_DetalleVentaLote_Lote FOREIGN KEY (LoteId, ProductoId) REFERENCES dbo.Lote(Id, ProductoId),
        CONSTRAINT CK_DetalleVentaLote_Cantidad CHECK (Cantidad > 0)
    );
END;
GO
CREATE OR ALTER TRIGGER dbo.TR_Productos_EvitarDuplicados ON dbo.Productos AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS
    (
        SELECT 1 FROM inserted i
        LEFT JOIN deleted d ON d.Id=i.Id
        WHERE i.Activo=1
          AND (d.Id IS NULL OR d.Activo=0 OR d.NombreClave<>i.NombreClave OR d.LitrosPorUnidad<>i.LitrosPorUnidad)
          AND EXISTS
          (
              SELECT 1 FROM dbo.Productos p WITH (UPDLOCK,HOLDLOCK)
              WHERE p.Id<>i.Id AND p.Activo=1 AND p.NombreClave=i.NombreClave AND p.LitrosPorUnidad=i.LitrosPorUnidad
          )
    )
        THROW 50011, N'Ya existe un producto con el mismo nombre y presentacion. Seleccionelo y utilice Agregar unidades.', 1;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_Lote_Agregar
    @NumeroLote nvarchar(50),
    @FechaIngreso date,
    @FechaVencimiento date,
    @Cantidad int,
    @ProductoId int
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    IF LEN(dbo.NormalizarIdentificador(@NumeroLote))=0 OR @Cantidad<=0 OR @ProductoId<=0
        THROW 50012, N'Ingrese un numero de lote, un producto y una cantidad validos.', 1;
    IF @FechaIngreso IS NULL OR @FechaVencimiento IS NULL OR @FechaIngreso>CONVERT(date,GETDATE()) OR @FechaVencimiento<@FechaIngreso OR @FechaVencimiento<CONVERT(date,GETDATE())
        THROW 50013, N'Verifique las fechas: el ingreso no puede ser futuro y el lote no debe estar vencido.', 1;
    DECLARE @Propia bit=0;
    IF @@TRANCOUNT=0 BEGIN SET @Propia=1; BEGIN TRANSACTION; END;
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM dbo.Productos WITH (UPDLOCK,HOLDLOCK) WHERE Id=@ProductoId AND Activo=1)
            THROW 50014, N'El producto no existe o esta dado de baja.', 1;
        DECLARE @Id int, @Vencimiento date, @Activo bit;
        SELECT @Id=Id,@Vencimiento=FechaVencimiento,@Activo=Activo
        FROM dbo.Lote WITH (UPDLOCK,HOLDLOCK)
        WHERE ProductoId=@ProductoId AND NumeroLoteClave=dbo.NormalizarIdentificador(@NumeroLote) COLLATE Latin1_General_100_CI_AI;
        DECLARE @Consolidado bit=CASE WHEN @Id IS NULL THEN 0 ELSE 1 END;
        IF @Id IS NULL
        BEGIN
            INSERT dbo.Lote(NumeroLote,FechaIngreso,FechaVencimiento,Cantidad,ProductoId,Activo)
            VALUES(LTRIM(RTRIM(@NumeroLote)),@FechaIngreso,@FechaVencimiento,@Cantidad,@ProductoId,1);
            SET @Id=CONVERT(int,SCOPE_IDENTITY());
        END
        ELSE
        BEGIN
            IF @Activo=0 THROW 50015, N'Este numero de lote ya existe y esta dado de baja. No se puede reutilizar.', 1;
            IF @Vencimiento<>@FechaVencimiento THROW 50016, N'El lote ya existe con otra fecha de vencimiento. Verifique el numero o utilice la fecha registrada.', 1;
            UPDATE dbo.Lote SET Cantidad=Cantidad+@Cantidad,
                FechaIngreso=CASE WHEN @FechaIngreso<FechaIngreso THEN @FechaIngreso ELSE FechaIngreso END
            WHERE Id=@Id;
        END;
        IF @Propia=1 COMMIT TRANSACTION;
        SELECT @Id AS Id,@Consolidado AS Consolidado;
    END TRY
    BEGIN CATCH
        IF @Propia=1 AND XACT_STATE()<>0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_Lote_ListarPorProducto @ProductoId int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id,NumeroLote,FechaIngreso,FechaVencimiento,Cantidad,ProductoId,Activo
    FROM dbo.Lote WHERE ProductoId=@ProductoId
    ORDER BY FechaIngreso,Id;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_Lote_Eliminar @Id int
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Lote SET Activo=0 WHERE Id=@Id;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_Lote_CalcularStockTotal @ProductoId int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT COALESCE(SUM(Cantidad),0) FROM dbo.Lote WHERE ProductoId=@ProductoId AND Activo=1;
END;
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
COMMIT TRANSACTION;
GO
