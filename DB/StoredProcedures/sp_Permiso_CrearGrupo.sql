IF OBJECT_ID('dbo.sp_Permiso_CrearGrupo','P') IS NOT NULL
    DROP PROCEDURE dbo.sp_Permiso_CrearGrupo;
GO
CREATE PROCEDURE dbo.sp_Permiso_CrearGrupo
    @Nombre NVARCHAR(200)
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
        DECLARE @Id INT;
        IF EXISTS (SELECT 1 FROM dbo.Permiso WHERE Nombre=@Nombre)
        BEGIN
            SELECT @Id = Id FROM dbo.Permiso WHERE Nombre=@Nombre;
            UPDATE dbo.Permiso SET EsPadre=1 WHERE Id=@Id;
        END
        ELSE
        BEGIN
            INSERT INTO dbo.Permiso(Nombre, EsPadre) VALUES(@Nombre, 1);
            SET @Id = SCOPE_IDENTITY();
        END
        IF (@StartedTran = 1) COMMIT TRAN;
        SELECT @Id AS Id;
    END TRY
    BEGIN CATCH
        IF (@StartedTran = 1 AND XACT_STATE() <> 0 AND @@TRANCOUNT > 0)
        BEGIN
            ROLLBACK TRAN;
        END
        DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
        RAISERROR(@ErrMsg,@ErrSeverity,1);
    END CATCH
END
GO
