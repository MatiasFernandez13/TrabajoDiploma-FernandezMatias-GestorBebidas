param([string]$Servidor = 'localhost')
$ErrorActionPreference = 'Stop'
$raiz = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$identificador = [Guid]::NewGuid().ToString('N')
$nombreBase = 'GestorBebidasPruebasStock_' + $identificador
$destino = Join-Path $raiz ('artifacts\pruebas-stock\' + $identificador)
New-Item -ItemType Directory -Path $destino -Force | Out-Null
function CopiarFuentes([string]$Origen, [string]$Salida) {
    New-Item -ItemType Directory -Path $Salida -Force | Out-Null
    foreach ($elemento in Get-ChildItem -LiteralPath $Origen -Force) {
        if ($elemento.PSIsContainer) {
            if ($elemento.Name -notin @('bin','obj','artifacts','.vs','.vscode','.git')) { CopiarFuentes $elemento.FullName (Join-Path $Salida $elemento.Name) }
        } elseif ($elemento.Name -notlike '*.user') { Copy-Item -LiteralPath $elemento.FullName -Destination $Salida }
    }
}
foreach ($capa in @('BE','BLL','DAL','INTERFACES','SERVICIOS','UI')) { CopiarFuentes (Join-Path $raiz $capa) (Join-Path $destino $capa) }
Copy-Item (Join-Path $raiz 'Directory.Build.props') $destino
$acceso = Join-Path $destino 'DAL\ACCESO.cs'
(Get-Content $acceso -Raw).Replace('Data Source=localhost;Initial Catalog=BaseGestionBebidasMF;Integrated Security=True', ('Data Source=' + $Servidor + ';Initial Catalog=' + $nombreBase + ';Integrated Security=True')) | Set-Content $acceso -Encoding UTF8
$proyecto = Join-Path $destino 'Comprobacion'
New-Item -ItemType Directory -Path $proyecto -Force | Out-Null
Copy-Item (Join-Path $PSScriptRoot 'Program.cs') $proyecto
@'
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup><OutputType>Exe</OutputType><TargetFramework>net8.0-windows</TargetFramework><UseWindowsForms>true</UseWindowsForms><ImplicitUsings>disable</ImplicitUsings></PropertyGroup>
  <ItemGroup><ProjectReference Include="../UI/UI.csproj" /></ItemGroup>
</Project>
'@ | Set-Content (Join-Path $proyecto 'Comprobacion.csproj') -Encoding UTF8
$configuracion = [xml](Get-Content (Join-Path $raiz 'UI\App.config') -Raw)
$configuracion.configuration.connectionStrings.add.connectionString = 'Data Source=' + $Servidor + ';Initial Catalog=' + $nombreBase + ';Integrated Security=True'
$configuracion.Save((Join-Path $proyecto 'App.config'))
$sql = Get-Content (Join-Path $raiz 'DB\GeneraBase_BebidasMF_Corregida.sql') -Raw
$sql = [regex]::Replace($sql, '(?m)^(USE|CREATE DATABASE|ALTER DATABASE) \[BaseGestionBebidasMF\]', { param($m) $m.Groups[1].Value + ' [' + $nombreBase + ']' })
$sql = $sql.Replace("IF DB_ID(N'BaseGestionBebidasMF')", ("IF DB_ID(N'" + $nombreBase + "')"))
$rutaSQL = Join-Path $destino 'instalar.sql'
[IO.File]::WriteAllText($rutaSQL, $sql, [Text.UTF8Encoding]::new($true))
try {
    sqlcmd -S $Servidor -E -b -i $rutaSQL > (Join-Path $destino 'instalacion.log')
    if ($LASTEXITCODE -ne 0) { throw ('Fallo al crear la base temporal. Consulte ' + (Join-Path $destino 'instalacion.log')) }
    dotnet run --project (Join-Path $proyecto 'Comprobacion.csproj') -- $destino > (Join-Path $destino 'pruebas.log')
    if ($LASTEXITCODE -ne 0) { Get-Content (Join-Path $destino 'pruebas.log') -Tail 20; throw 'Fallaron las pruebas' }
    Get-Content (Join-Path $destino 'pruebas.log') -Tail 40
    Write-Output ('Evidencias: ' + $destino)
} finally {
    sqlcmd -S $Servidor -E -b -Q ("IF DB_ID(N'" + $nombreBase + "') IS NOT NULL DROP DATABASE [" + $nombreBase + "]")
    if ($LASTEXITCODE -ne 0) { Write-Warning ('No se pudo retirar la base temporal ' + $nombreBase) }
}
