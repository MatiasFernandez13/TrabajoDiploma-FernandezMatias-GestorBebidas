IF OBJECT_ID('dbo.sp_DetalleVentas_Upsert', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_DetalleVentas_Upsert;
GO
CREATE PROCEDURE dbo.sp_DetalleVentas_Upsert
    @VentaId INT,
    @ProductoId INT,
    @Cantidad INT,
    @PrecioUnitario DECIMAL(18,2)
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
        IF EXISTS (SELECT 1 FROM DetalleVentas WHERE VentaId = @VentaId AND ProductoId = @ProductoId)
            UPDATE DetalleVentas
            SET Cantidad = Cantidad + @Cantidad,
                PrecioUnitario = @PrecioUnitario
            WHERE VentaId = @VentaId AND ProductoId = @ProductoId;
        ELSE
            INSERT INTO DetalleVentas (VentaId, ProductoId, Cantidad, PrecioUnitario)
            VALUES (@VentaId, @ProductoId, @Cantidad, @PrecioUnitario);
        IF (@StartedTran = 1) COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF (XACT_STATE() <> 0 AND @@TRANCOUNT > 0) ROLLBACK TRAN;
        DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END
GO
