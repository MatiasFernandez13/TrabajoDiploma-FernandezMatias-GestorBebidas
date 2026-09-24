IF OBJECT_ID('dbo.sp_ModificarProducto', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ModificarProducto;
GO
CREATE PROCEDURE dbo.sp_ModificarProducto
    @Id INT,
    @Nombre NVARCHAR(200),
    @CategoriaId INT,
    @Precio DECIMAL(18,2),
    @LitrosPorUnidad FLOAT,
    @Stock INT,
    @DVH DECIMAL(38,0)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        DECLARE @StartedTran BIT = 0;
        IF (@@TRANCOUNT = 0)
        BEGIN
            BEGIN TRAN;
            SET @StartedTran = 1;
        END
        UPDATE dbo.Productos
        SET Nombre = @Nombre,
            CategoriaId = @CategoriaId,
            Precio = @Precio,
            LitrosPorUnidad = @LitrosPorUnidad,
            Stock = @Stock,
            DVH = @DVH
        WHERE Id = @Id;
        IF (@StartedTran = 1) COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF (XACT_STATE() <> 0 AND @@TRANCOUNT > 0) ROLLBACK TRAN;
        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrSeverity INT = ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END
GO
