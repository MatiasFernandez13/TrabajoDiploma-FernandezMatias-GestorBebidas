IF OBJECT_ID('dbo.sp_Lote_ActualizarStockProducto', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_Lote_ActualizarStockProducto;
GO
CREATE PROCEDURE dbo.sp_Lote_ActualizarStockProducto
    @ProductoId INT,
    @Stock INT
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
        UPDATE Productos SET Stock = @Stock WHERE Id = @ProductoId;
        IF (@StartedTran = 1) COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF (XACT_STATE() <> 0 AND @@TRANCOUNT > 0) ROLLBACK TRAN;
        DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END
GO
