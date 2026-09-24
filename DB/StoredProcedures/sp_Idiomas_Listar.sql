IF OBJECT_ID('dbo.sp_Idiomas_Listar', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_Idiomas_Listar;
GO
CREATE PROCEDURE dbo.sp_Idiomas_Listar
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT Codigo, Nombre FROM Idiomas ORDER BY Nombre;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END
GO
