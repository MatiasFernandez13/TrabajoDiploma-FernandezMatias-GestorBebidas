CREATE OR ALTER PROCEDURE dbo.sp_Reporte_Zonas_Analisis
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Zona FROM dbo.Clientes WHERE NULLIF(LTRIM(RTRIM(Zona)), '') IS NOT NULL
    UNION
    SELECT Zona FROM dbo.Ventas WHERE NULLIF(LTRIM(RTRIM(Zona)), '') IS NOT NULL
    ORDER BY Zona;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_Reporte_Ventas_Analisis
    @Zona nvarchar(100) = NULL,
    @ProductoId int = NULL,
    @FechaDesde date = NULL,
    @FechaHasta date = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF @FechaDesde > @FechaHasta THROW 50001, 'Rango de fechas inválido.', 1;
    SELECT v.Id AS VentaId, v.Fecha,
           COALESCE(NULLIF(v.Vendedor, ''), u.NombreUsuario, '') AS Vendedor,
           COALESCE(NULLIF(v.Zona, ''), c.Zona, '') AS Zona,
           COALESCE(c.NombreCompleto, 'Venta Mostrador') AS Cliente,
           p.Nombre AS Producto, dv.Cantidad, dv.PrecioUnitario,
           dv.Cantidad * dv.PrecioUnitario AS Subtotal
    FROM dbo.Ventas v
    JOIN dbo.DetalleVentas dv ON dv.VentaId = v.Id
    JOIN dbo.Productos p ON p.Id = dv.ProductoId
    LEFT JOIN dbo.Clientes c ON c.Id = v.ClienteId
    LEFT JOIN dbo.Usuarios u ON u.Id = v.UsuarioId
    WHERE (@Zona IS NULL OR COALESCE(NULLIF(v.Zona, ''), c.Zona, '') = @Zona)
      AND (@ProductoId IS NULL OR p.Id = @ProductoId)
      AND (@FechaDesde IS NULL OR v.Fecha >= @FechaDesde)
      AND (@FechaHasta IS NULL OR CONVERT(date, v.Fecha) <= @FechaHasta)
    ORDER BY v.Fecha DESC, v.Id DESC, p.Nombre;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_Reporte_Stock_Analisis
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Hoy date = CONVERT(date, GETDATE());
    SELECT p.Id AS ProductoId, p.Nombre AS Producto,
           COALESCE(c.Nombre, 'Sin categoría') AS Categoria,
           p.Stock AS StockTotal, p.Precio, p.LitrosPorUnidad,
           (SELECT COUNT(*) FROM dbo.Lote l WHERE l.ProductoId = p.Id
             AND l.Activo = 1 AND l.Cantidad > 0 AND l.FechaVencimiento >= @Hoy) AS LotesActivos,
           (SELECT COUNT(*) FROM dbo.Lote l WHERE l.ProductoId = p.Id
             AND l.Activo = 1 AND l.Cantidad > 0
             AND l.FechaVencimiento BETWEEN @Hoy AND DATEADD(day, 30, @Hoy)) AS LotesPorVencer,
           (SELECT COUNT(*) FROM dbo.Lote l WHERE l.ProductoId = p.Id
             AND l.Activo = 1 AND l.Cantidad > 0 AND l.FechaVencimiento < @Hoy) AS LotesVencidos
    FROM dbo.Productos p
    LEFT JOIN dbo.Categorias c ON c.Id = p.CategoriaId
    WHERE p.Activo = 1
    ORDER BY c.Nombre, p.Nombre;
END;
GO
