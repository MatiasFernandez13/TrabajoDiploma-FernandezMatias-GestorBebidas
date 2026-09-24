IF OBJECT_ID('dbo.sp_Usuario_BajaLogica', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_Usuario_BajaLogica;
GO
CREATE PROCEDURE dbo.sp_Usuario_BajaLogica
    @Id INT
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
        SET Activo = 0
        WHERE Id = @Id;
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
