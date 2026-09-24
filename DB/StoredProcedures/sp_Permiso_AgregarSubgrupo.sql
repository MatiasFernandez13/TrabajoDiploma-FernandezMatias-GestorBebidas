IF OBJECT_ID('dbo.sp_Permiso_AgregarSubgrupo','P') IS NOT NULL
    DROP PROCEDURE dbo.sp_Permiso_AgregarSubgrupo;
GO
CREATE PROCEDURE dbo.sp_Permiso_AgregarSubgrupo
    @IdPermisoPadre INT,
    @NombreSubgrupo NVARCHAR(200)
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
        DECLARE @IdHijo INT, @TieneCiclo BIT = 0;
        IF EXISTS (SELECT 1 FROM dbo.Permiso WHERE Nombre=@NombreSubgrupo)
        BEGIN
            SELECT @IdHijo = Id FROM dbo.Permiso WHERE Nombre=@NombreSubgrupo;
            UPDATE dbo.Permiso SET EsPadre=1 WHERE Id=@IdHijo;
        END
        ELSE
        BEGIN
            INSERT INTO dbo.Permiso(Nombre, EsPadre) VALUES(@NombreSubgrupo, 1);
            SET @IdHijo = SCOPE_IDENTITY();
        END
        IF (@IdHijo = @IdPermisoPadre)
        BEGIN
            RAISERROR('No se puede asignar un grupo como subgrupo de sí mismo', 16, 1);
            IF (@StartedTran = 1 AND XACT_STATE() <> 0) ROLLBACK TRAN;
            RETURN;
        END
        ;WITH rec AS(
            SELECT IdPermisoPadre, IdPermisoHijo FROM dbo.PermisoPermiso WHERE IdPermisoPadre=@IdHijo
            UNION ALL
            SELECT p.IdPermisoPadre, p.IdPermisoHijo
            FROM dbo.PermisoPermiso p
            JOIN rec r ON p.IdPermisoPadre = r.IdPermisoHijo
        )
        SELECT TOP 1 @TieneCiclo = 1
        FROM rec
        WHERE IdPermisoHijo=@IdPermisoPadre;

        IF (@TieneCiclo = 1)
        BEGIN
            RAISERROR('Asignación inválida: crearía un ciclo', 16, 1);
            IF (@StartedTran = 1 AND XACT_STATE() <> 0) ROLLBACK TRAN;
            RETURN;
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
