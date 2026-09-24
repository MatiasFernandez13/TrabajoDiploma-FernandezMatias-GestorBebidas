:ON ERROR EXIT
USE [master]
GO
IF DB_ID(N'BaseGestionBebidasMF') IS NOT NULL THROW 50000, N'La base ya existe. Use una instancia vacia para instalar.', 1;
GO
CREATE DATABASE [BaseGestionBebidasMF]
GO
USE [BaseGestionBebidasMF]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tag](
    [Id] [int] NOT NULL,
    [Nombre] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_Tag] PRIMARY KEY CLUSTERED
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Idiomas](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [Codigo] [nvarchar](10) COLLATE Modern_Spanish_CI_AS NOT NULL,
    [Nombre] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NULL,
PRIMARY KEY CLUSTERED
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DigitoVerificador](
    [Tabla] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
    [DVV] [decimal](38, 0) NOT NULL,
 CONSTRAINT [PK__DigitoVe__80FC60E749CE240B] PRIMARY KEY CLUSTERED
(
    [Tabla] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Permiso](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [Nombre] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
    [EsPadre] [bit] NOT NULL,
PRIMARY KEY CLUSTERED
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clientes](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [NombreCompleto] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NULL,
    [Zona] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NULL,
    [Direccion] [nvarchar](255) COLLATE Modern_Spanish_CI_AS NULL,
    [Telefono] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NULL,
    [Email] [nvarchar](150) COLLATE Modern_Spanish_CI_AS NULL,
    [Activo] [bit] NOT NULL,
    [DVH] [decimal](38, 0) NOT NULL,
    [DVV] [decimal](38, 0) NOT NULL,
PRIMARY KEY CLUSTERED
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categorias](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [Nombre] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
PRIMARY KEY CLUSTERED
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PermisoPermiso](
    [IdPermisoPadre] [int] NOT NULL,
    [IdPermisoHijo] [int] NOT NULL,
 CONSTRAINT [PK_PermisoPermiso] PRIMARY KEY CLUSTERED
(
    [IdPermisoPadre] ASC,
    [IdPermisoHijo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Productos](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [Nombre] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
    [CategoriaId] [int] NOT NULL,
    [Precio] [decimal](10, 2) NOT NULL,
    [LitrosPorUnidad] [float] NOT NULL,
    [Stock] [int] NOT NULL,
    [Activo] [bit] NOT NULL,
    [DVH] [decimal](38, 0) NULL,
PRIMARY KEY CLUSTERED
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TraduccionT](
    [IdIdioma] [int] NOT NULL,
    [IdTag] [int] NOT NULL,
    [Traduccion] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_TraduccionT_1] PRIMARY KEY CLUSTERED
(
    [IdIdioma] ASC,
    [IdTag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuarios](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [NombreUsuario] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
    [Contraseña] [nvarchar](512) COLLATE Modern_Spanish_CI_AS NOT NULL,
    [Salt] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
    [Idioma] [nvarchar](10) COLLATE Modern_Spanish_CI_AS NOT NULL,
    [Activo] [bit] NOT NULL,
    [DVH] [decimal](38, 0) NULL,
 CONSTRAINT [PK__Usuarios__3214EC07B9B25E20] PRIMARY KEY CLUSTERED
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__Usuarios__6B0F5AE0BEAA38E3] UNIQUE NONCLUSTERED
(
    [NombreUsuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ventas](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [Fecha] [datetime] NOT NULL,
    [UsuarioId] [int] NOT NULL,
    [ClienteId] [int] NULL,
    [Zona] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NULL,
    [Vendedor] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NULL,
PRIMARY KEY CLUSTERED
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuario_Permiso](
    [IdUsuario] [int] NOT NULL,
    [IdPermiso] [int] NOT NULL,
 CONSTRAINT [PK_Usuario_Permiso] PRIMARY KEY CLUSTERED
(
    [IdUsuario] ASC,
    [IdPermiso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductoHistorial](
    [IdHistorial] [int] IDENTITY(1,1) NOT NULL,
    [IdProducto] [int] NOT NULL,
    [Nombre] [nvarchar](200) COLLATE Modern_Spanish_CI_AS NOT NULL,
    [CategoriaId] [int] NULL,
    [Precio] [decimal](18, 2) NULL,
    [LitrosPorUnidad] [float] NULL,
    [Stock] [int] NULL,
    [Activo] [bit] NOT NULL,
    [Fecha] [datetime] NOT NULL,
    [Accion] [nvarchar](20) COLLATE Modern_Spanish_CI_AS NOT NULL,
PRIMARY KEY CLUSTERED
(
    [IdHistorial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bitacora](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [UsuarioId] [int] NOT NULL,
    [FechaRegistro] [datetime2](7) NOT NULL,
    [Entidad] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
    [Accion] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
    [Detalle] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NULL,
    [DVH] [bigint] NULL,
PRIMARY KEY CLUSTERED
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Lote](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [NumeroLote] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NULL,
    [FechaIngreso] [date] NULL,
    [FechaVencimiento] [date] NULL,
    [Cantidad] [int] NULL,
    [ProductoId] [int] NULL,
    [Activo] [bit] NULL,
PRIMARY KEY CLUSTERED
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetalleVentas](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [VentaId] [int] NOT NULL,
    [ProductoId] [int] NOT NULL,
    [Cantidad] [int] NOT NULL,
    [PrecioUnitario] [decimal](10, 2) NOT NULL,
PRIMARY KEY CLUSTERED
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING ON

GO
CREATE UNIQUE NONCLUSTERED INDEX [UX_Idiomas_Codigo] ON [dbo].[Idiomas]
(
    [Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
CREATE UNIQUE NONCLUSTERED INDEX [UX_Permiso_Nombre] ON [dbo].[Permiso]
(
    [Nombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ProductoHistorial_IdProd_Fecha] ON [dbo].[ProductoHistorial]
(
    [IdProducto] ASC,
    [Fecha] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Permiso] ADD  CONSTRAINT [DF_Permiso_EsPadre]  DEFAULT ((0)) FOR [EsPadre]
GO
ALTER TABLE [dbo].[Clientes] ADD  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[Clientes] ADD  DEFAULT ((0)) FOR [DVH]
GO
ALTER TABLE [dbo].[Clientes] ADD  DEFAULT ((0)) FOR [DVV]
GO
ALTER TABLE [dbo].[Productos] ADD  CONSTRAINT [DF_Productos_Activo]  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[Usuarios] ADD  CONSTRAINT [DF__Usuarios__Idioma__7D439ABD]  DEFAULT ('es') FOR [Idioma]
GO
ALTER TABLE [dbo].[Usuarios] ADD  CONSTRAINT [DF_Usuarios_Activo]  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[Ventas] ADD  DEFAULT (getdate()) FOR [Fecha]
GO
ALTER TABLE [dbo].[ProductoHistorial] ADD  DEFAULT (getdate()) FOR [Fecha]
GO
ALTER TABLE [dbo].[Bitacora] ADD  DEFAULT (sysutcdatetime()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[Lote] ADD  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[PermisoPermiso]  WITH CHECK ADD  CONSTRAINT [FK_PermisoPermiso_Hijo] FOREIGN KEY([IdPermisoHijo])
REFERENCES [dbo].[Permiso] ([Id])
GO
ALTER TABLE [dbo].[PermisoPermiso] CHECK CONSTRAINT [FK_PermisoPermiso_Hijo]
GO
ALTER TABLE [dbo].[PermisoPermiso]  WITH CHECK ADD  CONSTRAINT [FK_PermisoPermiso_Padre] FOREIGN KEY([IdPermisoPadre])
REFERENCES [dbo].[Permiso] ([Id])
GO
ALTER TABLE [dbo].[PermisoPermiso] CHECK CONSTRAINT [FK_PermisoPermiso_Padre]
GO
ALTER TABLE [dbo].[Productos]  WITH CHECK ADD FOREIGN KEY([CategoriaId])
REFERENCES [dbo].[Categorias] ([Id])
GO
ALTER TABLE [dbo].[Productos]  WITH CHECK ADD FOREIGN KEY([CategoriaId])
REFERENCES [dbo].[Categorias] ([Id])
GO
ALTER TABLE [dbo].[TraduccionT]  WITH CHECK ADD  CONSTRAINT [FK_TraduccionT_Idiomas] FOREIGN KEY([IdIdioma])
REFERENCES [dbo].[Idiomas] ([Id])
GO
ALTER TABLE [dbo].[TraduccionT] CHECK CONSTRAINT [FK_TraduccionT_Idiomas]
GO
ALTER TABLE [dbo].[TraduccionT]  WITH CHECK ADD  CONSTRAINT [FK_TraduccionT_Tag] FOREIGN KEY([IdTag])
REFERENCES [dbo].[Tag] ([Id])
GO
ALTER TABLE [dbo].[TraduccionT] CHECK CONSTRAINT [FK_TraduccionT_Tag]
GO
ALTER TABLE [dbo].[Usuarios]  WITH CHECK ADD  CONSTRAINT [FK_Usuarios_IdiomaCodigo] FOREIGN KEY([Idioma])
REFERENCES [dbo].[Idiomas] ([Codigo])
GO
ALTER TABLE [dbo].[Usuarios] CHECK CONSTRAINT [FK_Usuarios_IdiomaCodigo]
GO
ALTER TABLE [dbo].[Usuarios]  WITH NOCHECK ADD  CONSTRAINT [FK_Usuarios_Idiomas] FOREIGN KEY([Idioma])
REFERENCES [dbo].[Idiomas] ([Codigo])
GO
ALTER TABLE [dbo].[Usuarios] CHECK CONSTRAINT [FK_Usuarios_Idiomas]
GO
ALTER TABLE [dbo].[Ventas]  WITH CHECK ADD FOREIGN KEY([ClienteId])
REFERENCES [dbo].[Clientes] ([Id])
GO
ALTER TABLE [dbo].[Ventas]  WITH CHECK ADD FOREIGN KEY([ClienteId])
REFERENCES [dbo].[Clientes] ([Id])
GO
ALTER TABLE [dbo].[Ventas]  WITH CHECK ADD  CONSTRAINT [FK__Ventas__UsuarioI__5BE2A6F2] FOREIGN KEY([UsuarioId])
REFERENCES [dbo].[Usuarios] ([Id])
GO
ALTER TABLE [dbo].[Ventas] CHECK CONSTRAINT [FK__Ventas__UsuarioI__5BE2A6F2]
GO
ALTER TABLE [dbo].[Usuario_Permiso]  WITH CHECK ADD  CONSTRAINT [FK_Usuario_Permiso_Permiso] FOREIGN KEY([IdPermiso])
REFERENCES [dbo].[Permiso] ([Id])
GO
ALTER TABLE [dbo].[Usuario_Permiso] CHECK CONSTRAINT [FK_Usuario_Permiso_Permiso]
GO
ALTER TABLE [dbo].[Usuario_Permiso]  WITH CHECK ADD  CONSTRAINT [FK_Usuario_Permiso_Usuario] FOREIGN KEY([IdUsuario])
REFERENCES [dbo].[Usuarios] ([Id])
GO
ALTER TABLE [dbo].[Usuario_Permiso] CHECK CONSTRAINT [FK_Usuario_Permiso_Usuario]
GO
ALTER TABLE [dbo].[ProductoHistorial]  WITH NOCHECK ADD  CONSTRAINT [FK_ProductoHistorial_Productos] FOREIGN KEY([IdProducto])
REFERENCES [dbo].[Productos] ([Id])
GO
ALTER TABLE [dbo].[ProductoHistorial] CHECK CONSTRAINT [FK_ProductoHistorial_Productos]
GO
ALTER TABLE [dbo].[Bitacora]  WITH CHECK ADD  CONSTRAINT [FK_Bitacora_Usuario] FOREIGN KEY([UsuarioId])
REFERENCES [dbo].[Usuarios] ([Id])
GO
ALTER TABLE [dbo].[Bitacora] CHECK CONSTRAINT [FK_Bitacora_Usuario]
GO
ALTER TABLE [dbo].[Lote]  WITH CHECK ADD FOREIGN KEY([ProductoId])
REFERENCES [dbo].[Productos] ([Id])
GO
ALTER TABLE [dbo].[Lote]  WITH CHECK ADD FOREIGN KEY([ProductoId])
REFERENCES [dbo].[Productos] ([Id])
GO
ALTER TABLE [dbo].[DetalleVentas]  WITH CHECK ADD FOREIGN KEY([ProductoId])
REFERENCES [dbo].[Productos] ([Id])
GO
ALTER TABLE [dbo].[DetalleVentas]  WITH CHECK ADD FOREIGN KEY([ProductoId])
REFERENCES [dbo].[Productos] ([Id])
GO
ALTER TABLE [dbo].[DetalleVentas]  WITH CHECK ADD FOREIGN KEY([VentaId])
REFERENCES [dbo].[Ventas] ([Id])
GO
ALTER TABLE [dbo].[DetalleVentas]  WITH CHECK ADD FOREIGN KEY([VentaId])
REFERENCES [dbo].[Ventas] ([Id])
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.sp_Clientes_ObtenerPorId
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT
            c.Id,
            c.NombreCompleto,
            c.Direccion,
            c.Telefono,
            c.Email,
            c.Zona,
            c.Activo,
            c.DVH
        FROM Clientes c
        WHERE c.Id = @Id;
    END TRY
    BEGIN CATCH
        DECLARE @Msg NVARCHAR(500) = ERROR_MESSAGE();
        RAISERROR(@Msg, 16, 1);
    END CATCH
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.sp_Clientes_Modificar
    @Id             INT,
    @NombreCompleto NVARCHAR(100),
    @Direccion      NVARCHAR(255) = NULL,
    @Telefono       NVARCHAR(50)  = NULL,
    @Email          NVARCHAR(150) = NULL,
    @Zona           NVARCHAR(50)  = NULL,
    @DVH            DECIMAL(38, 0) = 0
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE Clientes
        SET NombreCompleto = @NombreCompleto,
            Direccion      = @Direccion,
            Telefono       = @Telefono,
            Email          = @Email,
            Zona           = @Zona,
            DVH            = @DVH
        WHERE Id = @Id;

        RETURN @@ROWCOUNT;
    END TRY
    BEGIN CATCH
        DECLARE @Msg NVARCHAR(500) = ERROR_MESSAGE();
        RAISERROR(@Msg, 16, 1);
    END CATCH
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.sp_Clientes_ListarZonas
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT DISTINCT
            Zona
        FROM Clientes
        WHERE Zona IS NOT NULL
          AND LTRIM(RTRIM(Zona)) <> ''
          AND Activo = 1
        ORDER BY Zona;
    END TRY
    BEGIN CATCH
        DECLARE @Msg NVARCHAR(500) = ERROR_MESSAGE();
        RAISERROR(@Msg, 16, 1);
    END CATCH
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.sp_Clientes_Listar
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT
            c.Id,
            c.NombreCompleto,
            c.Direccion,
            c.Telefono,
            c.Email,
            c.Zona,
            c.Activo,
            c.DVH
        FROM Clientes c
        ORDER BY c.NombreCompleto;
    END TRY
    BEGIN CATCH
        DECLARE @Msg NVARCHAR(500) = ERROR_MESSAGE();
        RAISERROR(@Msg, 16, 1);
    END CATCH
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.sp_Clientes_Insertar
    @NombreCompleto NVARCHAR(100),
    @Direccion      NVARCHAR(255) = NULL,
    @Telefono       NVARCHAR(50)  = NULL,
    @Email          NVARCHAR(150) = NULL,
    @Zona           NVARCHAR(50)  = NULL,
    @Activo         BIT = 1,
    @DVH            DECIMAL(38, 0) = 0
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO Clientes
            (NombreCompleto, Direccion, Telefono, Email, Zona, Activo, DVH)
        VALUES
            (@NombreCompleto, @Direccion, @Telefono, @Email, @Zona, @Activo, @DVH);

        RETURN SCOPE_IDENTITY();
    END TRY
    BEGIN CATCH
        DECLARE @Msg NVARCHAR(500) = ERROR_MESSAGE();
        RAISERROR(@Msg, 16, 1);
    END CATCH
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.sp_Clientes_Eliminar
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE Clientes
        SET Activo = 0
        WHERE Id = @Id;

        RETURN @@ROWCOUNT;
    END TRY
    BEGIN CATCH
        DECLARE @Msg NVARCHAR(500) = ERROR_MESSAGE();
        RAISERROR(@Msg, 16, 1);
    END CATCH
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.sp_Categorias_Listar
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT Id, Nombre FROM dbo.Categorias ORDER BY Nombre;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrSeverity INT = ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.sp_Idiomas_Listar
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT Codigo, Nombre FROM Idiomas ORDER BY Nombre;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
        IF (@@TRANCOUNT = 0) BEGIN BEGIN TRAN; SET @StartedTran = 1; END
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
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_RecalcularDVV
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
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.sp_Permiso_CrearGrupo
    @Nombre NVARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Id INT;
    IF EXISTS (SELECT 1 FROM dbo.Permiso WHERE Nombre=@Nombre)
    BEGIN
        SELECT @Id = Id FROM dbo.Permiso WHERE Nombre=@Nombre;
        UPDATE dbo.Permiso SET EsPadre=1 WHERE Id=@Id;
    END
    ELSE
    BEGIN
        INSERT INTO dbo.Permiso(Nombre, EsPadre) VALUES(@Nombre, 1);
        SET @Id = SCOPE_IDENTITY();
    END
    SELECT @Id AS Id;
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.sp_Tag_Listar
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT Id, Nombre FROM Tag ORDER BY Nombre;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.sp_Permiso_ObtenerTodos
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, Nombre, EsPadre FROM dbo.Permiso;
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC dbo.sp_Usuario_ObtenerTodos
AS
BEGIN
  SET NOCOUNT ON;
  SELECT Id, NombreUsuario, Contraseña, Salt, Idioma, Activo, DVH
  FROM dbo.Usuarios;
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC dbo.sp_Usuario_ObtenerPorNombre
  @NombreUsuario NVARCHAR(100)
AS
BEGIN
  SET NOCOUNT ON;
  SELECT Id, NombreUsuario, Contraseña, Salt, Idioma, Activo, DVH
  FROM dbo.Usuarios
  WHERE NombreUsuario=@NombreUsuario;
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Usuario_Modificar]
    @Id            INT,
    @NombreUsuario NVARCHAR(100),
    @Contraseña    NVARCHAR(200),
    @Salt          NVARCHAR(50)  = NULL,
    @Idioma        NVARCHAR(10),
    @Activo        BIT,
    @DVH           DECIMAL(38,0)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Usuarios
    SET NombreUsuario = @NombreUsuario,
        Contraseña    = @Contraseña,
        Salt          = @Salt,
        Idioma        = @Idioma,
        Activo        = @Activo,
        DVH           = @DVH
    WHERE Id = @Id;
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.sp_Usuario_Insertar
    @NombreUsuario NVARCHAR(100),
    @Contraseña    NVARCHAR(256),
    @Salt          NVARCHAR(256) = NULL,
    @Idioma        NVARCHAR(10)  = NULL,
    @Activo        BIT,
    @DVH           DECIMAL(38,0)
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON;
    BEGIN TRY
        DECLARE @Started BIT = 0;
        IF @@TRANCOUNT = 0 BEGIN BEGIN TRAN; SET @Started = 1; END

        INSERT INTO dbo.Usuarios (NombreUsuario, Contraseña, Salt, Idioma, Activo, DVH)
        VALUES (@NombreUsuario, @Contraseña, @Salt, @Idioma, @Activo, @DVH);

        DECLARE @NuevoId INT = SCOPE_IDENTITY();
        IF @Started = 1 COMMIT TRAN;
        SELECT @NuevoId;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 AND @@TRANCOUNT > 0 ROLLBACK TRAN;
        DECLARE @Err NVARCHAR(4000)=ERROR_MESSAGE(), @Sev INT=ERROR_SEVERITY();
        RAISERROR(@Err, @Sev, 1);
    END CATCH
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.sp_Usuario_GuardarIdioma
    @IdUsuario INT,
    @Idioma NVARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
        UPDATE dbo.Usuarios
        SET Idioma = @Idioma
        WHERE Id = @IdUsuario;
        COMMIT;
    END TRY
    BEGIN CATCH
        IF (XACT_STATE() <> 0) ROLLBACK;
        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrSeverity INT = ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.sp_Usuario_BajaLogica
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
        UPDATE dbo.Usuarios
        SET Activo = 0
        WHERE Id = @Id;
        COMMIT;
    END TRY
    BEGIN CATCH
        IF (XACT_STATE() <> 0) ROLLBACK;
        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrSeverity INT = ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.sp_Traducciones_PorCodigo
    @Codigo NVARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT t.Nombre AS Tag, tr.Traduccion
        FROM TraduccionT tr
        JOIN Tag t ON tr.IdTag = t.Id
        JOIN Idiomas i ON tr.IdIdioma = i.Id
        WHERE i.Codigo = @Codigo;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.sp_Traduccion_Upsert
    @IdIdioma INT,
    @IdTag INT,
    @Traduccion NVARCHAR(400)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        DECLARE @StartedTran BIT = 0;
        IF (@@TRANCOUNT = 0) BEGIN BEGIN TRAN; SET @StartedTran = 1; END
        IF EXISTS (SELECT 1 FROM TraduccionT WHERE IdIdioma = @IdIdioma AND IdTag = @IdTag)
            UPDATE TraduccionT SET Traduccion = @Traduccion WHERE IdIdioma = @IdIdioma AND IdTag = @IdTag;
        ELSE
            INSERT INTO TraduccionT (IdIdioma, IdTag, Traduccion) VALUES (@IdIdioma, @IdTag, @Traduccion);
        IF (@StartedTran = 1) COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF (XACT_STATE() <> 0 AND @@TRANCOUNT > 0) ROLLBACK TRAN;
        DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.sp_Permiso_ObtenerRelaciones
AS
BEGIN
    SET NOCOUNT ON;
    SELECT IdPermisoPadre, IdPermisoHijo FROM dbo.PermisoPermiso;
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.sp_Permiso_AgregarSubgrupo
    @IdPermisoPadre INT,
    @NombreSubgrupo NVARCHAR(200)
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
        DECLARE @IdHijo INT, @TieneCiclo BIT = 0;
        IF EXISTS (SELECT 1 FROM dbo.Permiso WHERE Nombre=@NombreSubgrupo)
        BEGIN
            SELECT @IdHijo = Id FROM dbo.Permiso WHERE Nombre=@NombreSubgrupo;
            UPDATE dbo.Permiso SET EsPadre=1 WHERE Id=@IdHijo;
        END
        ELSE
        BEGIN
            INSERT INTO dbo.Permiso(Nombre, EsPadre) VALUES(@NombreSubgrupo, 1);
            SET @IdHijo = SCOPE_IDENTITY();
        END
        IF (@IdHijo = @IdPermisoPadre)
        BEGIN
            RAISERROR('No se puede asignar un grupo como subgrupo de sí mismo', 16, 1);
            IF (@StartedTran = 1 AND XACT_STATE() <> 0) ROLLBACK TRAN;
            RETURN;
        END
        ;WITH rec AS(
            SELECT IdPermisoPadre, IdPermisoHijo FROM dbo.PermisoPermiso WHERE IdPermisoPadre=@IdHijo
            UNION ALL
            SELECT p.IdPermisoPadre, p.IdPermisoHijo
            FROM dbo.PermisoPermiso p
            JOIN rec r ON p.IdPermisoPadre = r.IdPermisoHijo
        )
        SELECT TOP 1 @TieneCiclo = 1
        FROM rec
        WHERE IdPermisoHijo=@IdPermisoPadre;

        IF (@TieneCiclo = 1)
        BEGIN
            RAISERROR('Asignación inválida: crearía un ciclo', 16, 1);
            IF (@StartedTran = 1 AND XACT_STATE() <> 0) ROLLBACK TRAN;
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM dbo.PermisoPermiso WHERE IdPermisoPadre=@IdPermisoPadre AND IdPermisoHijo=@IdHijo)
            INSERT INTO dbo.PermisoPermiso(IdPermisoPadre, IdPermisoHijo) VALUES(@IdPermisoPadre, @IdHijo);
        IF (@StartedTran = 1) COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF (XACT_STATE() <> 0 AND @@TRANCOUNT > 0)
        BEGIN
            ROLLBACK TRAN;
        END
        DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
        RAISERROR(@ErrMsg,@ErrSeverity,1);
    END CATCH
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.sp_Permiso_AgregarSimple
    @IdPermisoPadre INT,
    @NombreSimple NVARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @IdHijo INT;
    IF EXISTS (SELECT 1 FROM dbo.Permiso WHERE Nombre=@NombreSimple)
    BEGIN
        SELECT @IdHijo = Id FROM dbo.Permiso WHERE Nombre=@NombreSimple;
        UPDATE dbo.Permiso SET EsPadre=0 WHERE Id=@IdHijo;
    END
    ELSE
    BEGIN
        INSERT INTO dbo.Permiso(Nombre, EsPadre) VALUES(@NombreSimple, 0);
        SET @IdHijo = SCOPE_IDENTITY();
    END
    IF NOT EXISTS (SELECT 1 FROM dbo.PermisoPermiso WHERE IdPermisoPadre=@IdPermisoPadre AND IdPermisoHijo=@IdHijo)
        INSERT INTO dbo.PermisoPermiso(IdPermisoPadre, IdPermisoHijo) VALUES(@IdPermisoPadre, @IdHijo);
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_ObtenerProductosActivos
AS
BEGIN
    SET NOCOUNT ON;

    SELECT Id, Nombre, Precio, LitrosPorUnidad, Stock, DVH
    FROM Productos
    WHERE Activo = 1;
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.sp_ObtenerProductoPorId
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT Id,
               Nombre,
               CategoriaId,
               Precio,
               LitrosPorUnidad,
               Stock,
               Activo,
               DVH
        FROM dbo.Productos
        WHERE Id = @Id;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrSeverity INT = ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ModificarProducto]
    @Id INT,
    @Nombre NVARCHAR(200),
    @CategoriaId INT,
    @Precio DECIMAL(18,2),
    @LitrosPorUnidad FLOAT,
    @Stock INT,
    @DVH DECIMAL(38,0)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Productos
    SET Nombre          = @Nombre,
        CategoriaId     = @CategoriaId,
        Precio          = @Precio,
        LitrosPorUnidad = @LitrosPorUnidad,
        Stock           = @Stock,
        DVH             = @DVH
    WHERE Id = @Id;
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.sp_BajaLogicaProducto
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
        UPDATE dbo.Productos
        SET Activo = 0
        WHERE Id = @Id;
        COMMIT;
    END TRY
    BEGIN CATCH
        IF (XACT_STATE() <> 0) ROLLBACK;
        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrSeverity INT = ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.sp_AgregarProducto
    @Nombre NVARCHAR(200),
    @CategoriaId INT,
    @Precio DECIMAL(18,2),
    @LitrosPorUnidad FLOAT,
    @Stock INT,
    @DVH DECIMAL(38,0)
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

        INSERT INTO dbo.Productos (Nombre, CategoriaId, Precio, LitrosPorUnidad, Stock, Activo, DVH)
        VALUES (@Nombre, @CategoriaId, @Precio, @LitrosPorUnidad, @Stock, 1, @DVH);

        DECLARE @NuevoId INT = SCOPE_IDENTITY();
        IF (@StartedTran = 1) COMMIT TRAN;
        SELECT @NuevoId;
    END TRY
    BEGIN CATCH
        IF (XACT_STATE() <> 0 AND @@TRANCOUNT > 0) ROLLBACK TRAN;
        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrSeverity INT = ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_ActualizarProducto
    @Id INT,
    @Nombre NVARCHAR(100),
    @Precio DECIMAL(18,2),
    @LitrosPorUnidad DECIMAL(18,2),
    @Stock INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Productos
    SET Nombre = @Nombre,
        Precio = @Precio,
        LitrosPorUnidad = @LitrosPorUnidad,
        Stock = @Stock
    WHERE Id = @Id AND Activo = 1;
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.sp_Lote_ActualizarStockProducto
    @ProductoId INT,
    @Stock INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE Productos SET Stock = @Stock WHERE Id = @ProductoId;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ListarProductos]
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT p.Id,
               p.Nombre,
               p.CategoriaId,
               c.Nombre  AS CategoriaNombre,
               p.Precio,
               p.LitrosPorUnidad,
               p.Stock,
               p.Activo,
               p.DVH
        FROM  dbo.Productos p
        LEFT  JOIN dbo.Categorias c ON c.Id = p.CategoriaId;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg      NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrSeverity INT            = ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.sp_Productos_Listar_IdNombre
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT Id, Nombre FROM Productos WHERE Activo = 1 ORDER BY Nombre;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.sp_Productos_DescontarStock
    @ProductoId INT,
    @Cantidad INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @stock INT;
        SELECT @stock = Stock FROM Productos WHERE Id = @ProductoId;
        IF (@stock IS NULL) RAISERROR('Producto inexistente', 16, 1);
        IF (@stock < @Cantidad) RAISERROR('Stock insuficiente', 16, 1);
        UPDATE Productos SET Stock = Stock - @Cantidad WHERE Id = @ProductoId;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_InsertarProducto]
    @Nombre NVARCHAR(100),
    @CategoriaId INT,
    @Precio DECIMAL(10,2),
    @LitrosPorUnidad FLOAT,
    @Stock INT,
    @Activo BIT,
    @DVH DECIMAL(38,0) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Productos
    (
        Nombre,
        CategoriaId,
        Precio,
        LitrosPorUnidad,
        Stock,
        Activo,
        DVH
    )
    VALUES
    (
        @Nombre,
        @CategoriaId,
        @Precio,
        @LitrosPorUnidad,
        @Stock,
        @Activo,
        @DVH
    );

    SELECT CAST(SCOPE_IDENTITY() AS INT) AS IdProducto;
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_VerificarIntegridadProductos
AS
BEGIN
    SET NOCOUNT ON;

    CREATE TABLE #Errores (
        IdProducto INT,
        Nombre NVARCHAR(100),
        DVH_Original DECIMAL(38,0),
        DVH_Recalculado DECIMAL(38,0),
        Observacion NVARCHAR(200)
    );

    DECLARE @Id INT, @Nombre NVARCHAR(100), @CategoriaId INT,
            @Precio DECIMAL(18,2), @LitrosPorUnidad FLOAT, @Stock INT, @Activo BIT,
            @Concatenado NVARCHAR(MAX),
            @Hash VARBINARY(64),
            @DVH_Recalc BIGINT, @DVH_Orig DECIMAL(38,0);

    DECLARE cur CURSOR FOR
        SELECT Id, Nombre, CategoriaId, Precio, LitrosPorUnidad, Stock, Activo, DVH
        FROM Productos;

    OPEN cur;
    FETCH NEXT FROM cur INTO @Id, @Nombre, @CategoriaId, @Precio, @LitrosPorUnidad, @Stock, @Activo, @DVH_Orig;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @Concatenado = CONCAT(@Id, @Nombre, @CategoriaId, @Precio, @LitrosPorUnidad, @Stock, @Activo);
        SET @Hash = HASHBYTES('SHA2_256', CONVERT(VARBINARY(MAX), @Concatenado));
        SET @DVH_Recalc = ABS(CONVERT(BIGINT, SUBSTRING(@Hash, 1, 8)));

        IF @DVH_Recalc != @DVH_Orig
        BEGIN
            INSERT INTO #Errores(IdProducto, Nombre, DVH_Original, DVH_Recalculado, Observacion)
            VALUES(@Id, @Nombre, @DVH_Orig, @DVH_Recalc, 'DVH no coincide');
        END

        FETCH NEXT FROM cur INTO @Id, @Nombre, @CategoriaId, @Precio, @LitrosPorUnidad, @Stock, @Activo, @DVH_Orig;
    END

    CLOSE cur;
    DEALLOCATE cur;

    DECLARE @SumaDVH DECIMAL(38,0);
    DECLARE @DVV_Almacenado DECIMAL(38,0);
    DECLARE @Observacion NVARCHAR(200);

    SELECT @SumaDVH = SUM(DVH) FROM Productos;
    SELECT @DVV_Almacenado = DVV FROM DigitoVerificador WHERE Tabla = 'Productos';

    IF @SumaDVH != @DVV_Almacenado
    BEGIN
        SET @Observacion = 'DVV no coincide: Suma DVH=' + CAST(@SumaDVH AS NVARCHAR(50))
                         + ', DVV almacenado=' + CAST(@DVV_Almacenado AS NVARCHAR(50));

        INSERT INTO #Errores(IdProducto, Nombre, DVH_Original, DVH_Recalculado, Observacion)
        VALUES(NULL, NULL, NULL, NULL, @Observacion);
    END

    SELECT * FROM #Errores;

    DROP TABLE #Errores;
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.sp_Idiomas_Eliminar
    @Codigo NVARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        DECLARE @StartedTran BIT = 0;
        IF (@@TRANCOUNT = 0) BEGIN BEGIN TRAN; SET @StartedTran = 1; END
        DECLARE @IdIdioma INT;
        SELECT @IdIdioma = Id FROM Idiomas WHERE Codigo = @Codigo;
        IF @IdIdioma IS NULL RAISERROR('Idioma no encontrado', 16, 1);
        DELETE FROM TraduccionT WHERE IdIdioma = @IdIdioma;
        DELETE FROM Idiomas WHERE Id = @IdIdioma;
        IF (@StartedTran = 1) COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF (XACT_STATE() <> 0 AND @@TRANCOUNT > 0) ROLLBACK TRAN;
        DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_EliminarProducto
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Productos
    SET Activo = 0
    WHERE Id = @Id AND Activo = 1;
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_CalcularDVH_Productos
AS
BEGIN
    DECLARE
        @Id INT,
        @Nombre NVARCHAR(100),
        @CategoriaId INT,
        @Precio DECIMAL(10,2),
        @LitrosPorUnidad FLOAT,
        @Stock INT,
        @Activo BIT

    DECLARE cur CURSOR FOR
        SELECT Id, Nombre, CategoriaId, Precio, LitrosPorUnidad, Stock, Activo
        FROM Productos

    OPEN cur

    FETCH NEXT FROM cur INTO @Id, @Nombre, @CategoriaId, @Precio, @LitrosPorUnidad, @Stock, @Activo

    WHILE @@FETCH_STATUS = 0
    BEGIN

        DECLARE @Concatenado NVARCHAR(MAX)
        SET @Concatenado = CONCAT(@Id, @Nombre, @CategoriaId, @Precio, @LitrosPorUnidad, @Stock, @Activo)


        DECLARE @Hash VARBINARY(64) = HASHBYTES('SHA2_256', CONVERT(VARBINARY(MAX), @Concatenado))
        DECLARE @DVH BIGINT = ABS(CONVERT(BIGINT, SUBSTRING(@Hash, 1, 8)))


        UPDATE Productos
        SET DVH = @DVH
        WHERE Id = @Id

        FETCH NEXT FROM cur INTO @Id, @Nombre, @CategoriaId, @Precio, @LitrosPorUnidad, @Stock, @Activo
    END

    CLOSE cur
    DEALLOCATE cur


    EXEC sp_RecalcularDVV 'Productos'
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.sp_Bitacora_Insertar
    @UsuarioId INT = NULL,
    @FechaRegistro DATETIME,
    @Entidad NVARCHAR(100) = NULL,
    @Accion NVARCHAR(100) = NULL,
    @Detalle NVARCHAR(4000) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO dbo.Bitacora (UsuarioId, FechaRegistro, Entidad, Accion, Detalle)
        VALUES (@UsuarioId, @FechaRegistro, @Entidad, @Accion, @Detalle);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF (XACT_STATE() <> 0) ROLLBACK;
        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrSeverity INT = ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.sp_Bitacora_Buscar
    @Desde DATETIME2 = NULL,
    @Hasta DATETIME2 = NULL,
    @Usuario NVARCHAR(100) = NULL,
    @Accion NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT b.Id,
               b.UsuarioId,
               u.NombreUsuario,
               b.FechaRegistro,
               b.Entidad,
               b.Accion,
               b.Detalle
        FROM dbo.Bitacora b
        LEFT JOIN dbo.Usuarios u ON b.UsuarioId = u.Id
        WHERE (@Desde IS NULL OR b.FechaRegistro >= @Desde)
          AND (@Hasta IS NULL OR b.FechaRegistro <= @Hasta)
          AND (@Usuario IS NULL OR u.NombreUsuario LIKE '%' + @Usuario + '%')
          AND (@Accion IS NULL OR b.Accion LIKE '%' + @Accion + '%')
        ORDER BY b.FechaRegistro DESC;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrSeverity INT = ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.sp_Ventas_Insertar
    @Fecha     DATETIME,
    @UsuarioId INT,
    @ClienteId INT        = NULL,
    @Zona      NVARCHAR(50)  = NULL,
    @Vendedor  NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO Ventas
            (Fecha, UsuarioId, ClienteId, Zona, Vendedor)
        VALUES
            (@Fecha, @UsuarioId, @ClienteId, @Zona, @Vendedor);


        SELECT CONVERT(INT, SCOPE_IDENTITY());
    END TRY
    BEGIN CATCH
        DECLARE @Msg NVARCHAR(500) = ERROR_MESSAGE();
        RAISERROR(@Msg, 16, 1);
    END CATCH
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.sp_ProductoHistorial_ListarPorProducto
    @Id INT
AS
BEGIN
    SELECT IdHistorial, Fecha, Nombre, CategoriaId, Precio, LitrosPorUnidad, Stock, Activo
    FROM   ProductoHistorial
    WHERE  IdProducto = @Id
    ORDER  BY Fecha DESC;
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.sp_Inventario_ObtenerStockPorProducto
AS
BEGIN
    SELECT p.Nombre AS NombreProducto, p.CategoriaId,
        CASE p.CategoriaId WHEN 1 THEN 'Alcohólica' ELSE 'No Alcohólica' END AS CategoriaNombre,
        SUM(l.Cantidad) AS StockTotal
    FROM Productos p
    LEFT JOIN Lote l ON p.Id = l.ProductoId
    GROUP BY p.Nombre, p.CategoriaId;
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.sp_Lote_ListarPorProducto
    @ProductoId INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT Id, NumeroLote, FechaIngreso, FechaVencimiento, Cantidad, ProductoId
        FROM Lote
        WHERE ProductoId = @ProductoId
        ORDER BY FechaVencimiento ASC;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.sp_Lote_Eliminar
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DELETE FROM Lote WHERE Id = @Id;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.sp_Lote_CalcularStockTotal
    @ProductoId INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT ISNULL(SUM(Cantidad),0) AS StockTotal
        FROM Lote
        WHERE ProductoId = @ProductoId;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.sp_Lote_Agregar
    @NumeroLote NVARCHAR(50),
    @FechaIngreso DATETIME,
    @FechaVencimiento DATETIME,
    @Cantidad INT,
    @ProductoId INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO Lote (NumeroLote, FechaIngreso, FechaVencimiento, Cantidad, ProductoId)
        VALUES (@NumeroLote, @FechaIngreso, @FechaVencimiento, @Cantidad, @ProductoId);
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE dbo.sp_Reporte_Stock_Analisis
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Hoy date = CONVERT(date, GETDATE());
    SELECT p.Id AS ProductoId, p.Nombre AS Producto,
           COALESCE(c.Nombre, 'Sin categorÃ­a') AS Categoria,
           p.Stock AS StockTotal, p.Precio, p.LitrosPorUnidad,
           (SELECT COUNT(*) FROM dbo.Lote l WHERE l.ProductoId = p.Id
             AND l.Activo = 1 AND l.Cantidad > 0 AND l.FechaVencimiento >= @Hoy) AS LotesActivos,
           (SELECT COUNT(*) FROM dbo.Lote l WHERE l.ProductoId = p.Id
             AND l.Activo = 1 AND l.Cantidad > 0
             AND l.FechaVencimiento BETWEEN @Hoy AND DATEADD(day, 30, @Hoy)) AS LotesPorVencer,
           (SELECT COUNT(*) FROM dbo.Lote l WHERE l.ProductoId = p.Id
             AND l.Activo = 1 AND l.Cantidad > 0 AND l.FechaVencimiento < @Hoy) AS LotesVencidos
    FROM dbo.Productos p
    LEFT JOIN dbo.Categorias c ON c.Id = p.CategoriaId
    WHERE p.Activo = 1
    ORDER BY c.Nombre, p.Nombre;
END;

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.sp_Reporte_Stock
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT
            p.Id AS ProductoId,
            p.Nombre AS Producto,
            cat.Nombre AS Categoria,
            p.Stock AS StockTotal,
            p.Precio,
            p.LitrosPorUnidad,
            LotesActivos = (SELECT COUNT(*)
                            FROM Lote l
                            WHERE l.ProductoId = p.Id)
        FROM Productos p
        INNER JOIN Categorias cat ON cat.Id = p.CategoriaId
        ORDER BY cat.Nombre, p.Nombre;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg2 NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrSeverity2 INT = ERROR_SEVERITY();
        RAISERROR(@ErrMsg2, @ErrSeverity2, 1);
    END CATCH
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE dbo.sp_Reporte_Zonas_Analisis
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Zona FROM dbo.Clientes WHERE NULLIF(LTRIM(RTRIM(Zona)), '') IS NOT NULL
    UNION
    SELECT Zona FROM dbo.Ventas WHERE NULLIF(LTRIM(RTRIM(Zona)), '') IS NOT NULL
    ORDER BY Zona;
END;

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE dbo.sp_Reporte_Ventas_Analisis
    @Zona nvarchar(100) = NULL,
    @ProductoId int = NULL,
    @FechaDesde date = NULL,
    @FechaHasta date = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF @FechaDesde > @FechaHasta THROW 50001, 'Rango de fechas invÃ¡lido.', 1;
    SELECT v.Id AS VentaId, v.Fecha,
           COALESCE(NULLIF(v.Vendedor, ''), u.NombreUsuario, '') AS Vendedor,
           COALESCE(NULLIF(v.Zona, ''), c.Zona, '') AS Zona,
           COALESCE(c.NombreCompleto, 'Venta Mostrador') AS Cliente,
           p.Nombre AS Producto, dv.Cantidad, dv.PrecioUnitario,
           dv.Cantidad * dv.PrecioUnitario AS Subtotal
    FROM dbo.Ventas v
    JOIN dbo.DetalleVentas dv ON dv.VentaId = v.Id
    JOIN dbo.Productos p ON p.Id = dv.ProductoId
    LEFT JOIN dbo.Clientes c ON c.Id = v.ClienteId
    LEFT JOIN dbo.Usuarios u ON u.Id = v.UsuarioId
    WHERE (@Zona IS NULL OR COALESCE(NULLIF(v.Zona, ''), c.Zona, '') = @Zona)
      AND (@ProductoId IS NULL OR p.Id = @ProductoId)
      AND (@FechaDesde IS NULL OR v.Fecha >= @FechaDesde)
      AND (@FechaHasta IS NULL OR CONVERT(date, v.Fecha) <= @FechaHasta)
    ORDER BY v.Fecha DESC, v.Id DESC, p.Nombre;
END;

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.sp_Reporte_Ventas
    @Zona       NVARCHAR(100) = NULL,
    @ProductoId INT           = NULL,
    @FechaDesde DATE          = NULL,
    @FechaHasta DATE          = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT v.Fecha,
               Vendedor = u.NombreUsuario,
               Zona     = COALESCE(c.Zona, ''),
               Cliente  = COALESCE(c.NombreCompleto, 'Venta Mostrador'),
               Producto = p.Nombre,
               dv.Cantidad,
               dv.PrecioUnitario,
               Subtotal = dv.Cantidad * dv.PrecioUnitario
        FROM Ventas v
        INNER JOIN Usuarios u         ON u.Id = v.UsuarioId
        INNER JOIN DetalleVentas dv   ON dv.VentaId = v.Id
        INNER JOIN Productos p        ON p.Id = dv.ProductoId
        LEFT  JOIN Clientes c         ON c.Id = v.ClienteId
        WHERE
              (@Zona IS NULL OR (c.Zona IS NOT NULL AND c.Zona = @Zona))
              AND (@ProductoId IS NULL OR p.Id = @ProductoId)
              AND (@FechaDesde IS NULL OR v.Fecha >= @FechaDesde)
              AND (@FechaHasta IS NULL OR v.Fecha < DATEADD(DAY, 1, @FechaHasta))
        ORDER BY v.Fecha DESC;
    END TRY
    BEGIN CATCH
        DECLARE @Msg NVARCHAR(500) = ERROR_MESSAGE();
        RAISERROR(@Msg, 16, 1);
    END CATCH
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.sp_DetalleVentas_Upsert
    @VentaId INT,
    @ProductoId INT,
    @Cantidad INT,
    @PrecioUnitario DECIMAL(18,2)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM DetalleVentas WHERE VentaId = @VentaId AND ProductoId = @ProductoId)
            UPDATE DetalleVentas
            SET Cantidad = Cantidad + @Cantidad,
                PrecioUnitario = @PrecioUnitario
            WHERE VentaId = @VentaId AND ProductoId = @ProductoId;
        ELSE
            INSERT INTO DetalleVentas (VentaId, ProductoId, Cantidad, PrecioUnitario)
            VALUES (@VentaId, @ProductoId, @Cantidad, @PrecioUnitario);
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END

GO
SET IDENTITY_INSERT [dbo].[Idiomas] ON

GO
INSERT [dbo].[Idiomas] ([Id], [Codigo], [Nombre]) VALUES (1, N'es', N'Español')
GO
INSERT [dbo].[Idiomas] ([Id], [Codigo], [Nombre]) VALUES (2, N'en', N'Inglés')
GO
INSERT [dbo].[Idiomas] ([Id], [Codigo], [Nombre]) VALUES (5, N'fr', N'Francés')
GO
INSERT [dbo].[Idiomas] ([Id], [Codigo], [Nombre]) VALUES (11, N'de', N'Alemán')
GO
INSERT [dbo].[Idiomas] ([Id], [Codigo], [Nombre]) VALUES (12, N'it', N'Italiano')
GO
INSERT [dbo].[Idiomas] ([Id], [Codigo], [Nombre]) VALUES (13, N'pt', N'Portugués')
GO
SET IDENTITY_INSERT [dbo].[Idiomas] OFF
GO
SET IDENTITY_INSERT [dbo].[Categorias] ON

GO
INSERT [dbo].[Categorias] ([Id], [Nombre]) VALUES (1, N'Alcohólica')
GO
INSERT [dbo].[Categorias] ([Id], [Nombre]) VALUES (2, N'No Alcohólica')
GO
SET IDENTITY_INSERT [dbo].[Categorias] OFF
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (0, N'lblUsuario')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (1, N'lblPassword')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (2, N'btnLogin')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (3, N'lblIdioma')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (4, N'FrmLogin')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (5, N'menuUsuarios')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (6, N'menuProductos')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (7, N'menuVentas')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (8, N'menuReportes')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (9, N'menuGestionPermisos')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (10, N'cerrarSesion')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (11, N'usuario')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (12, N'FrmGestionPermisos')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (13, N'btnAgregarPermisoASel')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (14, N'btnAsignarRol')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (15, N'btnCrearGrupo')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (16, N'lblRoles')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (17, N'lblPermisosDisponibles')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (18, N'lblSeleccionados')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (19, N'txtNombreGrupo')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (20, N'PlaceHolderText')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (21, N'menuAsignarPermisos')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (22, N'FrmUsuarios')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (23, N'btnAgregar')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (24, N'btnModificar')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (25, N'btnEliminar')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (26, N'btnGrabar')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (27, N'btnCancelar')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (28, N'lblUsuario')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (29, N'lblPassword')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (30, N'lblRol')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (31, N'menuIdiomas')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (32, N'menuVerificarIntegridad')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (33, N'menuRecalcularIntegridad')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (34, N'menuBitacora')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (35, N'btnNuevo')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (36, N'MostrarEliminados')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (37, N'lblCodigo')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (38, N'lblNombre')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (39, N'Gestionar')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (40, N'PermisosSimples')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (41, N'CrearPermisoSimple')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (42, N'PermisosCompuestos')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (43, N'SeleccionarSimples')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (44, N'GuardarAsignacion')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (45, N'EliminarGrupo')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (46, N'CrearGrupo')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (47, N'Asignar')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (48, N'SeleccionarUsuario')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (49, N'GruposDisponibles')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (50, N'Agregar')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (51, N'Registrar')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (52, N'Total')
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (53, N'GenerarReporte')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 0, N'Usuario')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 1, N'Contraseña')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 2, N'Iniciar Sesión')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 3, N'Idioma')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 4, N'Login - Gestión de Bebidas')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 5, N'Usuarios')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 6, N'Productos')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 7, N'Ventas')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 8, N'Reportes')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 9, N'Gestión de Permisos')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 10, N'Cerrar Sesión')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 11, N'Usuario')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 12, N'Gestión de Permisos')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 13, N'Agregar')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 14, N'Asignar Permisos a Rol')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 15, N'Crear Grupo')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 16, N'Seleccionar rol:')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 17, N'Permisos Simples Disponibles:')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 18, N'Permisos Seleccionados:')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 19, N'Nombre del grupo')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 20, N'Nombre del grupo')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 21, N'Asignar Permisos')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 22, N'Gestión de Usuarios')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 23, N'Agregar')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 24, N'Modificar')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 25, N'Eliminar')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 26, N'Grabar')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 27, N'Cancelar')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 28, N'Usuario')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 29, N'Contraseña')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 30, N'Rol')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 31, N'Idiomas')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 32, N'Verificar Integridad')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 33, N'Recalcular Integridad')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 34, N'Bitacora')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 35, N'Nuevo')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 36, N'Mostrar Eliminados')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 37, N'Codigo')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 38, N'Nombre')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 39, N'Gestionar')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 40, N'Permisos Simples')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 41, N'CrearPermisoSimple')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 42, N'Permisos Compuestos')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 43, N'Seleccionar Simples')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 44, N'GuardarAsignacion')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 45, N'EliminarGrupo')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 46, N'CrearGrupo')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 47, N'Asignar')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 48, N'Seleccionar Usuario')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 49, N'GruposDisponibles')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 50, N'Agregar')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 51, N'Registrar')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 52, N'Total')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 53, N'GenerarReporte')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 0, N'User')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 1, N'Password')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 2, N'Login')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 3, N'Language')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 4, N'Login - Beverage Management')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 5, N'Users')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 6, N'Products')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 7, N'Sales')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 8, N'Reports')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 9, N'Permission Groups')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 10, N'Log Out')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 11, N'User')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 12, N'Permission Management')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 13, N'Add')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 14, N'Assign Permissions to Role')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 15, N'Create Group')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 16, N'Select Role:')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 17, N'Available Simple Permissions:')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 18, N'Selected Permissions:')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 19, N'Group Name')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 20, N'Group Name')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 21, N'Assign Permissions')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 22, N'User Management')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 23, N'Add')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 24, N'Edit')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 25, N'Delete')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 26, N'Save')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 27, N'Cancel')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 28, N'User')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 29, N'Password')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 30, N'Role')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 0, N'Utilisateur')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 1, N'Mot de passe')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 2, N'Connexion')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 3, N'Langue')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 4, N'Connexion - Gestion des Boissons')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 5, N'Utilisateurs')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 6, N'Produits')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 7, N'Ventes')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 8, N'Rapports')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 9, N'Gestion des Permissions')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 10, N'Déconnexion')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 11, N'Utilisateur')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 12, N'Gestion des permissions')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 13, N'Ajouter')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 14, N'Attribuer des permissions au rôle')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 15, N'Créer un groupe')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 16, N'Sélectionner un rôle :')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 17, N'Permissions simples disponibles :')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 18, N'Permissions sélectionnées :')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 19, N'Nom du groupe')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 20, N'Nom du groupe')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 21, N'Attribuer des autorisations')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 22, N'Gestion des Utilisateurs')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 23, N'Ajouter')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 24, N'Modifier')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 25, N'Supprimer')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 26, N'Enregistrer')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 27, N'Annuler')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 28, N'Utilisateur')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 29, N'Mot de passe')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 30, N'Rôle')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 0, N'Benutzer')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 1, N'Passwort')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 2, N'Anmelden')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 3, N'Sprache')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 4, N'Anmeldung – Getränkeverwaltung')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 5, N'Benutzer')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 6, N'Produkte')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 7, N'Verkäufe')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 8, N'Berichte')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 9, N'Berechtigungsverwaltung')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 10, N'Abmelden')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 11, N'Benutzer')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 12, N'Berechtigungsverwaltung')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 13, N'Hinzufügen')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 14, N'Berechtigungen zu Rolle zuweisen')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 15, N'Gruppe erstellen')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 16, N'Rolle auswählen:')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 17, N'Verfügbare einfache Berechtigungen:')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 18, N'Ausgewählte Berechtigungen:')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 19, N'Gruppenname')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 20, N'Gruppenname')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 21, N'Berechtigungen zuweisen')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 22, N'Benutzerverwaltung')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 23, N'Hinzufügen')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 24, N'Bearbeiten')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 25, N'Löschen')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 26, N'Speichern')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 27, N'Abbrechen')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 28, N'Benutzer')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 29, N'Passwort')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 30, N'Rolle')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 0, N'Utente')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 1, N'Password')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 2, N'Accedi')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 3, N'Lingua')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 4, N'Accesso – Gestione Bevande')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 5, N'Utenti')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 6, N'Prodotti')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 7, N'Vendite')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 8, N'Report')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 9, N'Gestione Permessi')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 10, N'Esci')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 11, N'Utente')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 12, N'Gestione dei permessi')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 13, N'Aggiungi')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 14, N'Assegna permessi al ruolo')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 15, N'Crea gruppo')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 16, N'Seleziona ruolo:')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 17, N'Permessi semplici disponibili:')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 18, N'Permessi selezionati:')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 19, N'Nome del gruppo')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 20, N'Nome del gruppo')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 21, N'Assegnare permessi')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 22, N'Gestione Utenti')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 23, N'Aggiungi')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 24, N'Modifica')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 25, N'Elimina')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 26, N'Salva')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 27, N'Annulla')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 28, N'Utente')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 29, N'Password')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 30, N'Ruolo')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 0, N'Usuário')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 1, N'Senha')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 2, N'Entrar')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 3, N'Idioma')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 4, N'Login – Gestão de Bebidas')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 5, N'Usuários')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 6, N'Produtos')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 7, N'Vendas')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 8, N'Relatórios')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 9, N'Gestão de Permissões')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 10, N'Sair')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 11, N'Usuário')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 12, N'Gerenciamento de Permissões')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 13, N'Adicionar')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 14, N'Atribuir Permissões ao Papel')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 15, N'Criar Grupo')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 16, N'Selecionar papel:')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 17, N'Permissões Simples Disponíveis:')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 18, N'Permissões Selecionadas:')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 19, N'Nome do grupo')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 20, N'Nome do grupo')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 21, N'Atribuir permissões')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 22, N'Gestão de Usuários')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 23, N'Adicionar')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 24, N'Editar')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 25, N'Excluir')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 26, N'Salvar')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 27, N'Cancelar')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 28, N'Usuário')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 29, N'Senha')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 30, N'Função')
GO
