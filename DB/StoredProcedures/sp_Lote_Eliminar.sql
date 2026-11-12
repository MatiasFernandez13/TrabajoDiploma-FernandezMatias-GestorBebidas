CREATE OR ALTER PROCEDURE dbo.sp_Lote_Eliminar @Id int
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Lote SET Activo=0 WHERE Id=@Id;
END;
GO
