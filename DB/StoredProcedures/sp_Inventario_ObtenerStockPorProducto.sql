IF OBJECT_ID('dbo.sp_Inventario_ObtenerStockPorProducto', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_Inventario_ObtenerStockPorProducto;
GO

CREATE PROCEDURE dbo.sp_Inventario_ObtenerStockPorProducto
AS
BEGIN
    SELECT p.Nombre AS NombreProducto, p.CategoriaId,
        CASE p.CategoriaId WHEN 1 THEN 'Alcohólica' ELSE 'No Alcohólica' END AS CategoriaNombre,
        SUM(l.Cantidad) AS StockTotal
    FROM Productos p
    LEFT JOIN Lote l ON p.Id = l.ProductoId
    GROUP BY p.Nombre, p.CategoriaId;
END
GO
