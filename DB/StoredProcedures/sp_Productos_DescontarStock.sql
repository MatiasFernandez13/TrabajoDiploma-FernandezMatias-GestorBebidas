IF OBJECT_ID('dbo.sp_Productos_DescontarStock', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_Productos_DescontarStock;
GO
CREATE PROCEDURE dbo.sp_Productos_DescontarStock
    @ProductoId INT,
    @Cantidad INT
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
        DECLARE @stock INT;
        SELECT @stock = Stock FROM Productos WHERE Id = @ProductoId;
        IF (@stock IS NULL) RAISERROR('Producto inexistente', 16, 1);
        IF (@stock < @Cantidad) RAISERROR('Stock insuficiente', 16, 1);
        UPDATE Productos SET Stock = Stock - @Cantidad WHERE Id = @ProductoId;
        IF (@StartedTran = 1) COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF (XACT_STATE() <> 0 AND @@TRANCOUNT > 0) ROLLBACK TRAN;
        DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END
GO
