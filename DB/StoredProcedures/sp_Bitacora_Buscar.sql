SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Bitacora_Buscar]
    @Desde DATETIME = NULL,
    @Hasta DATETIME = NULL,
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
