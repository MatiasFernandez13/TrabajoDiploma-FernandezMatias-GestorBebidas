IF OBJECT_ID('dbo.sp_Traduccion_Upsert', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_Traduccion_Upsert;
GO
CREATE PROCEDURE dbo.sp_Traduccion_Upsert
    @IdIdioma INT,
    @IdTag INT,
    @Traduccion NVARCHAR(400)
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
        IF EXISTS (SELECT 1 FROM TraduccionT WHERE IdIdioma = @IdIdioma AND IdTag = @IdTag)
            UPDATE TraduccionT SET Traduccion = @Traduccion WHERE IdIdioma = @IdIdioma AND IdTag = @IdTag;
        ELSE
            INSERT INTO TraduccionT (IdIdioma, IdTag, Traduccion) VALUES (@IdIdioma, @IdTag, @Traduccion);
        IF (@StartedTran = 1) COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF (XACT_STATE() <> 0 AND @@TRANCOUNT > 0) ROLLBACK TRAN;
        DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END
GO
