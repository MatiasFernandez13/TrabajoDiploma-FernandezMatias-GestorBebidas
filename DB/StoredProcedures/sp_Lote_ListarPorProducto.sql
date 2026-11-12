CREATE OR ALTER PROCEDURE dbo.sp_Lote_ListarPorProducto @ProductoId int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id,NumeroLote,FechaIngreso,FechaVencimiento,Cantidad,ProductoId,Activo
    FROM dbo.Lote WHERE ProductoId=@ProductoId
    ORDER BY FechaIngreso,Id;
END;
GO
