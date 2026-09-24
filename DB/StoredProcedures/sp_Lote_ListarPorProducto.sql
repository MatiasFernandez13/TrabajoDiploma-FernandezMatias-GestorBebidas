IF OBJECT_ID('dbo.sp_Lote_ListarPorProducto', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_Lote_ListarPorProducto;
GO
CREATE PROCEDURE dbo.sp_Lote_ListarPorProducto
    @ProductoId INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT Id, NumeroLote, FechaIngreso, FechaVencimiento, Cantidad, ProductoId
        FROM Lote
        WHERE ProductoId = @ProductoId
        ORDER BY FechaVencimiento ASC;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END
GO
