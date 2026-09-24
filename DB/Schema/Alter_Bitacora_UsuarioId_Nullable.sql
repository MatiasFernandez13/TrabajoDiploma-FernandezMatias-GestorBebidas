BEGIN TRY
    IF OBJECT_ID('dbo.Bitacora', 'U') IS NULL
        RAISERROR('Tabla Bitacora no existe', 16, 1);

    DECLARE @isNullable bit = 0;
    SELECT @isNullable = CASE WHEN c.is_nullable = 1 THEN 1 ELSE 0 END
    FROM sys.columns c
    WHERE c.object_id = OBJECT_ID('dbo.Bitacora') AND c.name = 'UsuarioId';

    IF (@isNullable = 0)
    BEGIN
        ALTER TABLE dbo.Bitacora ALTER COLUMN UsuarioId INT NULL;
    END
END TRY
BEGIN CATCH
    DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrSeverity INT = ERROR_SEVERITY();
    RAISERROR(@ErrMsg, @ErrSeverity, 1);
END CATCH
