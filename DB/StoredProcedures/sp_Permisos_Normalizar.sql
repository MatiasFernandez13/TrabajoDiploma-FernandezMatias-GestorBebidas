IF OBJECT_ID('dbo.sp_Permisos_Normalizar', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_Permisos_Normalizar;
GO
CREATE PROCEDURE dbo.sp_Permisos_Normalizar
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY

        DECLARE @Simples TABLE (Nombre NVARCHAR(200) PRIMARY KEY);
        INSERT INTO @Simples(Nombre) VALUES
        (N'AccesoUsuarios'),(N'Usuarios.Alta'),(N'Usuarios.Modificar'),(N'Usuarios.Baja'),
        (N'AccesoProductos'),(N'Productos.Ver'),(N'Productos.Agregar'),(N'Productos.Modificar'),(N'Productos.Eliminar'),
        (N'AccesoVentas'),(N'Ventas.Realizar'),
        (N'AccesoReportes'),(N'Reportes.Ver'),(N'Reportes.Modificar'),(N'Reportes.Eliminar'),
        (N'AccesoIdiomas'),
        (N'AccesoPermisos'),(N'Permisos.Asignar'),(N'Permisos.Gestionar'),
        (N'AccesoAdministracion'),(N'AccesoBitacora'),(N'AccesoVerificarIntegridad'),(N'AccesoRecalcularIntegridad');

        DECLARE @Grupos TABLE (Nombre NVARCHAR(200) PRIMARY KEY);
        INSERT INTO @Grupos(Nombre) VALUES
        (N'Gestion Usuarios'),(N'Gestion Productos'),(N'Gestion Reportes'),
        (N'Gestion Idioma'),(N'Gestion Permisos'),(N'Gestion'),(N'Gestion Venta'),
        (N'Administracion'),(N'Base'),(N'Supervisor'),(N'Administrador');

        DELETE D
        FROM Grupo_PermisoDetalle D
        WHERE D.IdPermiso IN (SELECT Id FROM Permiso WHERE Nombre NOT IN (SELECT Nombre FROM @Simples))
           OR D.IdGrupo IN (SELECT Id FROM GrupoPermiso WHERE Nombre NOT IN (SELECT Nombre FROM @Grupos))
           OR D.IdGrupoHijo IN (SELECT Id FROM GrupoPermiso WHERE Nombre NOT IN (SELECT Nombre FROM @Grupos));

        DELETE FROM Permiso WHERE Nombre NOT IN (SELECT Nombre FROM @Simples);

        DELETE FROM GrupoPermiso WHERE Nombre NOT IN (SELECT Nombre FROM @Grupos);

        IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='UX_Permiso_Nombre' AND object_id=OBJECT_ID('Permiso'))
            CREATE UNIQUE INDEX UX_Permiso_Nombre ON Permiso(Nombre);
        IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='UX_GrupoPermiso_Nombre' AND object_id=OBJECT_ID('GrupoPermiso'))
            CREATE UNIQUE INDEX UX_GrupoPermiso_Nombre ON GrupoPermiso(Nombre);
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END
GO
