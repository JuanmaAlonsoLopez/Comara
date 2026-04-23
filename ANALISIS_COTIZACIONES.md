# Análisis del Módulo de Cotizaciones
**Fecha:** 2026-04-06
**Archivos revisados:** CotizacionesController.cs, Cotizacion.cs, DetalleCotizacion.cs, CotizacionEstado.cs, CotizacionViewModel.cs, VentaViewModel.cs, Views/Cotizaciones/*, Constants.cs, ApplicationDbContext.cs

---

## 🔴 ERRORES CRÍTICOS (Bugs que pueden causar comportamiento incorrecto)

### 1. `esEditable` en Index usa los IDs de estado incorrectos
**Archivo:** `Views/Cotizaciones/Index.cshtml`, línea 117

```csharp
var esEditable = item.CotEstadoId != 2 && item.CotEstadoId != 3; // No es Convertida ni Cancelada
```

**Problema:** El comentario dice "No es Convertida ni Cancelada" pero según `CotizacionEstadoConstantes`:
- Aprobada = **2**
- Rechazada = **3**
- Convertida = **4**
- Vencida = **5**

El código bloquea la edición de cotizaciones *Aprobadas* y *Rechazadas*, mientras que las *Convertidas* (id=4) sí muestran los botones de Editar y Eliminar. Es exactamente al revés de lo que se desea.

**Corrección:**
```csharp
var esEditable = item.CotEstadoId != CotizacionEstadoConstantes.Convertida;
```

---

### 2. `CotEstadoId` nunca se asigna al crear o editar cotizaciones
**Archivo:** `Controllers/CotizacionesController.cs`, acciones `Create` (POST) y `Edit` (POST)

```csharp
var cotizacion = new Cotizacion
{
    CotEstado = model.CotEstado,  // Solo se asigna el string
    // CotEstadoId no se asigna nunca
};
```

**Problema:** El sistema tiene dos campos para el estado: `CotEstado` (string legacy) y `CotEstadoId` (FK a la tabla de estados). Al crear/editar, solo se actualiza el string. Esto produce:
- El filtro por estado en el Index no encuentra las nuevas cotizaciones (filtra por `CotEstadoId`)
- Las badges de color no se muestran (dependen de `Estado.Color` que requiere el FK)
- La lógica de `ConvertToSale` usa `CotizacionEstadoConstantes.Convertida` (int) pero al comparar puede fallar

**Corrección:** Al crear/editar, mapear el string al ID correspondiente usando `CotizacionEstadoConstantes`.

---

### 3. `ConvertToSale` - el select de `VenEstado` usa strings pero el modelo espera `int?`
**Archivo:** `Views/Cotizaciones/ConvertToSale.cshtml`, línea 33

```html
<select asp-for="VenEstado" class="form-control">
    <option value="Completada">Completada</option>
    <option value="Pendiente">Pendiente</option>
</select>
```

**Problema:** `VentaViewModel.VenEstado` es `int?`, pero el select envía strings. El model binding de ASP.NET Core no puede convertir "Completada" a `int`, resultando en `VenEstado = null`. La venta se crea sin estado asignado.

**Corrección:**
```html
<option value="@VentaEstado.Completada">Completada</option>
<option value="@VentaEstado.Pendiente">Pendiente</option>
```

---

### 4. `ConvertToSale` - faltan campos obligatorios en el formulario
**Archivo:** `Views/Cotizaciones/ConvertToSale.cshtml`

La vista no incluye campos para `VenMetodoPago` ni `VenTipoCbte`. Sin embargo, el controlador usa `model.VenMetodoPago` para decidir si registrar en cuenta corriente. Si el usuario no puede ingresar el método de pago, la venta siempre se crea sin registro de cuentas corrientes, incluso si se debería acreditar.

---

### 5. `Details.cshtml` - condición de estado usa string en lugar de FK
**Archivo:** `Views/Cotizaciones/Details.cshtml`, líneas 138 y 153

```csharp
@if (Model.CotEstado != "Convertida" && Model.CotEstado != "Cancelada")
```

**Problema:** Si `CotEstado` string no fue actualizado correctamente (ver bug #2), una cotización convertida podría seguir mostrando los botones de Editar y Eliminar. Debería usarse `Model.CotEstadoId`.

---

### 6. `Edit` (POST) - sin transacción de base de datos
**Archivo:** `Controllers/CotizacionesController.cs`, acción `Edit` POST (~línea 221)

El `Edit` elimina todos los detalles existentes (`RemoveRange`) y luego agrega los nuevos, pero sin una transacción. Si falla la inserción de nuevos detalles, la cotización queda con cero ítems y datos inconsistentes en la base de datos. Comparar con `Create` que sí usa transacción.

---

### 7. `Delete` GET - el error de estado se redirige a `Details` que no muestra `TempData["Error"]`
**Archivo:** `Controllers/CotizacionesController.cs`, línea 529

```csharp
// En Delete GET:
TempData["Error"] = "No se puede eliminar una cotización convertida...";
return RedirectToAction(nameof(Details), new { id = cotizacion.CotCod });
```

La vista `Details.cshtml` no tiene bloque de alerta para `TempData["Error"]`, por lo que el mensaje se pierde silenciosamente. En contraste, el `DeleteConfirmed` (POST) redirige al Index donde sí se muestra. Hay inconsistencia y el error del GET nunca llega al usuario.

---

## 🟠 ERRORES DE LÓGICA / DATOS

### 8. `GetArticuloPrecio` devuelve `float` en lugar de `decimal`
**Archivo:** `Controllers/CotizacionesController.cs`, línea 757

```csharp
return Json(new {
    precio = (float)precioBase,  // ← conversión explícita a float
    costoNeto = (float)(articulo.ArtCost ?? 0),
    ...
});
```

Uno de los issues resueltos (FASE 1, punto 1) fue precisamente cambiar todos los campos monetarios de `float` a `decimal`. Esta respuesta JSON re-introduce la pérdida de precisión al forzar la conversión a `float` antes de enviarla al cliente. Los precios pueden llegar con redondeos incorrectos.

---

### 9. `Create` - `SelectList` en GET usa `"Id"` pero en el POST de error usa `"CliCod"`
**Archivo:** `Controllers/CotizacionesController.cs`, líneas 105 y 174

```csharp
// En GET Create:
ViewData["CliCod"] = new SelectList(..., "Id", "CliNombre");

// En POST Create (al volver con error):
ViewData["CliCod"] = new SelectList(..., "CliCod", "CliNombre", model.CliCod);
```

Si la propiedad de PK del modelo `Cliente` se llama `CliCod` (no `Id`), el GET Create puede no generar opciones o puede preseleccionar el valor incorrecto. Hay que unificar cuál es el campo de valor.

---

### 10. `CotizacionViewModel.CotEstado` - la lista de opciones en Create/Edit no incluye "Vencida"
**Archivo:** `Views/Cotizaciones/Create.cshtml` y `Edit.cshtml`

El select de estado está hardcodeado con "Pendiente/Aprobada/Rechazada" pero no incluye "Vencida" (estado 5 en constantes). Además, ningún proceso del sistema marca automáticamente cotizaciones como Vencidas según la fecha (recordar que el PDF dice validez de 15 días). Este estado existe en la tabla pero no se usa.

---

## 🟡 PROBLEMAS DE RENDIMIENTO / OPTIMIZACIÓN

### 11. `Index` carga `DetalleCotizaciones` innecesariamente
**Archivo:** `Controllers/CotizacionesController.cs`, línea 33

```csharp
.Include(c => c.DetalleCotizaciones)  // ← nunca se usa en la vista Index
```

La vista `Index` solo muestra Codigo, Fecha, Cliente, Total y Estado. Nunca accede a `DetalleCotizaciones`. Este Include ejecuta un JOIN adicional en cada consulta paginada, cargando todos los ítems de todas las cotizaciones en memoria sin necesidad.

---

### 12. `BuscarArticulos` - condiciones de búsqueda redundantes
**Archivo:** `Controllers/CotizacionesController.cs`, líneas 778-782

```csharp
.Where(a => (a.ArtCod != null && EF.Functions.ILike(a.ArtCod, $"{term}%")) ||   // ← redundante
            (a.ArtDesc != null && EF.Functions.ILike(a.ArtDesc, $"{term}%")) ||  // ← redundante
            (a.ArtCod != null && EF.Functions.ILike(a.ArtCod, $"%{term}%")) ||
            (a.ArtDesc != null && EF.Functions.ILike(a.ArtDesc, $"%{term}%")) ||
            ...);
```

`%{term}%` ya engloba todos los casos que cubriría `{term}%`. Las dos primeras condiciones son redundantes y hacen el query SQL más complejo sin beneficio funcional.

---

### 13. Los dropdowns de clientes cargan la tabla entera sin proyección
**Archivo:** `Controllers/CotizacionesController.cs`, múltiples acciones

```csharp
await _context.Clientes.ToListAsync()
```

A diferencia de lo que se resolvió en `VentasController` (FASE 6, punto 26), aquí se carga el objeto `Cliente` completo con todos sus campos. Debería usarse `.Select(c => new { c.CliCod, c.CliNombre })` solo para el dropdown.

---

## 🔵 PROBLEMAS DE INTEROPERABILIDAD CON OTROS MÓDULOS

### 14. No hay trazabilidad Cotización → Venta
Al convertir una cotización a venta, el sistema actualiza el estado de la cotización pero no guarda en la `Venta` resultante ningún campo indicando su cotización origen. Si alguien mira una venta, no puede saber de qué cotización provino. Se necesitaría un campo `VenCotizacionOrigen` en la tabla `VENTAS`.

### 15. La `ListaCod` no se persiste en la cotización
`CotizacionViewModel` tiene `ListaCod` pero el modelo `Cotizacion` no tiene un campo equivalente en la BD. Cuando se edita una cotización, no se recuerda con qué lista de precios fue generada. Esto complica la conversión a venta (¿a qué lista de precios se cotizó?).

### 16. No hay reserva de stock al cotizar
Al crear cotizaciones no se reserva stock. En escenarios de alta demanda, múltiples cotizaciones pueden cubrir el mismo stock. Cuando se convierten a ventas, la primera pasa y las demás fallan con "stock insuficiente", sin aviso previo al comercial. Si bien esto puede ser intencional, sería útil al menos mostrar una advertencia en la vista cuando la cantidad cotizada supera el stock actual.

### 17. No hay proceso automático de vencimiento de cotizaciones
El PDF generado dice "validez de 15 días" pero el sistema nunca cambia automáticamente el estado a "Vencida". Una cotización de hace un año sigue apareciendo como "Pendiente" y puede convertirse a venta con precios desactualizados. Se podría agregar un filtrado o advertencia basada en fecha.

### 18. `Edit` permite modificar cotizaciones en cualquier estado
No hay validación que impida editar una cotización "Aprobada" o "Vencida". Una vez aprobada por el cliente, debería ser inmutable (o requerir autorización especial para modificarla). Actualmente se pueden cambiar cantidades y precios post-aprobación.

---

## 📝 CÓDIGO DUPLICADO / DEUDA TÉCNICA

### 19. Lógica de búsqueda y precios duplicada entre Create y Edit
Los métodos JavaScript `buscarArticulos()`, `renderSearchResults()`, `seleccionarArticulo()`, `cargarPrecioArticulo()` y los estilos CSS están copiados íntegramente en `Create.cshtml` y `Edit.cshtml`. Deberían extraerse a un partial view o archivo JS compartido.

### 20. `BuscarArticulos` y `GetArticuloPrecio` no tienen caching
Estos dos endpoints de API son llamados frecuentemente durante la carga de una cotización. `GetArticuloPrecio` en particular puede llamarse múltiples veces para el mismo artículo y lista. Aplicar el patrón de `CachedDropdownService` reduciría la carga en BD.

---

## RESUMEN PRIORIZADO

| # | Severidad | Descripción |
|---|-----------|-------------|
| 1 | 🔴 CRÍTICO | `esEditable` bloquea Aprobadas/Rechazadas pero permite Convertidas |
| 2 | 🔴 CRÍTICO | `CotEstadoId` nunca se asigna → filtros y badges rotos |
| 3 | 🔴 CRÍTICO | `VenEstado` en ConvertToSale usa strings pero el modelo espera int |
| 4 | 🔴 CRÍTICO | Faltan campos MetodoPago/TipoCbte en formulario ConvertToSale |
| 5 | 🟠 ALTA | `Details` compara estado por string → puede mostrar botones incorrectos |
| 6 | 🟠 ALTA | `Edit` POST sin transacción → riesgo de cotización sin ítems |
| 7 | 🟠 ALTA | Error de Delete GET se pierde (redirige a Details sin bloque de alerta) |
| 8 | 🟠 ALTA | `GetArticuloPrecio` devuelve float → re-introduce pérdida de precisión |
| 9 | 🟡 MEDIA | SelectList usa "Id" en GET pero "CliCod" en POST con error |
| 10 | 🟡 MEDIA | Estado "Vencida" no usable ni procesado automáticamente |
| 11 | 🟡 MEDIA | `Include(DetalleCotizaciones)` en Index carga datos no usados |
| 12 | 🟡 MEDIA | Condiciones ILike redundantes en BuscarArticulos |
| 13 | 🟡 MEDIA | Dropdowns de clientes sin proyección (carga objetos completos) |
| 14 | 🔵 INTEROP | Sin trazabilidad Cotización → Venta |
| 15 | 🔵 INTEROP | ListaCod no persiste en la cotización guardada |
| 16 | 🔵 INTEROP | Sin reserva de stock ni advertencia de stock insuficiente al cotizar |
| 17 | 🔵 INTEROP | Sin proceso de vencimiento automático (14 días según PDF) |
| 18 | 🔵 INTEROP | Cotizaciones aprobadas son editables sin restricción |
| 19 | ⬜ DEUDA | CSS y JS de búsqueda duplicados entre Create.cshtml y Edit.cshtml |
| 20 | ⬜ DEUDA | BuscarArticulos/GetArticuloPrecio sin caching |
