IF OBJECT_ID('dbo.sp_Permiso_ObtenerRelaciones','P') IS NOT NULL
    DROP PROCEDURE dbo.sp_Permiso_ObtenerRelaciones;
GO
CREATE PROCEDURE dbo.sp_Permiso_ObtenerRelaciones
AS
BEGIN
    SET NOCOUNT ON;
    SELECT IdPermisoPadre, IdPermisoHijo FROM dbo.PermisoPermiso;
END
GO
