IF OBJECT_ID('dbo.sp_Productos_Listar_IdNombre', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_Productos_Listar_IdNombre;
GO
CREATE PROCEDURE dbo.sp_Productos_Listar_IdNombre
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT Id, Nombre FROM Productos WHERE Activo = 1 ORDER BY Nombre;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END
GO
