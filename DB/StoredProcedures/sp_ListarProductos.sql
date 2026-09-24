IF OBJECT_ID('dbo.sp_ListarProductos', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ListarProductos;
GO
CREATE PROCEDURE dbo.sp_ListarProductos
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT Id,
               Nombre,
               CategoriaId,
               Precio,
               LitrosPorUnidad,
               Stock,
               Activo,
               DVH
        FROM dbo.Productos;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrSeverity INT = ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END
GO
