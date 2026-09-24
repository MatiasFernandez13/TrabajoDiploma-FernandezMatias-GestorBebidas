BEGIN TRY

    IF COL_LENGTH('dbo.Permiso','EsPadre') IS NULL
        ALTER TABLE dbo.Permiso ADD EsPadre BIT NOT NULL CONSTRAINT DF_Permiso_EsPadre DEFAULT(0);


    IF OBJECT_ID('dbo.PermisoPermiso','U') IS NULL
    BEGIN
        CREATE TABLE dbo.PermisoPermiso(
            IdPermisoPadre INT NOT NULL,
            IdPermisoHijo INT NOT NULL,
            CONSTRAINT PK_PermisoPermiso PRIMARY KEY(IdPermisoPadre, IdPermisoHijo),
            CONSTRAINT FK_PermisoPermiso_Padre FOREIGN KEY (IdPermisoPadre) REFERENCES dbo.Permiso(Id),
            CONSTRAINT FK_PermisoPermiso_Hijo FOREIGN KEY (IdPermisoHijo) REFERENCES dbo.Permiso(Id)
        );
    END


    INSERT INTO dbo.Permiso (Nombre, EsPadre)
    SELECT gp.Nombre, 1
    FROM dbo.GrupoPermiso gp
    WHERE NOT EXISTS (SELECT 1 FROM dbo.Permiso p WHERE p.Nombre = gp.Nombre);


    ;WITH MapGrupos AS (
        SELECT gp.Id AS IdGrupo, p.Id AS IdPermisoGrupo
        FROM dbo.GrupoPermiso gp
        JOIN dbo.Permiso p ON p.Nombre = gp.Nombre AND p.EsPadre = 1
    ),
    MapSimples AS (
        SELECT ps.Id AS IdPermiso, p.Id AS IdPermisoNodo
        FROM dbo.Permiso ps
        JOIN dbo.Permiso p ON p.Nombre = ps.Nombre AND p.EsPadre = 0
    )
    INSERT INTO dbo.PermisoPermiso (IdPermisoPadre, IdPermisoHijo)
    SELECT mg.IdPermisoGrupo, ms.IdPermisoNodo
    FROM dbo.Grupo_PermisoDetalle d
    JOIN MapGrupos mg ON mg.IdGrupo = d.IdGrupo
    JOIN dbo.Permiso ps ON ps.Id = d.IdPermiso
    JOIN dbo.Permiso p ON p.Nombre = ps.Nombre AND p.EsPadre = 0
    JOIN MapSimples ms ON ms.IdPermiso = ps.Id
    WHERE d.IdPermiso IS NOT NULL
      AND NOT EXISTS (SELECT 1 FROM dbo.PermisoPermiso x WHERE x.IdPermisoPadre = mg.IdPermisoGrupo AND x.IdPermisoHijo = ms.IdPermisoNodo);

    INSERT INTO dbo.PermisoPermiso (IdPermisoPadre, IdPermisoHijo)
    SELECT mg.IdPermisoGrupo, mg2.IdPermisoGrupo
    FROM dbo.Grupo_PermisoDetalle d
    JOIN MapGrupos mg ON mg.IdGrupo = d.IdGrupo
    JOIN MapGrupos mg2 ON mg2.IdGrupo = d.IdGrupoHijo
    WHERE d.IdGrupoHijo IS NOT NULL
      AND d.IdGrupoHijo <> d.IdGrupo
      AND NOT EXISTS (SELECT 1 FROM dbo.PermisoPermiso x WHERE x.IdPermisoPadre = mg.IdPermisoGrupo AND x.IdPermisoHijo = mg2.IdPermisoGrupo);


    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='UX_Permiso_Nombre' AND object_id=OBJECT_ID('dbo.Permiso'))
    BEGIN
        ;WITH d AS (
            SELECT Id, Nombre, ROW_NUMBER() OVER (PARTITION BY Nombre ORDER BY Id) rn
            FROM dbo.Permiso
        )
        DELETE FROM d WHERE rn > 1;
        CREATE UNIQUE INDEX UX_Permiso_Nombre ON dbo.Permiso(Nombre);
    END
END TRY
BEGIN CATCH
    DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
    RAISERROR(@ErrMsg,@ErrSeverity,1);
END CATCH;
