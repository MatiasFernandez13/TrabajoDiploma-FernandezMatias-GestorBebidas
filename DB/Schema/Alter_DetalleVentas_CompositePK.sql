BEGIN TRY
    IF OBJECT_ID('dbo.DetalleVentas', 'U') IS NULL
        RAISERROR('Tabla DetalleVentas no existe', 16, 1);

    IF COL_LENGTH('dbo.DetalleVentas', 'Id') IS NOT NULL
    BEGIN
        DECLARE @PKName NVARCHAR(128);
        SELECT @PKName = kc.name
        FROM sys.key_constraints kc
        WHERE kc.parent_object_id = OBJECT_ID('dbo.DetalleVentas') AND kc.type = 'PK';
        IF @PKName IS NOT NULL
        BEGIN
            DECLARE @sql NVARCHAR(MAX) = 'ALTER TABLE dbo.DetalleVentas DROP CONSTRAINT ' + QUOTENAME(@PKName) + ';';
            EXEC sp_executesql @sql;
        END
        ALTER TABLE dbo.DetalleVentas DROP COLUMN Id;
    END

    IF NOT EXISTS (
        SELECT 1 FROM sys.key_constraints kc
        WHERE kc.parent_object_id = OBJECT_ID('dbo.DetalleVentas') AND kc.type = 'PK'
    )
    BEGIN
        ALTER TABLE dbo.DetalleVentas ADD CONSTRAINT PK_DetalleVentas PRIMARY KEY (VentaId, ProductoId);
    END

    IF NOT EXISTS (
        SELECT 1
        FROM sys.foreign_keys
        WHERE name = 'FK_DetalleVentas_Ventas'
    )
    BEGIN
        ALTER TABLE dbo.DetalleVentas
        ADD CONSTRAINT FK_DetalleVentas_Ventas
        FOREIGN KEY (VentaId) REFERENCES dbo.Ventas(Id);
    END

    IF NOT EXISTS (
        SELECT 1
        FROM sys.foreign_keys
        WHERE name = 'FK_DetalleVentas_Productos'
    )
    BEGIN
        ALTER TABLE dbo.DetalleVentas
        ADD CONSTRAINT FK_DetalleVentas_Productos
        FOREIGN KEY (ProductoId) REFERENCES dbo.Productos(Id);
    END
END TRY
BEGIN CATCH
    DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrSeverity INT = ERROR_SEVERITY();
    RAISERROR(@ErrMsg, @ErrSeverity, 1);
END CATCH
