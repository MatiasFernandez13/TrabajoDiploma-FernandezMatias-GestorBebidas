BEGIN TRY

    IF OBJECT_ID('dbo.ProductoHistorial','U') IS NOT NULL
    BEGIN
        IF NOT EXISTS (
            SELECT 1 FROM sys.foreign_keys
            WHERE name = 'FK_ProductoHistorial_Productos' AND parent_object_id = OBJECT_ID('dbo.ProductoHistorial')
        )
        BEGIN
            ALTER TABLE dbo.ProductoHistorial WITH NOCHECK
            ADD CONSTRAINT FK_ProductoHistorial_Productos
            FOREIGN KEY (IdProducto) REFERENCES dbo.Productos(Id);
        END
    END


    IF COL_LENGTH('dbo.Usuarios','Idioma') IS NOT NULL
       AND OBJECT_ID('dbo.Idiomas','U') IS NOT NULL
    BEGIN
        IF NOT EXISTS (
            SELECT 1 FROM sys.foreign_keys
            WHERE name = 'FK_Usuarios_Idiomas' AND parent_object_id = OBJECT_ID('dbo.Usuarios')
        )
        BEGIN
            ALTER TABLE dbo.Usuarios WITH NOCHECK
            ADD CONSTRAINT FK_Usuarios_Idiomas
            FOREIGN KEY (Idioma) REFERENCES dbo.Idiomas(Codigo);
        END
    END
END TRY
BEGIN CATCH
    DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
    RAISERROR(@ErrMsg,@ErrSeverity,1);
END CATCH;
