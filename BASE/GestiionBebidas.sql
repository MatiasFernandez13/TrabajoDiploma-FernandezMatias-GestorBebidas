-- Crear la base de datos
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'BaseGestionBebidasMF')
    DROP DATABASE BaseGestionBebidasMF;
GO

CREATE DATABASE BaseGestionBebidasMF;
GO

USE BaseGestionBebidasMF;
GO

-- Tabla de roles de usuario
CREATE TABLE Roles (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(50) NOT NULL
);

-- Tabla de usuarios
CREATE TABLE Usuarios (
    Id INT PRIMARY KEY IDENTITY(1,1),
    NombreUsuario NVARCHAR(50) NOT NULL UNIQUE,
    Contraseña NVARCHAR(512) NOT NULL,
    Salt NVARCHAR(100) NOT NULL,
    RolId INT NOT NULL,
    FOREIGN KEY (RolId) REFERENCES Roles(Id)
);

-- Tabla de categorías de productos (Ej: Alcohólicas, No Alcohólicas)
CREATE TABLE Categorias (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100) NOT NULL
);

-- Tabla de productos
CREATE TABLE Productos (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100) NOT NULL,
    CategoriaId INT NOT NULL,
    Precio DECIMAL(10, 2) NOT NULL,
    CapacidadLitros FLOAT NOT NULL,
    Stock INT NOT NULL,
    FOREIGN KEY (CategoriaId) REFERENCES Categorias(Id)
);

-- Tabla de clientes (opcional)
CREATE TABLE Clientes (
    Id INT PRIMARY KEY IDENTITY(1,1),
    NombreCompleto NVARCHAR(100),
    Zona NVARCHAR(50)
);

-- Tabla de ventas
CREATE TABLE Ventas (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Fecha DATETIME NOT NULL DEFAULT GETDATE(),
    UsuarioId INT NOT NULL,
    ClienteId INT NULL,
    FOREIGN KEY (UsuarioId) REFERENCES Usuarios(Id),
    FOREIGN KEY (ClienteId) REFERENCES Clientes(Id)
);

-- Tabla de detalle de ventas
CREATE TABLE DetalleVentas (
    Id INT PRIMARY KEY IDENTITY(1,1),
    VentaId INT NOT NULL,
    ProductoId INT NOT NULL,
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (VentaId) REFERENCES Ventas(Id),
    FOREIGN KEY (ProductoId) REFERENCES Productos(Id)
);
