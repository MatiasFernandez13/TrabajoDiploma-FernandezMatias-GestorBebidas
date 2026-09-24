IF OBJECT_ID('dbo.sp_Clientes_ListarZonas', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_Clientes_ListarZonas;
GO
CREATE PROCEDURE dbo.sp_Clientes_ListarZonas
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT DISTINCT Zona FROM Clientes;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END
GO
