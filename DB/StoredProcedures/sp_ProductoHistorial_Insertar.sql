IF OBJECT_ID('dbo.sp_ProductoHistorial_Insertar', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ProductoHistorial_Insertar;
GO

CREATE PROCEDURE dbo.sp_ProductoHistorial_Insertar
    @IdProducto INT,
    @Nombre NVARCHAR(200),
    @CategoriaId INT,
    @Precio DECIMAL(18, 2),
    @LitrosPorUnidad FLOAT,
    @Stock INT,
    @Activo BIT,
    @Accion NVARCHAR(20)
AS
BEGIN
    INSERT INTO ProductoHistorial
        (IdProducto, Nombre, CategoriaId, Precio, LitrosPorUnidad, Stock, Activo, Accion)
    VALUES
        (@IdProducto, @Nombre, @CategoriaId, @Precio, @LitrosPorUnidad, @Stock, @Activo, @Accion);
END
GO
