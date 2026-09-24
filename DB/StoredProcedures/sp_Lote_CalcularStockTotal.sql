IF OBJECT_ID('dbo.sp_Lote_CalcularStockTotal', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_Lote_CalcularStockTotal;
GO
CREATE PROCEDURE dbo.sp_Lote_CalcularStockTotal
    @ProductoId INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT ISNULL(SUM(Cantidad),0) AS StockTotal
        FROM Lote
        WHERE ProductoId = @ProductoId;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END
GO
