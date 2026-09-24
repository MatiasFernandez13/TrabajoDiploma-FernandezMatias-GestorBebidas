IF OBJECT_ID('dbo.sp_Usuario_ObtenerPorNombre', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_Usuario_ObtenerPorNombre;
GO
CREATE PROCEDURE dbo.sp_Usuario_ObtenerPorNombre
    @NombreUsuario NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT u.Id,
               u.NombreUsuario,
               u.Contraseña,
               u.Salt,
               u.RolId,
               r.Nombre AS RolNombre,
               u.Idioma,
               u.Activo,
               u.DVH
        FROM dbo.Usuarios u
        INNER JOIN dbo.Roles r ON r.Id = u.RolId
        WHERE u.NombreUsuario = @NombreUsuario;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrSeverity INT = ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END
GO
