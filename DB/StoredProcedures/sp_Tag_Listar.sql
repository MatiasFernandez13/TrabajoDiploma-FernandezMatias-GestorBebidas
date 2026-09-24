IF OBJECT_ID('dbo.sp_Tag_Listar', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_Tag_Listar;
GO
CREATE PROCEDURE dbo.sp_Tag_Listar
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT Id, Nombre FROM Tag ORDER BY Nombre;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END
GO
