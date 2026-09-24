IF OBJECT_ID('dbo.sp_Bitacora_Insertar', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_Bitacora_Insertar;
GO
CREATE PROCEDURE dbo.sp_Bitacora_Insertar
    @UsuarioId INT = NULL,
    @FechaRegistro DATETIME,
    @Entidad NVARCHAR(100) = NULL,
    @Accion NVARCHAR(100) = NULL,
    @Detalle NVARCHAR(4000) = NULL
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
        INSERT INTO dbo.Bitacora (UsuarioId, FechaRegistro, Entidad, Accion, Detalle)
        VALUES (@UsuarioId, @FechaRegistro, @Entidad, @Accion, @Detalle);
        IF (@StartedTran = 1) COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF (XACT_STATE() <> 0 AND @@TRANCOUNT > 0) ROLLBACK TRAN;
        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrSeverity INT = ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END
GO
