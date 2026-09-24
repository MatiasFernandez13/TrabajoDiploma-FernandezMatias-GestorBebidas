using BE;

namespace UI.Reportes;
public class SolicitudExportacionReporte
{
    public ReporteDocumento Documento { get; set; } = new ReporteDocumento();
    public string Destino { get; set; } = string.Empty;
    public string Formato { get; set; } = "pdf";
    public bool AbrirAlFinalizar { get; set; }
}

public class EstadoVistaReporte
{
    public bool Ocupado { get; set; }
    public string? Mensaje { get; set; }
}
