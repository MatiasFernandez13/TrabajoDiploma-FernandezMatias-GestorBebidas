IF OBJECT_ID('dbo.sp_Ventas_Insertar', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_Ventas_Insertar;
GO
CREATE PROCEDURE dbo.sp_Ventas_Insertar
    @Fecha DATETIME,
    @UsuarioId INT
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
        INSERT INTO Ventas (Fecha, UsuarioId) VALUES (@Fecha, @UsuarioId);
        IF (@StartedTran = 1) COMMIT TRAN;
        SELECT CAST(SCOPE_IDENTITY() AS INT) AS VentaId;
    END TRY
    BEGIN CATCH
        IF (XACT_STATE() <> 0 AND @@TRANCOUNT > 0) ROLLBACK TRAN;
        DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END
GO
