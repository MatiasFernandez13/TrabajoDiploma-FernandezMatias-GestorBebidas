# Reportes de ventas e inventario

La pantalla conserva una instantánea de la última consulta: cambiar filtros no cambia sus indicadores ni el contenido exportado hasta presionar **Generar reporte**.

## Instalación

Para una instalación nueva, ejecutar `Instalar.sql` siguiendo el README de la raíz. Para actualizar únicamente reportes en una base existente, ejecutar `StoredProcedures/Reportes_Analisis.sql` en `BaseGestionBebidasMF`. Crea o actualiza tres procedimientos específicos de reportes; no modifica datos comerciales ni los procedimientos anteriores. La instalación ya se aplicó en la base local durante el desarrollo.

Restaurar y compilar `UI/UI.csproj`. Las exportaciones usan ClosedXML 0.105.0 y PDFsharp-MigraDoc-GDI 6.2.4; no requieren Excel ni impresora PDF instalada. Para imprimir, la opción del menú permite guardar y abrir un PDF en el visor predeterminado.

## Criterios

- Ventas distintas: cantidad de identificadores de venta diferentes en los resultados.
- Ticket del filtro: suma de subtotales dividida por ventas distintas. Al filtrar un producto se incluye únicamente el importe de ese producto, no el resto de la operación.
- Comparación: período inmediatamente anterior de igual cantidad de días, con los mismos filtros. Si el importe anterior es cero, no se calcula un porcentaje.
- Fechas: ambos extremos incluyen el día completo. El gráfico incluye días/meses sin ventas entre la primera y la última venta mostrada.
- Stock: productos activos; unidades según `Productos.Stock`. No descuenta automáticamente los lotes vencidos: éstos se muestran como alerta.
- Umbral bajo: parámetro de la consulta, inicialmente 10 unidades. Stock bajo es mayor que cero y menor o igual al umbral. No es un mínimo persistente por producto ni modifica inventario.
- Lotes vigentes: activos, con cantidad positiva y fecha de vencimiento igual o posterior al día actual de la base.
- Por vencer: lotes vigentes que vencen desde hoy hasta dentro de 30 días, inclusive. Vencidos: activos con cantidad positiva y fecha anterior a hoy.
- Valorización: stock por precio de venta actual. No representa costo ni ganancia.
- Excel incluye hojas Detalle y Resumen, con números y fechas tipados. CSV incluye columnas de contexto por fila para conservar filtros y autor sin romper su estructura tabular. PDF y HTML incluyen encabezado, resumen y detalle.
- La vista agrupada es auxiliar; el menú exporta el detalle completo de la consulta y su resumen.

## Organización del código

Las consultas de ventas reciben `FiltroReporteVentas` entre UI, BLL y DAL. La BLL calcula el período anterior y devuelve `ResultadoReporteVentas`, sin modificar el filtro original. El stock se filtra mediante `FiltroReporteStock`. Los cálculos y agrupaciones están en `ReporteCalculosBLL`; las entidades de consulta y resultado están en BE. El exportador recibe `SolicitudExportacionReporte` y los gráficos reciben `DatosGraficoReporte`. El módulo usa tipos explícitos, sin `var`. Las firmas de eventos de Windows Forms y las llamadas a bibliotecas conservan los parámetros que requieren sus APIs.
