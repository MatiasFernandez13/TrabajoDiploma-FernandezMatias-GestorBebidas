BEGIN TRY

    IF COL_LENGTH('dbo.Grupo_PermisoDetalle','Id') IS NULL
        ALTER TABLE dbo.Grupo_PermisoDetalle ADD Id INT IDENTITY(1,1);


    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='PK_Grupo_PermisoDetalle' AND object_id=OBJECT_ID('dbo.Grupo_PermisoDetalle'))
        ALTER TABLE dbo.Grupo_PermisoDetalle ADD CONSTRAINT PK_Grupo_PermisoDetalle PRIMARY KEY (Id);


    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_GPD_Grupo' AND parent_object_id=OBJECT_ID('dbo.Grupo_PermisoDetalle'))
        ALTER TABLE dbo.Grupo_PermisoDetalle ADD CONSTRAINT FK_GPD_Grupo
            FOREIGN KEY (IdGrupo) REFERENCES dbo.GrupoPermiso(Id) ON DELETE CASCADE;

    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_GPD_Permiso' AND parent_object_id=OBJECT_ID('dbo.Grupo_PermisoDetalle'))
        ALTER TABLE dbo.Grupo_PermisoDetalle ADD CONSTRAINT FK_GPD_Permiso
            FOREIGN KEY (IdPermiso) REFERENCES dbo.Permiso(Id) ON DELETE CASCADE;

    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_GPD_GrupoHijo' AND parent_object_id=OBJECT_ID('dbo.Grupo_PermisoDetalle'))
        ALTER TABLE dbo.Grupo_PermisoDetalle ADD CONSTRAINT FK_GPD_GrupoHijo
            FOREIGN KEY (IdGrupoHijo) REFERENCES dbo.GrupoPermiso(Id) ON DELETE CASCADE;


    IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name='CK_GPD_TipoHijo' AND parent_object_id=OBJECT_ID('dbo.Grupo_PermisoDetalle'))
        ALTER TABLE dbo.Grupo_PermisoDetalle ADD CONSTRAINT CK_GPD_TipoHijo
            CHECK (
              (IdPermiso IS NOT NULL AND IdGrupoHijo IS NULL) OR
              (IdPermiso IS NULL AND IdGrupoHijo IS NOT NULL)
            );


    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='UX_GPD_Grupo_Permiso' AND object_id=OBJECT_ID('dbo.Grupo_PermisoDetalle'))
        CREATE UNIQUE INDEX UX_GPD_Grupo_Permiso ON dbo.Grupo_PermisoDetalle(IdGrupo, IdPermiso) WHERE IdPermiso IS NOT NULL;

    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='UX_GPD_Grupo_GrupoHijo' AND object_id=OBJECT_ID('dbo.Grupo_PermisoDetalle'))
        CREATE UNIQUE INDEX UX_GPD_Grupo_GrupoHijo ON dbo.Grupo_PermisoDetalle(IdGrupo, IdGrupoHijo) WHERE IdGrupoHijo IS NOT NULL;
END TRY
BEGIN CATCH
    DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
    RAISERROR(@ErrMsg,@ErrSeverity,1);
END CATCH;
