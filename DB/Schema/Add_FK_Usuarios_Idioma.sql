SET NOCOUNT ON;
BEGIN TRY
    BEGIN TRAN;

    ;WITH d AS (
        SELECT Codigo
        FROM dbo.Idiomas
        WHERE Codigo IS NOT NULL
        GROUP BY Codigo
        HAVING COUNT(*) > 1
    )
    SELECT Codigo INTO #dups FROM d;
    DECLARE @cod NVARCHAR(10);
    WHILE EXISTS (SELECT 1 FROM #dups)
    BEGIN
        SELECT TOP 1 @cod = Codigo FROM #dups ORDER BY Codigo;
        DECLARE @keepId INT, @rid INT;
        SELECT @keepId = MIN(Id) FROM dbo.Idiomas WHERE Codigo = @cod;
        WHILE EXISTS (SELECT 1 FROM dbo.Idiomas WHERE Codigo = @cod AND Id <> @keepId)
        BEGIN
            SELECT TOP 1 @rid = Id FROM dbo.Idiomas WHERE Codigo = @cod AND Id <> @keepId ORDER BY Id;
            UPDATE dbo.TraduccionT SET IdIdioma = @keepId WHERE IdIdioma = @rid;
            DELETE FROM dbo.Idiomas WHERE Id = @rid;
        END
        DELETE FROM #dups WHERE Codigo = @cod;
    END
    DROP TABLE IF EXISTS #dups;

    IF EXISTS (SELECT 1 FROM dbo.Idiomas WHERE Codigo IS NULL)
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.Idiomas WHERE Codigo = 'es')
            INSERT INTO dbo.Idiomas (Codigo, Nombre) VALUES ('es', 'Español');
        UPDATE dbo.Idiomas SET Codigo = 'es' WHERE Codigo IS NULL;
    END

    IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'UX_Idiomas_Codigo' AND object_id = OBJECT_ID('dbo.Idiomas'))
        DROP INDEX UX_Idiomas_Codigo ON dbo.Idiomas;
    ALTER TABLE dbo.Idiomas ALTER COLUMN Codigo NVARCHAR(10) NOT NULL;
    CREATE UNIQUE INDEX UX_Idiomas_Codigo ON dbo.Idiomas(Codigo);

    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Usuarios_IdiomaCodigo' AND parent_object_id = OBJECT_ID('dbo.Usuarios'))
    BEGIN

        UPDATE u SET Idioma = 'es'
        FROM dbo.Usuarios u
        WHERE NOT EXISTS (SELECT 1 FROM dbo.Idiomas i WHERE i.Codigo = u.Idioma);
        ALTER TABLE dbo.Usuarios WITH CHECK ADD CONSTRAINT FK_Usuarios_IdiomaCodigo
            FOREIGN KEY (Idioma) REFERENCES dbo.Idiomas(Codigo);
        ALTER TABLE dbo.Usuarios CHECK CONSTRAINT FK_Usuarios_IdiomaCodigo;
    END
    COMMIT;
END TRY
BEGIN CATCH
    IF (XACT_STATE() <> 0) ROLLBACK;
    DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE(), @ErrSeverity INT = ERROR_SEVERITY();
    RAISERROR(@ErrMsg, @ErrSeverity, 1);
END CATCH;
