# Problemas de Logica de Negocio: Cotizacion - Venta - Facturacion

## Flujo general
```
Cotizacion (Pendiente) -> ConvertToSale -> Venta (Pendiente) -> AutorizarConAfip -> Venta (Facturada) -> RegistrarPago
                                               | alternativo
                                          Presupuesto -> Venta (Completada) + MovCaja
```

---

## Problemas detectados

### #1 - Cotizacion Create NO usa transaccion [RESUELTO]
**Severidad:** Media
**Archivo:** `CotizacionesController.cs:139-156`
**Descripcion:** Se hace `SaveChangesAsync()` para la cotizacion (L140), y luego otro `SaveChangesAsync()` para los detalles (L156). Si el segundo falla, queda una cotizacion sin detalles en la BD. VentasController usa transaccion, pero CotizacionesController no.

### #2 - ConvertToSale no asigna VenMetodoPago ni VenLista [RESUELTO]
**Severidad:** Media
**Archivo:** `CotizacionesController.cs:401-408`
**Descripcion:** Al crear la venta desde cotizacion, no se asigna `VenMetodoPago` ni `VenLista`. Comparado con VentasController.Create que si los asigna. La venta queda con metodo de pago y lista `null`.

### #3 - ConvertToSale no registra en cuenta corriente [RESUELTO]
**Severidad:** Media
**Archivo:** `CotizacionesController.cs:400-443`
**Descripcion:** Cuando VentasController.Create detecta que es cuenta corriente, registra en `CUENTAS_CORRIENTES`. ConvertToSale no tiene esta logica, por lo que si se usa CC no se registra el movimiento.

### #4 - Presupuesto registra en Caja pero Venta.Create no [NO SE CORRIGE]
**Severidad:** Baja (parece intencional)
**Archivo:** `VentasController.cs:1350-1371`
**Descripcion:** Cuando se genera un Presupuesto se registra MovimientoCaja, pero la creacion directa de venta con efectivo no. El dinero entra al pagar o generar presupuesto, parece ser el diseno intencionado.

### #5 - Presupuesto no verifica stock antes de completar [NO SE CORRIGE]
**Severidad:** Baja (parece intencional)
**Archivo:** `VentasController.cs:1350-1354`
**Descripcion:** Al generar presupuesto cambia estado a Completada sin verificar stock. Es correcto porque el stock ya se desconto al crear la venta.

### #6 - CctaDesc muestra "Venta #0" en vez del codigo real [RESUELTO]
**Severidad:** Media
**Archivo:** `VentasController.cs:358`
**Descripcion:** `CctaDesc = $"Venta #{venta.VenCod}"` usa VenCod antes del SaveChanges, por lo que siempre queda como "Venta #0" porque la BD aun no genero el ID.

### #7 - Delete de venta NO revierte cuenta corriente [RESUELTO]
**Severidad:** Alta - corrompe saldo del cliente
**Archivo:** `VentasController.cs:694-734`
**Descripcion:** Al eliminar una venta se restaura el stock, pero si la venta era cuenta corriente no se revierte el movimiento en CUENTAS_CORRIENTES. El saldo del cliente queda inflado.

### #8 - Edit de venta NO maneja cambio de metodo de pago (CC) [RESUELTO]
**Severidad:** Alta - corrompe saldo del cliente
**Archivo:** `VentasController.cs:574-628`
**Descripcion:** Si una venta se creo con "Cuenta Corriente" y se edita cambiando a "Efectivo", el registro en CUENTAS_CORRIENTES no se revierte. Tampoco se crea uno nuevo si se cambia a cuenta corriente.

### #9 - Delete de cotizacion no valida estado [RESUELTO]
**Severidad:** Baja
**Archivo:** `CotizacionesController.cs:491-505`
**Descripcion:** Se puede eliminar una cotizacion que ya fue "Convertida" a venta. No hay validacion de estado antes de eliminar.
