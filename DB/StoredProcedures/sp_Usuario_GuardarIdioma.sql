IF OBJECT_ID('dbo.sp_Usuario_GuardarIdioma', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_Usuario_GuardarIdioma;
GO
CREATE PROCEDURE dbo.sp_Usuario_GuardarIdioma
    @IdUsuario INT,
    @Idioma NVARCHAR(10)
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
        UPDATE dbo.Usuarios
        SET Idioma = @Idioma
        WHERE Id = @IdUsuario;
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
