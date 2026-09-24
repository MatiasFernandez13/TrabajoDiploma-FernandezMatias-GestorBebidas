IF OBJECT_ID('dbo.sp_Reporte_Stock', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_Reporte_Stock;
GO
CREATE PROCEDURE dbo.sp_Reporte_Stock
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT
            p.Id AS ProductoId,
            p.Nombre AS Producto,
            cat.Nombre AS Categoria,
            p.Stock AS StockTotal,
            p.Precio,
            p.LitrosPorUnidad,
            LotesActivos = (SELECT COUNT(*)
                            FROM Lote l
                            WHERE l.ProductoId = p.Id)
        FROM Productos p
        INNER JOIN Categorias cat ON cat.Id = p.CategoriaId
        ORDER BY cat.Nombre, p.Nombre;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrSeverity INT = ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END
GO
