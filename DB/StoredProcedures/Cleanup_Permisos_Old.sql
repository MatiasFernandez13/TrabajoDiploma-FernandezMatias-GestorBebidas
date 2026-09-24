BEGIN TRY


    IF OBJECT_ID('dbo.GrupoPermiso','U') IS NOT NULL
    BEGIN
        SELECT * INTO dbo.GrupoPermiso_Backup FROM dbo.GrupoPermiso;
    END
    IF OBJECT_ID('dbo.Grupo_PermisoDetalle','U') IS NOT NULL
    BEGIN
        SELECT * INTO dbo.Grupo_PermisoDetalle_Backup FROM dbo.Grupo_PermisoDetalle;
    END
    IF OBJECT_ID('dbo.Usuario_GrupoPermiso','U') IS NOT NULL
    BEGIN
        SELECT * INTO dbo.Usuario_GrupoPermiso_Backup FROM dbo.Usuario_GrupoPermiso;
    END


    IF OBJECT_ID('dbo.sp_Permisos_Normalizar','P') IS NOT NULL
        DROP PROCEDURE dbo.sp_Permisos_Normalizar;


    IF OBJECT_ID('dbo.Usuario_GrupoPermiso','U') IS NOT NULL
        DROP TABLE dbo.Usuario_GrupoPermiso;
    IF OBJECT_ID('dbo.Grupo_PermisoDetalle','U') IS NOT NULL
        DROP TABLE dbo.Grupo_PermisoDetalle;
    IF OBJECT_ID('dbo.GrupoPermiso','U') IS NOT NULL
        DROP TABLE dbo.GrupoPermiso;
END TRY
BEGIN CATCH
    DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
    RAISERROR(@ErrMsg,@ErrSeverity,1);
END CATCH;
