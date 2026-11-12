# Productos, lotes y ventas — 11/11/2026

## Actualizar una instalación existente

Ejecutar `Actualizar_Productos_Lotes_Ventas.sql` completo con **Modo SQLCMD** en SQL Server Management Studio. Apunta a `BaseGestionBebidasMF`. La actualización se aplica en una transacción y puede repetirse. Si detecta números de lote equivalentes ya duplicados para un producto o datos incompatibles con las restricciones, se detiene sin consolidarlos ni borrar registros automáticamente.

El instalador `GeneraBase_BebidasMF_Corregida.sql` y la alternativa vacía `Instalar.sql` ya incluyen esta actualización. No se deben ejecutar sobre una base existente. Si se restaura el respaldo histórico de septiembre, ejecutar primero `RepararBase_BebidasMF.sql` y después esta actualización.

## Comportamiento

- Productos usa dos filas de campos alineados; los valores numéricos están alineados a la derecha.
- La identidad de un producto se compone del nombre normalizado y la presentación en litros. Se ignoran mayúsculas, tildes, espacios, guiones y guiones bajos. La categoría no permite eludir esta validación. Las presentaciones distintas están permitidas.
- La validación existe en la BLL y en un trigger de SQL Server. Los productos duplicados históricos se conservan: no se fusionan ni se cambian ventas anteriores. En la copia revisada existen pares previos como Agua Mineral de 1 L y prueba de 1,5 L. Por esa razón, la restricción de productos bloquea nuevas identidades duplicadas sin impedir actualizar el stock de esos registros antiguos.
- Una restricción única sobre producto y número de lote normalizado impide crear dos filas equivalentes. El mismo número puede pertenecer a productos diferentes.
- Al ingresar más unidades de un lote existente se suman a su cantidad, siempre que esté activo y coincida el vencimiento. Se conserva la primera fecha de ingreso. Al escribir un número existente se completa su vencimiento registrado; si se cambia por una fecha incompatible, se rechaza el ingreso.
- No se aceptan cantidades de ingreso menores o iguales a cero, ingresos futuros ni lotes ya vencidos. La baja de lotes es lógica para conservar la trazabilidad; un número dado de baja no se reutiliza.
- Ventas ofrece lotes individuales suficientes y una combinación que prioriza el lote preseleccionado y luego el orden de ingreso. Solo ofrece lotes activos y vigentes, restando las cantidades ya reservadas en el carrito. Las reservas no bloquean inventario para otros usuarios hasta confirmar la venta.
- El carrito conserva líneas separadas por lote. Quitar una línea elimina únicamente esa asignación. Confirmar vuelve a validar y descontar cada lote de forma atómica; si cambió el stock o venció un lote, toda la venta se revierte y se solicita una nueva selección. No se sustituye silenciosamente el lote elegido.
- `DetalleVentaLote` registra las cantidades descontadas por lote en las ventas nuevas. Las ventas históricas se conservan y no se les inventa una asignación de lotes.
- El stock físico del producto suma sus lotes activos. El stock vendible excluye además los lotes vencidos y de ingreso futuro; por eso ambas cantidades pueden diferir.
- Altas, consolidaciones, bajas y ajustes de lotes sincronizan stock e integridad del producto dentro de la misma transacción.

## Pruebas

`Tests/Stock/Ejecutar.ps1` crea una base temporal de nombre único a partir del instalador completo, compila una copia aislada de las mismas fuentes con esa conexión y ejecuta la prueba. Retira su base temporal al terminar. Requiere Windows, .NET 8, SQL Server y sqlcmd, con permisos para crear bases.

```powershell
.\Tests\Stock\Ejecutar.ps1 -Servidor localhost
```

Las pruebas cubren nombres equivalentes, presentaciones distintas, altas y modificaciones duplicadas, consolidación y vencimientos, reservas del carrito, combinaciones, stock insuficiente, lotes de otro producto, cantidades inválidas, ventas simultáneas, rollback después de descontar un primer lote, restricciones SQL, bajas, actualización de integridad y distribución del formulario. Las evidencias y la imagen del formulario quedan en `artifacts/pruebas-stock` y no se publican como código fuente.
