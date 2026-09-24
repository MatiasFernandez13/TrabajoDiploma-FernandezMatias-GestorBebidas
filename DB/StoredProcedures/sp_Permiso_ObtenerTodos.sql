IF OBJECT_ID('dbo.sp_Permiso_ObtenerTodos','P') IS NOT NULL
    DROP PROCEDURE dbo.sp_Permiso_ObtenerTodos;
GO
CREATE PROCEDURE dbo.sp_Permiso_ObtenerTodos
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, Nombre, EsPadre FROM dbo.Permiso;
END
GO
