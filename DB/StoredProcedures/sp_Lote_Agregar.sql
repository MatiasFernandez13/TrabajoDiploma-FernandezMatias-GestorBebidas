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
