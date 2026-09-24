CREATE OR ALTER PROCEDURE sp_RecalcularDVV
    @Tabla NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @SQL NVARCHAR(MAX);
    DECLARE @SumaDVH DECIMAL(38, 0);


    SET @SQL = 'SELECT @Resultado = COALESCE(SUM(DVH), 0) % 2147483647 FROM ' + QUOTENAME(@Tabla);


    EXEC sp_executesql
        @SQL,
        N'@Resultado DECIMAL(38, 0) OUTPUT',
        @Resultado = @SumaDVH OUTPUT;


    IF EXISTS (SELECT 1 FROM DigitoVerificador WHERE Tabla = @Tabla)
    BEGIN
        UPDATE DigitoVerificador
        SET DVV = @SumaDVH
        WHERE Tabla = @Tabla;
    END
    ELSE
    BEGIN
        INSERT INTO DigitoVerificador (Tabla, DVV)
        VALUES (@Tabla, @SumaDVH);
    END
END
GO
