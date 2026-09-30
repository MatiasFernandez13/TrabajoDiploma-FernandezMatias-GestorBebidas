:ON ERROR EXIT

USE [master];
GO
IF DB_ID(N'BaseGestionBebidasMF') IS NOT NULL
    THROW 50000, N'La base ya existe. Use RepararBase_BebidasMF.sql para una instalacion existente o una instancia vacia para instalar.', 1;
CREATE DATABASE [BaseGestionBebidasMF];
GO
USE [BaseGestionBebidasMF]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bitacora](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [UsuarioId] [int] NOT NULL,
    [FechaRegistro] [datetime2](7) NOT NULL,
    [Entidad] [nvarchar](100) NOT NULL,
    [Accion] [nvarchar](50) NOT NULL,
    [Detalle] [nvarchar](max) NULL,
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
CREATE TABLE [dbo].[Categorias](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [Nombre] [nvarchar](100) NOT NULL,
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
    [NombreCompleto] [nvarchar](100) NULL,
    [Zona] [nvarchar](50) NULL,
    [Direccion] [nvarchar](255) NULL,
    [Telefono] [nvarchar](50) NULL,
    [Email] [nvarchar](150) NULL,
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

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DigitoVerificador](
    [Tabla] [nvarchar](50) NOT NULL,
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
CREATE TABLE [dbo].[Idiomas](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [Codigo] [nvarchar](10) NOT NULL,
    [Nombre] [nvarchar](50) NULL,
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
CREATE TABLE [dbo].[Lote](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [NumeroLote] [nvarchar](50) NULL,
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
CREATE TABLE [dbo].[Permiso](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [Nombre] [nvarchar](100) NOT NULL,
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
CREATE TABLE [dbo].[ProductoHistorial](
    [IdHistorial] [int] IDENTITY(1,1) NOT NULL,
    [IdProducto] [int] NOT NULL,
    [Nombre] [nvarchar](200) NOT NULL,
    [CategoriaId] [int] NULL,
    [Precio] [decimal](18, 2) NULL,
    [LitrosPorUnidad] [float] NULL,
    [Stock] [int] NULL,
    [Activo] [bit] NOT NULL,
    [Fecha] [datetime] NOT NULL,
    [Accion] [nvarchar](20) NOT NULL,
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
CREATE TABLE [dbo].[Productos](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [Nombre] [nvarchar](100) NOT NULL,
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
CREATE TABLE [dbo].[Tag](
    [Id] [int] NOT NULL,
    [Nombre] [nvarchar](50) NOT NULL,
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
CREATE TABLE [dbo].[TraduccionT](
    [IdIdioma] [int] NOT NULL,
    [IdTag] [int] NOT NULL,
    [Traduccion] [nvarchar](100) NOT NULL,
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
CREATE TABLE [dbo].[Usuarios](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [NombreUsuario] [nvarchar](50) NOT NULL,
    [Contraseña] [nvarchar](512) NOT NULL,
    [Salt] [nvarchar](100) NOT NULL,
    [Idioma] [nvarchar](10) NOT NULL,
    [Activo] [bit] NOT NULL,
    [DVH] [decimal](38, 0) NULL,
 CONSTRAINT [PK__Usuarios__3214EC07B9B25E20] PRIMARY KEY CLUSTERED
(
    [Id] ASC
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
    [Zona] [nvarchar](50) NULL,
    [Vendedor] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Bitacora] ON

INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1, 7, CAST(N'2025-07-11T23:27:54.3920891' AS DateTime2), N'Producto', N'INSERT', N'Antes: null; Después: SheridansMuestra - 50L - $10', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2, 7, CAST(N'2025-07-11T23:30:26.5303388' AS DateTime2), N'Usuario', N'INSERT', N'Antes: null; Después: BE.Usuario', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3, 7, CAST(N'2025-07-11T23:58:12.4462195' AS DateTime2), N'Producto', N'INSERT', N'Antes: null; Después: testBitacora - 500L - $450', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (4, 7, CAST(N'2025-09-04T00:16:28.5100000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (6, 7, CAST(N'2025-09-04T00:17:00.7633333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (8, 7, CAST(N'2025-09-05T15:54:42.7166667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (9, 7, CAST(N'2025-09-05T15:55:01.1966667' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (10, 7, CAST(N'2025-09-05T15:55:10.3300000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (11, 7, CAST(N'2025-09-05T15:55:15.6266667' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (12, 7, CAST(N'2025-09-05T15:55:20.3533333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (13, 7, CAST(N'2025-09-05T15:55:28.6666667' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (14, 7, CAST(N'2025-09-05T16:14:42.7533333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (15, 7, CAST(N'2025-09-05T16:14:48.1900000' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (16, 7, CAST(N'2025-09-05T16:14:51.5233333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (17, 7, CAST(N'2025-09-05T16:14:57.2033333' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (18, 7, CAST(N'2025-09-05T16:15:02.0633333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (19, 7, CAST(N'2025-09-05T17:15:47.7600000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (20, 7, CAST(N'2025-09-05T17:16:12.5133333' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (21, 14, CAST(N'2025-09-05T17:16:18.1200000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario tevez', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (22, 14, CAST(N'2025-09-05T17:16:23.5500000' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario tevez', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (23, 14, CAST(N'2025-09-05T17:16:36.6533333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario tevez', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (24, 7, CAST(N'2025-09-05T17:22:49.1866667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (25, 7, CAST(N'2025-10-07T20:29:59.1633333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (26, 7, CAST(N'2025-10-17T19:13:54.3300000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (27, 7, CAST(N'2025-10-17T19:16:33.9566667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (28, 7, CAST(N'2025-10-17T19:24:10.5800000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (29, 7, CAST(N'2025-10-20T19:12:05.8633333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (30, 7, CAST(N'2025-10-31T17:12:55.8266667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (31, 7, CAST(N'2025-10-31T17:37:08.3600000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (32, 7, CAST(N'2025-10-31T19:15:58.2433333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (33, 7, CAST(N'2025-10-31T19:16:11.6766667' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (34, 7, CAST(N'2025-10-31T19:22:28.4400000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (35, 7, CAST(N'2025-10-31T21:18:11.5666667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (36, 7, CAST(N'2025-10-31T21:51:39.8700000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (37, 7, CAST(N'2025-10-31T21:53:09.0500000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (38, 7, CAST(N'2025-10-31T21:53:56.7733333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (39, 7, CAST(N'2025-10-31T21:54:45.0366667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (40, 7, CAST(N'2025-10-31T21:54:52.0433333' AS DateTime2), N'Usuario', N'Eliminar', N'Se eliminó el usuario con Id=25', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (41, 7, CAST(N'2025-11-04T00:11:49.6533333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (42, 7, CAST(N'2025-11-04T00:12:02.1866667' AS DateTime2), N'Producto', N'Modificación', N'Se modificó el producto SheridansMuestra', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (43, 7, CAST(N'2025-11-04T00:12:20.3033333' AS DateTime2), N'Producto', N'Modificación', N'Se modificó el producto Fernet Branca', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (44, 7, CAST(N'2025-11-04T00:12:30.2566667' AS DateTime2), N'Producto', N'Baja', N'Se eliminó el producto con Id=11', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (45, 7, CAST(N'2025-11-04T00:12:40.8400000' AS DateTime2), N'Producto', N'Alta', N'Se agregó el producto Agua Mineral', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (46, 7, CAST(N'2025-11-04T00:27:37.3000000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (47, 7, CAST(N'2025-11-04T00:27:57.1633333' AS DateTime2), N'Producto', N'Modificación', N'Se modificó el producto Agua M', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (48, 7, CAST(N'2025-11-04T00:28:05.7900000' AS DateTime2), N'Producto', N'Baja', N'Se eliminó el producto con Id=13', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (49, 7, CAST(N'2025-11-04T00:28:08.9400000' AS DateTime2), N'Producto', N'Baja', N'Se eliminó el producto con Id=14', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (50, 7, CAST(N'2025-11-04T23:12:51.0966667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (51, 7, CAST(N'2025-11-04T23:39:10.2900000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (52, 7, CAST(N'2025-11-06T00:07:07.8400000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (53, 7, CAST(N'2025-11-06T00:07:55.3500000' AS DateTime2), N'Producto', N'Modificación', N'Se modificó el producto Citric Jugo', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (54, 7, CAST(N'2025-11-06T00:09:02.5400000' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (55, 7, CAST(N'2025-11-06T00:09:47.3400000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (56, 7, CAST(N'2025-11-06T00:10:21.9200000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (57, 7, CAST(N'2025-11-06T22:23:39.1233333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (58, 7, CAST(N'2025-11-06T22:25:18.7866667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (59, 7, CAST(N'2025-11-06T22:28:47.1533333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (60, 7, CAST(N'2025-11-07T00:24:06.1833333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (61, 7, CAST(N'2025-11-07T00:24:14.8366667' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (62, 7, CAST(N'2025-11-07T00:24:19.5066667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (63, 7, CAST(N'2025-11-07T00:24:26.2633333' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (64, 7, CAST(N'2025-11-07T00:24:31.5133333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (65, 7, CAST(N'2025-11-07T00:24:47.2066667' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (66, 7, CAST(N'2025-11-07T00:24:51.2200000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (67, 7, CAST(N'2025-11-07T00:24:57.3166667' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (68, 7, CAST(N'2025-11-07T00:25:02.5000000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (69, 7, CAST(N'2025-11-07T00:25:09.3366667' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (70, 7, CAST(N'2025-11-07T00:25:14.8733333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (71, 7, CAST(N'2025-11-07T00:25:30.0533333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (72, 7, CAST(N'2025-11-13T22:38:04.3600000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (73, 7, CAST(N'2025-11-13T22:44:30.1233333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (74, 7, CAST(N'2025-11-13T22:55:57.6900000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (75, 7, CAST(N'2025-11-13T22:57:25.2800000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (76, 7, CAST(N'2025-11-13T22:58:31.5266667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (77, 7, CAST(N'2025-11-13T23:03:18.6400000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (78, 7, CAST(N'2025-11-13T23:06:20.2033333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (79, 26, CAST(N'2025-11-13T23:17:16.7433333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario vendedor', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (80, 7, CAST(N'2025-11-13T23:22:34.2833333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (81, 7, CAST(N'2025-11-13T23:24:07.4366667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (82, 7, CAST(N'2025-11-13T23:26:36.7633333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (83, 7, CAST(N'2025-11-13T23:42:26.9633333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (84, 7, CAST(N'2025-11-13T23:42:49.7433333' AS DateTime2), N'Usuario', N'Alta', N'Se creó el usuario usuariiitoo con rol Vendedor', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (85, 7, CAST(N'2025-11-13T23:50:51.0266667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (86, 7, CAST(N'2025-11-13T23:51:03.3300000' AS DateTime2), N'Usuario', N'Alta', N'Se creó el usuario testeerrr con rol Vendedor', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (87, 7, CAST(N'2025-11-13T23:51:16.6400000' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario carlosPrueba, rol: Vendedor', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (88, 7, CAST(N'2025-11-13T23:54:21.8300000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (89, 7, CAST(N'2025-11-13T23:56:26.4200000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (90, 7, CAST(N'2025-11-13T23:57:07.3933333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (91, 7, CAST(N'2025-11-13T23:58:48.6233333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (92, 7, CAST(N'2025-11-13T23:59:41.7100000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (93, 7, CAST(N'2025-11-13T23:59:45.9666667' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario admin, rol: Administrador', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (94, 7, CAST(N'2025-11-14T00:01:45.8433333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (95, 7, CAST(N'2025-11-14T17:29:20.8100000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (96, 7, CAST(N'2025-11-14T17:30:46.0300000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (97, 7, CAST(N'2025-11-14T17:30:55.0533333' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario calitosM, rol: Vendedor', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (98, 7, CAST(N'2025-11-14T17:31:20.9533333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (99, 7, CAST(N'2025-11-14T17:31:27.1033333' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario calitosM, rol: Vendedor', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (100, 7, CAST(N'2025-11-14T17:32:21.8900000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (101, 7, CAST(N'2025-11-14T17:32:59.6466667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
GO
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (102, 7, CAST(N'2025-11-14T17:35:45.4000000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (103, 7, CAST(N'2025-11-14T17:35:54.3133333' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario ana, rol: Vendedor', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (104, 7, CAST(N'2025-11-14T17:37:03.6800000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (105, 7, CAST(N'2025-11-14T17:37:14.0933333' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario tevezzz, rol: Vendedor', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (106, 7, CAST(N'2025-11-14T17:38:55.3633333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (107, 7, CAST(N'2025-11-14T18:16:42.7366667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (108, 7, CAST(N'2025-11-14T19:22:18.8566667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (109, 7, CAST(N'2025-11-22T11:59:26.5566667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (110, 7, CAST(N'2025-11-22T12:00:34.6800000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (111, 7, CAST(N'2025-11-22T12:03:21.0033333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (112, 7, CAST(N'2025-11-22T12:03:50.4933333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (113, 7, CAST(N'2025-11-22T12:05:15.9333333' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (114, 7, CAST(N'2025-11-26T13:38:52.0866667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (115, 7, CAST(N'2025-11-26T13:41:11.2566667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (116, 7, CAST(N'2025-11-26T13:42:46.3900000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (117, 7, CAST(N'2025-11-26T13:43:17.9633333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (118, 7, CAST(N'2025-11-26T13:50:25.5266667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (119, 7, CAST(N'2025-11-26T13:52:31.2433333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (120, 7, CAST(N'2025-11-26T18:48:58.9733333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (121, 7, CAST(N'2025-11-26T18:50:03.4166667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (122, 7, CAST(N'2025-11-26T22:52:41.1200000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (123, 7, CAST(N'2025-11-27T21:47:35.0666667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (124, 7, CAST(N'2025-11-27T22:19:53.9333333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (125, 7, CAST(N'2025-12-12T15:37:28.6900000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (126, 7, CAST(N'2025-12-12T15:37:43.4966667' AS DateTime2), N'Usuario', N'Alta', N'Se creó el usuario usuariootp con rol Vendedor', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (127, 7, CAST(N'2025-12-12T15:37:54.7700000' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario usuariootp, rol: Vendedor', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (128, 7, CAST(N'2025-12-12T15:38:01.0600000' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario usuariootoo, rol: Vendedor', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (129, 7, CAST(N'2025-12-12T15:38:05.0533333' AS DateTime2), N'Usuario', N'Eliminar', N'Se eliminó el usuario con Id=23', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (130, 7, CAST(N'2025-12-12T15:38:10.8133333' AS DateTime2), N'Usuario', N'Eliminar', N'Se eliminó el usuario con Id=23', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (131, 7, CAST(N'2025-12-12T15:38:16.4400000' AS DateTime2), N'Usuario', N'Eliminar', N'Se eliminó el usuario con Id=23', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (132, 7, CAST(N'2025-12-12T15:38:37.2233333' AS DateTime2), N'Producto', N'Alta', N'Se agregó el producto testt1', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (133, 7, CAST(N'2025-12-12T15:38:44.9200000' AS DateTime2), N'Producto', N'Modificación', N'Se modificó el producto testt1aaa', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (134, 7, CAST(N'2025-12-12T15:38:54.7733333' AS DateTime2), N'Producto', N'Baja lógica', N'Se dio de baja el producto con Id=17', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (135, 7, CAST(N'2025-12-12T15:40:58.6466667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (136, 7, CAST(N'2025-12-12T19:32:05.1233333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (137, 7, CAST(N'2025-12-12T19:34:07.4833333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (138, 7, CAST(N'2025-12-12T19:35:36.7333333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (139, 7, CAST(N'2025-12-13T11:19:08.0733333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (140, 7, CAST(N'2025-12-13T11:49:14.8533333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (141, 7, CAST(N'2025-12-13T11:58:24.4233333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (142, 7, CAST(N'2025-12-13T16:45:48.1400000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (143, 7, CAST(N'2025-12-13T16:47:57.9166667' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (144, 7, CAST(N'2025-12-13T21:13:41.1800000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (145, 7, CAST(N'2025-12-13T21:17:33.4533333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (146, 7, CAST(N'2025-12-13T21:38:36.9466667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (147, 7, CAST(N'2025-12-13T21:51:32.1233333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (148, 7, CAST(N'2025-12-13T22:08:25.9833333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (149, 7, CAST(N'2025-12-13T22:14:33.6500000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (150, 7, CAST(N'2025-12-13T22:18:55.9600000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (151, 7, CAST(N'2025-12-13T22:19:20.6700000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (152, 7, CAST(N'2025-12-13T22:19:40.9933333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (153, 7, CAST(N'2025-12-13T22:21:17.8933333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (154, 7, CAST(N'2025-12-13T22:25:48.4700000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (155, 7, CAST(N'2025-12-13T22:51:45.2633333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (156, 7, CAST(N'2025-12-13T23:32:59.9600000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (157, 7, CAST(N'2025-12-13T23:33:21.7466667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (158, 7, CAST(N'2025-12-13T23:34:37.4066667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (159, 7, CAST(N'2025-12-14T00:11:45.7100000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (160, 7, CAST(N'2025-12-14T00:27:19.4266667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (161, 7, CAST(N'2025-12-14T00:29:20.7433333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (162, 7, CAST(N'2025-12-14T00:33:11.0800000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (163, 7, CAST(N'2025-12-14T00:35:06.8233333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (164, 7, CAST(N'2025-12-14T00:52:41.0600000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (165, 7, CAST(N'2025-12-14T01:10:02.8600000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (166, 7, CAST(N'2025-12-14T01:11:53.1833333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (167, 7, CAST(N'2025-12-14T01:28:36.3366667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (168, 7, CAST(N'2025-12-14T01:29:04.3433333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (169, 7, CAST(N'2025-12-14T01:30:42.2466667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (170, 7, CAST(N'2025-12-14T01:52:07.1133333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (171, 7, CAST(N'2025-12-14T02:06:59.6300000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (172, 7, CAST(N'2025-12-14T02:11:21.4833333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (173, 7, CAST(N'2025-12-14T02:15:03.7766667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (174, 7, CAST(N'2025-12-14T02:15:48.8466667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (175, 7, CAST(N'2025-12-14T02:24:24.9166667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (176, 7, CAST(N'2025-12-14T02:26:24.7733333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (177, 7, CAST(N'2025-12-16T21:02:24.9933333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (178, 7, CAST(N'2025-12-16T21:20:14.2866667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (179, 7, CAST(N'2025-12-16T21:20:53.1266667' AS DateTime2), N'Permisos', N'Asignar', N'Se asignaron grupos de permisos al usuario Id=22', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (180, 7, CAST(N'2025-12-16T21:21:00.2766667' AS DateTime2), N'Permisos', N'Asignar', N'Se asignaron grupos de permisos al usuario Id=8', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (181, 7, CAST(N'2025-12-16T21:21:03.6900000' AS DateTime2), N'Permisos', N'Asignar', N'Se asignaron grupos de permisos al usuario Id=14', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (182, 7, CAST(N'2025-12-16T21:21:06.8266667' AS DateTime2), N'Permisos', N'Asignar', N'Se asignaron grupos de permisos al usuario Id=16', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (183, 7, CAST(N'2025-12-16T21:21:09.9166667' AS DateTime2), N'Permisos', N'Asignar', N'Se asignaron grupos de permisos al usuario Id=20', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (184, 7, CAST(N'2025-12-16T21:21:13.3766667' AS DateTime2), N'Permisos', N'Asignar', N'Se asignaron grupos de permisos al usuario Id=21', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (185, 7, CAST(N'2025-12-16T21:21:18.4366667' AS DateTime2), N'Permisos', N'Asignar', N'Se asignaron grupos de permisos al usuario Id=22', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (186, 7, CAST(N'2025-12-16T21:23:50.6766667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (187, 7, CAST(N'2025-12-16T21:24:30.7800000' AS DateTime2), N'Usuario', N'Alta', N'Se creó el usuario testu con rol Vendedor', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (188, 7, CAST(N'2025-12-16T21:24:46.6833333' AS DateTime2), N'Usuario', N'Alta', N'Se creó el usuario testmen con rol Vendedor', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (189, 7, CAST(N'2025-12-16T21:25:00.3733333' AS DateTime2), N'Permisos', N'Asignar', N'Se asignaron grupos de permisos al usuario Id=24', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (190, 7, CAST(N'2025-12-16T21:25:04.7633333' AS DateTime2), N'Permisos', N'Asignar', N'Se asignaron grupos de permisos al usuario Id=25', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (191, 7, CAST(N'2025-12-16T21:32:29.0000000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (192, 7, CAST(N'2025-12-16T21:47:08.9900000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (193, 7, CAST(N'2025-12-16T22:18:05.8900000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (194, 7, CAST(N'2025-12-16T22:18:16.5533333' AS DateTime2), N'Usuario', N'Error', N'Modificación usuario fallida: Error en UsuarioDAL.Modificar', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (195, 7, CAST(N'2025-12-16T22:18:23.9066667' AS DateTime2), N'Sistema', N'Error', N'Error en UsuarioDAL.Modificar', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (196, 7, CAST(N'2025-12-16T22:18:35.6133333' AS DateTime2), N'Usuario', N'Error', N'Modificación usuario fallida: Error en UsuarioDAL.Modificar', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (197, 7, CAST(N'2025-12-16T22:18:55.1700000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (198, 7, CAST(N'2025-12-16T22:19:04.4700000' AS DateTime2), N'Usuario', N'Error', N'Modificación usuario fallida: Error en UsuarioDAL.Modificar', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (199, 7, CAST(N'2025-12-16T22:32:25.0066667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (200, 7, CAST(N'2025-12-16T22:32:31.8233333' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario carlitos, rol: Vendedor', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (201, 7, CAST(N'2025-12-16T22:32:37.3900000' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario carlitos, rol: Vendedor', NULL)
GO
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (202, 7, CAST(N'2025-12-16T22:32:45.8466667' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario tevezzz, rol: Vendedor', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (203, 7, CAST(N'2025-12-16T22:32:50.4133333' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (204, 8, CAST(N'2025-12-16T22:32:56.5700000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario carlitos', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (205, 8, CAST(N'2025-12-16T22:33:12.9466667' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario carlitos', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (206, 7, CAST(N'2025-12-16T22:33:35.6466667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (207, 7, CAST(N'2025-12-16T22:33:46.6933333' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario tevez, rol: Vendedor', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (208, 7, CAST(N'2025-12-16T22:33:52.7766667' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario ana, rol: Vendedor', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (209, 7, CAST(N'2025-12-16T22:34:03.6566667' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario test, rol: Vendedor', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (210, 7, CAST(N'2025-12-16T22:34:13.1366667' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario tester1, rol: Vendedor', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (211, 7, CAST(N'2025-12-16T22:34:19.9000000' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario testu, rol: Vendedor', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (212, 7, CAST(N'2025-12-16T22:34:26.6400000' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario testmen, rol: Vendedor', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (213, 7, CAST(N'2025-12-16T22:34:35.1033333' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (214, 14, CAST(N'2025-12-16T22:37:08.5700000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario tevez', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (215, 14, CAST(N'2025-12-16T22:37:15.7500000' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario tevez', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (216, 16, CAST(N'2025-12-16T22:37:20.8533333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario ana', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (217, 16, CAST(N'2025-12-16T22:37:24.4400000' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario ana', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (218, 21, CAST(N'2025-12-16T22:37:28.9600000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario test', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (219, 21, CAST(N'2025-12-16T22:37:32.9566667' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario test', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (220, 24, CAST(N'2025-12-16T22:49:12.4600000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario testu', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (221, 24, CAST(N'2025-12-16T22:49:18.5966667' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario testu', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (222, 25, CAST(N'2025-12-16T22:49:26.7100000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario testmen', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (223, 25, CAST(N'2025-12-16T22:49:33.0400000' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario testmen', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (224, 7, CAST(N'2025-12-16T22:50:58.1166667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (225, 7, CAST(N'2025-12-17T00:21:12.5633333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (226, 7, CAST(N'2025-12-17T00:21:17.4333333' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (232, 7, CAST(N'2025-12-17T00:38:06.8133333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (233, 7, CAST(N'2025-12-17T00:42:55.7066667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (234, 7, CAST(N'2025-12-17T00:43:08.7933333' AS DateTime2), N'Usuario', N'Error', N'Alta usuario fallida: Error en UsuarioDAL.Insertar', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (235, 7, CAST(N'2025-12-18T21:02:34.8833333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (236, 7, CAST(N'2025-12-18T21:06:44.9700000' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (237, 7, CAST(N'2025-12-18T21:12:08.8300000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (238, 7, CAST(N'2025-12-18T21:15:52.7466667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (239, 7, CAST(N'2025-12-18T21:20:18.6800000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (240, 7, CAST(N'2025-12-18T21:21:55.2000000' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (241, 7, CAST(N'2025-12-18T21:46:46.9966667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (242, 7, CAST(N'2025-12-18T21:47:19.8933333' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (243, 7, CAST(N'2025-12-18T21:49:35.7666667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (244, 7, CAST(N'2025-12-18T22:26:58.1133333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (245, 7, CAST(N'2025-12-18T22:38:08.9000000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (246, 7, CAST(N'2025-12-18T22:38:18.1000000' AS DateTime2), N'Sistema', N'Error', N'Cannot insert the value NULL into column ''Id'', table ''BaseGestionBebidasMF.dbo.Tag''; column does not allow nulls. INSERT fails.
The statement has been terminated.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (247, 7, CAST(N'2025-12-18T22:38:39.1766667' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (248, 7, CAST(N'2025-12-18T22:42:05.4000000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (249, 7, CAST(N'2025-12-18T22:50:54.0666667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (250, 7, CAST(N'2025-12-18T22:51:35.7733333' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (251, 7, CAST(N'2025-12-18T22:55:30.6900000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (252, 7, CAST(N'2025-12-18T22:55:41.7666667' AS DateTime2), N'Sistema', N'Error', N'Object reference not set to an instance of an object.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (253, 7, CAST(N'2025-12-18T22:56:59.0966667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (254, 7, CAST(N'2025-12-18T23:00:13.4266667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (255, 7, CAST(N'2026-02-25T20:28:09.2600000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (256, 7, CAST(N'2026-02-25T20:28:28.5533333' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario tester1', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (257, 7, CAST(N'2026-02-25T20:28:46.6766667' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario tester15', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (258, 7, CAST(N'2026-02-25T20:29:10.5900000' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (259, 7, CAST(N'2026-02-25T20:32:32.3500000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (260, 7, CAST(N'2026-02-25T20:32:43.6400000' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario carlitos', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (261, 7, CAST(N'2026-02-25T20:32:55.7733333' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario tevez', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (262, 7, CAST(N'2026-02-25T20:32:59.9766667' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (263, 8, CAST(N'2026-02-25T20:33:10.6033333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario carlitos', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (264, 8, CAST(N'2026-02-25T20:34:04.5466667' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario carlitos', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (265, 14, CAST(N'2026-02-25T20:34:10.9933333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario tevez', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (266, 14, CAST(N'2026-02-25T20:35:38.8166667' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario tevez', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (267, 7, CAST(N'2026-02-25T20:36:18.8600000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (268, 7, CAST(N'2026-02-25T20:36:27.1066667' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario ana', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (269, 7, CAST(N'2026-02-25T20:36:35.7133333' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario test', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (270, 7, CAST(N'2026-02-25T20:36:45.1700000' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario tester15', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (271, 7, CAST(N'2026-02-25T20:36:53.0533333' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario testu', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (272, 7, CAST(N'2026-02-25T20:37:00.1033333' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario testmen', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (273, 7, CAST(N'2026-02-25T20:37:06.5533333' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (274, 16, CAST(N'2026-02-25T20:37:09.8700000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario ana', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (275, 16, CAST(N'2026-02-25T20:37:17.5333333' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario ana', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (276, 21, CAST(N'2026-02-25T20:38:19.7433333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario test', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (277, 21, CAST(N'2026-02-25T20:39:08.7733333' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario test', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (278, 22, CAST(N'2026-02-25T20:39:19.6300000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario tester15', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (279, 22, CAST(N'2026-02-25T20:39:54.6900000' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario tester15', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (280, 24, CAST(N'2026-02-25T20:40:24.1833333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario testu', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (281, 24, CAST(N'2026-02-25T20:40:36.7800000' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario testu', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (282, 25, CAST(N'2026-02-25T20:40:44.1266667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario testmen', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (283, 25, CAST(N'2026-02-25T20:40:51.2133333' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario testmen', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (284, 7, CAST(N'2026-02-25T20:40:56.5000000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (285, 7, CAST(N'2026-02-25T20:41:22.5333333' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (286, 7, CAST(N'2026-02-25T20:42:01.5800000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (287, 7, CAST(N'2026-02-25T20:42:12.0766667' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (288, 7, CAST(N'2026-02-25T20:43:38.3333333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (289, 7, CAST(N'2026-02-25T20:45:25.4266667' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (290, 7, CAST(N'2026-02-25T20:57:05.8300000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (291, 7, CAST(N'2026-02-25T20:57:41.4733333' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (292, 7, CAST(N'2026-02-25T20:59:34.0333333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (293, 7, CAST(N'2026-02-25T21:00:19.5333333' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (294, 7, CAST(N'2026-02-25T21:01:29.0166667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (295, 7, CAST(N'2026-02-25T21:01:46.2466667' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (296, 7, CAST(N'2026-02-28T23:58:51.4700000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (297, 7, CAST(N'2026-03-01T00:00:54.0433333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (298, 7, CAST(N'2026-03-01T00:21:20.6233333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (299, 7, CAST(N'2026-03-01T00:21:49.3066667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (300, 7, CAST(N'2026-03-01T11:23:32.0933333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (301, 7, CAST(N'2026-03-01T11:30:44.6633333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (302, 7, CAST(N'2026-03-01T11:31:26.7666667' AS DateTime2), N'Producto', N'Alta', N'Se agregó el producto ProbandoLote', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (303, 7, CAST(N'2026-03-01T14:36:16.8300000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (304, 7, CAST(N'2026-03-01T14:37:18.9433333' AS DateTime2), N'Producto', N'Alta', N'Se agregó el producto prueba con Lote 1090', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (305, 7, CAST(N'2026-03-01T14:38:06.6433333' AS DateTime2), N'Producto', N'Alta', N'Se agregó el producto prueba con Lote 1010', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (306, 7, CAST(N'2026-03-01T14:40:56.7033333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
GO
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (307, 7, CAST(N'2026-03-01T14:42:07.2833333' AS DateTime2), N'Producto', N'Modificación', N'Se modificó el producto prueba', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (308, 7, CAST(N'2026-03-01T14:42:39.5466667' AS DateTime2), N'Producto', N'Modificación', N'Se modificó el producto prueba', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (309, 7, CAST(N'2026-03-01T14:53:13.6533333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (310, 7, CAST(N'2026-03-01T14:54:05.0533333' AS DateTime2), N'Producto', N'Modificación', N'Se modificó el producto prueba', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (311, 7, CAST(N'2026-03-01T15:01:03.7100000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (312, 7, CAST(N'2026-03-01T15:20:22.5533333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (313, 7, CAST(N'2026-03-02T08:35:06.4266667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (314, 7, CAST(N'2026-03-03T20:16:42.0800000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (315, 7, CAST(N'2026-03-03T20:17:39.6600000' AS DateTime2), N'Usuario', N'Error', N'Alta usuario fallida: Error en UsuarioDAL.Insertar', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (316, 7, CAST(N'2026-03-03T20:17:55.6166667' AS DateTime2), N'Sistema', N'Error', N'Error en UsuarioDAL.Insertar', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (317, 7, CAST(N'2026-03-03T20:18:27.4200000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (318, 7, CAST(N'2026-03-03T20:19:04.2766667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (319, 7, CAST(N'2026-03-03T20:47:13.8433333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (320, 7, CAST(N'2026-03-03T20:47:43.6066667' AS DateTime2), N'Usuario', N'Error', N'Alta usuario fallida: Error en UsuarioDAL.Insertar', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (321, 7, CAST(N'2026-03-03T20:47:53.2000000' AS DateTime2), N'Sistema', N'Error', N'Error en UsuarioDAL.Insertar', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (322, 7, CAST(N'2026-03-03T20:57:33.4633333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (323, 7, CAST(N'2026-03-03T20:58:07.0666667' AS DateTime2), N'Usuario', N'Error', N'Alta usuario fallida: Error en UsuarioDAL.Insertar', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (324, 7, CAST(N'2026-03-03T20:58:10.2500000' AS DateTime2), N'Sistema', N'Error', N'Error en UsuarioDAL.Insertar', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (325, 7, CAST(N'2026-03-03T21:02:15.7866667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (326, 7, CAST(N'2026-03-03T21:02:24.7566667' AS DateTime2), N'Usuario', N'Error', N'Alta usuario fallida: Error en UsuarioDAL.Insertar', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (327, 7, CAST(N'2026-03-03T21:25:49.4566667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (328, 7, CAST(N'2026-03-03T21:25:59.4766667' AS DateTime2), N'Usuario', N'Alta', N'Se creó el usuario user1', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (329, 7, CAST(N'2026-03-03T21:26:13.9500000' AS DateTime2), N'Usuario', N'Alta', N'Se creó el usuario user22', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (330, 7, CAST(N'2026-03-03T21:26:30.6300000' AS DateTime2), N'Permisos', N'Asignar', N'Se asignaron grupos de permisos al usuario Id=27', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (331, 7, CAST(N'2026-03-03T21:39:38.2033333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (332, 7, CAST(N'2026-03-03T21:49:19.7400000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (333, 7, CAST(N'2026-03-03T21:55:50.7566667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (334, 7, CAST(N'2026-03-03T21:58:31.9933333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (335, 7, CAST(N'2026-03-03T22:04:03.3133333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (336, 7, CAST(N'2026-03-03T22:34:40.2166667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (337, 7, CAST(N'2026-03-03T22:53:03.4700000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (338, 7, CAST(N'2026-03-03T22:54:53.2633333' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (339, 7, CAST(N'2026-03-03T22:54:57.1566667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (340, 7, CAST(N'2026-03-03T22:56:46.8800000' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (341, 7, CAST(N'2026-03-03T23:05:44.8566667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (342, 7, CAST(N'2026-03-03T23:07:08.9800000' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (343, 7, CAST(N'2026-03-03T23:07:41.7733333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (344, 7, CAST(N'2026-03-03T23:35:17.7366667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (345, 7, CAST(N'2026-03-03T23:41:56.6200000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (346, 7, CAST(N'2026-03-03T23:49:54.5433333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (347, 7, CAST(N'2026-03-03T23:57:46.6366667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (348, 7, CAST(N'2026-03-04T00:06:24.2966667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (349, 7, CAST(N'2026-03-04T00:11:39.8133333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (350, 7, CAST(N'2026-03-04T00:14:00.1866667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (351, 7, CAST(N'2026-03-04T00:15:35.1633333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (352, 7, CAST(N'2026-03-04T00:16:03.7233333' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (353, 7, CAST(N'2026-03-04T00:16:44.3500000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (354, 7, CAST(N'2026-03-04T00:19:14.6033333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (355, 7, CAST(N'2026-03-04T00:20:31.9866667' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (356, 7, CAST(N'2026-03-04T00:26:07.9100000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (357, 7, CAST(N'2026-03-04T00:30:49.8400000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (358, 7, CAST(N'2026-03-04T00:35:47.4533333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (359, 7, CAST(N'2026-03-04T00:36:36.0233333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (360, 7, CAST(N'2026-03-04T00:37:50.6733333' AS DateTime2), N'Producto', N'Alta', N'Se agregó el producto testnuevo con Lote 5544', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (361, 7, CAST(N'2026-03-04T00:39:05.1900000' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (362, 7, CAST(N'2026-03-04T00:39:08.4066667' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (363, 7, CAST(N'2026-03-04T00:39:10.0100000' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (364, 7, CAST(N'2026-03-04T00:39:12.0233333' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (365, 7, CAST(N'2026-03-04T00:39:13.8266667' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (366, 7, CAST(N'2026-03-04T00:39:21.9600000' AS DateTime2), N'Venta', N'Error', N'Confirmar venta fallida: No hay suficiente stock en lotes para el producto ID 7. Faltan 27 unidades.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (367, 7, CAST(N'2026-03-04T00:39:36.5466667' AS DateTime2), N'Venta', N'Error', N'Confirmar venta fallida: No hay suficiente stock en lotes para el producto ID 7. Faltan 27 unidades.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (368, 7, CAST(N'2026-03-04T00:39:42.6766667' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (369, 7, CAST(N'2026-03-04T00:39:58.5333333' AS DateTime2), N'Venta', N'Error', N'Confirmar venta fallida: No hay suficiente stock en lotes para el producto ID 4. Faltan 5 unidades.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (370, 7, CAST(N'2026-03-04T00:40:08.9533333' AS DateTime2), N'Venta', N'Error', N'Confirmar venta fallida: No hay suficiente stock en lotes para el producto ID 4. Faltan 5 unidades.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (371, 7, CAST(N'2026-03-04T00:44:21.1300000' AS DateTime2), N'Permisos', N'Asignar', N'Se asignaron grupos de permisos al usuario Id=27', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (372, 7, CAST(N'2026-03-04T00:48:18.0000000' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (373, 7, CAST(N'2026-03-04T00:52:10.7366667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (374, 7, CAST(N'2026-03-04T01:10:03.1066667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (375, 7, CAST(N'2026-03-04T01:10:24.3100000' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (376, 7, CAST(N'2026-03-04T01:10:27.6833333' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (377, 7, CAST(N'2026-03-04T01:10:29.2533333' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (378, 7, CAST(N'2026-03-04T01:10:32.2433333' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (379, 7, CAST(N'2026-03-04T01:10:34.6566667' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (380, 7, CAST(N'2026-03-04T01:10:36.9466667' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (381, 7, CAST(N'2026-03-04T01:11:49.9366667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (382, 7, CAST(N'2026-03-04T01:12:03.1100000' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (383, 7, CAST(N'2026-03-04T01:12:05.9500000' AS DateTime2), N'Venta', N'Error', N'Confirmar venta fallida: No hay suficiente stock en lotes para el producto ID 6. Faltan 3 unidades.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (384, 7, CAST(N'2026-03-04T01:12:25.9800000' AS DateTime2), N'Venta', N'Error', N'Confirmar venta fallida: No hay suficiente stock en lotes para el producto ID 6. Faltan 1 unidades.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (385, 7, CAST(N'2026-03-04T01:13:12.1733333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (386, 7, CAST(N'2026-03-04T01:15:07.2900000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (387, 7, CAST(N'2026-03-04T01:15:18.4266667' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (388, 7, CAST(N'2026-03-04T01:17:56.0733333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (389, 7, CAST(N'2026-03-04T01:18:10.5400000' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario tevez', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (390, 7, CAST(N'2026-03-04T01:18:39.3500000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (391, 7, CAST(N'2026-03-04T01:24:34.5033333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (392, 7, CAST(N'2026-03-04T08:15:33.4933333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (393, 7, CAST(N'2026-03-04T08:15:49.1066667' AS DateTime2), N'Usuario', N'Alta', N'Se creó el usuario user99', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (394, 7, CAST(N'2026-03-04T08:16:24.7400000' AS DateTime2), N'Producto', N'Alta', N'Se agregó el producto producTest con Lote 6677', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (395, 7, CAST(N'2026-03-04T08:16:56.1933333' AS DateTime2), N'Producto', N'Modificación', N'Se modificó el producto Cerveza Quilmes', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (396, 7, CAST(N'2026-03-04T08:17:12.7166667' AS DateTime2), N'Producto', N'Modificación', N'Se modificó el producto Vino Malbec', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (397, 7, CAST(N'2026-03-04T08:17:33.1533333' AS DateTime2), N'Producto', N'Modificación', N'Se modificó el producto Coca Cola', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (398, 7, CAST(N'2026-03-04T08:18:01.4300000' AS DateTime2), N'Producto', N'Modificación', N'Se modificó el producto Agua Mineral', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (399, 7, CAST(N'2026-03-04T08:18:13.2266667' AS DateTime2), N'Producto', N'Modificación', N'Se modificó el producto Fernet Branca', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (400, 7, CAST(N'2026-03-04T08:18:27.6800000' AS DateTime2), N'Producto', N'Modificación', N'Se modificó el producto Cerveza Corona', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (401, 7, CAST(N'2026-03-04T08:18:48.0533333' AS DateTime2), N'Producto', N'Modificación', N'Se modificó el producto Sheridans', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (402, 7, CAST(N'2026-03-04T08:19:04.4000000' AS DateTime2), N'Producto', N'Modificación', N'Se modificó el producto Citric Jugo', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (403, 7, CAST(N'2026-03-04T08:19:18.4166667' AS DateTime2), N'Producto', N'Modificación', N'Se modificó el producto Agua Mineral', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (404, 7, CAST(N'2026-03-04T08:19:57.5800000' AS DateTime2), N'Producto', N'Modificación', N'Se modificó el producto ProbandoLote', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (405, 7, CAST(N'2026-03-04T08:20:12.5700000' AS DateTime2), N'Producto', N'Modificación', N'Se modificó el producto ProbandoLote', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (406, 7, CAST(N'2026-03-04T08:21:08.3633333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
GO
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (407, 7, CAST(N'2026-03-04T08:23:57.7800000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (408, 7, CAST(N'2026-03-04T08:26:14.6300000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (409, 7, CAST(N'2026-03-04T08:26:51.0633333' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (410, 7, CAST(N'2026-03-04T08:27:00.1766667' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (411, 7, CAST(N'2026-03-04T08:27:02.7100000' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (412, 7, CAST(N'2026-03-04T08:27:05.0466667' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (413, 7, CAST(N'2026-03-04T08:30:00.1966667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (414, 7, CAST(N'2026-03-04T08:30:21.4600000' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (415, 7, CAST(N'2026-03-04T08:30:24.9566667' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (416, 7, CAST(N'2026-03-04T08:34:57.4966667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (417, 7, CAST(N'2026-03-04T08:35:08.2900000' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (418, 7, CAST(N'2026-03-04T08:35:11.2700000' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (419, 7, CAST(N'2026-03-04T08:35:13.6833333' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (420, 7, CAST(N'2026-03-04T08:35:15.5600000' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (421, 7, CAST(N'2026-03-04T08:35:18.8800000' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (422, 7, CAST(N'2026-03-04T08:35:23.1333333' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (423, 7, CAST(N'2026-03-04T08:38:23.1966667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (424, 7, CAST(N'2026-03-04T08:38:35.4433333' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (425, 7, CAST(N'2026-03-04T08:38:37.5033333' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (426, 7, CAST(N'2026-03-04T08:38:39.0800000' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (427, 7, CAST(N'2026-03-04T08:38:40.6866667' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (428, 7, CAST(N'2026-03-04T08:38:42.6900000' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (429, 7, CAST(N'2026-03-04T08:43:07.8733333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (430, 7, CAST(N'2026-03-04T08:43:25.9766667' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (431, 7, CAST(N'2026-03-04T08:43:28.4366667' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (432, 7, CAST(N'2026-03-04T08:43:29.8933333' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (433, 7, CAST(N'2026-03-04T08:43:35.7466667' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (434, 7, CAST(N'2026-03-04T08:43:51.5766667' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (435, 7, CAST(N'2026-03-04T08:43:53.6833333' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (436, 7, CAST(N'2026-03-04T08:46:30.4666667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (437, 7, CAST(N'2026-03-04T08:46:45.0433333' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (438, 7, CAST(N'2026-03-04T08:46:47.7600000' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (439, 7, CAST(N'2026-03-04T08:46:49.4933333' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (440, 7, CAST(N'2026-03-04T08:46:51.4266667' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (441, 7, CAST(N'2026-03-04T08:53:11.9066667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (442, 7, CAST(N'2026-03-04T08:53:26.2533333' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (443, 7, CAST(N'2026-03-04T08:53:26.9200000' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (444, 7, CAST(N'2026-03-04T08:53:27.3300000' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (445, 7, CAST(N'2026-03-04T08:53:27.9333333' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (446, 7, CAST(N'2026-03-04T08:53:30.5766667' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (447, 7, CAST(N'2026-03-04T08:54:24.8033333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (448, 7, CAST(N'2026-03-04T08:57:15.0300000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (449, 7, CAST(N'2026-03-04T08:58:11.5200000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (450, 7, CAST(N'2026-03-04T09:33:57.7500000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (451, 7, CAST(N'2026-03-04T09:42:30.0600000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (452, 7, CAST(N'2026-03-04T09:43:36.8233333' AS DateTime2), N'Usuario', N'Alta', N'Se creó el usuario userZ', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (453, 7, CAST(N'2026-03-04T09:43:57.5066667' AS DateTime2), N'Producto', N'Alta', N'Se agregó el producto producZ con Lote 789', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (454, 7, CAST(N'2026-03-04T09:44:18.6266667' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (455, 7, CAST(N'2026-03-04T09:47:21.4333333' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (456, 29, CAST(N'2026-03-04T09:47:35.5433333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario userZ', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (457, 29, CAST(N'2026-03-04T09:47:39.1666667' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario userZ', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (458, 7, CAST(N'2026-03-04T10:09:34.3033333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (459, 7, CAST(N'2026-03-04T10:09:47.7366667' AS DateTime2), N'Usuario', N'Error', N'Alta usuario fallida: Error en UsuarioDAL.Insertar', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (460, 7, CAST(N'2026-03-04T10:10:00.9066667' AS DateTime2), N'Usuario', N'Error', N'Alta usuario fallida: Error en UsuarioDAL.Insertar', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (461, 7, CAST(N'2026-03-04T10:10:33.7400000' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario userZz', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (462, 7, CAST(N'2026-03-04T10:10:44.0700000' AS DateTime2), N'Usuario', N'Eliminar', N'Se eliminó el usuario con Id=29', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (463, 7, CAST(N'2026-03-04T10:36:28.7500000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (464, 7, CAST(N'2026-03-04T10:36:39.5033333' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (465, 7, CAST(N'2026-03-04T10:36:55.5666667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (466, 7, CAST(N'2026-03-04T10:39:35.5766667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (467, 7, CAST(N'2026-03-04T10:40:08.0633333' AS DateTime2), N'Usuario', N'Error', N'Alta usuario fallida: Error en UsuarioDAL.Insertar', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (468, 7, CAST(N'2026-03-04T10:40:27.8200000' AS DateTime2), N'Usuario', N'Error', N'Alta usuario fallida: Error en UsuarioDAL.Insertar', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (469, 7, CAST(N'2026-03-04T10:40:45.7800000' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario user25', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (470, 7, CAST(N'2026-03-04T10:41:01.4000000' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (471, 7, CAST(N'2026-03-04T10:46:27.7166667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (472, 7, CAST(N'2026-03-04T10:46:41.0166667' AS DateTime2), N'Usuario', N'Error', N'Alta usuario fallida: Error en UsuarioDAL.Insertar', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (473, 7, CAST(N'2026-03-04T10:53:26.1466667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (474, 7, CAST(N'2026-03-04T10:53:37.3066667' AS DateTime2), N'Usuario', N'Alta', N'Se creó el usuario zzuser', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (475, 7, CAST(N'2026-03-04T10:54:15.9200000' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario zzuser2', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (476, 7, CAST(N'2026-03-04T10:54:39.5000000' AS DateTime2), N'Usuario', N'Alta', N'Se creó el usuario zuserBorrar', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (477, 7, CAST(N'2026-03-04T10:54:48.2100000' AS DateTime2), N'Usuario', N'Eliminar', N'Se eliminó el usuario con Id=31', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (478, 7, CAST(N'2026-03-04T10:55:28.9466667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (479, 7, CAST(N'2026-03-04T10:55:38.9633333' AS DateTime2), N'Usuario', N'Alta', N'Se creó el usuario ttuser', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (480, 7, CAST(N'2026-03-04T11:19:08.3433333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (481, 7, CAST(N'2026-03-04T11:19:33.5300000' AS DateTime2), N'Usuario', N'Alta', N'Se creó el usuario ztuser', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (482, 7, CAST(N'2026-03-04T11:19:41.3666667' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario ttuser', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (483, 7, CAST(N'2026-03-04T11:19:49.1700000' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario ttuser2', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (484, 7, CAST(N'2026-03-04T11:21:13.9266667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (485, 7, CAST(N'2026-03-04T11:21:26.1833333' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (486, 7, CAST(N'2026-03-04T12:18:08.1900000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (487, 7, CAST(N'2026-03-04T12:18:50.8666667' AS DateTime2), N'Usuario', N'ControlCambios', N'{"entity":"Usuario","action":"Modificar","id":22,"before":{"Id":22,"NombreUsuario":"tester15","ContraseñaHasheada":"Tm2tiRGWMkbFECWQN25ByHpTsML9lhVbE9veqXqDdi8G9aWRCkOCrWux79aiHUjtHcwLM5UiZ+YDVfr/67Auhg==","Salt":"c193f200-b9ce-4702-91df-11efd88fd35a","Idioma":"es","Activo":true,"DVH":2931316471971993677},"after":{"Id":22,"NombreUsuario":"tester1555","ContraseñaHasheada":"h5PX3userC3Tm5Q0eEmPFijBoTtQqzST6EkpSBjspeLZ6yjBtu7gWLmsx2blC444TOhtEjCipxIoKdeJJCcqnQ==","Salt":"35b16eba-b514-4df4-a2d9-367fd77105d2","Idioma":"es","Activo":true}}', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (488, 7, CAST(N'2026-03-04T12:18:50.9000000' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario tester1555', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (489, 7, CAST(N'2026-03-04T12:21:20.1666667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (490, 7, CAST(N'2026-03-04T12:21:31.7766667' AS DateTime2), N'Usuario', N'ControlCambios', N'{"entity":"Usuario","action":"Modificar","id":22,"before":{"Id":22,"NombreUsuario":"tester1555","ContraseñaHasheada":"h5PX3userC3Tm5Q0eEmPFijBoTtQqzST6EkpSBjspeLZ6yjBtu7gWLmsx2blC444TOhtEjCipxIoKdeJJCcqnQ==","Salt":"35b16eba-b514-4df4-a2d9-367fd77105d2","Idioma":"es","Activo":true,"DVH":8882737913526203382},"after":{"Id":22,"NombreUsuario":"tester15","ContraseñaHasheada":"Tm2tiRGWMkbFECWQN25ByHpTsML9lhVbE9veqXqDdi8G9aWRCkOCrWux79aiHUjtHcwLM5UiZ+YDVfr/67Auhg==","Salt":"c193f200-b9ce-4702-91df-11efd88fd35a","Idioma":"es","Activo":true}}', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (491, 7, CAST(N'2026-03-04T12:21:31.8000000' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario tester15', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (492, 7, CAST(N'2026-03-04T12:21:59.0533333' AS DateTime2), N'Usuario', N'ControlCambios', N'{"entity":"Usuario","action":"Modificar","id":26,"before":{"Id":26,"NombreUsuario":"user1","ContraseñaHasheada":"Hj90IT0HG9Y3wcFLbxPpjR8nZsB4fVgNqWyY7W8qpAV+pKb1NCYyyy+24WrU5eUXXLM6exJfkQBxepFj+eMq1A==","Salt":"2a74b244-425d-4c99-9c28-3f21eeba231b","Idioma":"es","Activo":true,"DVH":7712235173365687750},"after":{"Id":26,"NombreUsuario":"user1revert","ContraseñaHasheada":"qmBrHlxN7gDXbALvbQDfb1ujb3mquS7hJ7GaZKu1hCdGzFUUWbwSFvfy8WJZnSRuksaplta5epAl0Unl3ktZHQ==","Salt":"b1e28205-5de1-46dc-b0b8-c8e7f7f98a04","Idioma":"es","Activo":true}}', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (493, 7, CAST(N'2026-03-04T12:21:59.0766667' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario user1revert', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (494, 7, CAST(N'2026-03-04T12:22:09.9600000' AS DateTime2), N'Usuario', N'ControlCambios', N'{"entity":"Usuario","action":"Modificar","id":26,"before":{"Id":26,"NombreUsuario":"user1revert","ContraseñaHasheada":"qmBrHlxN7gDXbALvbQDfb1ujb3mquS7hJ7GaZKu1hCdGzFUUWbwSFvfy8WJZnSRuksaplta5epAl0Unl3ktZHQ==","Salt":"b1e28205-5de1-46dc-b0b8-c8e7f7f98a04","Idioma":"es","Activo":true,"DVH":6294991062527884153},"after":{"Id":26,"NombreUsuario":"user1","ContraseñaHasheada":"Hj90IT0HG9Y3wcFLbxPpjR8nZsB4fVgNqWyY7W8qpAV+pKb1NCYyyy+24WrU5eUXXLM6exJfkQBxepFj+eMq1A==","Salt":"2a74b244-425d-4c99-9c28-3f21eeba231b","Idioma":"es","Activo":true}}', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (495, 7, CAST(N'2026-03-04T12:22:09.9800000' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario user1', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (496, 7, CAST(N'2026-03-04T12:25:46.3533333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (497, 7, CAST(N'2026-03-04T12:25:57.3033333' AS DateTime2), N'Usuario', N'ControlCambios', N'{"entity":"Usuario","action":"Eliminar","id":30,"before":{"Id":30,"NombreUsuario":"zzuser2","ContraseñaHasheada":"gnF7jUQNLEzuh1SUeENrS3/Gs4ynU+yTrY1yI6M4KSt7ftPiJRz8jZrbMZBKiejZazu1hm0lmDm7akteCEb6GQ==","Salt":"33b290f3-e71d-4426-b35b-de18ac7a8831","Idioma":"es","Activo":true,"DVH":9017173231804270687},"after":null}', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (498, 7, CAST(N'2026-03-04T12:25:57.3200000' AS DateTime2), N'Usuario', N'Eliminar', N'Se eliminó el usuario con Id=30', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (499, 7, CAST(N'2026-03-04T12:27:12.4700000' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (500, 7, CAST(N'2026-03-04T12:34:24.4400000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (501, 7, CAST(N'2026-03-04T12:34:50.4433333' AS DateTime2), N'Usuario', N'ControlCambios', N'{"entity":"Usuario","action":"Modificar","id":30,"before":{"Id":30,"NombreUsuario":"zzuser2","ContraseñaHasheada":"gnF7jUQNLEzuh1SUeENrS3/Gs4ynU+yTrY1yI6M4KSt7ftPiJRz8jZrbMZBKiejZazu1hm0lmDm7akteCEb6GQ==","Salt":"33b290f3-e71d-4426-b35b-de18ac7a8831","Idioma":"es","Activo":false,"DVH":9017173231804270687},"after":{"Id":30,"NombreUsuario":"zzuser2","ContraseñaHasheada":"gnF7jUQNLEzuh1SUeENrS3/Gs4ynU+yTrY1yI6M4KSt7ftPiJRz8jZrbMZBKiejZazu1hm0lmDm7akteCEb6GQ==","Salt":"33b290f3-e71d-4426-b35b-de18ac7a8831","Idioma":"es","Activo":true}}', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (502, 7, CAST(N'2026-03-04T12:34:50.4633333' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario zzuser2', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (503, 7, CAST(N'2026-03-04T12:35:21.8166667' AS DateTime2), N'Usuario', N'ControlCambios', N'{"entity":"Usuario","action":"Modificar","id":29,"before":{"Id":29,"NombreUsuario":"userZz","ContraseñaHasheada":"lafZ/T01DhjEWNV6RdHwyypdcesCmE2sIdJAiu6vIuVFaom85BzKsaYWEmdQPZZtbGmlhMjYDHICqqPrG4dadg==","Salt":"377443e6-a8c2-4887-8a26-865238bc8942","Idioma":"es","Activo":false,"DVH":6723491538306580620},"after":{"Id":29,"NombreUsuario":"userZz","ContraseñaHasheada":"lafZ/T01DhjEWNV6RdHwyypdcesCmE2sIdJAiu6vIuVFaom85BzKsaYWEmdQPZZtbGmlhMjYDHICqqPrG4dadg==","Salt":"377443e6-a8c2-4887-8a26-865238bc8942","Idioma":"es","Activo":true}}', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (504, 7, CAST(N'2026-03-04T12:35:21.8333333' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario userZz', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (505, 7, CAST(N'2026-03-04T12:35:35.0133333' AS DateTime2), N'Usuario', N'ControlCambios', N'{"entity":"Usuario","action":"Eliminar","id":29,"before":{"Id":29,"NombreUsuario":"userZz","ContraseñaHasheada":"lafZ/T01DhjEWNV6RdHwyypdcesCmE2sIdJAiu6vIuVFaom85BzKsaYWEmdQPZZtbGmlhMjYDHICqqPrG4dadg==","Salt":"377443e6-a8c2-4887-8a26-865238bc8942","Idioma":"es","Activo":true,"DVH":2746715598235132679},"after":null}', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (506, 7, CAST(N'2026-03-04T12:35:35.0233333' AS DateTime2), N'Usuario', N'Eliminar', N'Se eliminó el usuario con Id=29', NULL)
GO
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (507, 7, CAST(N'2026-03-04T12:35:40.0400000' AS DateTime2), N'Usuario', N'ControlCambios', N'{"entity":"Usuario","action":"Modificar","id":29,"before":{"Id":29,"NombreUsuario":"userZz","ContraseñaHasheada":"lafZ/T01DhjEWNV6RdHwyypdcesCmE2sIdJAiu6vIuVFaom85BzKsaYWEmdQPZZtbGmlhMjYDHICqqPrG4dadg==","Salt":"377443e6-a8c2-4887-8a26-865238bc8942","Idioma":"es","Activo":false,"DVH":2746715598235132679},"after":{"Id":29,"NombreUsuario":"userZz","ContraseñaHasheada":"lafZ/T01DhjEWNV6RdHwyypdcesCmE2sIdJAiu6vIuVFaom85BzKsaYWEmdQPZZtbGmlhMjYDHICqqPrG4dadg==","Salt":"377443e6-a8c2-4887-8a26-865238bc8942","Idioma":"es","Activo":true}}', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (508, 7, CAST(N'2026-03-04T12:35:40.0600000' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario userZz', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (509, 7, CAST(N'2026-03-04T12:36:05.8066667' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (510, 7, CAST(N'2026-03-04T20:35:38.3166667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (511, 7, CAST(N'2026-03-05T12:01:41.9000000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (512, 7, CAST(N'2026-03-05T15:09:16.9766667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (513, 7, CAST(N'2026-03-05T16:01:14.7966667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (514, 7, CAST(N'2026-03-05T16:02:53.5633333' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (515, 7, CAST(N'2026-03-05T16:24:07.0933333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (516, 7, CAST(N'2026-03-07T00:40:05.8566667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (517, 7, CAST(N'2026-03-07T00:40:14.5366667' AS DateTime2), N'Sistema', N'Error', N'Value cannot be null. (Parameter ''value'')', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (518, 7, CAST(N'2026-03-07T00:40:21.8033333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (519, 7, CAST(N'2026-03-07T00:52:05.1266667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (520, 7, CAST(N'2026-03-07T00:56:11.4333333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (521, 7, CAST(N'2026-03-07T00:56:40.4066667' AS DateTime2), N'Producto', N'Modificación', N'Se modificó el producto Coca Cola', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (522, 7, CAST(N'2026-03-07T00:56:55.3700000' AS DateTime2), N'Producto', N'Rollback', N'Se revirtió el producto 4 a un estado anterior', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (523, 7, CAST(N'2026-03-07T00:57:53.0866667' AS DateTime2), N'Producto', N'Modificación', N'Se modificó el producto Agua Mineral', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (524, 7, CAST(N'2026-03-07T01:02:25.0766667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (525, 7, CAST(N'2026-03-07T19:57:27.6366667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (526, 7, CAST(N'2026-03-07T20:01:46.3266667' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (528, 7, CAST(N'2026-03-07T21:22:56.6300000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (529, 7, CAST(N'2026-03-07T21:23:40.9400000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (530, 7, CAST(N'2026-03-07T21:50:08.5966667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (531, 7, CAST(N'2026-03-07T22:07:26.6066667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (532, 7, CAST(N'2026-03-07T22:07:47.2133333' AS DateTime2), N'Usuario', N'Alta', N'Se creó el usuario pichon', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (533, 7, CAST(N'2026-03-07T22:07:47.2266667' AS DateTime2), N'Usuario', N'ControlCambios', N'{"entity":"Usuario","action":"Alta","id":35,"before":null,"after":{"Id":35,"NombreUsuario":"pichon","ContraseñaHasheada":"hqd/kx/YqQFt+lD/1XCXf3c8LfI3fOWV4ZvF8gtRAi9+P+8UEKzQrHN8S8wGIPpDa3q6oMghiGDUb5UlOyhVdQ==","Salt":"4e358bf2-0ef3-465b-9cf4-9ec318bd8ee2","Idioma":"es","Activo":true,"DVH":0}}', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (534, 7, CAST(N'2026-03-07T22:09:08.6033333' AS DateTime2), N'Permisos', N'Asignar', N'Se asignaron grupos de permisos al usuario Id=35', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (535, 7, CAST(N'2026-03-07T22:09:51.3600000' AS DateTime2), N'Producto', N'Alta', N'Se agregó el producto AguaPichon con Lote 1945', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (536, 7, CAST(N'2026-03-07T22:10:28.6766667' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (537, 7, CAST(N'2026-03-07T22:13:09.9333333' AS DateTime2), N'Producto', N'Modificación', N'Se modificó el producto AguaPichon', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (538, 7, CAST(N'2026-03-07T22:13:42.9200000' AS DateTime2), N'Producto', N'Rollback', N'Se revirtió el producto 24 a un estado anterior', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (539, 7, CAST(N'2026-03-08T00:17:27.0000000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (540, 7, CAST(N'2026-03-08T00:37:52.7233333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (541, 7, CAST(N'2026-03-08T00:40:26.5366667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (542, 7, CAST(N'2026-03-09T21:08:33.3333333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (543, 7, CAST(N'2026-03-09T21:09:04.7733333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (544, 7, CAST(N'2026-03-09T21:18:22.0133333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (545, 7, CAST(N'2026-03-09T21:28:05.9000000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (546, 7, CAST(N'2026-03-09T22:16:44.8333333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (547, 7, CAST(N'2026-03-11T10:22:12.8200000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (548, 7, CAST(N'2026-03-11T10:22:27.8066667' AS DateTime2), N'Usuario', N'Alta', N'Se creó el usuario newUser', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (549, 7, CAST(N'2026-03-11T10:22:33.7266667' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (550, 36, CAST(N'2026-03-11T10:22:38.2966667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario newUser', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (551, 7, CAST(N'2026-03-11T10:23:41.9333333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (552, 7, CAST(N'2026-03-11T10:23:50.0366667' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (553, 7, CAST(N'2026-03-11T15:29:19.4900000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (554, 7, CAST(N'2026-03-13T18:08:11.4566667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (555, 7, CAST(N'2026-03-13T18:08:30.1700000' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (556, 7, CAST(N'2026-03-13T18:40:41.2366667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (557, 7, CAST(N'2026-03-13T18:40:48.3666667' AS DateTime2), N'Usuario', N'Error', N'Alta usuario fallida: Error en UsuarioDAL.Insertar', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (558, 7, CAST(N'2026-03-13T18:40:52.9266667' AS DateTime2), N'Usuario', N'Error', N'Alta usuario fallida: Error en UsuarioDAL.Insertar', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (559, 7, CAST(N'2026-03-13T18:41:16.4100000' AS DateTime2), N'Producto', N'Error', N'Alta producto fallida: Error en LoteDAL.Agregar | The INSERT statement conflicted with the FOREIGN KEY constraint "FK__Lote__ProductoId__3C34F16F". The conflict occurred in database "BaseGestionBebidasMF", table "dbo.Productos", column ''Id''.
The statement has been terminated.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (560, 7, CAST(N'2026-03-13T18:43:06.6766667' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (561, 7, CAST(N'2026-03-13T19:02:44.9400000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (562, 7, CAST(N'2026-03-13T19:02:50.5533333' AS DateTime2), N'Sistema', N'Error', N'Culture is not supported. (Parameter ''name'')
asdasd is an invalid culture identifier.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (563, 7, CAST(N'2026-03-13T19:03:01.4866667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (564, 7, CAST(N'2026-03-13T19:03:19.0266667' AS DateTime2), N'Usuario', N'Error', N'Alta usuario fallida: Error en UsuarioDAL.Insertar', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (565, 7, CAST(N'2026-03-13T19:03:50.8300000' AS DateTime2), N'Producto', N'Error', N'Alta producto fallida: No se obtuvo Id válido del producto insertado', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (566, 7, CAST(N'2026-03-13T19:34:35.0066667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (567, 7, CAST(N'2026-03-13T19:34:48.2833333' AS DateTime2), N'Usuario', N'Error', N'Alta usuario fallida: Error en UsuarioDAL.Insertar', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1554, 7, CAST(N'2026-03-19T20:00:52.1266667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1555, 7, CAST(N'2026-03-19T20:01:08.6466667' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1556, 7, CAST(N'2026-03-19T20:01:16.7233333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1557, 7, CAST(N'2026-03-19T21:28:00.2366667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1558, 7, CAST(N'2026-03-19T21:28:14.0933333' AS DateTime2), N'Usuario', N'Error', N'Alta usuario fallida: Error en UsuarioDAL.Insertar', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1559, 7, CAST(N'2026-03-19T21:28:24.0166667' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1560, 7, CAST(N'2026-03-19T21:45:15.2733333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1561, 7, CAST(N'2026-03-19T21:45:28.1233333' AS DateTime2), N'Usuario', N'Error', N'Alta usuario fallida: Error en UsuarioDAL.Insertar | Error converting data type numeric to decimal.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1562, 7, CAST(N'2026-03-19T22:00:35.8600000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1563, 7, CAST(N'2026-03-19T22:00:50.7366667' AS DateTime2), N'Usuario', N'Error', N'Alta usuario fallida: Error en UsuarioDAL.Insertar | Error converting data type numeric to decimal.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1564, 7, CAST(N'2026-03-19T22:02:08.7633333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1565, 7, CAST(N'2026-03-19T22:02:25.0166667' AS DateTime2), N'Usuario', N'Error', N'Alta usuario fallida: Error en UsuarioDAL.Insertar | Error converting data type numeric to decimal.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1566, 7, CAST(N'2026-03-19T22:09:56.8433333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1567, 7, CAST(N'2026-03-19T22:10:06.0300000' AS DateTime2), N'Usuario', N'Error', N'Alta usuario fallida: Error en UsuarioDAL.Modificar | Error converting data type numeric to decimal.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1568, 7, CAST(N'2026-03-20T20:13:51.8200000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1569, 7, CAST(N'2026-03-20T20:14:14.7600000' AS DateTime2), N'Usuario', N'Error', N'Alta usuario fallida: Error en UsuarioDAL.Modificar | Error converting data type numeric to decimal.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1570, 7, CAST(N'2026-03-20T20:14:50.8900000' AS DateTime2), N'Usuario', N'Eliminar', N'Se eliminó el usuario con Id=1041', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1571, 7, CAST(N'2026-03-20T20:18:48.8300000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1572, 7, CAST(N'2026-03-20T20:19:02.2333333' AS DateTime2), N'Usuario', N'Alta', N'Se creó el usuario testprobando24', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1573, 7, CAST(N'2026-03-20T20:19:14.9966667' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario testprobando24', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1574, 7, CAST(N'2026-03-20T20:19:25.6833333' AS DateTime2), N'Usuario', N'Modificar', N'Se modificó el usuario testprobando242', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1575, 7, CAST(N'2026-03-20T20:19:50.7100000' AS DateTime2), N'Producto', N'Alta', N'Se agregó el producto test224 con Lote 5647', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1576, 7, CAST(N'2026-03-20T20:20:04.7800000' AS DateTime2), N'Producto', N'Baja lógica', N'Se dio de baja el producto con Id=27', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1577, 7, CAST(N'2026-03-20T20:20:14.1066667' AS DateTime2), N'Usuario', N'Eliminar', N'Se eliminó el usuario con Id=1038', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1578, 7, CAST(N'2026-03-20T20:20:19.4000000' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1579, 7, CAST(N'2026-04-08T19:17:51.2800000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1580, 7, CAST(N'2026-04-08T19:18:09.5066667' AS DateTime2), N'Usuario', N'Alta', N'Se creó el usuario test2026', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1581, 7, CAST(N'2026-04-08T19:18:37.3133333' AS DateTime2), N'Permisos', N'Asignar', N'Se asignaron grupos de permisos al usuario Id=1043', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1582, 7, CAST(N'2026-04-08T19:21:54.0366667' AS DateTime2), N'Producto', N'Alta', N'Se agregó el producto test2026 con Lote 2026', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1583, 7, CAST(N'2026-04-08T19:22:10.2766667' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1584, 7, CAST(N'2026-04-08T19:23:01.5766667' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1585, 7, CAST(N'2026-04-08T20:12:54.4300000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1586, 7, CAST(N'2026-04-08T20:17:01.3933333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1587, 7, CAST(N'2026-04-08T20:17:19.0333333' AS DateTime2), N'Usuario', N'Alta', N'Se creó el usuario test2026b', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1588, 7, CAST(N'2026-04-08T20:18:29.7100000' AS DateTime2), N'Permisos', N'Asignar', N'Se asignaron grupos de permisos al usuario Id=1044', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1589, 7, CAST(N'2026-04-08T20:20:09.9333333' AS DateTime2), N'Producto', N'Alta', N'Se agregó el producto test2026b con Lote 2026', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1590, 7, CAST(N'2026-04-08T20:20:38.7266667' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1591, 7, CAST(N'2026-04-08T22:16:41.8533333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1592, 7, CAST(N'2026-04-08T22:23:43.5933333' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1593, 7, CAST(N'2026-04-08T22:28:00.2833333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
GO
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1594, 7, CAST(N'2026-04-15T19:17:09.8633333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1595, 7, CAST(N'2026-04-15T22:10:08.6466667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1596, 7, CAST(N'2026-04-15T22:11:10.1000000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1597, 7, CAST(N'2026-04-15T22:11:30.3400000' AS DateTime2), N'Producto', N'Error', N'Modificación producto fallida: Error en ProductoDAL.Modificar', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1598, 7, CAST(N'2026-04-15T22:11:35.0333333' AS DateTime2), N'Producto', N'Error', N'Modificación producto fallida: Error en ProductoDAL.Modificar', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1599, 7, CAST(N'2026-04-15T22:11:42.9933333' AS DateTime2), N'Producto', N'Error', N'Baja producto fallida: Error en ProductoDAL.Eliminar', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1600, 7, CAST(N'2026-04-15T22:12:22.5700000' AS DateTime2), N'Producto', N'Error', N'Alta producto fallida: Error en ProductoDAL.Agregar | Implicit distributed transactions have not been enabled. If you''re intentionally starting a distributed transaction, set TransactionManager.ImplicitDistributedTransactions to true.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1601, 7, CAST(N'2026-04-15T22:15:36.5600000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1602, 7, CAST(N'2026-04-15T22:15:45.5533333' AS DateTime2), N'Producto', N'Error', N'Modificación producto fallida: Error en ProductoDAL.ObtenerPorId', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1603, 7, CAST(N'2026-04-15T22:20:09.9433333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1604, 7, CAST(N'2026-04-15T22:20:18.7833333' AS DateTime2), N'Producto', N'Error', N'Modificación producto fallida: Error en ProductoDAL.ObtenerPorId', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1605, 7, CAST(N'2026-04-15T22:23:54.8433333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1606, 7, CAST(N'2026-04-15T22:24:03.9700000' AS DateTime2), N'Producto', N'Error', N'Modificación producto fallida: Error en ProductoDAL.ObtenerPorId', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1607, 7, CAST(N'2026-04-15T22:24:19.6733333' AS DateTime2), N'Producto', N'Error', N'Alta producto fallida: Error en ProductoDAL.Insertar | The ConnectionString property has not been initialized.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1608, 7, CAST(N'2026-04-15T22:25:13.8766667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1609, 7, CAST(N'2026-04-15T22:25:25.9566667' AS DateTime2), N'Producto', N'Error', N'Alta producto fallida: Error en ProductoDAL.Insertar | The ConnectionString property has not been initialized.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1610, 7, CAST(N'2026-04-15T22:27:26.0633333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1611, 7, CAST(N'2026-04-15T22:27:42.1900000' AS DateTime2), N'Producto', N'Error', N'Alta producto fallida: Error en LoteDAL.Agregar | The INSERT statement conflicted with the FOREIGN KEY constraint "FK__Lote__ProductoId__3C34F16F". The conflict occurred in database "BaseGestionBebidasMF", table "dbo.Productos", column ''Id''.
The statement has been terminated.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1612, 7, CAST(N'2026-04-15T22:30:40.0133333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1613, 7, CAST(N'2026-04-15T22:31:02.9033333' AS DateTime2), N'Producto', N'Error', N'Alta producto fallida: Error en LoteDAL.Agregar | The INSERT statement conflicted with the FOREIGN KEY constraint "FK__Lote__ProductoId__3C34F16F". The conflict occurred in database "BaseGestionBebidasMF", table "dbo.Productos", column ''Id''.
The statement has been terminated.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1614, 7, CAST(N'2026-04-15T22:33:17.0000000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1615, 7, CAST(N'2026-04-15T22:33:31.9400000' AS DateTime2), N'Producto', N'Error', N'Alta producto fallida: Error en LoteDAL.Agregar | The INSERT statement conflicted with the FOREIGN KEY constraint "FK__Lote__ProductoId__3C34F16F". The conflict occurred in database "BaseGestionBebidasMF", table "dbo.Productos", column ''Id''.
The statement has been terminated.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1616, 7, CAST(N'2026-04-15T22:36:04.3633333' AS DateTime2), N'Producto', N'Error', N'Alta producto fallida: Error en LoteDAL.Agregar | The INSERT statement conflicted with the FOREIGN KEY constraint "FK__Lote__ProductoId__3C34F16F". The conflict occurred in database "BaseGestionBebidasMF", table "dbo.Productos", column ''Id''.
The statement has been terminated.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1617, 7, CAST(N'2026-04-15T22:36:30.5466667' AS DateTime2), N'Producto', N'Error', N'Alta producto fallida: Error en LoteDAL.Agregar | The INSERT statement conflicted with the FOREIGN KEY constraint "FK__Lote__ProductoId__3C34F16F". The conflict occurred in database "BaseGestionBebidasMF", table "dbo.Productos", column ''Id''.
The statement has been terminated.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1618, 7, CAST(N'2026-04-18T14:43:11.2000000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1619, 7, CAST(N'2026-04-18T14:43:28.7466667' AS DateTime2), N'Sistema', N'Error', N'Error en ProductoDAL.ObtenerPorId', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1620, 7, CAST(N'2026-04-18T14:44:04.9633333' AS DateTime2), N'Producto', N'Error', N'Cargar historial: Error en ProductoDAL.ObtenerPorId', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1621, 7, CAST(N'2026-04-18T14:44:13.2366667' AS DateTime2), N'Producto', N'Error', N'Cargar historial: Error en ProductoDAL.ObtenerPorId', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1622, 7, CAST(N'2026-04-18T14:44:18.3733333' AS DateTime2), N'Producto', N'Error', N'Cargar historial: Error en ProductoDAL.ObtenerPorId', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1623, 7, CAST(N'2026-04-18T14:44:21.8633333' AS DateTime2), N'Producto', N'Error', N'Cargar historial: Error en ProductoDAL.ObtenerPorId', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1624, 7, CAST(N'2026-04-18T14:44:25.6600000' AS DateTime2), N'Producto', N'Error', N'Cargar historial: Error en ProductoDAL.ObtenerPorId', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1625, 7, CAST(N'2026-04-18T14:46:33.2700000' AS DateTime2), N'Producto', N'Error', N'Cargar historial: Error en ProductoDAL.ObtenerPorId', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1626, 7, CAST(N'2026-04-21T21:12:35.6200000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1627, 7, CAST(N'2026-04-21T21:13:01.5200000' AS DateTime2), N'Producto', N'Error', N'Alta producto fallida: Error en LoteDAL.Agregar | The INSERT statement conflicted with the FOREIGN KEY constraint "FK__Lote__ProductoId__3C34F16F". The conflict occurred in database "BaseGestionBebidasMF", table "dbo.Productos", column ''Id''.
The statement has been terminated.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1628, 7, CAST(N'2026-04-21T21:40:42.3833333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1629, 7, CAST(N'2026-04-21T21:41:00.3533333' AS DateTime2), N'Producto', N'Error', N'Alta producto fallida: Error en LoteDAL.Agregar | The INSERT statement conflicted with the FOREIGN KEY constraint "FK__Lote__ProductoId__3C34F16F". The conflict occurred in database "BaseGestionBebidasMF", table "dbo.Productos", column ''Id''.
The statement has been terminated.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1630, 7, CAST(N'2026-04-21T22:22:47.6600000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1631, 7, CAST(N'2026-04-21T22:23:05.4066667' AS DateTime2), N'Producto', N'Error', N'Alta producto fallida: Error en ProductoDAL.ObtenerPorId | The ConnectionString property has not been initialized.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1632, 7, CAST(N'2026-04-21T22:23:38.8366667' AS DateTime2), N'Producto', N'Error', N'Alta producto fallida: Error en ProductoDAL.ObtenerPorId | The ConnectionString property has not been initialized.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1633, 7, CAST(N'2026-04-22T10:49:08.3633333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1634, 7, CAST(N'2026-04-22T10:49:27.4666667' AS DateTime2), N'Producto', N'Error', N'Alta con lote fallida para ''asdTESTsp'': Error en LoteDAL.ActualizarStockEnProducto → Procedure or function ''sp_Lote_ActualizarStockProducto'' expects parameter ''@Stock'', which was not supplied.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1635, 7, CAST(N'2026-04-22T11:47:10.4533333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1636, 7, CAST(N'2026-04-22T11:47:26.7633333' AS DateTime2), N'Producto', N'Error', N'Alta con lote fallida para ''asdTESTsp'': Error en ProductoDAL.Modificar → Transaction count after EXECUTE indicates a mismatching number of BEGIN and COMMIT statements. Previous count = 1, current count = 0.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1638, 7, CAST(N'2026-04-22T12:23:26.1733333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1639, 7, CAST(N'2026-04-22T12:23:42.1733333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1640, 7, CAST(N'2026-04-22T12:23:57.2333333' AS DateTime2), N'Producto', N'Alta con Lote', N'Se agregó ''asdTESTsp2'' (Id=1033) con lote ''1234''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1641, 7, CAST(N'2026-04-22T12:24:33.0133333' AS DateTime2), N'Producto', N'Alta con Lote', N'Se agregó ''zzTEstsp'' (Id=1034) con lote ''1234''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1643, 7, CAST(N'2026-04-22T13:21:53.5433333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1644, 7, CAST(N'2026-04-22T13:22:23.8733333' AS DateTime2), N'Producto', N'Alta con Lote', N'Se agregó ''asTESTTp2'' (Id=1035) con lote ''1234''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1646, 7, CAST(N'2026-04-22T14:05:17.1866667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1647, 7, CAST(N'2026-04-22T14:05:37.5966667' AS DateTime2), N'Usuario', N'Alta', N'Se creó el usuario ''zz22Testsp'' (Id=1045)', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1648, 7, CAST(N'2026-04-22T14:05:47.7100000' AS DateTime2), N'Usuario', N'Modificación', N'Se modificó el usuario ''zz22Testsp2'' (Id=1045)', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1649, 7, CAST(N'2026-04-22T14:05:58.6833333' AS DateTime2), N'Usuario', N'Baja lógica', N'Se dio de baja el usuario con Id=1045', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1651, 7, CAST(N'2026-04-22T14:06:23.7266667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1652, 7, CAST(N'2026-04-22T14:30:11.2033333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1653, 7, CAST(N'2026-04-22T14:30:22.7066667' AS DateTime2), N'Sistema', N'Error', N'El índice -1 no tiene un valor.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1654, 7, CAST(N'2026-04-22T14:30:26.9300000' AS DateTime2), N'Venta', N'Alta', N'Venta #1031 registrada por UsuarioId=7 (2 producto(s))', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1656, 7, CAST(N'2026-04-22T14:53:31.7433333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1657, 7, CAST(N'2026-04-22T15:31:27.3333333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1658, 7, CAST(N'2026-04-22T15:31:55.8500000' AS DateTime2), N'Idioma', N'Error', N'Alta fallida para ''zz2'': Could not find stored procedure ''sp_Idiomas_Insertar''.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1659, 7, CAST(N'2026-04-22T15:34:21.1033333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1660, 7, CAST(N'2026-04-22T15:34:41.7866667' AS DateTime2), N'Idioma', N'Alta', N'Se creó el idioma ''zztest2'' (zz22)', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1661, 7, CAST(N'2026-04-22T15:35:03.3666667' AS DateTime2), N'Idioma', N'Baja', N'Se eliminó el idioma ''zz22''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1674, 7, CAST(N'2026-04-22T15:44:43.7266667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1675, 7, CAST(N'2026-04-22T15:44:46.1600000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1676, 7, CAST(N'2026-04-22T15:44:46.1700000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1677, 7, CAST(N'2026-04-22T15:44:46.1733333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1678, 7, CAST(N'2026-04-22T15:44:46.1766667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1679, 7, CAST(N'2026-04-22T15:44:46.1833333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1680, 7, CAST(N'2026-04-22T15:44:46.1900000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1681, 7, CAST(N'2026-04-22T15:44:46.1933333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1682, 7, CAST(N'2026-04-22T15:44:55.5300000' AS DateTime2), N'Permisos', N'Alta', N'Se creó el grupo ''asdZZ2''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1683, 7, CAST(N'2026-04-22T15:44:55.5366667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1684, 7, CAST(N'2026-04-22T15:44:55.5400000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1685, 7, CAST(N'2026-04-22T15:44:55.5433333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1686, 7, CAST(N'2026-04-22T15:44:55.5433333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1687, 7, CAST(N'2026-04-22T15:44:55.5466667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1688, 7, CAST(N'2026-04-22T15:44:55.5500000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1689, 7, CAST(N'2026-04-22T15:44:55.5500000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1690, 7, CAST(N'2026-04-22T15:45:04.6833333' AS DateTime2), N'Permisos', N'Modificación', N'Se actualizaron permisos simples de ''asdZZ2''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1691, 7, CAST(N'2026-04-22T15:45:04.6933333' AS DateTime2), N'Permisos', N'Modificación', N'Se actualizaron subgrupos de ''asdZZ2''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1692, 7, CAST(N'2026-04-22T15:45:04.6966667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1693, 7, CAST(N'2026-04-22T15:45:04.7000000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1694, 7, CAST(N'2026-04-22T15:45:04.7033333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1695, 7, CAST(N'2026-04-22T15:45:04.7066667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1696, 7, CAST(N'2026-04-22T15:45:04.7066667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1697, 7, CAST(N'2026-04-22T15:45:04.7100000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1698, 7, CAST(N'2026-04-22T15:45:04.7133333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1699, 7, CAST(N'2026-04-22T15:45:15.2000000' AS DateTime2), N'Permisos', N'Modificación', N'Se actualizaron permisos simples de ''asdZZ2''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1700, 7, CAST(N'2026-04-22T15:45:15.2033333' AS DateTime2), N'Permisos', N'Modificación', N'Se actualizaron subgrupos de ''asdZZ2''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1701, 7, CAST(N'2026-04-22T15:45:15.2066667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1702, 7, CAST(N'2026-04-22T15:45:15.2066667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1703, 7, CAST(N'2026-04-22T15:45:15.2100000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1704, 7, CAST(N'2026-04-22T15:45:15.2100000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1705, 7, CAST(N'2026-04-22T15:45:15.2100000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1706, 7, CAST(N'2026-04-22T15:45:15.2133333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1707, 7, CAST(N'2026-04-22T15:45:15.2133333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1708, 7, CAST(N'2026-04-22T15:45:23.5533333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''asdZZ2''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1709, 7, CAST(N'2026-04-22T15:45:23.5566667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1710, 7, CAST(N'2026-04-22T15:45:23.5600000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
GO
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1711, 7, CAST(N'2026-04-22T15:45:23.5600000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1712, 7, CAST(N'2026-04-22T15:45:23.5633333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1713, 7, CAST(N'2026-04-22T15:45:23.5633333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1714, 7, CAST(N'2026-04-22T15:45:23.5666667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1715, 7, CAST(N'2026-04-22T15:45:23.5700000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1728, 7, CAST(N'2026-04-22T15:54:40.9966667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1729, 7, CAST(N'2026-04-22T15:55:31.6300000' AS DateTime2), N'Producto', N'Modificación', N'Se modificó el producto ''Coca Cola'' (Id=4)', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1730, 7, CAST(N'2026-04-22T15:56:01.3700000' AS DateTime2), N'Producto', N'Rollback', N'Se revirtió el producto (Id=4) a estado anterior', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1731, 7, CAST(N'2026-04-22T15:56:12.4600000' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1745, 7, CAST(N'2026-04-22T16:34:14.2766667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1770, 7, CAST(N'2026-04-22T16:38:16.5733333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1771, 7, CAST(N'2026-04-22T16:38:48.4400000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1772, 7, CAST(N'2026-04-22T16:38:48.4533333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1773, 7, CAST(N'2026-04-22T16:38:48.4566667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1774, 7, CAST(N'2026-04-22T16:38:48.4566667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1775, 7, CAST(N'2026-04-22T16:38:48.4600000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1776, 7, CAST(N'2026-04-22T16:38:48.4633333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1777, 7, CAST(N'2026-04-22T16:38:48.4666667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1778, 7, CAST(N'2026-04-22T16:39:04.0533333' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1791, 7, CAST(N'2026-04-22T16:41:49.1900000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1804, 7, CAST(N'2026-04-22T16:42:59.8733333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1805, 7, CAST(N'2026-04-22T16:43:05.1633333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1806, 7, CAST(N'2026-04-22T16:43:05.1666667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1807, 7, CAST(N'2026-04-22T16:43:05.1700000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1808, 7, CAST(N'2026-04-22T16:43:05.1733333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1809, 7, CAST(N'2026-04-22T16:43:05.1766667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1810, 7, CAST(N'2026-04-22T16:43:05.1800000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1811, 7, CAST(N'2026-04-22T16:43:05.1833333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1824, 7, CAST(N'2026-04-22T16:43:35.7266667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1837, 7, CAST(N'2026-04-22T18:59:46.4300000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1850, 7, CAST(N'2026-04-29T22:06:14.2566667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1851, 7, CAST(N'2026-04-29T22:06:45.4333333' AS DateTime2), N'Producto', N'Modificación', N'Se modificó el producto ''ProbandoLote'' (Id=18)', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1852, 7, CAST(N'2026-04-29T22:07:00.4166667' AS DateTime2), N'Producto', N'Modificación', N'Se modificó el producto ''Sheridans'' (Id=9)', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1853, 7, CAST(N'2026-04-29T22:07:18.7966667' AS DateTime2), N'Producto', N'Modificación', N'Se modificó el producto ''prueba'' (Id=19)', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1854, 7, CAST(N'2026-04-29T22:07:29.9733333' AS DateTime2), N'Producto', N'Modificación', N'Se modificó el producto ''prueba'' (Id=20)', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1855, 7, CAST(N'2026-04-29T22:07:47.5966667' AS DateTime2), N'Producto', N'Modificación', N'Se modificó el producto ''SheridansMuestra'' (Id=10)', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1869, 7, CAST(N'2026-04-29T22:13:08.4666667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1870, 7, CAST(N'2026-04-29T22:13:43.0400000' AS DateTime2), N'Producto', N'Alta con Lote', N'Se agregó ''test999'' (Id=1036) con lote ''4224''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1884, 7, CAST(N'2026-05-13T14:20:14.9966667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1885, 7, CAST(N'2026-05-13T14:20:38.1466667' AS DateTime2), N'Usuario', N'Alta', N'Se creó el usuario ''nuevito22'' (Id=1046)', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1886, 7, CAST(N'2026-05-13T14:21:00.9266667' AS DateTime2), N'Producto', N'Alta con Lote', N'Se agregó ''nuevito23'' (Id=1037) con lote ''2332''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1887, 7, CAST(N'2026-05-13T14:21:10.6466667' AS DateTime2), N'Venta', N'Alta', N'Venta #1032 registrada por UsuarioId=7 (1 producto(s))', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1888, 7, CAST(N'2026-05-13T14:21:43.4566667' AS DateTime2), N'Idioma', N'Alta', N'Se creó el idioma ''nuevito33'' (nv3)', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1889, 7, CAST(N'2026-05-13T14:21:52.5200000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1890, 7, CAST(N'2026-05-13T14:21:52.5266667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1891, 7, CAST(N'2026-05-13T14:21:52.5300000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1892, 7, CAST(N'2026-05-13T14:21:52.5333333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1893, 7, CAST(N'2026-05-13T14:21:52.5366667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1894, 7, CAST(N'2026-05-13T14:21:52.5400000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1895, 7, CAST(N'2026-05-13T14:21:52.5466667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1896, 7, CAST(N'2026-05-13T14:22:01.3300000' AS DateTime2), N'Permisos', N'Alta', N'Se creó el grupo ''nuevito33''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1897, 7, CAST(N'2026-05-13T14:22:01.3400000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1898, 7, CAST(N'2026-05-13T14:22:01.3500000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1899, 7, CAST(N'2026-05-13T14:22:01.3600000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1900, 7, CAST(N'2026-05-13T14:22:01.3733333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1901, 7, CAST(N'2026-05-13T14:22:01.3833333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1902, 7, CAST(N'2026-05-13T14:22:01.3900000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1903, 7, CAST(N'2026-05-13T14:22:01.3966667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1904, 7, CAST(N'2026-05-13T14:22:10.4833333' AS DateTime2), N'Permisos', N'Modificación', N'Se actualizaron permisos simples de ''nuevito33''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1905, 7, CAST(N'2026-05-13T14:22:10.5000000' AS DateTime2), N'Permisos', N'Modificación', N'Se actualizaron subgrupos de ''nuevito33''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1906, 7, CAST(N'2026-05-13T14:22:10.5100000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1907, 7, CAST(N'2026-05-13T14:22:10.5133333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1908, 7, CAST(N'2026-05-13T14:22:10.5166667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1909, 7, CAST(N'2026-05-13T14:22:10.5233333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1910, 7, CAST(N'2026-05-13T14:22:10.5266667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1911, 7, CAST(N'2026-05-13T14:22:10.5300000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1912, 7, CAST(N'2026-05-13T14:22:10.5333333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1913, 7, CAST(N'2026-05-13T14:22:29.7533333' AS DateTime2), N'Permisos', N'Asignar', N'Se asignaron grupos de permisos al usuario Id=1046', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1926, 7, CAST(N'2026-05-13T14:23:35.7433333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1939, 7, CAST(N'2026-05-13T14:24:07.6800000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1952, 7, CAST(N'2026-05-13T19:37:39.9266667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1953, 7, CAST(N'2026-05-13T19:37:50.3600000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1954, 7, CAST(N'2026-05-13T19:37:50.3666667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1955, 7, CAST(N'2026-05-13T19:37:50.3700000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1956, 7, CAST(N'2026-05-13T19:37:50.3700000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1957, 7, CAST(N'2026-05-13T19:37:50.3733333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1958, 7, CAST(N'2026-05-13T19:37:50.3800000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1959, 7, CAST(N'2026-05-13T19:37:50.3833333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1972, 7, CAST(N'2026-05-13T20:17:44.1500000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1985, 7, CAST(N'2026-05-13T20:22:41.7766667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (1998, 7, CAST(N'2026-05-13T20:23:38.6133333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2011, 7, CAST(N'2026-05-13T20:27:19.8400000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2024, 7, CAST(N'2026-05-13T21:17:06.6000000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2037, 7, CAST(N'2026-05-13T21:19:59.0133333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2038, 7, CAST(N'2026-05-13T21:20:04.0433333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2039, 7, CAST(N'2026-05-13T21:20:04.0533333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2040, 7, CAST(N'2026-05-13T21:20:04.0600000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2041, 7, CAST(N'2026-05-13T21:20:04.0633333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2042, 7, CAST(N'2026-05-13T21:20:04.0666667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2043, 7, CAST(N'2026-05-13T21:20:04.0733333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2044, 7, CAST(N'2026-05-13T21:20:04.0766667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2057, 7, CAST(N'2026-05-13T21:22:16.4600000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2070, 7, CAST(N'2026-05-13T21:23:49.6233333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2083, 7, CAST(N'2026-05-13T21:25:14.6200000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2096, 7, CAST(N'2026-05-13T21:29:33.5966667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2097, 7, CAST(N'2026-05-13T21:29:54.7733333' AS DateTime2), N'Usuario', N'Alta', N'Se creó el usuario ''nuevo35'' (Id=1047)', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2098, 7, CAST(N'2026-05-13T21:30:09.7200000' AS DateTime2), N'Producto', N'Modificación', N'Se modificó el producto ''nuevito23'' (Id=1037)', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2099, 7, CAST(N'2026-05-13T21:31:02.6100000' AS DateTime2), N'Producto', N'Alta con Lote', N'Se agregó ''nuevo935'' (Id=1038) con lote ''3222''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2100, 7, CAST(N'2026-05-13T21:31:07.7366667' AS DateTime2), N'Producto', N'Baja lógica', N'Se dio de baja el producto (Id=1038)', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2101, 7, CAST(N'2026-05-13T21:31:18.3733333' AS DateTime2), N'Venta', N'Alta', N'Venta #1033 registrada por UsuarioId=7 (1 producto(s))', NULL)
GO
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2102, 7, CAST(N'2026-05-13T21:31:53.8133333' AS DateTime2), N'Idioma', N'Modificación', N'Se actualizaron traducciones para IdIdioma=1023', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2103, 7, CAST(N'2026-05-13T21:31:58.6133333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2104, 7, CAST(N'2026-05-13T21:31:58.6200000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2105, 7, CAST(N'2026-05-13T21:31:58.6300000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2106, 7, CAST(N'2026-05-13T21:31:58.6366667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2107, 7, CAST(N'2026-05-13T21:31:58.6433333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2108, 7, CAST(N'2026-05-13T21:31:58.6466667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2109, 7, CAST(N'2026-05-13T21:31:58.6533333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2110, 7, CAST(N'2026-05-13T21:32:05.3733333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2111, 7, CAST(N'2026-05-13T21:32:05.3766667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2112, 7, CAST(N'2026-05-13T21:32:05.3800000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2113, 7, CAST(N'2026-05-13T21:32:05.3833333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2114, 7, CAST(N'2026-05-13T21:32:05.3866667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2115, 7, CAST(N'2026-05-13T21:32:05.3866667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2116, 7, CAST(N'2026-05-13T21:32:05.3933333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2117, 7, CAST(N'2026-05-13T21:32:11.0866667' AS DateTime2), N'Permisos', N'Modificación', N'Se actualizaron subgrupos de ''test2026aaa''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2118, 7, CAST(N'2026-05-13T21:32:12.5733333' AS DateTime2), N'Permisos', N'Modificación', N'Se actualizaron permisos simples de ''test2026aaa''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2119, 7, CAST(N'2026-05-13T21:32:13.9633333' AS DateTime2), N'Permisos', N'Modificación', N'Se actualizaron permisos simples de ''test2026aaa''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2120, 7, CAST(N'2026-05-13T21:32:13.9700000' AS DateTime2), N'Permisos', N'Modificación', N'Se actualizaron subgrupos de ''test2026aaa''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2121, 7, CAST(N'2026-05-13T21:32:13.9700000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2122, 7, CAST(N'2026-05-13T21:32:13.9733333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2123, 7, CAST(N'2026-05-13T21:32:13.9733333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2124, 7, CAST(N'2026-05-13T21:32:13.9766667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2125, 7, CAST(N'2026-05-13T21:32:13.9800000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2126, 7, CAST(N'2026-05-13T21:32:13.9800000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2127, 7, CAST(N'2026-05-13T21:32:13.9833333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2128, 7, CAST(N'2026-05-13T21:32:24.8000000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2129, 7, CAST(N'2026-05-13T21:32:24.8266667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2130, 7, CAST(N'2026-05-13T21:32:24.8333333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2131, 7, CAST(N'2026-05-13T21:32:24.8333333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2132, 7, CAST(N'2026-05-13T21:32:24.8366667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2133, 7, CAST(N'2026-05-13T21:32:24.8433333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2134, 7, CAST(N'2026-05-13T21:32:24.8466667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2135, 7, CAST(N'2026-05-13T21:32:41.8700000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2136, 7, CAST(N'2026-05-13T21:32:41.8800000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2137, 7, CAST(N'2026-05-13T21:32:41.8833333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2138, 7, CAST(N'2026-05-13T21:32:41.8866667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2139, 7, CAST(N'2026-05-13T21:32:41.8900000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2140, 7, CAST(N'2026-05-13T21:32:41.8933333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2141, 7, CAST(N'2026-05-13T21:32:41.8966667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2142, 7, CAST(N'2026-05-13T21:33:26.7266667' AS DateTime2), N'Producto', N'Rollback', N'Se revirtió el producto (Id=1037) a estado anterior', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2143, 7, CAST(N'2026-05-13T21:33:37.1966667' AS DateTime2), N'Sesion', N'LOGOUT', N'Salida del sistema del usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2157, 7, CAST(N'2026-05-13T21:35:39.5066667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2170, 7, CAST(N'2026-05-13T21:42:06.0633333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2171, 7, CAST(N'2026-05-13T21:42:12.1000000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2172, 7, CAST(N'2026-05-13T21:42:12.1133333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2173, 7, CAST(N'2026-05-13T21:42:12.1166667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2174, 7, CAST(N'2026-05-13T21:42:12.1200000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2175, 7, CAST(N'2026-05-13T21:42:12.1233333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2176, 7, CAST(N'2026-05-13T21:42:12.1266667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2177, 7, CAST(N'2026-05-13T21:42:12.1300000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2190, 7, CAST(N'2026-05-13T21:44:02.4400000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2203, 7, CAST(N'2026-05-13T21:44:50.6466667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2228, 7, CAST(N'2026-05-13T21:46:02.1766667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2241, 7, CAST(N'2026-05-13T21:46:43.7400000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2254, 7, CAST(N'2026-05-13T21:51:30.7900000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2255, 7, CAST(N'2026-05-13T21:51:50.9100000' AS DateTime2), N'Producto', N'Modificación', N'Se modificó el producto ''test2026bb'' (Id=1027)', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2269, 7, CAST(N'2026-05-13T21:57:34.7300000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2282, 7, CAST(N'2026-05-13T22:00:04.5800000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2295, 7, CAST(N'2026-05-13T22:12:07.0066667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2308, 7, CAST(N'2026-05-13T22:15:28.4833333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2321, 7, CAST(N'2026-05-13T22:17:39.7466667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2334, 7, CAST(N'2026-05-13T22:20:00.9500000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2347, 7, CAST(N'2026-05-16T20:11:06.6600000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2360, 7, CAST(N'2026-06-03T20:25:36.2966667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2361, 7, CAST(N'2026-06-03T20:26:45.9800000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2362, 7, CAST(N'2026-06-03T20:26:45.9900000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2363, 7, CAST(N'2026-06-03T20:26:45.9933333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2364, 7, CAST(N'2026-06-03T20:26:45.9966667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2365, 7, CAST(N'2026-06-03T20:26:46.0000000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2366, 7, CAST(N'2026-06-03T20:26:46.0033333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2367, 7, CAST(N'2026-06-03T20:26:46.0066667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2380, 7, CAST(N'2026-06-03T22:28:00.7066667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2393, 7, CAST(N'2026-06-03T22:29:22.3633333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2406, 7, CAST(N'2026-06-03T22:30:06.1000000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2419, 7, CAST(N'2026-06-03T22:31:02.4033333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2420, 7, CAST(N'2026-06-03T22:31:08.3100000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2421, 7, CAST(N'2026-06-03T22:31:08.3200000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2422, 7, CAST(N'2026-06-03T22:31:08.3200000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2423, 7, CAST(N'2026-06-03T22:31:08.3200000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2424, 7, CAST(N'2026-06-03T22:31:08.3233333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2425, 7, CAST(N'2026-06-03T22:31:08.3266667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2426, 7, CAST(N'2026-06-03T22:31:08.3266667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2427, 7, CAST(N'2026-06-03T22:31:11.5600000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2428, 7, CAST(N'2026-06-03T22:31:11.5700000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2429, 7, CAST(N'2026-06-03T22:31:11.5766667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2430, 7, CAST(N'2026-06-03T22:31:11.5800000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2431, 7, CAST(N'2026-06-03T22:31:11.5866667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2432, 7, CAST(N'2026-06-03T22:31:11.5900000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2433, 7, CAST(N'2026-06-03T22:31:11.6000000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2446, 7, CAST(N'2026-06-10T19:15:57.7100000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2447, 7, CAST(N'2026-06-10T19:22:33.7500000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2448, 7, CAST(N'2026-06-10T19:22:33.7666667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2449, 7, CAST(N'2026-06-10T19:22:33.7700000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2450, 7, CAST(N'2026-06-10T19:22:33.7700000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2451, 7, CAST(N'2026-06-10T19:22:33.7733333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2452, 7, CAST(N'2026-06-10T19:22:33.7766667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2453, 7, CAST(N'2026-06-10T19:22:33.7800000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2466, 7, CAST(N'2026-07-08T19:16:05.9133333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2467, 7, CAST(N'2026-07-08T19:16:14.6500000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
GO
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2468, 7, CAST(N'2026-07-08T19:16:14.6533333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2469, 7, CAST(N'2026-07-08T19:16:14.6666667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2470, 7, CAST(N'2026-07-08T19:16:14.6666667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2471, 7, CAST(N'2026-07-08T19:16:14.6733333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2472, 7, CAST(N'2026-07-08T19:16:14.6766667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2473, 7, CAST(N'2026-07-08T19:16:14.6833333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2474, 7, CAST(N'2026-07-08T19:16:22.6300000' AS DateTime2), N'Producto', N'Modificación', N'Se modificó el producto ''Fernet Branca'' (Id=6)', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2488, 7, CAST(N'2026-07-08T19:27:30.8000000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2489, 7, CAST(N'2026-07-08T19:27:42.2400000' AS DateTime2), N'Producto', N'Modificación', N'Se modificó el producto ''Coca Cola'' (Id=4)', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2502, 7, CAST(N'2026-07-08T19:35:01.6233333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2503, 7, CAST(N'2026-07-08T19:35:11.7766667' AS DateTime2), N'Producto', N'Modificación', N'Se modificó el producto ''Citric'' (Id=8)', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2516, 7, CAST(N'2026-07-08T19:48:31.3666667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2541, 7, CAST(N'2026-07-14T20:41:07.6733333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2542, 7, CAST(N'2026-07-14T20:41:14.1300000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2543, 7, CAST(N'2026-07-14T20:41:14.1333333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2544, 7, CAST(N'2026-07-14T20:41:14.1366667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2545, 7, CAST(N'2026-07-14T20:41:14.1366667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2546, 7, CAST(N'2026-07-14T20:41:14.1433333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2547, 7, CAST(N'2026-07-14T20:41:14.1466667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2548, 7, CAST(N'2026-07-14T20:41:14.1500000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2549, 7, CAST(N'2026-07-14T20:41:23.1000000' AS DateTime2), N'Permisos', N'Modificación', N'Se actualizaron permisos simples de ''testgruppp''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2550, 7, CAST(N'2026-07-14T20:41:23.1100000' AS DateTime2), N'Permisos', N'Modificación', N'Se actualizaron subgrupos de ''testgruppp''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2551, 7, CAST(N'2026-07-14T20:41:23.1133333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2552, 7, CAST(N'2026-07-14T20:41:23.1166667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2553, 7, CAST(N'2026-07-14T20:41:23.1200000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2554, 7, CAST(N'2026-07-14T20:41:23.1200000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2555, 7, CAST(N'2026-07-14T20:41:23.1233333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2556, 7, CAST(N'2026-07-14T20:41:23.1266667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2557, 7, CAST(N'2026-07-14T20:41:23.1300000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2570, 7, CAST(N'2026-07-15T18:56:38.3666667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2571, 7, CAST(N'2026-07-15T18:56:42.3233333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2572, 7, CAST(N'2026-07-15T18:56:42.3366667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2573, 7, CAST(N'2026-07-15T18:56:42.3400000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2574, 7, CAST(N'2026-07-15T18:56:42.3433333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2575, 7, CAST(N'2026-07-15T18:56:42.3466667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2576, 7, CAST(N'2026-07-15T18:56:42.3500000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2577, 7, CAST(N'2026-07-15T18:56:42.3533333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2578, 7, CAST(N'2026-07-15T18:56:45.0366667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2579, 7, CAST(N'2026-07-15T18:56:45.0466667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2580, 7, CAST(N'2026-07-15T18:56:45.0566667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2581, 7, CAST(N'2026-07-15T18:56:45.0666667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2582, 7, CAST(N'2026-07-15T18:56:45.0733333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2583, 7, CAST(N'2026-07-15T18:56:45.0766667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2584, 7, CAST(N'2026-07-15T18:56:45.0766667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2597, 7, CAST(N'2026-07-15T19:33:32.7833333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2610, 7, CAST(N'2026-07-29T14:52:45.3366667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2611, 7, CAST(N'2026-07-29T14:52:51.3833333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2612, 7, CAST(N'2026-07-29T14:52:51.3966667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2613, 7, CAST(N'2026-07-29T14:52:51.4066667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2614, 7, CAST(N'2026-07-29T14:52:51.4133333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2615, 7, CAST(N'2026-07-29T14:52:51.4200000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2616, 7, CAST(N'2026-07-29T14:52:51.4333333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2617, 7, CAST(N'2026-07-29T14:52:51.4500000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2630, 7, CAST(N'2026-07-29T17:17:24.0000000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2631, 7, CAST(N'2026-07-29T17:17:45.6600000' AS DateTime2), N'Reporte', N'Error', N'Error al generar reporte de stock: Could not find stored procedure ''sp_Reporte_Stock''.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2632, 7, CAST(N'2026-07-29T17:17:55.4700000' AS DateTime2), N'Reporte', N'Error', N'Error al generar reporte de ventas: Procedure or function sp_Reporte_Ventas has too many arguments specified.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2633, 7, CAST(N'2026-07-29T17:18:07.0200000' AS DateTime2), N'Reporte', N'Error', N'Error al generar reporte de ventas: Procedure or function sp_Reporte_Ventas has too many arguments specified.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2634, 7, CAST(N'2026-07-29T17:18:15.1800000' AS DateTime2), N'Reporte', N'Error', N'Error al generar reporte de ventas: Procedure or function sp_Reporte_Ventas has too many arguments specified.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2647, 7, CAST(N'2026-07-29T17:28:43.4400000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2648, 7, CAST(N'2026-07-29T17:28:47.9500000' AS DateTime2), N'Reporte', N'ReporteVentas', N'Generado reporte de ventas: Zona=TODAS, ProductoId=NULL, FechaDesde=SIN FILTRO, FechaHasta=SIN FILTRO → 0 fila(s), 0 unidad(es), $0,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2649, 7, CAST(N'2026-07-29T17:28:55.9033333' AS DateTime2), N'Reporte', N'ReporteVentas', N'Generado reporte de ventas: Zona=TODAS, ProductoId=NULL, FechaDesde=2025-07-16, FechaHasta=SIN FILTRO → 0 fila(s), 0 unidad(es), $0,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2650, 7, CAST(N'2026-07-29T17:28:58.5100000' AS DateTime2), N'Reporte', N'ReporteVentas', N'Generado reporte de ventas: Zona=TODAS, ProductoId=NULL, FechaDesde=2025-07-16, FechaHasta=SIN FILTRO → 0 fila(s), 0 unidad(es), $0,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2651, 7, CAST(N'2026-07-29T17:29:04.9100000' AS DateTime2), N'Reporte', N'ReporteVentas', N'Generado reporte de ventas: Zona=TODAS, ProductoId=NULL, FechaDesde=2024-11-13, FechaHasta=SIN FILTRO → 0 fila(s), 0 unidad(es), $0,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2652, 7, CAST(N'2026-07-29T17:29:06.1166667' AS DateTime2), N'Reporte', N'ReporteVentas', N'Generado reporte de ventas: Zona=TODAS, ProductoId=NULL, FechaDesde=2024-11-13, FechaHasta=SIN FILTRO → 0 fila(s), 0 unidad(es), $0,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2653, 7, CAST(N'2026-07-29T17:29:27.6133333' AS DateTime2), N'Reporte', N'ReporteStock', N'Generado reporte de stock: 31 producto(s), 4121 unidad(es), valorizado $17.240.700,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2666, 7, CAST(N'2026-07-29T17:51:43.9000000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2667, 7, CAST(N'2026-07-29T17:51:47.9200000' AS DateTime2), N'Reporte', N'ReporteVentas', N'Generado reporte de ventas: Zona=TODAS, ProductoId=NULL, FechaDesde=SIN FILTRO, FechaHasta=SIN FILTRO → 40 fila(s), 251 unidad(es), $1.054.330,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2680, 7, CAST(N'2026-07-29T18:05:23.4666667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2681, 7, CAST(N'2026-07-29T18:05:30.1733333' AS DateTime2), N'Reporte', N'ReporteVentas', N'Generado reporte de ventas: Zona=TODAS, ProductoId=NULL, FechaDesde=SIN FILTRO, FechaHasta=SIN FILTRO → 40 fila(s), 251 unidad(es), $1.054.330,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2694, 7, CAST(N'2026-07-29T18:13:54.6800000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2695, 7, CAST(N'2026-07-29T18:14:21.5600000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2696, 7, CAST(N'2026-07-29T18:14:21.5700000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2697, 7, CAST(N'2026-07-29T18:14:21.5733333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2698, 7, CAST(N'2026-07-29T18:14:21.5766667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2699, 7, CAST(N'2026-07-29T18:14:21.5833333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2700, 7, CAST(N'2026-07-29T18:14:21.5866667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2701, 7, CAST(N'2026-07-29T18:14:21.5900000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2714, 7, CAST(N'2026-08-24T23:56:17.7800000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2727, 7, CAST(N'2026-08-24T23:56:53.7866667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2728, 7, CAST(N'2026-08-24T23:57:16.6233333' AS DateTime2), N'Reporte', N'ReporteStock', N'Generado reporte de stock: 31 producto(s), 4121 unidad(es), valorizado $17.240.700,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2729, 7, CAST(N'2026-08-24T23:57:36.2866667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2730, 7, CAST(N'2026-08-24T23:57:36.2966667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2731, 7, CAST(N'2026-08-24T23:57:36.3033333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2732, 7, CAST(N'2026-08-24T23:57:36.3066667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2733, 7, CAST(N'2026-08-24T23:57:36.3133333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2734, 7, CAST(N'2026-08-24T23:57:36.3166667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2735, 7, CAST(N'2026-08-24T23:57:36.3233333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2748, 7, CAST(N'2026-08-25T00:06:16.0666667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2749, 7, CAST(N'2026-08-25T00:06:48.4933333' AS DateTime2), N'Usuario', N'Modificación', N'Se modificó el usuario ''testmen'' (Id=25)', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2763, 7, CAST(N'2026-08-25T00:12:07.4800000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2764, 7, CAST(N'2026-08-25T00:13:58.5066667' AS DateTime2), N'Cliente', N'Error', N'Alta fallida para ''Estefano Garcia'': Error en ClienteDAL.Insertar → Error converting data type numeric to decimal.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2765, 7, CAST(N'2026-08-25T00:14:07.2200000' AS DateTime2), N'Cliente', N'Error', N'Alta fallida para ''Estefano Garcia'': Error en ClienteDAL.Insertar → Error converting data type numeric to decimal.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2766, 7, CAST(N'2026-08-25T00:14:17.9166667' AS DateTime2), N'Cliente', N'Error', N'Alta fallida para ''Estefano Garcia'': Error en ClienteDAL.Insertar → Error converting data type numeric to decimal.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2767, 7, CAST(N'2026-08-25T00:14:37.0800000' AS DateTime2), N'Cliente', N'Error', N'Alta fallida para ''Estefano Garcia'': Error en ClienteDAL.Insertar → Error converting data type numeric to decimal.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2768, 7, CAST(N'2026-08-25T00:15:20.1933333' AS DateTime2), N'Cliente', N'Error', N'Alta fallida para ''fegerger'': Error en ClienteDAL.Insertar → Error converting data type numeric to decimal.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2782, 7, CAST(N'2026-08-25T00:16:20.6800000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2795, 7, CAST(N'2026-08-25T00:16:49.2866667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2808, 7, CAST(N'2026-08-25T00:50:12.6966667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2809, 7, CAST(N'2026-08-25T00:50:49.8566667' AS DateTime2), N'Cliente', N'Error', N'Alta fallida para ''carlitos tevez'': Error en ClienteDAL.Insertar → Parameter value ''2085793298254452404,0000000000'' is out of range.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2810, 7, CAST(N'2026-08-25T00:51:01.8066667' AS DateTime2), N'Cliente', N'Error', N'Alta fallida para ''carlitos tevez'': Error en ClienteDAL.Insertar → Parameter value ''7204710430156623602,0000000000'' is out of range.', NULL)
GO
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2823, 7, CAST(N'2026-08-25T01:10:33.7566667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2824, 7, CAST(N'2026-08-25T01:11:10.5200000' AS DateTime2), N'Cliente', N'Error', N'Alta fallida para ''carlitos teves'': El ID debe ser mayor a cero.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2837, 7, CAST(N'2026-08-25T01:22:36.9600000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2850, 7, CAST(N'2026-08-25T01:56:07.9966667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2851, 7, CAST(N'2026-08-25T01:56:47.5400000' AS DateTime2), N'Cliente', N'Alta', N'Se agregó el cliente ''carlitos tevez'' (Id=0, Zona=Norte)', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2852, 7, CAST(N'2026-08-25T01:57:15.0600000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2853, 7, CAST(N'2026-08-25T01:57:15.0700000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2854, 7, CAST(N'2026-08-25T01:57:15.0733333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2855, 7, CAST(N'2026-08-25T01:57:15.0733333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2856, 7, CAST(N'2026-08-25T01:57:15.0766667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2857, 7, CAST(N'2026-08-25T01:57:15.0800000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2858, 7, CAST(N'2026-08-25T01:57:15.0866667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2871, 7, CAST(N'2026-08-25T18:26:10.4400000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2872, 7, CAST(N'2026-08-25T18:27:50.3966667' AS DateTime2), N'Cliente', N'Alta', N'Se agregó el cliente ''Mailen Barrera'' (Id=0, Zona=Oeste)', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2873, 7, CAST(N'2026-08-25T18:28:55.0600000' AS DateTime2), N'Usuario', N'Alta', N'Se creó el usuario ''prueba123'' (Id=1048)', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2874, 7, CAST(N'2026-08-25T18:29:04.2733333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2875, 7, CAST(N'2026-08-25T18:29:04.2833333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2876, 7, CAST(N'2026-08-25T18:29:04.2900000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2877, 7, CAST(N'2026-08-25T18:29:04.2933333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2878, 7, CAST(N'2026-08-25T18:29:04.2966667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2879, 7, CAST(N'2026-08-25T18:29:04.3000000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2880, 7, CAST(N'2026-08-25T18:29:04.3033333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2881, 7, CAST(N'2026-08-25T18:29:13.9000000' AS DateTime2), N'Permisos', N'Asignar', N'Se asignaron grupos de permisos al usuario Id=1048', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2895, 7, CAST(N'2026-08-25T18:34:01.5266667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2896, 7, CAST(N'2026-08-25T18:34:41.4866667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2897, 7, CAST(N'2026-08-25T18:34:41.4966667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2898, 7, CAST(N'2026-08-25T18:34:41.5000000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2899, 7, CAST(N'2026-08-25T18:34:41.5033333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2900, 7, CAST(N'2026-08-25T18:34:41.5033333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2901, 7, CAST(N'2026-08-25T18:34:41.5100000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2902, 7, CAST(N'2026-08-25T18:34:41.5133333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2915, 7, CAST(N'2026-08-25T18:51:36.6066667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2928, 7, CAST(N'2026-08-25T20:27:49.0500000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2941, 7, CAST(N'2026-08-25T21:37:53.0933333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2942, 7, CAST(N'2026-08-25T21:38:56.0166667' AS DateTime2), N'Venta', N'Error', N'Confirmar venta fallida: Error en VentaDAL.RegistrarVenta → The INSERT statement conflicted with the FOREIGN KEY constraint "FK__DetalleVe__Venta__5812160E". The conflict occurred in database "BaseGestionBebidasMF", table "dbo.Ventas", column ''Id''.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2943, 7, CAST(N'2026-08-25T21:39:13.0066667' AS DateTime2), N'Venta', N'Error', N'Confirmar venta fallida: Error en VentaDAL.RegistrarVenta → The INSERT statement conflicted with the FOREIGN KEY constraint "FK__DetalleVe__Venta__5812160E". The conflict occurred in database "BaseGestionBebidasMF", table "dbo.Ventas", column ''Id''.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2956, 7, CAST(N'2026-08-25T22:40:02.2300000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2957, 7, CAST(N'2026-08-25T22:40:56.0500000' AS DateTime2), N'Venta', N'Error', N'Confirmar venta fallida: Error en VentaDAL.RegistrarVenta: The INSERT statement conflicted with the FOREIGN KEY constraint "FK__DetalleVe__Venta__5812160E". The conflict occurred in database "BaseGestionBebidasMF", table "dbo.Ventas", column ''Id''.

⚠️ Verificá haber ejecutado TODOS los scripts SQL en SSMS:
  - 07_AlterTable_Ventas_Zona_Vendedor.sql (agrega columnas Zona/Vendedor)
  - 08_sp_Ventas_Insertar_ConClienteId.sql
  - sp_DetalleVentas_Upsert / sp_Lote_ListarPorProducto / sp_Lote_ActualizarStockProducto / sp_Lote_CalcularStockTotal → The INSERT statement conflicted with the FOREIGN KEY constraint "FK__DetalleVe__Venta__5812160E". The conflict occurred in database "BaseGestionBebidasMF", table "dbo.Ventas", column ''Id''.', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2970, 7, CAST(N'2026-08-25T23:13:12.9166667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2971, 7, CAST(N'2026-08-25T23:13:36.1833333' AS DateTime2), N'Usuario', N'Modificación', N'Se modificó el usuario ''administrador'' (Id=20)', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2985, 7, CAST(N'2026-08-25T23:23:03.1866667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (2986, 7, CAST(N'2026-08-25T23:24:22.6100000' AS DateTime2), N'Usuario', N'Modificación', N'Se modificó el usuario ''testmen2'' (Id=25)', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3000, 7, CAST(N'2026-08-25T23:40:01.4700000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3001, 7, CAST(N'2026-08-25T23:41:12.3933333' AS DateTime2), N'Venta', N'Alta', N'Venta #1037 registrada por UsuarioId=7, ClienteId= (2 producto(s))', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3002, 7, CAST(N'2026-08-25T23:41:25.7066667' AS DateTime2), N'Venta', N'Alta', N'Venta #1038 registrada por UsuarioId=7, ClienteId=8 (1 producto(s))', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3003, 7, CAST(N'2026-08-25T23:41:35.4066667' AS DateTime2), N'Reporte', N'ReporteVentas', N'Generado reporte de ventas: Zona=Oeste, ProductoId=NULL, FechaDesde=SIN FILTRO, FechaHasta=SIN FILTRO → 1 fila(s), 3 unidad(es), $13.500,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3004, 7, CAST(N'2026-08-25T23:41:40.4466667' AS DateTime2), N'Reporte', N'ReporteVentas', N'Generado reporte de ventas: Zona=TODAS, ProductoId=NULL, FechaDesde=SIN FILTRO, FechaHasta=SIN FILTRO → 43 fila(s), 264 unidad(es), $1.109.430,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3005, 7, CAST(N'2026-08-25T23:42:23.8766667' AS DateTime2), N'Usuario', N'Modificación', N'Se modificó el usuario ''tester155'' (Id=22)', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3019, 7, CAST(N'2026-08-26T00:27:53.1800000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3020, 7, CAST(N'2026-08-26T00:29:33.6066667' AS DateTime2), N'Venta', N'Alta', N'Venta #1039 registrada por UsuarioId=7, ClienteId= (4 producto(s))', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3034, 7, CAST(N'2026-08-26T00:29:54.5233333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3047, 7, CAST(N'2026-08-26T00:40:21.3966667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3060, 7, CAST(N'2026-08-26T00:42:10.5533333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3714, 7, CAST(N'2026-09-10T20:26:51.5800000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3715, 7, CAST(N'2026-09-10T20:27:02.4200000' AS DateTime2), N'Reporte', N'ReporteVentas', N'Generado reporte de ventas: Zona=TODAS, ProductoId=NULL, FechaDesde=SIN FILTRO, FechaHasta=SIN FILTRO → 47 fila(s), 280 unidad(es), $1.203.830,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3748, 7, CAST(N'2026-09-11T22:30:00.5033333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3749, 7, CAST(N'2026-09-11T22:30:03.1733333' AS DateTime2), N'Reporte', N'ReporteStock', N'Generado reporte de stock: 24 producto(s), 4018 unidad(es), valorizado $16.835.300,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3750, 7, CAST(N'2026-09-11T22:30:16.5400000' AS DateTime2), N'Reporte', N'ReporteStock', N'Generado reporte de stock: 24 producto(s), 4018 unidad(es), valorizado $16.835.300,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3751, 7, CAST(N'2026-09-11T22:30:25.8066667' AS DateTime2), N'Reporte', N'ReporteVentas', N'Generado reporte de ventas: Zona=TODAS, ProductoId=NULL, FechaDesde=2026-09-01, FechaHasta=2026-09-11 → 0 fila(s), 0 unidad(es), $0,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3752, 7, CAST(N'2026-09-11T22:30:25.8166667' AS DateTime2), N'Reporte', N'ReporteVentas', N'Generado reporte de ventas: Zona=TODAS, ProductoId=NULL, FechaDesde=2026-08-21, FechaHasta=2026-08-31 → 7 fila(s), 29 unidad(es), $149.500,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3753, 7, CAST(N'2026-09-11T22:30:36.9766667' AS DateTime2), N'Reporte', N'ReporteVentas', N'Generado reporte de ventas: Zona=TODAS, ProductoId=NULL, FechaDesde=2026-02-10, FechaHasta=2026-09-11 → 34 fila(s), 156 unidad(es), $707.330,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3754, 7, CAST(N'2026-09-11T22:30:36.9833333' AS DateTime2), N'Reporte', N'ReporteVentas', N'Generado reporte de ventas: Zona=TODAS, ProductoId=NULL, FechaDesde=2025-07-11, FechaHasta=2026-02-09 → 13 fila(s), 124 unidad(es), $496.500,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3776, 7, CAST(N'2026-09-14T14:32:26.1333333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3777, 7, CAST(N'2026-09-14T14:32:51.9300000' AS DateTime2), N'Venta', N'Alta', N'Venta #2034 registrada por UsuarioId=7, ClienteId= (2 producto(s))', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3778, 7, CAST(N'2026-09-14T14:32:59.1600000' AS DateTime2), N'Reporte', N'ReporteStock', N'Generado reporte de stock: 24 producto(s), 4016 unidad(es), valorizado $16.828.700,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3779, 7, CAST(N'2026-09-14T14:33:03.8533333' AS DateTime2), N'Reporte', N'ReporteVentas', N'Generado reporte de ventas: Zona=TODAS, ProductoId=NULL, FechaDesde=2026-09-01, FechaHasta=2026-09-14 → 2 fila(s), 2 unidad(es), $6.600,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3780, 7, CAST(N'2026-09-14T14:33:03.8600000' AS DateTime2), N'Reporte', N'ReporteVentas', N'Generado reporte de ventas: Zona=TODAS, ProductoId=NULL, FechaDesde=2026-08-18, FechaHasta=2026-08-31 → 7 fila(s), 29 unidad(es), $149.500,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3794, 7, CAST(N'2026-09-14T22:51:52.4833333' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3812, 7, CAST(N'2026-09-14T22:57:23.1366667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3813, 7, CAST(N'2026-09-14T22:57:25.9500000' AS DateTime2), N'Reporte', N'ReporteStock', N'Generado reporte de stock: 24 producto(s), 4016 unidad(es), valorizado $16.828.700,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3814, 7, CAST(N'2026-09-14T22:57:34.0466667' AS DateTime2), N'Reporte', N'ReporteVentas', N'Generado reporte de ventas: Zona=TODAS, ProductoId=NULL, FechaDesde=2026-09-01, FechaHasta=2026-09-14 → 2 fila(s), 2 unidad(es), $6.600,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3815, 7, CAST(N'2026-09-14T22:57:34.0600000' AS DateTime2), N'Reporte', N'ReporteVentas', N'Generado reporte de ventas: Zona=TODAS, ProductoId=NULL, FechaDesde=2026-08-18, FechaHasta=2026-08-31 → 7 fila(s), 29 unidad(es), $149.500,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3816, 7, CAST(N'2026-09-14T22:57:41.8300000' AS DateTime2), N'Reporte', N'ReporteVentas', N'Generado reporte de ventas: Zona=TODAS, ProductoId=NULL, FechaDesde=2026-08-01, FechaHasta=2026-08-31 → 7 fila(s), 29 unidad(es), $149.500,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3817, 7, CAST(N'2026-09-14T22:57:41.8433333' AS DateTime2), N'Reporte', N'ReporteVentas', N'Generado reporte de ventas: Zona=TODAS, ProductoId=NULL, FechaDesde=2026-07-01, FechaHasta=2026-07-31 → 0 fila(s), 0 unidad(es), $0,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3818, 7, CAST(N'2026-09-14T22:59:33.5433333' AS DateTime2), N'Venta', N'Alta', N'Venta #2035 registrada por UsuarioId=7, ClienteId= (4 producto(s))', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3819, 7, CAST(N'2026-09-14T22:59:40.8000000' AS DateTime2), N'Reporte', N'ReporteStock', N'Generado reporte de stock: 24 producto(s), 4000 unidad(es), valorizado $16.779.800,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3820, 7, CAST(N'2026-09-14T22:59:43.4566667' AS DateTime2), N'Reporte', N'ReporteVentas', N'Generado reporte de ventas: Zona=TODAS, ProductoId=NULL, FechaDesde=2026-09-01, FechaHasta=2026-09-14 → 6 fila(s), 18 unidad(es), $55.500,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3821, 7, CAST(N'2026-09-14T22:59:43.4866667' AS DateTime2), N'Reporte', N'ReporteVentas', N'Generado reporte de ventas: Zona=TODAS, ProductoId=NULL, FechaDesde=2026-08-18, FechaHasta=2026-08-31 → 7 fila(s), 29 unidad(es), $149.500,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3835, 7, CAST(N'2026-09-14T23:04:03.4900000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3836, 7, CAST(N'2026-09-14T23:04:12.4733333' AS DateTime2), N'Reporte', N'ReporteStock', N'Generado reporte de stock: 24 producto(s), 4000 unidad(es), valorizado $16.779.800,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3837, 7, CAST(N'2026-09-14T23:04:21.0033333' AS DateTime2), N'Reporte', N'ReporteVentas', N'Generado reporte de ventas: Zona=TODAS, ProductoId=NULL, FechaDesde=2026-09-01, FechaHasta=2026-09-14 → 6 fila(s), 18 unidad(es), $55.500,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3838, 7, CAST(N'2026-09-14T23:04:21.0133333' AS DateTime2), N'Reporte', N'ReporteVentas', N'Generado reporte de ventas: Zona=TODAS, ProductoId=NULL, FechaDesde=2026-08-18, FechaHasta=2026-08-31 → 7 fila(s), 29 unidad(es), $149.500,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3839, 7, CAST(N'2026-09-14T23:04:48.2400000' AS DateTime2), N'Reporte', N'Exportar', N'Reporte de ventas · xlsx · 6 filas · 01/09/2026 — 14/09/2026 · Todos los productos · Todas las zonas', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3840, 7, CAST(N'2026-09-14T23:05:39.5566667' AS DateTime2), N'Reporte', N'ReporteVentas', N'Generado reporte de ventas: Zona=TODAS, ProductoId=NULL, FechaDesde=SIN FILTRO, FechaHasta=SIN FILTRO → 53 fila(s), 298 unidad(es), $1.259.330,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3841, 7, CAST(N'2026-09-14T23:06:02.0300000' AS DateTime2), N'Reporte', N'ReporteStock', N'Generado reporte de stock: 24 producto(s), 4000 unidad(es), valorizado $16.779.800,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3842, 7, CAST(N'2026-09-14T23:06:12.1500000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3843, 7, CAST(N'2026-09-14T23:06:12.1700000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3844, 7, CAST(N'2026-09-14T23:06:12.1766667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3845, 7, CAST(N'2026-09-14T23:06:12.1833333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3846, 7, CAST(N'2026-09-14T23:06:12.1933333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3847, 7, CAST(N'2026-09-14T23:06:12.1966667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3848, 7, CAST(N'2026-09-14T23:06:12.2200000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3849, 7, CAST(N'2026-09-14T23:06:18.7866667' AS DateTime2), N'Reporte', N'ReporteStock', N'Generado reporte de stock: 24 producto(s), 4000 unidad(es), valorizado $16.779.800,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3865, 7, CAST(N'2026-09-15T22:17:43.8566667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3866, 7, CAST(N'2026-09-15T22:17:47.0233333' AS DateTime2), N'Reporte', N'ReporteStock', N'Generado reporte de stock: 24 producto(s), 4000 unidad(es), valorizado $16.779.800,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3867, 7, CAST(N'2026-09-15T22:17:50.2966667' AS DateTime2), N'Reporte', N'ReporteVentas', N'Generado reporte de ventas: Zona=TODAS, ProductoId=NULL, FechaDesde=2026-09-01, FechaHasta=2026-09-15 → 6 fila(s), 18 unidad(es), $55.500,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3868, 7, CAST(N'2026-09-15T22:17:50.3033333' AS DateTime2), N'Reporte', N'ReporteVentas', N'Generado reporte de ventas: Zona=TODAS, ProductoId=NULL, FechaDesde=2026-08-17, FechaHasta=2026-08-31 → 7 fila(s), 29 unidad(es), $149.500,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3869, 7, CAST(N'2026-09-15T22:18:05.5933333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3870, 7, CAST(N'2026-09-15T22:18:05.6033333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3871, 7, CAST(N'2026-09-15T22:18:05.6100000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
GO
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3872, 7, CAST(N'2026-09-15T22:18:05.6133333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3873, 7, CAST(N'2026-09-15T22:18:05.6200000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3874, 7, CAST(N'2026-09-15T22:18:05.6233333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3875, 7, CAST(N'2026-09-15T22:18:05.6300000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3876, 7, CAST(N'2026-09-15T22:18:07.3400000' AS DateTime2), N'Reporte', N'ReporteStock', N'Generado reporte de stock: 24 producto(s), 4000 unidad(es), valorizado $16.779.800,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3889, 7, CAST(N'2026-09-15T22:21:19.3866667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3890, 7, CAST(N'2026-09-15T22:21:22.9033333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3891, 7, CAST(N'2026-09-15T22:21:22.9233333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3892, 7, CAST(N'2026-09-15T22:21:22.9266667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3893, 7, CAST(N'2026-09-15T22:21:22.9300000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3894, 7, CAST(N'2026-09-15T22:21:22.9333333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3895, 7, CAST(N'2026-09-15T22:21:22.9366667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3896, 7, CAST(N'2026-09-15T22:21:22.9400000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3897, 7, CAST(N'2026-09-15T22:21:24.3533333' AS DateTime2), N'Reporte', N'ReporteStock', N'Generado reporte de stock: 24 producto(s), 4000 unidad(es), valorizado $16.779.800,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3898, 7, CAST(N'2026-09-15T22:21:27.3400000' AS DateTime2), N'Reporte', N'ReporteVentas', N'Generado reporte de ventas: Zona=TODAS, ProductoId=NULL, FechaDesde=2026-09-01, FechaHasta=2026-09-15 → 6 fila(s), 18 unidad(es), $55.500,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3899, 7, CAST(N'2026-09-15T22:21:27.3500000' AS DateTime2), N'Reporte', N'ReporteVentas', N'Generado reporte de ventas: Zona=TODAS, ProductoId=NULL, FechaDesde=2026-08-17, FechaHasta=2026-08-31 → 7 fila(s), 29 unidad(es), $149.500,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3912, 7, CAST(N'2026-09-15T23:21:01.9766667' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3913, 7, CAST(N'2026-09-15T23:21:04.4700000' AS DateTime2), N'Reporte', N'ReporteStock', N'Generado reporte de stock: 24 producto(s), 4000 unidad(es), valorizado $16.779.800,00', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3926, 7, CAST(N'2026-09-15T23:27:47.3900000' AS DateTime2), N'Sesion', N'LOGIN', N'Ingreso al sistema con usuario admin', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3927, 7, CAST(N'2026-09-15T23:27:49.8666667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''FullUser''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3928, 7, CAST(N'2026-09-15T23:27:49.8766667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''GrupeteTest''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3929, 7, CAST(N'2026-09-15T23:27:49.8800000' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ModElim''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3930, 7, CAST(N'2026-09-15T23:27:49.8833333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Pruebita''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3931, 7, CAST(N'2026-09-15T23:27:49.8866667' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''ReportesLectura''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3932, 7, CAST(N'2026-09-15T23:27:49.8933333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''test1''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3933, 7, CAST(N'2026-09-15T23:27:49.9033333' AS DateTime2), N'Permisos', N'Baja', N'Se eliminó el grupo ''Vender''', NULL)
INSERT [dbo].[Bitacora] ([Id], [UsuarioId], [FechaRegistro], [Entidad], [Accion], [Detalle], [DVH]) VALUES (3934, 7, CAST(N'2026-09-15T23:27:50.4133333' AS DateTime2), N'Reporte', N'ReporteStock', N'Generado reporte de stock: 24 producto(s), 4000 unidad(es), valorizado $16.779.800,00', NULL)
SET IDENTITY_INSERT [dbo].[Bitacora] OFF
GO
SET IDENTITY_INSERT [dbo].[Categorias] ON

INSERT [dbo].[Categorias] ([Id], [Nombre]) VALUES (1, N'Alcohólica')
INSERT [dbo].[Categorias] ([Id], [Nombre]) VALUES (2, N'No Alcohólica')
SET IDENTITY_INSERT [dbo].[Categorias] OFF
GO
SET IDENTITY_INSERT [dbo].[Clientes] ON

INSERT [dbo].[Clientes] ([Id], [NombreCompleto], [Zona], [Direccion], [Telefono], [Email], [Activo], [DVH], [DVV]) VALUES (1, N'Juan Pérez', N'Centro', NULL, NULL, NULL, 1, CAST(0 AS Decimal(38, 0)), CAST(0 AS Decimal(38, 0)))
INSERT [dbo].[Clientes] ([Id], [NombreCompleto], [Zona], [Direccion], [Telefono], [Email], [Activo], [DVH], [DVV]) VALUES (2, N'María González', N'Norte', NULL, NULL, NULL, 1, CAST(0 AS Decimal(38, 0)), CAST(0 AS Decimal(38, 0)))
INSERT [dbo].[Clientes] ([Id], [NombreCompleto], [Zona], [Direccion], [Telefono], [Email], [Activo], [DVH], [DVV]) VALUES (3, N'Carlos López', N'Sur', NULL, NULL, NULL, 1, CAST(0 AS Decimal(38, 0)), CAST(0 AS Decimal(38, 0)))
INSERT [dbo].[Clientes] ([Id], [NombreCompleto], [Zona], [Direccion], [Telefono], [Email], [Activo], [DVH], [DVV]) VALUES (4, N'Ana Fernández', N'Este', NULL, NULL, NULL, 1, CAST(0 AS Decimal(38, 0)), CAST(0 AS Decimal(38, 0)))
INSERT [dbo].[Clientes] ([Id], [NombreCompleto], [Zona], [Direccion], [Telefono], [Email], [Activo], [DVH], [DVV]) VALUES (5, N'Jorge Martínez', N'Oeste', NULL, NULL, NULL, 1, CAST(0 AS Decimal(38, 0)), CAST(0 AS Decimal(38, 0)))
INSERT [dbo].[Clientes] ([Id], [NombreCompleto], [Zona], [Direccion], [Telefono], [Email], [Activo], [DVH], [DVV]) VALUES (7, N'carlitos tevez', N'Norte', N'av falsa 123', N'11-1234-4342', N'magoya@gmail.com', 1, CAST(5849139928171462506 AS Decimal(38, 0)), CAST(0 AS Decimal(38, 0)))
INSERT [dbo].[Clientes] ([Id], [NombreCompleto], [Zona], [Direccion], [Telefono], [Email], [Activo], [DVH], [DVV]) VALUES (8, N'Mailen Barrera', N'Oeste', N'Calle falsa 1122', N'11-425-785965', N'barrera_22@gmail.com', 1, CAST(5736759490488607613 AS Decimal(38, 0)), CAST(0 AS Decimal(38, 0)))
SET IDENTITY_INSERT [dbo].[Clientes] OFF
GO
SET IDENTITY_INSERT [dbo].[DetalleVentas] ON

INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (1, 4, 2, 10, CAST(2500.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (2, 4, 3, 5, CAST(5000.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (3, 5, 4, 20, CAST(2500.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (4, 6, 4, 15, CAST(2500.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (5, 7, 7, 22, CAST(3000.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (6, 8, 4, 5, CAST(2500.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (7, 9, 4, 10, CAST(2500.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (8, 10, 3, 15, CAST(5000.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (9, 10, 6, 10, CAST(15000.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (10, 11, 4, 5, CAST(2500.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (11, 12, 4, 5, CAST(2500.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (12, 13, 4, 1, CAST(2500.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (13, 14, 7, 1, CAST(3000.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (14, 15, 4, 9, CAST(2500.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (15, 15, 15, 5, CAST(1000.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (16, 16, 5, 5, CAST(1000.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (17, 16, 12, 5, CAST(3600.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (24, 23, 5, 5, CAST(1000.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (25, 23, 7, 17, CAST(3000.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (26, 23, 10, 3, CAST(10.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (27, 24, 7, 5, CAST(3000.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (28, 24, 12, 7, CAST(3600.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (29, 25, 4, 5, CAST(2500.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (30, 25, 23, 5, CAST(4000.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (31, 26, 24, 5, CAST(5000.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (32, 26, 19, 3, CAST(9000.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (33, 27, 7, 1, CAST(3000.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (1033, 1027, 1026, 1, CAST(5000.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (1034, 1027, 12, 3, CAST(3600.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (1035, 1028, 1027, 5, CAST(4500.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (1036, 1028, 1026, 1, CAST(5000.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (1037, 1029, 12, 3, CAST(3600.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (1038, 1029, 18, 1, CAST(5000.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (1039, 1030, 18, 1, CAST(5000.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (1040, 1030, 9, 4, CAST(40000.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (1041, 1030, 7, 2, CAST(3000.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (1042, 1031, 6, 1, CAST(15000.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (1043, 1031, 7, 22, CAST(3000.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (1044, 1032, 1037, 1, CAST(3500.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (1045, 1033, 1037, 2, CAST(4500.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (1049, 1037, 12, 6, CAST(3600.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (1050, 1037, 18, 4, CAST(5000.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (1051, 1038, 4, 3, CAST(4500.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (1052, 1039, 12, 4, CAST(3600.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (1053, 1039, 18, 4, CAST(5000.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (1054, 1039, 19, 5, CAST(9000.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (1055, 1039, 21, 3, CAST(5000.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (2046, 2034, 7, 1, CAST(3000.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (2047, 2034, 12, 1, CAST(3600.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (2048, 2035, 12, 4, CAST(3600.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (2049, 2035, 18, 1, CAST(5000.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (2050, 2035, 4, 1, CAST(4500.00 AS Decimal(10, 2)))
INSERT [dbo].[DetalleVentas] ([Id], [VentaId], [ProductoId], [Cantidad], [PrecioUnitario]) VALUES (2051, 2035, 2, 10, CAST(2500.00 AS Decimal(10, 2)))
SET IDENTITY_INSERT [dbo].[DetalleVentas] OFF
GO
INSERT [dbo].[DigitoVerificador] ([Tabla], [DVV]) VALUES (N'Clientes', CAST(11585899418660070119 AS Decimal(38, 0)))
INSERT [dbo].[DigitoVerificador] ([Tabla], [DVV]) VALUES (N'Productos', CAST(476021291 AS Decimal(38, 0)))
INSERT [dbo].[DigitoVerificador] ([Tabla], [DVV]) VALUES (N'Usuarios', CAST(1887872544 AS Decimal(38, 0)))
GO
SET IDENTITY_INSERT [dbo].[Idiomas] ON

INSERT [dbo].[Idiomas] ([Id], [Codigo], [Nombre]) VALUES (1, N'es', N'Español')
INSERT [dbo].[Idiomas] ([Id], [Codigo], [Nombre]) VALUES (2, N'en', N'Inglés')
INSERT [dbo].[Idiomas] ([Id], [Codigo], [Nombre]) VALUES (5, N'fr', N'Francés')
INSERT [dbo].[Idiomas] ([Id], [Codigo], [Nombre]) VALUES (11, N'de', N'Alemán')
INSERT [dbo].[Idiomas] ([Id], [Codigo], [Nombre]) VALUES (12, N'it', N'Italiano')
INSERT [dbo].[Idiomas] ([Id], [Codigo], [Nombre]) VALUES (13, N'pt', N'Portugués')
INSERT [dbo].[Idiomas] ([Id], [Codigo], [Nombre]) VALUES (15, N'att', N'atteo')
INSERT [dbo].[Idiomas] ([Id], [Codigo], [Nombre]) VALUES (17, N'ts', N'testerrr')
INSERT [dbo].[Idiomas] ([Id], [Codigo], [Nombre]) VALUES (18, N'xtu', N'pruebaX')
INSERT [dbo].[Idiomas] ([Id], [Codigo], [Nombre]) VALUES (20, N'tst3', N'testito')
INSERT [dbo].[Idiomas] ([Id], [Codigo], [Nombre]) VALUES (21, N'testZ', N'testerZ')
INSERT [dbo].[Idiomas] ([Id], [Codigo], [Nombre]) VALUES (22, N'asdasd', N'testtas')
INSERT [dbo].[Idiomas] ([Id], [Codigo], [Nombre]) VALUES (1023, N'nv3', N'nuevito33')
SET IDENTITY_INSERT [dbo].[Idiomas] OFF
GO
SET IDENTITY_INSERT [dbo].[Lote] ON

INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (1, N'1090', CAST(N'2026-03-01' AS Date), CAST(N'2026-04-01' AS Date), 0, 19, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (2, N'1010', CAST(N'2026-03-01' AS Date), CAST(N'2026-04-01' AS Date), 10, 20, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (3, N'2020', CAST(N'2026-03-01' AS Date), CAST(N'2026-04-01' AS Date), 22, 19, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (4, N'1999', CAST(N'2026-03-01' AS Date), CAST(N'2026-04-01' AS Date), 3, 19, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (5, N'555', CAST(N'2026-03-01' AS Date), CAST(N'2026-03-01' AS Date), 7, 8, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (6, N'1', CAST(N'2026-03-02' AS Date), CAST(N'2026-03-02' AS Date), 23, 10, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (7, N'555', CAST(N'2026-03-02' AS Date), CAST(N'2026-03-02' AS Date), 27, 10, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (8, N'5544', CAST(N'2026-03-04' AS Date), CAST(N'2026-04-04' AS Date), 25, 21, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (9, N'9988', CAST(N'2026-03-04' AS Date), CAST(N'2026-03-04' AS Date), 7, 21, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (10, N'6677', CAST(N'2026-03-04' AS Date), CAST(N'2026-03-04' AS Date), 5, 22, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (11, N'2222', CAST(N'2026-03-04' AS Date), CAST(N'2026-04-04' AS Date), 80, 2, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (12, N'3333', CAST(N'2026-03-04' AS Date), CAST(N'2026-04-04' AS Date), 30, 3, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (13, N'4444', CAST(N'2026-03-04' AS Date), CAST(N'2026-04-04' AS Date), 100, 4, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (14, N'4455', CAST(N'2026-03-04' AS Date), CAST(N'2026-03-04' AS Date), 26, 4, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (15, N'5555', CAST(N'2026-03-04' AS Date), CAST(N'2026-04-04' AS Date), 140, 5, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (16, N'6666', CAST(N'2026-03-04' AS Date), CAST(N'2026-04-04' AS Date), 19, 6, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (17, N'7777', CAST(N'2026-03-04' AS Date), CAST(N'2026-04-04' AS Date), 129, 7, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (18, N'9999', CAST(N'2026-03-04' AS Date), CAST(N'2026-04-04' AS Date), 1, 9, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (19, N'10', CAST(N'2026-03-04' AS Date), CAST(N'2026-04-04' AS Date), 1184, 12, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (20, N'1515', CAST(N'2026-03-04' AS Date), CAST(N'2026-04-04' AS Date), 80, 15, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (21, N'1555', CAST(N'2026-03-04' AS Date), CAST(N'2026-03-04' AS Date), 50, 15, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (22, N'1516', CAST(N'2026-03-04' AS Date), CAST(N'2026-03-04' AS Date), 50, 15, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (23, N'34', CAST(N'2026-03-04' AS Date), CAST(N'2026-04-04' AS Date), 1807, 18, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (24, N'1818', CAST(N'2026-03-04' AS Date), CAST(N'2026-04-04' AS Date), 34, 18, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (25, N'789', CAST(N'2026-03-04' AS Date), CAST(N'2026-03-04' AS Date), 5, 23, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (26, N'1945', CAST(N'2026-03-07' AS Date), CAST(N'2026-03-07' AS Date), 20, 24, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (1027, N'5647', CAST(N'2026-03-20' AS Date), CAST(N'2026-03-20' AS Date), 5, 1025, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (1028, N'2026', CAST(N'2026-04-08' AS Date), CAST(N'2026-05-08' AS Date), 13, 1026, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (1029, N'2026', CAST(N'2026-04-08' AS Date), CAST(N'2026-04-08' AS Date), 20, 1027, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (1040, N'1234', CAST(N'2026-04-22' AS Date), CAST(N'2026-04-22' AS Date), 25, 1032, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (1041, N'1234', CAST(N'2026-04-22' AS Date), CAST(N'2026-04-22' AS Date), 25, 1033, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (1042, N'1234', CAST(N'2026-04-22' AS Date), CAST(N'2026-04-22' AS Date), 12, 1034, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (1043, N'1234', CAST(N'2026-04-22' AS Date), CAST(N'2026-04-22' AS Date), 31, 1035, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (1044, N'4254', CAST(N'2026-04-22' AS Date), CAST(N'2026-04-22' AS Date), 15, 1035, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (1045, N'4224', CAST(N'2026-04-29' AS Date), CAST(N'2026-05-29' AS Date), 15, 1036, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (1046, N'5555', CAST(N'2026-04-29' AS Date), CAST(N'2026-04-29' AS Date), 10, 1036, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (1047, N'2332', CAST(N'2026-05-13' AS Date), CAST(N'2026-05-13' AS Date), 2, 1037, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (1048, N'4433', CAST(N'2026-05-13' AS Date), CAST(N'2026-05-13' AS Date), 15, 1037, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (1049, N'3222', CAST(N'2026-05-13' AS Date), CAST(N'2026-06-13' AS Date), 2, 1038, 1)
INSERT [dbo].[Lote] ([Id], [NumeroLote], [FechaIngreso], [FechaVencimiento], [Cantidad], [ProductoId], [Activo]) VALUES (1050, N'5544', CAST(N'2026-05-13' AS Date), CAST(N'2026-05-13' AS Date), 3, 1027, 1)
SET IDENTITY_INSERT [dbo].[Lote] OFF
GO
SET IDENTITY_INSERT [dbo].[Permiso] ON

INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (6, N'Realizar Venta', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (8, N'Cancelar Venta', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (9, N'Alta Usuario', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (10, N'Baja Usuario', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (11, N'Modificación Usuario', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (12, N'Alta Producto', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (13, N'Baja Producto', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (14, N'Modificación Producto', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (15, N'Ver Reportes', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (16, N'Alta Reporte', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (17, N'Baja Reporte', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (18, N'Modificar Reporte', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (19, N'Gestionar Permisos', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (20, N'Asignar Permisos', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (21, N'Agregar Usuario', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (22, N'Modificar Usuario', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (23, N'Eliminar Usuario', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (24, N'Gestionar Productos', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (25, N'Test22', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (26, N'AccesoUsuarios', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (27, N'Usuarios.Alta', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (28, N'Usuarios.Modificar', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (29, N'Usuarios.Baja', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (30, N'AccesoProductos', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (31, N'Productos.Ver', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (32, N'Productos.Agregar', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (33, N'Productos.Modificar', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (34, N'Productos.Eliminar', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (35, N'AccesoVentas', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (36, N'Ventas.Realizar', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (37, N'AccesoReportes', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (38, N'Reportes.Ver', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (39, N'Reportes.Modificar', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (40, N'Reportes.Eliminar', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (41, N'AccesoIdiomas', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (42, N'AccesoPermisos', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (43, N'Permisos.Asignar', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (44, N'Permisos.Gestionar', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (45, N'AccesoAdministracion', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (46, N'AccesoBitacora', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (47, N'AccesoVerificarIntegridad', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (48, N'AccesoRecalcularIntegridad', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (49, N'AccesoLotes', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (50, N'AccesoControlCambios', 0)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (51, N'Administracion', 1)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (52, N'Gestion Usuarios', 1)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (53, N'Gestion Productos', 1)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (54, N'Gestion Reportes', 1)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (55, N'Gestion Idioma', 1)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (56, N'Gestion Permisos', 1)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (57, N'Gestion Venta', 1)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (58, N'Gestion', 1)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (59, N'Base', 1)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (60, N'Vendedor', 1)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (61, N'Supervisor', 1)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (62, N'Administrador', 1)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (63, N'TesteandoNuevoComp', 1)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (64, N'GrupoTest', 1)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (65, N'testgruppp', 1)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (1065, N'test2026aaa', 1)
INSERT [dbo].[Permiso] ([Id], [Nombre], [EsPadre]) VALUES (1067, N'nuevito33', 1)
SET IDENTITY_INSERT [dbo].[Permiso] OFF
GO
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (51, 45)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (51, 46)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (51, 47)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (51, 48)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (51, 50)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (52, 26)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (52, 27)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (52, 28)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (52, 29)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (53, 30)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (53, 31)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (53, 32)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (53, 33)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (53, 34)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (54, 37)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (54, 38)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (54, 39)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (54, 40)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (55, 41)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (56, 42)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (56, 43)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (56, 44)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (57, 35)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (57, 36)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (58, 52)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (58, 53)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (58, 54)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (58, 55)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (58, 56)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (58, 57)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (59, 30)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (59, 31)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (59, 41)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (60, 57)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (60, 59)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (61, 26)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (61, 27)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (61, 28)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (61, 29)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (61, 30)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (61, 31)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (61, 33)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (61, 34)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (61, 37)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (61, 38)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (61, 39)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (61, 40)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (61, 41)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (61, 45)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (62, 26)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (62, 27)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (62, 28)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (62, 29)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (62, 30)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (62, 31)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (62, 32)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (62, 33)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (62, 34)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (62, 35)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (62, 36)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (62, 37)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (62, 38)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (62, 39)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (62, 40)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (62, 41)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (62, 42)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (62, 43)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (62, 44)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (62, 45)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (62, 46)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (62, 47)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (62, 48)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (62, 50)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (63, 50)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (63, 64)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (64, 50)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (65, 26)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (65, 27)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (65, 28)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (65, 29)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (65, 41)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (65, 46)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (1065, 30)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (1065, 31)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (1065, 32)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (1065, 33)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (1065, 34)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (1065, 53)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (1067, 26)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (1067, 27)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (1067, 28)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (1067, 29)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (1067, 35)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (1067, 36)
INSERT [dbo].[PermisoPermiso] ([IdPermisoPadre], [IdPermisoHijo]) VALUES (1067, 41)
GO
SET IDENTITY_INSERT [dbo].[ProductoHistorial] ON

INSERT [dbo].[ProductoHistorial] ([IdHistorial], [IdProducto], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [Fecha], [Accion]) VALUES (1, 4, N'Coca Cola', 2, CAST(2500.00 AS Decimal(18, 2)), 1.5, 130, 1, CAST(N'2026-03-07T00:56:40.380' AS DateTime), N'Modificar')
INSERT [dbo].[ProductoHistorial] ([IdHistorial], [IdProducto], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [Fecha], [Accion]) VALUES (2, 5, N'Agua Mineral', 2, CAST(1000.00 AS Decimal(18, 2)), 1, 140, 1, CAST(N'2026-03-07T00:57:53.063' AS DateTime), N'Modificar')
INSERT [dbo].[ProductoHistorial] ([IdHistorial], [IdProducto], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [Fecha], [Accion]) VALUES (3, 24, N'AguaPichon', 2, CAST(5000.00 AS Decimal(18, 2)), 2, 20, 1, CAST(N'2026-03-07T22:13:09.870' AS DateTime), N'Modificar')
INSERT [dbo].[ProductoHistorial] ([IdHistorial], [IdProducto], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [Fecha], [Accion]) VALUES (4, 27, N'PruebaTmp', 1, CAST(100.00 AS Decimal(18, 2)), 1, 0, 1, CAST(N'2026-03-20T20:20:04.770' AS DateTime), N'Eliminar')
INSERT [dbo].[ProductoHistorial] ([IdHistorial], [IdProducto], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [Fecha], [Accion]) VALUES (8, 4, N'Coca Cola', 2, CAST(2500.00 AS Decimal(18, 2)), 1.5, 130, 1, CAST(N'2026-04-22T15:55:31.597' AS DateTime), N'Modificar')
INSERT [dbo].[ProductoHistorial] ([IdHistorial], [IdProducto], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [Fecha], [Accion]) VALUES (9, 18, N'ProbandoLote', 2, CAST(5000.00 AS Decimal(18, 2)), 1000, 1850, 1, CAST(N'2026-04-29T22:06:45.410' AS DateTime), N'Modificar')
INSERT [dbo].[ProductoHistorial] ([IdHistorial], [IdProducto], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [Fecha], [Accion]) VALUES (10, 9, N'Sheridans', 1, CAST(40000.00 AS Decimal(18, 2)), 750, 1, 1, CAST(N'2026-04-29T22:07:00.390' AS DateTime), N'Modificar')
INSERT [dbo].[ProductoHistorial] ([IdHistorial], [IdProducto], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [Fecha], [Accion]) VALUES (11, 19, N'prueba', 2, CAST(9000.00 AS Decimal(18, 2)), 1500, 30, 1, CAST(N'2026-04-29T22:07:18.757' AS DateTime), N'Modificar')
INSERT [dbo].[ProductoHistorial] ([IdHistorial], [IdProducto], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [Fecha], [Accion]) VALUES (12, 20, N'prueba', 1, CAST(4000.00 AS Decimal(18, 2)), 1500, 10, 1, CAST(N'2026-04-29T22:07:29.943' AS DateTime), N'Modificar')
INSERT [dbo].[ProductoHistorial] ([IdHistorial], [IdProducto], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [Fecha], [Accion]) VALUES (13, 10, N'SheridansMuestra', 1, CAST(10.00 AS Decimal(18, 2)), 50, 50, 1, CAST(N'2026-04-29T22:07:47.587' AS DateTime), N'Modificar')
INSERT [dbo].[ProductoHistorial] ([IdHistorial], [IdProducto], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [Fecha], [Accion]) VALUES (14, 1037, N'nuevito23', 2, CAST(3500.00 AS Decimal(18, 2)), 2, 4, 1, CAST(N'2026-05-13T21:30:09.687' AS DateTime), N'Modificar')
INSERT [dbo].[ProductoHistorial] ([IdHistorial], [IdProducto], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [Fecha], [Accion]) VALUES (15, 1038, N'nuevo935', 2, CAST(3200.00 AS Decimal(18, 2)), 5, 2, 1, CAST(N'2026-05-13T21:31:07.720' AS DateTime), N'Eliminar')
INSERT [dbo].[ProductoHistorial] ([IdHistorial], [IdProducto], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [Fecha], [Accion]) VALUES (16, 1027, N'test2026b', 1, CAST(4500.00 AS Decimal(18, 2)), 3, 20, 1, CAST(N'2026-05-13T21:51:50.867' AS DateTime), N'Modificar')
INSERT [dbo].[ProductoHistorial] ([IdHistorial], [IdProducto], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [Fecha], [Accion]) VALUES (17, 6, N'Fernet Branca', 1, CAST(15000.00 AS Decimal(18, 2)), 0.75, 19, 1, CAST(N'2026-07-08T19:16:22.597' AS DateTime), N'Modificar')
INSERT [dbo].[ProductoHistorial] ([IdHistorial], [IdProducto], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [Fecha], [Accion]) VALUES (18, 4, N'Coca Cola', 2, CAST(2500.00 AS Decimal(18, 2)), 1.5, 130, 1, CAST(N'2026-07-08T19:27:42.213' AS DateTime), N'Modificar')
INSERT [dbo].[ProductoHistorial] ([IdHistorial], [IdProducto], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [Fecha], [Accion]) VALUES (19, 8, N'Citric', 2, CAST(3600.00 AS Decimal(18, 2)), 1, 7, 1, CAST(N'2026-07-08T19:35:11.733' AS DateTime), N'Modificar')
SET IDENTITY_INSERT [dbo].[ProductoHistorial] OFF
GO
SET IDENTITY_INSERT [dbo].[Productos] ON

INSERT [dbo].[Productos] ([Id], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [DVH]) VALUES (2, N'Cerveza Quilmes', 1, CAST(2500.00 AS Decimal(10, 2)), 1, 80, 1, CAST(3531634371046437948 AS Decimal(38, 0)))
INSERT [dbo].[Productos] ([Id], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [DVH]) VALUES (3, N'Vino Malbec', 1, CAST(5000.00 AS Decimal(10, 2)), 0.75, 30, 1, CAST(5116574739206051686 AS Decimal(38, 0)))
INSERT [dbo].[Productos] ([Id], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [DVH]) VALUES (4, N'Coca Cola', 2, CAST(4500.00 AS Decimal(10, 2)), 1.5, 126, 1, CAST(2972642870610315465 AS Decimal(38, 0)))
INSERT [dbo].[Productos] ([Id], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [DVH]) VALUES (5, N'Agua Mineral', 2, CAST(3000.00 AS Decimal(10, 2)), 1, 140, 1, CAST(7214780961741671346 AS Decimal(38, 0)))
INSERT [dbo].[Productos] ([Id], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [DVH]) VALUES (6, N'Fernet Branca', 1, CAST(18000.00 AS Decimal(10, 2)), 0.75, 19, 1, CAST(4064163226475546037 AS Decimal(38, 0)))
INSERT [dbo].[Productos] ([Id], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [DVH]) VALUES (7, N'Cerveza Corona', 1, CAST(3000.00 AS Decimal(10, 2)), 0.5, 129, 1, CAST(8342057242441271057 AS Decimal(38, 0)))
INSERT [dbo].[Productos] ([Id], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [DVH]) VALUES (8, N'Citric', 2, CAST(4600.00 AS Decimal(10, 2)), 1, 7, 1, CAST(5941012178926192382 AS Decimal(38, 0)))
INSERT [dbo].[Productos] ([Id], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [DVH]) VALUES (9, N'Sheridans', 1, CAST(40000.00 AS Decimal(10, 2)), 0.75, 1, 1, CAST(7805888935239902543 AS Decimal(38, 0)))
INSERT [dbo].[Productos] ([Id], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [DVH]) VALUES (10, N'SheridansMuestra', 1, CAST(10.00 AS Decimal(10, 2)), 0.05, 50, 1, CAST(2449744540007530540 AS Decimal(38, 0)))
INSERT [dbo].[Productos] ([Id], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [DVH]) VALUES (12, N'Citric Jugo', 2, CAST(3600.00 AS Decimal(10, 2)), 1, 1184, 1, CAST(3884214770578314281 AS Decimal(38, 0)))
INSERT [dbo].[Productos] ([Id], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [DVH]) VALUES (15, N'Agua Mineral', 2, CAST(1000.00 AS Decimal(10, 2)), 1, 180, 1, CAST(4562289368871503262 AS Decimal(38, 0)))
INSERT [dbo].[Productos] ([Id], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [DVH]) VALUES (16, N'testaguaa1', 2, CAST(5000.00 AS Decimal(10, 2)), 1, 5, 0, CAST(2535033029100379537 AS Decimal(38, 0)))
INSERT [dbo].[Productos] ([Id], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [DVH]) VALUES (17, N'testt1aaa', 2, CAST(2000.00 AS Decimal(10, 2)), 1, 5, 0, CAST(4094958079704023595 AS Decimal(38, 0)))
INSERT [dbo].[Productos] ([Id], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [DVH]) VALUES (18, N'ProbandoLote', 2, CAST(5000.00 AS Decimal(10, 2)), 1, 1841, 1, CAST(3675754648443908300 AS Decimal(38, 0)))
INSERT [dbo].[Productos] ([Id], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [DVH]) VALUES (19, N'prueba', 2, CAST(9000.00 AS Decimal(10, 2)), 1.5, 25, 1, CAST(4441189930264270207 AS Decimal(38, 0)))
INSERT [dbo].[Productos] ([Id], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [DVH]) VALUES (20, N'prueba', 1, CAST(4000.00 AS Decimal(10, 2)), 1.5, 10, 1, CAST(5838623527950599633 AS Decimal(38, 0)))
INSERT [dbo].[Productos] ([Id], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [DVH]) VALUES (21, N'testnuevo', 2, CAST(5000.00 AS Decimal(10, 2)), 2, 32, 1, CAST(3206912844902544077 AS Decimal(38, 0)))
INSERT [dbo].[Productos] ([Id], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [DVH]) VALUES (22, N'producTest', 2, CAST(4500.00 AS Decimal(10, 2)), 3, 5, 1, CAST(166712901118317752 AS Decimal(38, 0)))
INSERT [dbo].[Productos] ([Id], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [DVH]) VALUES (23, N'producZ', 2, CAST(4000.00 AS Decimal(10, 2)), 5, 5, 1, CAST(7650360493268883383 AS Decimal(38, 0)))
INSERT [dbo].[Productos] ([Id], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [DVH]) VALUES (24, N'AguaPichon', 2, CAST(5000.00 AS Decimal(10, 2)), 2, 20, 1, CAST(3046018347992392459 AS Decimal(38, 0)))
INSERT [dbo].[Productos] ([Id], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [DVH]) VALUES (27, N'PruebaTmp', 1, CAST(100.00 AS Decimal(10, 2)), 1, 0, 0, CAST(6791430838757429673 AS Decimal(38, 0)))
INSERT [dbo].[Productos] ([Id], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [DVH]) VALUES (1025, N'test224', 1, CAST(2000.00 AS Decimal(10, 2)), 2, 5, 1, CAST(7685665986928057210 AS Decimal(38, 0)))
INSERT [dbo].[Productos] ([Id], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [DVH]) VALUES (1026, N'test2026', 1, CAST(5000.00 AS Decimal(10, 2)), 2, 13, 1, CAST(4480594815197415832 AS Decimal(38, 0)))
INSERT [dbo].[Productos] ([Id], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [DVH]) VALUES (1027, N'test2026bb', 1, CAST(4500.00 AS Decimal(10, 2)), 3, 23, 1, CAST(7517794014752589146 AS Decimal(38, 0)))
INSERT [dbo].[Productos] ([Id], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [DVH]) VALUES (1032, N'asdTESTsp', 2, CAST(3400.00 AS Decimal(10, 2)), 3, 25, 0, CAST(512016135578580000 AS Decimal(38, 0)))
INSERT [dbo].[Productos] ([Id], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [DVH]) VALUES (1033, N'asdTESTsp2', 2, CAST(3500.00 AS Decimal(10, 2)), 3, 25, 0, CAST(7311183122186206418 AS Decimal(38, 0)))
INSERT [dbo].[Productos] ([Id], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [DVH]) VALUES (1034, N'zzTEstsp', 1, CAST(3500.00 AS Decimal(10, 2)), 2, 12, 0, CAST(7734195333935501972 AS Decimal(38, 0)))
INSERT [dbo].[Productos] ([Id], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [DVH]) VALUES (1035, N'asTESTTp2', 2, CAST(3450.00 AS Decimal(10, 2)), 2, 46, 1, CAST(5476543379497803160 AS Decimal(38, 0)))
INSERT [dbo].[Productos] ([Id], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [DVH]) VALUES (1036, N'test999', 2, CAST(3000.00 AS Decimal(10, 2)), 2, 25, 1, CAST(3619615067069174616 AS Decimal(38, 0)))
INSERT [dbo].[Productos] ([Id], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [DVH]) VALUES (1037, N'nuevito23', 2, CAST(3500.00 AS Decimal(10, 2)), 2, 4, 1, CAST(3775556964707776407 AS Decimal(38, 0)))
INSERT [dbo].[Productos] ([Id], [Nombre], [CategoriaId], [Precio], [LitrosPorUnidad], [Stock], [Activo], [DVH]) VALUES (1038, N'nuevo935', 2, CAST(3200.00 AS Decimal(10, 2)), 5, 2, 0, CAST(4648576769660735252 AS Decimal(38, 0)))
SET IDENTITY_INSERT [dbo].[Productos] OFF
GO
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (0, N'lblUsuario')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (1, N'lblPassword')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (2, N'btnLogin')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (3, N'lblIdioma')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (4, N'FrmLogin')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (5, N'menuUsuarios')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (6, N'menuProductos')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (7, N'menuVentas')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (8, N'menuReportes')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (9, N'menuGestionPermisos')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (10, N'cerrarSesion')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (11, N'usuario')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (12, N'FrmGestionPermisos')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (13, N'btnAgregarPermisoASel')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (14, N'btnAsignarRol')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (15, N'btnCrearGrupo')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (16, N'lblRoles')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (17, N'lblPermisosDisponibles')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (18, N'lblSeleccionados')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (19, N'txtNombreGrupo')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (20, N'PlaceHolderText')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (21, N'menuAsignarPermisos')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (22, N'FrmUsuarios')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (23, N'btnAgregar')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (24, N'btnModificar')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (25, N'btnEliminar')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (26, N'btnGrabar')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (27, N'btnCancelar')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (28, N'lblUsuario')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (29, N'lblPassword')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (30, N'lblRol')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (31, N'menuIdiomas')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (32, N'menuVerificarIntegridad')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (33, N'menuRecalcularIntegridad')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (34, N'menuBitacora')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (35, N'btnNuevo')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (36, N'MostrarEliminados')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (37, N'lblCodigo')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (38, N'lblNombre')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (39, N'Gestionar')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (40, N'PermisosSimples')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (41, N'CrearPermisoSimple')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (42, N'PermisosCompuestos')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (43, N'SeleccionarSimples')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (44, N'GuardarAsignacion')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (45, N'EliminarGrupo')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (46, N'CrearGrupo')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (47, N'Asignar')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (48, N'SeleccionarUsuario')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (49, N'GruposDisponibles')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (50, N'Agregar')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (51, N'Registrar')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (52, N'Total')
INSERT [dbo].[Tag] ([Id], [Nombre]) VALUES (53, N'GenerarReporte')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 0, N'Usuario')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 1, N'Contraseña')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 2, N'Iniciar Sesión')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 3, N'Idioma')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 4, N'Login - Gestión de Bebidas')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 5, N'Usuarios')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 6, N'Productos')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 7, N'Ventas')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 8, N'Reportes')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 9, N'Gestión de Permisos')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 10, N'Cerrar Sesión')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 11, N'Usuario')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 12, N'Gestión de Permisos')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 13, N'Agregar')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 14, N'Asignar Permisos a Rol')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 15, N'Crear Grupo')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 16, N'Seleccionar rol:')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 17, N'Permisos Simples Disponibles:')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 18, N'Permisos Seleccionados:')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 19, N'Nombre del grupo')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 20, N'Nombre del grupo')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 21, N'Asignar Permisos')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 22, N'Gestión de Usuarios')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 23, N'Agregar')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 24, N'Modificar')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 25, N'Eliminar')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 26, N'Grabar')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 27, N'Cancelar')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 28, N'Usuario')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 29, N'Contraseña')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 30, N'Rol')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 31, N'Idiomas')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 32, N'Verificar Integridad')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 33, N'Recalcular Integridad')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 34, N'Bitacora')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 35, N'Nuevo')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 36, N'Mostrar Eliminados')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 37, N'Codigo')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 38, N'Nombre')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 39, N'Gestionar')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 40, N'Permisos Simples')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 41, N'CrearPermisoSimple')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 42, N'Permisos Compuestos')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 43, N'Seleccionar Simples')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 44, N'GuardarAsignacion')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 45, N'EliminarGrupo')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 46, N'CrearGrupo')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 47, N'Asignar')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 48, N'Seleccionar Usuario')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 49, N'GruposDisponibles')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 50, N'Agregar')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 51, N'Registrar')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 52, N'Total')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1, 53, N'GenerarReporte')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 0, N'User')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 1, N'Password')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 2, N'Login')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 3, N'Language')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 4, N'Login - Beverage Management')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 5, N'Users')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 6, N'Products')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 7, N'Sales')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 8, N'Reports')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 9, N'Permission Groups')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 10, N'Log Out')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 11, N'User')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 12, N'Permission Management')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 13, N'Add')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 14, N'Assign Permissions to Role')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 15, N'Create Group')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 16, N'Select Role:')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 17, N'Available Simple Permissions:')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 18, N'Selected Permissions:')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 19, N'Group Name')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 20, N'Group Name')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 21, N'Assign Permissions')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 22, N'User Management')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 23, N'Add')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 24, N'Edit')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 25, N'Delete')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 26, N'Save')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 27, N'Cancel')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 28, N'User')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 29, N'Password')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (2, 30, N'Role')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 0, N'Utilisateur')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 1, N'Mot de passe')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 2, N'Connexion')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 3, N'Langue')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 4, N'Connexion - Gestion des Boissons')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 5, N'Utilisateurs')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 6, N'Produits')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 7, N'Ventes')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 8, N'Rapports')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 9, N'Gestion des Permissions')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 10, N'Déconnexion')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 11, N'Utilisateur')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 12, N'Gestion des permissions')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 13, N'Ajouter')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 14, N'Attribuer des permissions au rôle')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 15, N'Créer un groupe')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 16, N'Sélectionner un rôle :')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 17, N'Permissions simples disponibles :')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 18, N'Permissions sélectionnées :')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 19, N'Nom du groupe')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 20, N'Nom du groupe')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 21, N'Attribuer des autorisations')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 22, N'Gestion des Utilisateurs')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 23, N'Ajouter')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 24, N'Modifier')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 25, N'Supprimer')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 26, N'Enregistrer')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 27, N'Annuler')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 28, N'Utilisateur')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 29, N'Mot de passe')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (5, 30, N'Rôle')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 0, N'Benutzer')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 1, N'Passwort')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 2, N'Anmelden')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 3, N'Sprache')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 4, N'Anmeldung – Getränkeverwaltung')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 5, N'Benutzer')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 6, N'Produkte')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 7, N'Verkäufe')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 8, N'Berichte')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 9, N'Berechtigungsverwaltung')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 10, N'Abmelden')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 11, N'Benutzer')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 12, N'Berechtigungsverwaltung')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 13, N'Hinzufügen')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 14, N'Berechtigungen zu Rolle zuweisen')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 15, N'Gruppe erstellen')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 16, N'Rolle auswählen:')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 17, N'Verfügbare einfache Berechtigungen:')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 18, N'Ausgewählte Berechtigungen:')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 19, N'Gruppenname')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 20, N'Gruppenname')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 21, N'Berechtigungen zuweisen')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 22, N'Benutzerverwaltung')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 23, N'Hinzufügen')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 24, N'Bearbeiten')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 25, N'Löschen')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 26, N'Speichern')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 27, N'Abbrechen')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 28, N'Benutzer')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 29, N'Passwort')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (11, 30, N'Rolle')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 0, N'Utente')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 1, N'Password')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 2, N'Accedi')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 3, N'Lingua')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 4, N'Accesso – Gestione Bevande')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 5, N'Utenti')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 6, N'Prodotti')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 7, N'Vendite')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 8, N'Report')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 9, N'Gestione Permessi')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 10, N'Esci')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 11, N'Utente')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 12, N'Gestione dei permessi')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 13, N'Aggiungi')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 14, N'Assegna permessi al ruolo')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 15, N'Crea gruppo')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 16, N'Seleziona ruolo:')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 17, N'Permessi semplici disponibili:')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 18, N'Permessi selezionati:')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 19, N'Nome del gruppo')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 20, N'Nome del gruppo')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 21, N'Assegnare permessi')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 22, N'Gestione Utenti')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 23, N'Aggiungi')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 24, N'Modifica')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 25, N'Elimina')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 26, N'Salva')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 27, N'Annulla')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 28, N'Utente')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 29, N'Password')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (12, 30, N'Ruolo')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 0, N'Usuário')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 1, N'Senha')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 2, N'Entrar')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 3, N'Idioma')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 4, N'Login – Gestão de Bebidas')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 5, N'Usuários')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 6, N'Produtos')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 7, N'Vendas')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 8, N'Relatórios')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 9, N'Gestão de Permissões')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 10, N'Sair')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 11, N'Usuário')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 12, N'Gerenciamento de Permissões')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 13, N'Adicionar')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 14, N'Atribuir Permissões ao Papel')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 15, N'Criar Grupo')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 16, N'Selecionar papel:')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 17, N'Permissões Simples Disponíveis:')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 18, N'Permissões Selecionadas:')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 19, N'Nome do grupo')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 20, N'Nome do grupo')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 21, N'Atribuir permissões')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 22, N'Gestão de Usuários')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 23, N'Adicionar')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 24, N'Editar')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 25, N'Excluir')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 26, N'Salvar')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 27, N'Cancelar')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 28, N'Usuário')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 29, N'Senha')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (13, 30, N'Função')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (15, 0, N'atteo22')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (15, 1, N'atteo15')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (15, 2, N'atteo8')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (15, 3, N'atteo14')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (15, 4, N'atteo12')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (15, 5, N'atteo27')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (15, 6, N'atteo25')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (15, 7, N'atteo28')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (15, 8, N'atteo26')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (15, 9, N'atteo24')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (15, 10, N'atteo10')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (15, 11, N'atteo31')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (15, 12, N'atteo11')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (15, 13, N'atteo2')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (15, 14, N'atteo3')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (15, 15, N'atteo5')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (15, 16, N'atteo19')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (15, 17, N'atteo17')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (15, 18, N'atteo20')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (15, 19, N'atteo30')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (15, 20, N'atteo29')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (15, 21, N'atteo23')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (15, 22, N'atteo13')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (15, 23, N'atteo1')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (15, 24, N'atteo9')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (15, 25, N'atteo6')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (15, 26, N'atteo7')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (15, 27, N'atteo4')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (15, 28, N'atteo21')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (15, 29, N'atteo16')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (15, 30, N'atteo18')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 0, N'test34')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 1, N'test27')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 2, N'test10')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 3, N'test25')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 4, N'test18')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 5, N'test42')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 6, N'test39')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 7, N'test43')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 8, N'test41')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 9, N'test37')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 10, N'test13')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 11, N'test54')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 12, N'test17')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 13, N'test4')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 14, N'test5')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 15, N'test7')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 16, N'test31')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 17, N'test29')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 18, N'test32')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 19, N'test53')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 20, N'test48')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 21, N'test35')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 22, N'test19')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 23, N'test3')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 24, N'test11')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 25, N'test8')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 26, N'test9')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 27, N'test6')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 28, N'test33')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 29, N'test28')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 30, N'test30')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 31, N'test38')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 32, N'test44')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 33, N'test40')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 34, N'test36')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 35, N'test12')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 36, N'test45')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 37, N'test24')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 38, N'test26')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 39, N'test21')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 40, N'test47')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 41, N'test15')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 42, N'test46')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 43, N'test50')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 44, N'test23')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 45, N'test16')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 46, N'test14')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 47, N'test2')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 48, N'test51')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 49, N'test22')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 50, N'test1')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 51, N'test49')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 52, N'test52')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (17, 53, N'test20')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 0, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 1, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 2, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 3, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 4, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 5, N'usuaX')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 6, N'produX')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 7, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 8, N'RepoX')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 9, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 10, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 11, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 12, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 13, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 14, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 15, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 16, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 17, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 18, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 19, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 20, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 21, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 22, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 23, N'g')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 24, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 25, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 26, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 27, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 28, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 29, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 30, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 31, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 32, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 33, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 34, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 35, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 36, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 37, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 38, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 39, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 40, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 41, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 42, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 43, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 44, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 45, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 46, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 47, N'asiign')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 48, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 49, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 50, N'agregandooo')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 51, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 52, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (18, 53, N'')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (20, 5, N'hhh')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (20, 7, N'vvvvvvvvv')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (20, 8, N'aaa')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (21, 6, N'3')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (21, 8, N'5')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (21, 9, N'1')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (21, 31, N'2')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (21, 33, N'4')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (21, 47, N'b')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (21, 50, N'a')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (22, 47, N'dg')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 0, N'Usuario')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 1, N'Contraseña')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 2, N'Iniciar Sesión')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 3, N'Idioma')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 4, N'Login - Gestión de Bebidas')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 5, N'Usuarios')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 6, N'nv34')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 7, N'Ventas')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 8, N'Reportes')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 9, N'nv65')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 10, N'Cerrar Sesión')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 11, N'Usuario')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 12, N'Gestión de Permisos')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 13, N'nv3')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 14, N'Asignar Permisos a Rol')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 15, N'Crear Grupo')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 16, N'Seleccionar rol:')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 17, N'Permisos Simples Disponibles:')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 18, N'Permisos Seleccionados:')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 19, N'Nombre del grupo')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 20, N'Nombre del grupo')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 21, N'Asignar Permisos')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 22, N'Gestión de Usuarios')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 23, N'Agregar')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 24, N'Modificar')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 25, N'Eliminar')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 26, N'Grabar')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 27, N'Cancelar')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 28, N'Usuario')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 29, N'Contraseña')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 30, N'Rol')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 31, N'nv355')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 32, N'Verificar Integridad')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 33, N'Recalcular Integridad')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 34, N'Bitacora')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 35, N'Nuevo')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 36, N'Mostrar Eliminados')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 37, N'Codigo')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 38, N'Nombre')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 39, N'Gestionar')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 40, N'Permisos Simples')
GO
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 41, N'CrearPermisoSimple')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 42, N'Permisos Compuestos')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 43, N'Seleccionar Simples')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 44, N'GuardarAsignacion')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 45, N'EliminarGrupo')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 46, N'CrearGrupo')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 47, N'nv2')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 48, N'Seleccionar Usuario')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 49, N'GruposDisponibles')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 50, N'nv')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 51, N'Registrar')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 52, N'Total')
INSERT [dbo].[TraduccionT] ([IdIdioma], [IdTag], [Traduccion]) VALUES (1023, 53, N'GenerarReporte')
GO
INSERT [dbo].[Usuario_Permiso] ([IdUsuario], [IdPermiso]) VALUES (7, 62)
INSERT [dbo].[Usuario_Permiso] ([IdUsuario], [IdPermiso]) VALUES (35, 64)
INSERT [dbo].[Usuario_Permiso] ([IdUsuario], [IdPermiso]) VALUES (1043, 53)
INSERT [dbo].[Usuario_Permiso] ([IdUsuario], [IdPermiso]) VALUES (1044, 1065)
INSERT [dbo].[Usuario_Permiso] ([IdUsuario], [IdPermiso]) VALUES (1046, 1067)
INSERT [dbo].[Usuario_Permiso] ([IdUsuario], [IdPermiso]) VALUES (1048, 64)
GO
SET IDENTITY_INSERT [dbo].[Usuarios] ON

INSERT [dbo].[Usuarios] ([Id], [NombreUsuario], [Contraseña], [Salt], [Idioma], [Activo], [DVH]) VALUES (7, N'admin', N'yK3Yexd3D+GfJqdizhQW0Y4vVmCzeNzL7XR95iO7M8CY+6ql7gtyDxQ+4qINTwo3Yyh9BYePcxIxVKWdArQ/KQ==', N'56f27d37-740d-458b-b1ae-f652f4fec731', N'es', 1, CAST(3510380924299723335 AS Decimal(38, 0)))
INSERT [dbo].[Usuarios] ([Id], [NombreUsuario], [Contraseña], [Salt], [Idioma], [Activo], [DVH]) VALUES (8, N'carlitos', N'YnOA2n6y1YkuBlxbrEah6u0AsJ9z85wI+49vU575+vlLWWcbVRLe0BW7dS7MTR2wIuUNojKtNEMTy+gVzFp/eQ==', N'078d55a4-7ca3-4d53-a4ef-f6c3e448cd10', N'es', 1, CAST(3172448433085823171 AS Decimal(38, 0)))
INSERT [dbo].[Usuarios] ([Id], [NombreUsuario], [Contraseña], [Salt], [Idioma], [Activo], [DVH]) VALUES (14, N'tevez', N'NaoPENDfDw5+0dps6/2RXsLqgw9TTlmP+5GrCSVFROH56bxJamWKizBDqrHrFpmGqtKAgyHMT5Mh4zz4NferXg==', N'66ff1d83-85bd-4a2c-adc2-a2b042705196', N'es', 1, CAST(1447654833182644699 AS Decimal(38, 0)))
INSERT [dbo].[Usuarios] ([Id], [NombreUsuario], [Contraseña], [Salt], [Idioma], [Activo], [DVH]) VALUES (16, N'ana', N'ykm2Y/6IpHP6FIhkmWjuDeeoHaT/OmP0j1f558YgoKnvsUeze1ueo8QbSirNtt7kWPRxXH2mDRgGUt4KwyUkrw==', N'4797ab02-40a7-4e2c-baf8-7b23c3c6db62', N'es', 1, CAST(7497653302941457730 AS Decimal(38, 0)))
INSERT [dbo].[Usuarios] ([Id], [NombreUsuario], [Contraseña], [Salt], [Idioma], [Activo], [DVH]) VALUES (20, N'administrador', N'administrador2025', N'333333333333333', N'es', 1, CAST(424319349263547886 AS Decimal(38, 0)))
INSERT [dbo].[Usuarios] ([Id], [NombreUsuario], [Contraseña], [Salt], [Idioma], [Activo], [DVH]) VALUES (21, N'test', N'MRbvPjtfxy3oTV+yi1ntGs/RHP0Y7kyAnfAqC0MKMVnWVgTCW9oO8xbnL4OroWAvbIHEpXKx5qCc4m+RUZaGqg==', N'851790f4-2d70-401b-8496-fa47aeab4aa2', N'es', 1, CAST(6760133747494152159 AS Decimal(38, 0)))
INSERT [dbo].[Usuarios] ([Id], [NombreUsuario], [Contraseña], [Salt], [Idioma], [Activo], [DVH]) VALUES (22, N'tester155', N'Tm2tiRGWMkbFECWQN25ByHpTsML9lhVbE9veqXqDdi8G9aWRCkOCrWux79aiHUjtHcwLM5UiZ+YDVfr/67Auhg==', N'c193f200-b9ce-4702-91df-11efd88fd35a', N'es', 1, CAST(8389831805397801237 AS Decimal(38, 0)))
INSERT [dbo].[Usuarios] ([Id], [NombreUsuario], [Contraseña], [Salt], [Idioma], [Activo], [DVH]) VALUES (23, N'usuariootoo', N'JJAQjGUqCDFRzfPGpQRi605bX18D1YhQAhjH2eUa2I/P9hVK/TuQiz5uFbmyG3fDghgTozYiXdQTTihHW0EOBw==', N'8a211f82-058b-4a27-93e6-6b0b2dbce288', N'es', 0, CAST(3379234080786369681 AS Decimal(38, 0)))
INSERT [dbo].[Usuarios] ([Id], [NombreUsuario], [Contraseña], [Salt], [Idioma], [Activo], [DVH]) VALUES (24, N'testu', N'VP0qqhWs5hHZRuA99Z1Y85E9hTrxpjJuNqUwxjn8b970iPa0gKQxvV+C5DWd20dPgsmc463YgIrWZd4BbyzQNw==', N'7d86268c-452a-4a6d-a174-e666776e77f3', N'es', 1, CAST(3314567778603560431 AS Decimal(38, 0)))
INSERT [dbo].[Usuarios] ([Id], [NombreUsuario], [Contraseña], [Salt], [Idioma], [Activo], [DVH]) VALUES (25, N'testmen2', N'ECdmB77qMLJG8Pa3Vp51CFowKbMpbEgAMaWmVDdY9dzHVyW1XaOCEfFJYzV8iAlR1y0/dTEaP44TSzP03ngFEQ==', N'9b9d9610-a9b3-40e2-9e6f-77b68af1f425', N'es', 1, CAST(4192579318899362938 AS Decimal(38, 0)))
INSERT [dbo].[Usuarios] ([Id], [NombreUsuario], [Contraseña], [Salt], [Idioma], [Activo], [DVH]) VALUES (26, N'user1', N'Hj90IT0HG9Y3wcFLbxPpjR8nZsB4fVgNqWyY7W8qpAV+pKb1NCYyyy+24WrU5eUXXLM6exJfkQBxepFj+eMq1A==', N'2a74b244-425d-4c99-9c28-3f21eeba231b', N'es', 1, CAST(7712235173365687750 AS Decimal(38, 0)))
INSERT [dbo].[Usuarios] ([Id], [NombreUsuario], [Contraseña], [Salt], [Idioma], [Activo], [DVH]) VALUES (27, N'user25', N'LLULPB6OIfgEEcl8m+6TBZDh9yT4WJqEtC7iZzkY5kwCmiCrS547Zb39lBxPoVkIIXqskh+Bm3aX9AudEPOkhQ==', N'9104829b-4cd1-4390-82df-61d36cec2764', N'es', 1, CAST(3606587951674902174 AS Decimal(38, 0)))
INSERT [dbo].[Usuarios] ([Id], [NombreUsuario], [Contraseña], [Salt], [Idioma], [Activo], [DVH]) VALUES (28, N'user99', N'JiQek5dwybKrDAMredjZGTqwYGx/mWho+x/Hsf5XN+Gm1hsPfJTOk9GROV+e6LaqMMObh3H5vfF2UYytes0hmg==', N'051c2d0d-48e1-4112-9d70-83ab6c16ea1b', N'es', 1, CAST(1058214996251113460 AS Decimal(38, 0)))
INSERT [dbo].[Usuarios] ([Id], [NombreUsuario], [Contraseña], [Salt], [Idioma], [Activo], [DVH]) VALUES (29, N'userZz', N'lafZ/T01DhjEWNV6RdHwyypdcesCmE2sIdJAiu6vIuVFaom85BzKsaYWEmdQPZZtbGmlhMjYDHICqqPrG4dadg==', N'377443e6-a8c2-4887-8a26-865238bc8942', N'es', 1, CAST(2746715598235132679 AS Decimal(38, 0)))
INSERT [dbo].[Usuarios] ([Id], [NombreUsuario], [Contraseña], [Salt], [Idioma], [Activo], [DVH]) VALUES (30, N'zzuser2', N'gnF7jUQNLEzuh1SUeENrS3/Gs4ynU+yTrY1yI6M4KSt7ftPiJRz8jZrbMZBKiejZazu1hm0lmDm7akteCEb6GQ==', N'33b290f3-e71d-4426-b35b-de18ac7a8831', N'es', 1, CAST(9017173231804270687 AS Decimal(38, 0)))
INSERT [dbo].[Usuarios] ([Id], [NombreUsuario], [Contraseña], [Salt], [Idioma], [Activo], [DVH]) VALUES (31, N'zuserBorrar', N'0WVjn62Gp8Bdu5y7sKqVO/09/GyDvrAWAtJuUxflxvO5ULPVKUITZia+c8jcfmQSYcAqLnmJM5nBk40jW6htWw==', N'8e6b03ea-7d37-4244-9e1f-a93716326cb6', N'es', 0, CAST(8047309116438259702 AS Decimal(38, 0)))
INSERT [dbo].[Usuarios] ([Id], [NombreUsuario], [Contraseña], [Salt], [Idioma], [Activo], [DVH]) VALUES (32, N'ttuser2', N'ah0nAEGRjusnq1o9XzZUI3A/09Qw3N7j2EUAa45VOlu2wnlk6xlL71OfR8+r63QEy/nFeIJmR7re9d7Bw74nMg==', N'fb449a69-d210-4336-956d-dcd7444e9351', N'es', 1, CAST(2574697791887550002 AS Decimal(38, 0)))
INSERT [dbo].[Usuarios] ([Id], [NombreUsuario], [Contraseña], [Salt], [Idioma], [Activo], [DVH]) VALUES (33, N'ztuser', N'ITrcEEBiYZlmTDNYXFI6dXqO+MyPZz4VFkahWE6fCMUWpmSxRVqmnhzssHaEKgW0J+y2ECt/PVNTW1eb9KXPmw==', N'68294301-d538-475c-88cf-54cd0aa77ce9', N'es', 1, CAST(7100341596741199403 AS Decimal(38, 0)))
INSERT [dbo].[Usuarios] ([Id], [NombreUsuario], [Contraseña], [Salt], [Idioma], [Activo], [DVH]) VALUES (35, N'pichon', N'hqd/kx/YqQFt+lD/1XCXf3c8LfI3fOWV4ZvF8gtRAi9+P+8UEKzQrHN8S8wGIPpDa3q6oMghiGDUb5UlOyhVdQ==', N'4e358bf2-0ef3-465b-9cf4-9ec318bd8ee2', N'es', 1, CAST(2898154430907577984 AS Decimal(38, 0)))
INSERT [dbo].[Usuarios] ([Id], [NombreUsuario], [Contraseña], [Salt], [Idioma], [Activo], [DVH]) VALUES (36, N'newUser', N'Rs+DSjgRHTMGBY/NytMtwh7cKyRk8YAv+0XVDKXAkFajI/Zcfb2WkCUfpQgVJKnYtTGCe3rJLhmfGdTsSObEvg==', N'fe298a91-b193-420e-9d77-fdf1b9083eea', N'es', 1, CAST(7453829394144713435 AS Decimal(38, 0)))
INSERT [dbo].[Usuarios] ([Id], [NombreUsuario], [Contraseña], [Salt], [Idioma], [Activo], [DVH]) VALUES (1038, N'testprobando22', N'wQQ9iMS+pXv7ysa+srkjbkg3pa89ldMXgMOGg9HJ2Z8oRsEWi3L0+4oTWj/nk8fMlViqH8ZYe6TgoIfnw3yt/w==', N'a17ae1fd-3a7c-4d6c-94e4-8550b4407d1c', N'es', 0, CAST(5623296114150502807 AS Decimal(38, 0)))
INSERT [dbo].[Usuarios] ([Id], [NombreUsuario], [Contraseña], [Salt], [Idioma], [Activo], [DVH]) VALUES (1041, N'testprobando23', N'w0J95JGSGwZAsKdQByjY9JRD+6fVNc4sxNB+WGM2s3l8D4eL9/AhLt9Q3unr+GmpJqFZYzGWor+Rur0eeSke8w==', N'ab8803fe-cccd-45b8-96f3-771bae5dbc95', N'es', 0, CAST(3124082414060275673 AS Decimal(38, 0)))
INSERT [dbo].[Usuarios] ([Id], [NombreUsuario], [Contraseña], [Salt], [Idioma], [Activo], [DVH]) VALUES (1042, N'testprobando242', N'ijn10jwWCfqKIXzpUqYhj+LMEaDt3q5MK7iGqC2JFLwwBAI5kL4BJ3uFY1rt9Fpj6aY3XJOlALPNgDkmwYBxrw==', N'dd2db80e-c886-4d91-834d-bc25be80ca51', N'es', 1, CAST(3036797347986421773 AS Decimal(38, 0)))
INSERT [dbo].[Usuarios] ([Id], [NombreUsuario], [Contraseña], [Salt], [Idioma], [Activo], [DVH]) VALUES (1043, N'test2026', N'Nv7VXbZstnSXESRK9pvewO5T3oqQ+NI7bnoGzM8C2EgWjdiBl1KzASDraQ5GMGgtDiXyhTML86cicmyiyO45yg==', N'c9554d2f-05f0-4044-8714-82c4666486d6', N'es', 1, CAST(5261939101858377843 AS Decimal(38, 0)))
INSERT [dbo].[Usuarios] ([Id], [NombreUsuario], [Contraseña], [Salt], [Idioma], [Activo], [DVH]) VALUES (1044, N'test2026b', N'rRcsjmRo6KKZ6XYplVJMwnlVpglKwFDAkNrQvhtN2fMUlUQgoy5JUgPyuwSE4FiQ+U1zyNHTKMMcfckonK/ljQ==', N'0d803c02-ad75-4b72-99a8-9b64ae710f55', N'es', 1, CAST(6480548124319959609 AS Decimal(38, 0)))
INSERT [dbo].[Usuarios] ([Id], [NombreUsuario], [Contraseña], [Salt], [Idioma], [Activo], [DVH]) VALUES (1045, N'zz22Testsp2', N'EzhBYQM9FIo3VHfznqYb+1oCK0tEjQFtLbbPB+R2la3RpFr+lfu5ZOGKgLfNBDtSP/gijsFgaTSGEJat4StPjQ==', N'0fc3db0b-4132-4853-8e36-87bb23353c59', N'es', 0, CAST(8423518391027944654 AS Decimal(38, 0)))
INSERT [dbo].[Usuarios] ([Id], [NombreUsuario], [Contraseña], [Salt], [Idioma], [Activo], [DVH]) VALUES (1046, N'nuevito22', N'All91rtaHBlA8MZ9hHQxRyo7MHlnobAfwql7ci6yNd0Hja/OcwDUERKW2A3jm1Aww/0O0wX2RvU4AOdyzKzycw==', N'a5af9406-3016-40e8-9c01-84a06d3f25b3', N'es', 1, CAST(409097304788492037 AS Decimal(38, 0)))
INSERT [dbo].[Usuarios] ([Id], [NombreUsuario], [Contraseña], [Salt], [Idioma], [Activo], [DVH]) VALUES (1047, N'nuevo35', N'o5wVlaF0oweYhWD5q8519Ga82L7TlcyRMQIXUiWMrdrMvGMRtV1gpEvUs94RNRW8yWLUSz43GVdfuwtVtrJtNg==', N'8c2341da-e705-400a-b147-7a4b70a64165', N'es', 1, CAST(3286154966936280678 AS Decimal(38, 0)))
INSERT [dbo].[Usuarios] ([Id], [NombreUsuario], [Contraseña], [Salt], [Idioma], [Activo], [DVH]) VALUES (1048, N'prueba123', N'EHNx4/mZQCodm7rWs5YPBaH/XEPW4cyQ/d4T1m8yY4hzSgTPHZ5Cr+o1ee1iiZX2o/AAGw+RoxjM7VT4+zYY3A==', N'763a59cc-8362-4b56-b161-d8095e366b96', N'es', 1, CAST(6252231790337451385 AS Decimal(38, 0)))
SET IDENTITY_INSERT [dbo].[Usuarios] OFF
GO
SET IDENTITY_INSERT [dbo].[Ventas] ON

INSERT [dbo].[Ventas] ([Id], [Fecha], [UsuarioId], [ClienteId], [Zona], [Vendedor]) VALUES (4, CAST(N'2025-11-06T00:08:31.380' AS DateTime), 7, NULL, NULL, NULL)
INSERT [dbo].[Ventas] ([Id], [Fecha], [UsuarioId], [ClienteId], [Zona], [Vendedor]) VALUES (5, CAST(N'2025-11-06T22:25:41.413' AS DateTime), 7, NULL, NULL, NULL)
INSERT [dbo].[Ventas] ([Id], [Fecha], [UsuarioId], [ClienteId], [Zona], [Vendedor]) VALUES (6, CAST(N'2025-11-06T22:25:57.550' AS DateTime), 7, NULL, NULL, NULL)
INSERT [dbo].[Ventas] ([Id], [Fecha], [UsuarioId], [ClienteId], [Zona], [Vendedor]) VALUES (7, CAST(N'2025-11-06T22:29:08.070' AS DateTime), 7, NULL, NULL, NULL)
INSERT [dbo].[Ventas] ([Id], [Fecha], [UsuarioId], [ClienteId], [Zona], [Vendedor]) VALUES (8, CAST(N'2025-11-13T22:38:53.417' AS DateTime), 7, NULL, NULL, NULL)
INSERT [dbo].[Ventas] ([Id], [Fecha], [UsuarioId], [ClienteId], [Zona], [Vendedor]) VALUES (9, CAST(N'2025-11-22T12:04:28.490' AS DateTime), 7, NULL, NULL, NULL)
INSERT [dbo].[Ventas] ([Id], [Fecha], [UsuarioId], [ClienteId], [Zona], [Vendedor]) VALUES (10, CAST(N'2025-12-12T00:16:44.860' AS DateTime), 7, NULL, NULL, NULL)
INSERT [dbo].[Ventas] ([Id], [Fecha], [UsuarioId], [ClienteId], [Zona], [Vendedor]) VALUES (11, CAST(N'2025-12-12T14:27:11.070' AS DateTime), 7, NULL, NULL, NULL)
INSERT [dbo].[Ventas] ([Id], [Fecha], [UsuarioId], [ClienteId], [Zona], [Vendedor]) VALUES (12, CAST(N'2025-12-12T14:31:16.233' AS DateTime), 7, NULL, NULL, NULL)
INSERT [dbo].[Ventas] ([Id], [Fecha], [UsuarioId], [ClienteId], [Zona], [Vendedor]) VALUES (13, CAST(N'2025-12-12T15:39:08.940' AS DateTime), 7, NULL, NULL, NULL)
INSERT [dbo].[Ventas] ([Id], [Fecha], [UsuarioId], [ClienteId], [Zona], [Vendedor]) VALUES (14, CAST(N'2025-12-13T16:46:33.030' AS DateTime), 7, NULL, NULL, NULL)
INSERT [dbo].[Ventas] ([Id], [Fecha], [UsuarioId], [ClienteId], [Zona], [Vendedor]) VALUES (15, CAST(N'2026-02-25T20:35:23.893' AS DateTime), 14, NULL, NULL, NULL)
INSERT [dbo].[Ventas] ([Id], [Fecha], [UsuarioId], [ClienteId], [Zona], [Vendedor]) VALUES (16, CAST(N'2026-02-25T20:57:29.810' AS DateTime), 7, NULL, NULL, NULL)
INSERT [dbo].[Ventas] ([Id], [Fecha], [UsuarioId], [ClienteId], [Zona], [Vendedor]) VALUES (23, CAST(N'2026-03-04T08:30:39.050' AS DateTime), 7, NULL, NULL, NULL)
INSERT [dbo].[Ventas] ([Id], [Fecha], [UsuarioId], [ClienteId], [Zona], [Vendedor]) VALUES (24, CAST(N'2026-03-04T08:53:38.517' AS DateTime), 7, NULL, NULL, NULL)
INSERT [dbo].[Ventas] ([Id], [Fecha], [UsuarioId], [ClienteId], [Zona], [Vendedor]) VALUES (25, CAST(N'2026-03-04T09:44:26.090' AS DateTime), 7, NULL, NULL, NULL)
INSERT [dbo].[Ventas] ([Id], [Fecha], [UsuarioId], [ClienteId], [Zona], [Vendedor]) VALUES (26, CAST(N'2026-03-07T22:10:44.460' AS DateTime), 7, NULL, NULL, NULL)
INSERT [dbo].[Ventas] ([Id], [Fecha], [UsuarioId], [ClienteId], [Zona], [Vendedor]) VALUES (27, CAST(N'2026-03-13T18:42:05.410' AS DateTime), 7, NULL, NULL, NULL)
INSERT [dbo].[Ventas] ([Id], [Fecha], [UsuarioId], [ClienteId], [Zona], [Vendedor]) VALUES (1027, CAST(N'2026-04-08T19:22:13.450' AS DateTime), 7, NULL, NULL, NULL)
INSERT [dbo].[Ventas] ([Id], [Fecha], [UsuarioId], [ClienteId], [Zona], [Vendedor]) VALUES (1028, CAST(N'2026-04-08T20:20:40.377' AS DateTime), 7, NULL, NULL, NULL)
INSERT [dbo].[Ventas] ([Id], [Fecha], [UsuarioId], [ClienteId], [Zona], [Vendedor]) VALUES (1029, CAST(N'2026-04-08T22:21:06.247' AS DateTime), 7, NULL, NULL, NULL)
INSERT [dbo].[Ventas] ([Id], [Fecha], [UsuarioId], [ClienteId], [Zona], [Vendedor]) VALUES (1030, CAST(N'2026-04-18T14:45:35.100' AS DateTime), 7, NULL, NULL, NULL)
INSERT [dbo].[Ventas] ([Id], [Fecha], [UsuarioId], [ClienteId], [Zona], [Vendedor]) VALUES (1031, CAST(N'2026-04-22T14:30:26.737' AS DateTime), 7, NULL, NULL, NULL)
INSERT [dbo].[Ventas] ([Id], [Fecha], [UsuarioId], [ClienteId], [Zona], [Vendedor]) VALUES (1032, CAST(N'2026-05-13T14:21:10.583' AS DateTime), 7, NULL, NULL, NULL)
INSERT [dbo].[Ventas] ([Id], [Fecha], [UsuarioId], [ClienteId], [Zona], [Vendedor]) VALUES (1033, CAST(N'2026-05-13T21:31:18.273' AS DateTime), 7, NULL, NULL, NULL)
INSERT [dbo].[Ventas] ([Id], [Fecha], [UsuarioId], [ClienteId], [Zona], [Vendedor]) VALUES (1037, CAST(N'2026-08-25T23:41:12.323' AS DateTime), 7, NULL, NULL, N'admin')
INSERT [dbo].[Ventas] ([Id], [Fecha], [UsuarioId], [ClienteId], [Zona], [Vendedor]) VALUES (1038, CAST(N'2026-08-25T23:41:25.657' AS DateTime), 7, 8, N'Oeste', N'admin')
INSERT [dbo].[Ventas] ([Id], [Fecha], [UsuarioId], [ClienteId], [Zona], [Vendedor]) VALUES (1039, CAST(N'2026-08-26T00:29:33.537' AS DateTime), 7, NULL, NULL, N'admin')
INSERT [dbo].[Ventas] ([Id], [Fecha], [UsuarioId], [ClienteId], [Zona], [Vendedor]) VALUES (2034, CAST(N'2026-09-14T14:32:51.850' AS DateTime), 7, NULL, NULL, N'admin')
INSERT [dbo].[Ventas] ([Id], [Fecha], [UsuarioId], [ClienteId], [Zona], [Vendedor]) VALUES (2035, CAST(N'2026-09-14T22:59:33.390' AS DateTime), 7, NULL, NULL, N'admin')
SET IDENTITY_INSERT [dbo].[Ventas] OFF
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
SET ANSI_PADDING ON
GO

ALTER TABLE [dbo].[Usuarios] ADD  CONSTRAINT [UQ__Usuarios__6B0F5AE0BEAA38E3] UNIQUE NONCLUSTERED
(
    [NombreUsuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Bitacora] ADD  DEFAULT (sysutcdatetime()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[Clientes] ADD  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[Clientes] ADD  DEFAULT ((0)) FOR [DVH]
GO
ALTER TABLE [dbo].[Clientes] ADD  DEFAULT ((0)) FOR [DVV]
GO
ALTER TABLE [dbo].[Lote] ADD  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[Permiso] ADD  CONSTRAINT [DF_Permiso_EsPadre]  DEFAULT ((0)) FOR [EsPadre]
GO
ALTER TABLE [dbo].[ProductoHistorial] ADD  DEFAULT (getdate()) FOR [Fecha]
GO
ALTER TABLE [dbo].[Productos] ADD  CONSTRAINT [DF_Productos_Activo]  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[Usuarios] ADD  CONSTRAINT [DF__Usuarios__Idioma__7D439ABD]  DEFAULT ('es') FOR [Idioma]
GO
ALTER TABLE [dbo].[Usuarios] ADD  CONSTRAINT [DF_Usuarios_Activo]  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[Ventas] ADD  DEFAULT (getdate()) FOR [Fecha]
GO
ALTER TABLE [dbo].[Bitacora]  WITH CHECK ADD  CONSTRAINT [FK_Bitacora_Usuario] FOREIGN KEY([UsuarioId])
REFERENCES [dbo].[Usuarios] ([Id])
GO
ALTER TABLE [dbo].[Bitacora] CHECK CONSTRAINT [FK_Bitacora_Usuario]
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
ALTER TABLE [dbo].[Lote]  WITH CHECK ADD FOREIGN KEY([ProductoId])
REFERENCES [dbo].[Productos] ([Id])
GO
ALTER TABLE [dbo].[Lote]  WITH CHECK ADD FOREIGN KEY([ProductoId])
REFERENCES [dbo].[Productos] ([Id])
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
ALTER TABLE [dbo].[ProductoHistorial]  WITH NOCHECK ADD  CONSTRAINT [FK_ProductoHistorial_Productos] FOREIGN KEY([IdProducto])
REFERENCES [dbo].[Productos] ([Id])
GO
ALTER TABLE [dbo].[ProductoHistorial] CHECK CONSTRAINT [FK_ProductoHistorial_Productos]
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

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.sp_RecalcularDVV
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

CREATE PROCEDURE [dbo].[sp_ActualizarProducto]
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
CREATE PROCEDURE [dbo].[sp_AgregarProducto]
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
CREATE PROCEDURE [dbo].[sp_BajaLogicaProducto]
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
CREATE PROCEDURE [dbo].[sp_Bitacora_Buscar]
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
CREATE PROCEDURE [dbo].[sp_Bitacora_Insertar]
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
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Categorias_Listar]
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

CREATE PROCEDURE [dbo].[sp_Clientes_Eliminar]
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

CREATE PROCEDURE [dbo].[sp_Clientes_Insertar]
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

CREATE PROCEDURE [dbo].[sp_Clientes_Listar]
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

CREATE PROCEDURE [dbo].[sp_Clientes_ListarZonas]
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

CREATE PROCEDURE [dbo].[sp_Clientes_Modificar]
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

CREATE PROCEDURE [dbo].[sp_Clientes_ObtenerPorId]
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
CREATE PROCEDURE [dbo].[sp_DetalleVentas_Upsert]
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

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_EliminarProducto]
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
CREATE PROCEDURE [dbo].[sp_Idiomas_Eliminar]
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
CREATE PROCEDURE [dbo].[sp_Idiomas_Insertar]
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
CREATE PROCEDURE [dbo].[sp_Idiomas_Listar]
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

CREATE PROCEDURE [dbo].[sp_Inventario_ObtenerStockPorProducto]
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
CREATE PROCEDURE [dbo].[sp_Lote_ActualizarStockProducto]
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
CREATE PROCEDURE [dbo].[sp_Lote_Agregar]
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
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Lote_CalcularStockTotal]
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
CREATE PROCEDURE [dbo].[sp_Lote_Eliminar]
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
CREATE PROCEDURE [dbo].[sp_Lote_ListarPorProducto]
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
CREATE PROCEDURE [dbo].[sp_ObtenerProductoPorId]
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
CREATE PROCEDURE [dbo].[sp_ObtenerProductosActivos]
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
CREATE PROCEDURE [dbo].[sp_Permiso_AgregarSimple]
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
CREATE PROCEDURE [dbo].[sp_Permiso_AgregarSubgrupo]
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
CREATE PROCEDURE [dbo].[sp_Permiso_CrearGrupo]
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
CREATE PROCEDURE [dbo].[sp_Permiso_ObtenerRelaciones]
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
CREATE PROCEDURE [dbo].[sp_Permiso_ObtenerTodos]
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

CREATE PROCEDURE [dbo].[sp_ProductoHistorial_Insertar]
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

CREATE PROCEDURE [dbo].[sp_ProductoHistorial_ListarPorProducto]
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
CREATE PROCEDURE [dbo].[sp_Productos_DescontarStock]
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
CREATE PROCEDURE [dbo].[sp_Productos_Listar_IdNombre]
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
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Reporte_Stock]
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
CREATE   PROCEDURE [dbo].[sp_Reporte_Stock_Analisis]
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

CREATE PROCEDURE [dbo].[sp_Reporte_Ventas]
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
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[sp_Reporte_Ventas_Analisis]
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
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Reporte_Zonas_Analisis]
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
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Tag_Listar]
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
CREATE PROCEDURE [dbo].[sp_Traduccion_Upsert]
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
CREATE PROCEDURE [dbo].[sp_Traducciones_PorCodigo]
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
CREATE PROCEDURE [dbo].[sp_Usuario_BajaLogica]
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
CREATE PROCEDURE [dbo].[sp_Usuario_GuardarIdioma]
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
CREATE PROCEDURE [dbo].[sp_Usuario_Insertar]
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
CREATE PROC [dbo].[sp_Usuario_ObtenerPorNombre]
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
CREATE PROC [dbo].[sp_Usuario_ObtenerTodos]
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

CREATE PROCEDURE [dbo].[sp_Ventas_Insertar]
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
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

UPDATE dbo.DigitoVerificador
SET DVV = DVV % 2147483647
WHERE Tabla IN (N'Usuarios', N'Productos', N'Clientes')
  AND DVV >= 2147483647;
GO
DECLARE @ClientesReparados int = 0;
UPDATE dbo.Clientes SET DVH = 6491190686089612601 WHERE Id = 1 AND DVH = 0 AND Activo = 1 AND CONVERT(varbinary(max),ISNULL([NombreCompleto],N'')) = CONVERT(varbinary(max),N'Juan Pérez') AND CONVERT(varbinary(max),ISNULL([Direccion],N'')) = CONVERT(varbinary(max),N'') AND CONVERT(varbinary(max),ISNULL([Telefono],N'')) = CONVERT(varbinary(max),N'') AND CONVERT(varbinary(max),ISNULL([Email],N'')) = CONVERT(varbinary(max),N'') AND CONVERT(varbinary(max),ISNULL([Zona],N'')) = CONVERT(varbinary(max),N'Centro');
SET @ClientesReparados += @@ROWCOUNT;
UPDATE dbo.Clientes SET DVH = 6950164950606709194 WHERE Id = 2 AND DVH = 0 AND Activo = 1 AND CONVERT(varbinary(max),ISNULL([NombreCompleto],N'')) = CONVERT(varbinary(max),N'María González') AND CONVERT(varbinary(max),ISNULL([Direccion],N'')) = CONVERT(varbinary(max),N'') AND CONVERT(varbinary(max),ISNULL([Telefono],N'')) = CONVERT(varbinary(max),N'') AND CONVERT(varbinary(max),ISNULL([Email],N'')) = CONVERT(varbinary(max),N'') AND CONVERT(varbinary(max),ISNULL([Zona],N'')) = CONVERT(varbinary(max),N'Norte');
SET @ClientesReparados += @@ROWCOUNT;
UPDATE dbo.Clientes SET DVH = 5804301795869395250 WHERE Id = 3 AND DVH = 0 AND Activo = 1 AND CONVERT(varbinary(max),ISNULL([NombreCompleto],N'')) = CONVERT(varbinary(max),N'Carlos López') AND CONVERT(varbinary(max),ISNULL([Direccion],N'')) = CONVERT(varbinary(max),N'') AND CONVERT(varbinary(max),ISNULL([Telefono],N'')) = CONVERT(varbinary(max),N'') AND CONVERT(varbinary(max),ISNULL([Email],N'')) = CONVERT(varbinary(max),N'') AND CONVERT(varbinary(max),ISNULL([Zona],N'')) = CONVERT(varbinary(max),N'Sur');
SET @ClientesReparados += @@ROWCOUNT;
UPDATE dbo.Clientes SET DVH = 3483121921036141040 WHERE Id = 4 AND DVH = 0 AND Activo = 1 AND CONVERT(varbinary(max),ISNULL([NombreCompleto],N'')) = CONVERT(varbinary(max),N'Ana Fernández') AND CONVERT(varbinary(max),ISNULL([Direccion],N'')) = CONVERT(varbinary(max),N'') AND CONVERT(varbinary(max),ISNULL([Telefono],N'')) = CONVERT(varbinary(max),N'') AND CONVERT(varbinary(max),ISNULL([Email],N'')) = CONVERT(varbinary(max),N'') AND CONVERT(varbinary(max),ISNULL([Zona],N'')) = CONVERT(varbinary(max),N'Este');
SET @ClientesReparados += @@ROWCOUNT;
UPDATE dbo.Clientes SET DVH = 993899767157773483 WHERE Id = 5 AND DVH = 0 AND Activo = 1 AND CONVERT(varbinary(max),ISNULL([NombreCompleto],N'')) = CONVERT(varbinary(max),N'Jorge Martínez') AND CONVERT(varbinary(max),ISNULL([Direccion],N'')) = CONVERT(varbinary(max),N'') AND CONVERT(varbinary(max),ISNULL([Telefono],N'')) = CONVERT(varbinary(max),N'') AND CONVERT(varbinary(max),ISNULL([Email],N'')) = CONVERT(varbinary(max),N'') AND CONVERT(varbinary(max),ISNULL([Zona],N'')) = CONVERT(varbinary(max),N'Oeste');
SET @ClientesReparados += @@ROWCOUNT;
UPDATE dbo.Clientes SET DVH = 5732668763541191245 WHERE Id = 7 AND DVH = 5849139928171462506 AND Activo = 1 AND CONVERT(varbinary(max),ISNULL([NombreCompleto],N'')) = CONVERT(varbinary(max),N'carlitos tevez') AND CONVERT(varbinary(max),ISNULL([Direccion],N'')) = CONVERT(varbinary(max),N'av falsa 123') AND CONVERT(varbinary(max),ISNULL([Telefono],N'')) = CONVERT(varbinary(max),N'11-1234-4342') AND CONVERT(varbinary(max),ISNULL([Email],N'')) = CONVERT(varbinary(max),N'magoya@gmail.com') AND CONVERT(varbinary(max),ISNULL([Zona],N'')) = CONVERT(varbinary(max),N'Norte');
SET @ClientesReparados += @@ROWCOUNT;
UPDATE dbo.Clientes SET DVH = 2920357738009587220 WHERE Id = 8 AND DVH = 5736759490488607613 AND Activo = 1 AND CONVERT(varbinary(max),ISNULL([NombreCompleto],N'')) = CONVERT(varbinary(max),N'Mailen Barrera') AND CONVERT(varbinary(max),ISNULL([Direccion],N'')) = CONVERT(varbinary(max),N'Calle falsa 1122') AND CONVERT(varbinary(max),ISNULL([Telefono],N'')) = CONVERT(varbinary(max),N'11-425-785965') AND CONVERT(varbinary(max),ISNULL([Email],N'')) = CONVERT(varbinary(max),N'barrera_22@gmail.com') AND CONVERT(varbinary(max),ISNULL([Zona],N'')) = CONVERT(varbinary(max),N'Oeste');
SET @ClientesReparados += @@ROWCOUNT;
IF @ClientesReparados > 0 EXEC dbo.sp_RecalcularDVV N'Clientes';
GO
