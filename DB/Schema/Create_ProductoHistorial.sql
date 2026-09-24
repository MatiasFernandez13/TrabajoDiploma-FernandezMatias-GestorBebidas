BEGIN TRY
    IF OBJECT_ID('dbo.ProductoHistorial','U') IS NULL
    BEGIN
        CREATE TABLE dbo.ProductoHistorial(
            IdHistorial INT IDENTITY(1,1) PRIMARY KEY,
            IdProducto INT NOT NULL,
            Nombre NVARCHAR(200) NOT NULL,
            CategoriaId INT NULL,
            Precio DECIMAL(18,2) NULL,
            LitrosPorUnidad FLOAT NULL,
            Stock INT NULL,
            Activo BIT NOT NULL,
            Fecha DATETIME NOT NULL DEFAULT(GETDATE()),
            Accion NVARCHAR(20) NOT NULL
        );
        CREATE INDEX IX_ProductoHistorial_IdProd_Fecha ON dbo.ProductoHistorial(IdProducto, Fecha DESC);
    END
END TRY
BEGIN CATCH
    DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
    RAISERROR(@ErrMsg,@ErrSeverity,1);
END CATCH;
