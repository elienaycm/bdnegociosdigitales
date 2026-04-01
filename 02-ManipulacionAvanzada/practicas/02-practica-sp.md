## Actividad de Evaluación 2. 
### Practica de stored procedure ventas varios productos

#### Elienay Ivana Cantera Martinez EVND

## Tablas TYPE

Se usan principalmente para:

- Pasar colecciones de datos entre procedimientos y funciones.
- Procesar grandes volúmenes de datos de forma eficiente (usando BULK COLLECT).
- Manipular listas de registros sin necesidad de insertar datos en tablas temporales globales.

## Tipos de Tablas
1. Tablas Indexadas (Asociativas): Usan una clave (como un número o texto) para acceder a los valores.

2. Tablas Anidadas (Nested Tables): Son más parecidas a una lista estándar y se pueden almacenar en columnas de la base de datos.

## Ejemplo
```sql
CREATE TYPE dbo.udt_ListaProductos AS TABLE (
    id_producto INT,
    cantidad INT
);
GO

CREATE OR ALTER PROCEDURE dbo.usp_agregar_venta_n_productos
    @id_cliente NVARCHAR(5),
    --TABLA TYPE
    @tabla_productos dbo.udt_ListaProductos READONLY 
AS  
BEGIN
```

## STORE PROCEDURE

1. Este bloque de código define un procedimiento almacenado diseñado para procesar transacciones de múltiples artículos de forma simultánea.
```sql
CREATE OR ALTER PROCEDURE dbo.usp_agregar_venta_n_productos
    @id_cliente NVARCHAR(5),
    @tabla_productos dbo.udt_ListaProductos READONLY 
AS
```
2. Inicia la ejecución lógica del proceso, desactivando el conteo de filas para mejorar el rendimiento.
```sql
BEGIN
    SET NOCOUNT ON;
    DECLARE @NuevoIdVenta INT;
```
3. Valida la existencia del comprador en el catálogo de clientes.
```sql
        IF NOT EXISTS (SELECT 1 FROM dbo.CatCliente AS CC WHERE CC.id_cliente = @id_cliente)
        BEGIN
            PRINT 'ERROR: El cliente no existe.';
            ROLLBACK TRANSACTION; RETURN;
        END
```
4. Este bloque de código realiza una validación de inventario cruzando la lista de productos solicitados con el catálogo de existencias.
```sql
IF EXISTS (
            SELECT 1 FROM @tabla_productos AS TP
            INNER JOIN dbo.CatProducto AS CP ON TP.id_producto = CP.id_producto
            WHERE TP.cantidad > CP.existencia
        )
        BEGIN
            PRINT 'ERROR: Stock insuficiente.';
            ROLLBACK TRANSACTION; RETURN;
        END
```
5. Registra la transacción en la tabla de ventas.
```sql
INSERT INTO dbo.tblVenta (id_cliente, fecha) VALUES (@id_cliente, GETDATE());
        SET @NuevoIdVenta = SCOPE_IDENTITY();
```
6. Este bloque de código registra el desglose de la venta vinculando cada producto solicitado con el ID generado, tomando los precios actuales del catálogo para completar los datos de cada artículo vendido.
```sql
INSERT INTO dbo.tblDetalleVenta (id_venta, id_producto, precio_venta, cantidad_vendida)
        SELECT @NuevoIdVenta, TP.id_producto, CP.precio, TP.cantidad
        FROM @tabla_productos AS TP
        INNER JOIN dbo.CatProducto AS CP ON TP.id_producto = CP.id_producto;
```
7. Descuenta las cantidades vendidas del stock actual en el catálogo de productos y finaliza la transacción de forma permanente, confirmando que la operación fue exitosa mediante el ID de venta generado.
```sql
UPDATE CP
        SET CP.existencia = CP.existencia - TP.cantidad
        FROM dbo.CatProducto AS CP
        INNER JOIN @tabla_productos AS TP ON CP.id_producto = TP.id_producto;

        COMMIT TRANSACTION;
        PRINT 'VENTA REALIZADA CON EXITO. ID: ' + CAST(@NuevoIdVenta AS VARCHAR);
```
8. Captura cualquier falla ocurrida durante la ejecución para revertir los cambios pendientes en la base de datos.
```sql
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        PRINT 'OCURRIO UN ERROR: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
```
9. Se reserva un espacio en SQL para almacenar temporalmente el listado de artículos que el cliente desea adquirir antes de procesar la venta.
```sql
DECLARE @Compra AS dbo.udt_ListaProductos;
```
10. Este bloque de código se encarga de poblar el carrito de compras con los identificadores de los artículos y las cantidades específicas que el usuario desea procesar en la transacción actual.
```sql
INSERT INTO @Compra (id_producto, cantidad) VALUES (1, 1), (2, 1), (3, 1);
```
![Base de Datos para Negocios Digitales](/img/tabla1.png "BD.")
![Base de Datos para Negocios Digitales](/img/tabla2.png "BD.")
