IF OBJECT_ID('dbo.sp_Permiso_AgregarSimple','P') IS NOT NULL
    DROP PROCEDURE dbo.sp_Permiso_AgregarSimple;
GO
CREATE PROCEDURE dbo.sp_Permiso_AgregarSimple
    @IdPermisoPadre INT,
    @NombreSimple NVARCHAR(200)
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
        DECLARE @IdHijo INT;
        IF EXISTS (SELECT 1 FROM dbo.Permiso WHERE Nombre=@NombreSimple)
        BEGIN
            SELECT @IdHijo = Id FROM dbo.Permiso WHERE Nombre=@NombreSimple;
            UPDATE dbo.Permiso SET EsPadre=0 WHERE Id=@IdHijo;
        END
        ELSE
        BEGIN
            INSERT INTO dbo.Permiso(Nombre, EsPadre) VALUES(@NombreSimple, 0);
            SET @IdHijo = SCOPE_IDENTITY();
        END
        IF NOT EXISTS (SELECT 1 FROM dbo.PermisoPermiso WHERE IdPermisoPadre=@IdPermisoPadre AND IdPermisoHijo=@IdHijo)
            INSERT INTO dbo.PermisoPermiso(IdPermisoPadre, IdPermisoHijo) VALUES(@IdPermisoPadre, @IdHijo);
        IF (@StartedTran = 1) COMMIT TRAN;
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
