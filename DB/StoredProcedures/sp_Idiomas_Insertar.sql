IF OBJECT_ID('dbo.sp_Idiomas_Insertar', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_Idiomas_Insertar;
GO
CREATE PROCEDURE dbo.sp_Idiomas_Insertar
    @Codigo NVARCHAR(10),
    @Nombre NVARCHAR(100)
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
        IF EXISTS (SELECT 1 FROM Idiomas WHERE Codigo = @Codigo)
            RAISERROR('El idioma ya existe', 16, 1);
        INSERT INTO Idiomas (Codigo, Nombre) VALUES (@Codigo, @Nombre);
        IF (@StartedTran = 1) COMMIT TRAN;
        SELECT CAST(SCOPE_IDENTITY() AS INT) AS IdiomaId;
    END TRY
    BEGIN CATCH
        IF (XACT_STATE() <> 0 AND @@TRANCOUNT > 0) ROLLBACK TRAN;
        DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END
GO
