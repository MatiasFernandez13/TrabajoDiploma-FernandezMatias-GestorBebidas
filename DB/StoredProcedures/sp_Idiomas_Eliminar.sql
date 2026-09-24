IF OBJECT_ID('dbo.sp_Idiomas_Eliminar', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_Idiomas_Eliminar;
GO
CREATE PROCEDURE dbo.sp_Idiomas_Eliminar
    @Codigo NVARCHAR(10)
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
        DECLARE @IdIdioma INT;
        SELECT @IdIdioma = Id FROM Idiomas WHERE Codigo = @Codigo;
        IF @IdIdioma IS NULL RAISERROR('Idioma no encontrado', 16, 1);
        DELETE FROM TraduccionT WHERE IdIdioma = @IdIdioma;
        DELETE FROM Idiomas WHERE Id = @IdIdioma;
        IF (@StartedTran = 1) COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF (XACT_STATE() <> 0 AND @@TRANCOUNT > 0) ROLLBACK TRAN;
        DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END
GO
