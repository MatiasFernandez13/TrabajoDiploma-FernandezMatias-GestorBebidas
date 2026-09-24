IF OBJECT_ID('dbo.sp_Traducciones_PorCodigo', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_Traducciones_PorCodigo;
GO
CREATE PROCEDURE dbo.sp_Traducciones_PorCodigo
    @Codigo NVARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT t.Nombre AS Tag, tr.Traduccion
        FROM TraduccionT tr
        JOIN Tag t ON tr.IdTag = t.Id
        JOIN Idiomas i ON tr.IdIdioma = i.Id
        WHERE i.Codigo = @Codigo;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END
GO
