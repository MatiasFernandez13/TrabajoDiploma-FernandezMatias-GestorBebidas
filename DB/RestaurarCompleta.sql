:ON ERROR EXIT
:setvar RutaRespaldo "C:\Entrega\BaseGestionBebidasMF.bak"

USE [master];
GO

IF DB_ID(N'BaseGestionBebidasMF') IS NOT NULL
    THROW 50000, N'La base BaseGestionBebidasMF ya existe. La restauracion no sobrescribe bases existentes.', 1;

DECLARE @Respaldo nvarchar(4000) = N'$(RutaRespaldo)';
DECLARE @DirectorioDatos nvarchar(4000) = CONVERT(nvarchar(4000), SERVERPROPERTY('InstanceDefaultDataPath'));
DECLARE @DirectorioLog nvarchar(4000) = CONVERT(nvarchar(4000), SERVERPROPERTY('InstanceDefaultLogPath'));

IF @DirectorioDatos IS NULL OR @DirectorioLog IS NULL
    THROW 50001, N'No se pudieron determinar las carpetas de SQL Server. Use el asistente de restauracion de Management Studio.', 1;

IF RIGHT(@DirectorioDatos, 1) <> N'\'
    SET @DirectorioDatos += N'\';
IF RIGHT(@DirectorioLog, 1) <> N'\'
    SET @DirectorioLog += N'\';

DECLARE @ArchivoDatos nvarchar(4000) = @DirectorioDatos + N'BaseGestionBebidasMF.mdf';
DECLARE @ArchivoLog nvarchar(4000) = @DirectorioLog + N'BaseGestionBebidasMF_log.ldf';

RESTORE VERIFYONLY FROM DISK = @Respaldo WITH CHECKSUM;

RESTORE DATABASE [BaseGestionBebidasMF]
FROM DISK = @Respaldo
WITH MOVE N'BaseGestionBebidasMF' TO @ArchivoDatos,
     MOVE N'BaseGestionBebidasMF_log' TO @ArchivoLog,
     CHECKSUM;
GO
