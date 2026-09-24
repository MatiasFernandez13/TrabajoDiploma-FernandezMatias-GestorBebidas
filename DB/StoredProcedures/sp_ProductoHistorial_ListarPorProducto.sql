IF OBJECT_ID('dbo.sp_ProductoHistorial_ListarPorProducto', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ProductoHistorial_ListarPorProducto;
GO

CREATE PROCEDURE dbo.sp_ProductoHistorial_ListarPorProducto
    @Id INT
AS
BEGIN
    SELECT IdHistorial, Fecha, Nombre, CategoriaId, Precio, LitrosPorUnidad, Stock, Activo
    FROM   ProductoHistorial
    WHERE  IdProducto = @Id
    ORDER  BY Fecha DESC;
END
GO
