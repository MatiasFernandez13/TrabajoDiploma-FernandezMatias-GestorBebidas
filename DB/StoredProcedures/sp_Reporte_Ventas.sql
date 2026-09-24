IF OBJECT_ID('dbo.sp_Reporte_Ventas', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_Reporte_Ventas;
GO
CREATE PROCEDURE dbo.sp_Reporte_Ventas
    @Zona NVARCHAR(100) = NULL,
    @ProductoId INT = NULL,
    @FechaDesde DATE = NULL,
    @FechaHasta DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT
            v.Fecha,
            Zona     = COALESCE(c.Zona, ''),
            Cliente  = COALESCE(c.NombreCompleto, 'Venta Mostrador'),
            Producto = p.Nombre,
            dv.Cantidad,
            dv.PrecioUnitario,
            Subtotal = dv.Cantidad * dv.PrecioUnitario
        FROM Ventas v
        INNER JOIN DetalleVentas dv ON dv.VentaId = v.Id
        INNER JOIN Productos p       ON p.Id = dv.ProductoId
        LEFT  JOIN Clientes c        ON c.Id = v.ClienteId
        WHERE
            (@Zona IS NULL OR (c.Zona IS NOT NULL AND c.Zona = @Zona))
            AND (@ProductoId IS NULL OR p.Id = @ProductoId)
            AND (@FechaDesde IS NULL OR v.Fecha >= @FechaDesde)
            AND (@FechaHasta IS NULL OR v.Fecha < DATEADD(DAY, 1, @FechaHasta))
        ORDER BY v.Fecha DESC;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrSeverity INT = ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END
GO
