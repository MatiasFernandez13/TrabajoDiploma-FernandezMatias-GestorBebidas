BEGIN TRY
    IF OBJECT_ID('dbo.Usuario_Permiso','U') IS NULL
    BEGIN
        CREATE TABLE dbo.Usuario_Permiso(
            IdUsuario INT NOT NULL,
            IdPermiso INT NOT NULL,
            CONSTRAINT PK_Usuario_Permiso PRIMARY KEY(IdUsuario, IdPermiso),
            CONSTRAINT FK_Usuario_Permiso_Usuario FOREIGN KEY (IdUsuario) REFERENCES dbo.Usuarios(Id),
            CONSTRAINT FK_Usuario_Permiso_Permiso FOREIGN KEY (IdPermiso) REFERENCES dbo.Permiso(Id)
        );
    END
END TRY
BEGIN CATCH
    DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), @ErrSeverity INT=ERROR_SEVERITY();
    RAISERROR(@ErrMsg,@ErrSeverity,1);
END CATCH;
