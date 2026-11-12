CREATE OR ALTER PROCEDURE dbo.sp_Lote_CalcularStockTotal @ProductoId int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT COALESCE(SUM(Cantidad),0) FROM dbo.Lote WHERE ProductoId=@ProductoId AND Activo=1;
END;
GO
