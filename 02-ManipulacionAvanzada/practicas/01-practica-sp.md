# Store procedure de Inserción venta con un producto

#### Elienay Ivana Cantera Martinez EVND
#### Actividad de Evaluación 2

### 1. Creación de bdpracticas
```sql
CREATE DATABASE bdpracticas;
GO

USE bdpracticas;
GO
```
- Creación de tablas en base a los datos de NORTWIND:

1.1 CatCliente:

Almacena los datos de identificación de los compradores.
```sql
CREATE TABLE CatCliente(
    id_cliente NVARCHAR(5) PRIMARY KEY,
    nombre_cliente VARCHAR(50),
    Pais VARCHAR(20),
    Ciudad VARCHAR(20)
);
```
1.2 CatProducto:

Se registra la información de cada artículo disponible para la venta
```sql
CREATE TABLE CatProducto(
    --EL 1,1 es para marcar de 1 a uno
    id_producto INT PRIMARY KEY IDENTITY (1,1),
    nombre_Producto VARCHAR(50),
    existencia INT,
    precio DECIMAL(10,2)
);
```
1.3 tblVenta:

Registra los datos generales de cada transacción.
```sql
CREATE TABLE tblVenta(
    id_venta INT PRIMARY KEY IDENTITY(1,1),
    --Pone automaticamnete la hora y dia
    fecha DATETIME DEFAULT GETDATE(),
    id_cliente NVARCHAR(5),
    --Primero existe un cliente para despues exista una venta
    CONSTRAINT FK_Venta_Cliente FOREIGN KEY (id_cliente) REFERENCES CatCliente(id_cliente)
);
```
1.4 tblDetalleVenta:

Esta tabla almacena el desglose individual de cada artículo incluido en una venta, permitiendo que un mismo folio de ticket contenga múltiples productos.
```sql
CREATE TABLE tblDetalleVenta(
    id_venta INT,
    id_producto INT,
    precio_venta DECIMAL(10,2),
    cantidad_vendida INT,
    PRIMARY KEY (id_venta, id_producto),
    CONSTRAINT FK_Detalle_Venta FOREIGN KEY (id_venta) REFERENCES tblVenta(id_venta),
    CONSTRAINT FK_Detalle_Producto FOREIGN KEY (id_producto) REFERENCES CatProducto(id_producto)
);
```
Diagrama
![Base de Datos para Negocios Digitales](/img/mapa.png "BD.")

### 2. Migración de Datos

Este bloque de código se encarga de poblar los catálogos extrayendo información real de la base de datos NORTHWIND.
```sql
--Clientes
INSERT INTO CatCliente (id_cliente, nombre_cliente, Pais, Ciudad)
SELECT CustomerID, ContactName, Country, City FROM NORTHWND.dbo.Customers;
--Productos
INSERT INTO CatProducto (nombre_Producto, existencia, precio)
SELECT ProductName, UnitsInStock, UnitPrice FROM NORTHWND.dbo.Products;
go
```
### 3. STORE PROCEDURE

1. Este bloque de código define el inicio del procedimiento almacenado encargado de gestionar las ventas.
```sql
CREATE OR ALTER PROC usp_agregar_venta
@id_cliente NCHAR(5),
@id_producto INT,
@cantidad INT
AS  
BEGIN
    SET NOCOUNT ON;
```
2. En este bloque de código se preparan las variables necesarias para almacenar el stock y el precio del producto antes de realizar la venta.
```sql
DECLARE @stockActual INT;
    DECLARE @precioActual DECIMAL(10,2);
    DECLARE @NuevoIdVenta INT;

    BEGIN TRY
    BEGIN TRANSACTION;

    --Si el cliente no existe
    IF NOT EXISTS (SELECT 1 FROM CatCliente WHERE id_cliente=@id_cliente)
    BEGIN
    PRINT 'ERROR: El cliente no existe. Proceso terminado';
    ROLLBACK;
    RETURN;
END
```
- Sirve para que el sistema no intente registrar una venta a un cliente que no existe en la base de datos.
```sql
IF NOT EXISTS (SELECT 1 FROM CatCliente WHERE id_cliente=@id_cliente)
```
3. Validación de Existencia del Producto
```sql
IF NOT EXISTS (SELECT 1 FROM CatProducto WHERE id_producto=@id_producto)
BEGIN
    PRINT 'ERROR: El producto no existe. Proceso terminado';
    ROLLBACK;
    RETURN;
END
```
4. En este bloque, el sistema realiza una consulta directa al catálogo de productos para capturar el estado real del inventario.
```sql
SELECT @stockActual=existencia, @precioActual= precio
FROM CatProducto 
WHERE id_producto = @id_producto;
```
5. Este bloque de código compara la cantidad solicitada en la venta contra el stock real almacenado en la variable `@stockActual`.
```sql
IF @stockActual<@cantidad
BEGIN
    PRINT 'ERROR: Stock insuficiente. Existencia actual: ' + CAST(@stockActual AS VARCHAR);
    ROLLBACK;
    RETURN;
END
```
6. Este bloque de código realiza la colocación inicial en la tabla `tblVenta`, marcando el inicio oficial de la transacción en el sistema.
```sql
INSERT INTO tblVenta (id_cliente, Fecha)
VALUES (@id_cliente, GETDATE());
```
7. Obtener ID
```sql
SET @NuevoIdVenta = SCOPE_IDENTITY();
```
8. Este bloque de código realiza la colocación de los artículos específicos en la tabla `tblDetalleVenta`, vinculándolos directamente con el folio de venta recién generado.
```sql
INSERT INTO tblDetalleVenta (id_venta, id_producto, precio_venta, cantidad_vendida)
VALUES (@NuevoIdVenta, @id_producto, @precioActual, @cantidad);
```
9. Este bloque final reduce la existencia en la tabla `CatProducto` restando la cantidad vendida del stock actual.
```sql
UPDATE CatProducto
SET existencia = existencia - @cantidad
WHERE id_producto = @id_producto;

    COMMIT;
    PRINT 'VENTA REALIZADA CON ÉXITO. Venta No: ' + CAST(@NuevoIdVenta AS VARCHAR);
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
    ROLLBACK;

    PRINT 'OCURRIÓ UN ERROR INESPERADO: ' + ERROR_MESSAGE();
END CATCH
END;
GO
```
### 3. Pruebas de Ejecución y Verificación
```sql
SELECT * FROM CatCliente;

EXEC usp_agregar_venta 'ELIENAY', 1,5;
EXEC usp_agregar_venta 'ANATR', 1, 6;
SELECT * FROM tblVenta;
SELECT * FROM tblDetalleVenta;
SELECT * FROM CatProducto;
```
![Base de Datos para Negocios Digitales](/img/ultima3.png "BD.")

![Base de Datos para Negocios Digitales](/img/ultima2.png "BD.")

![Base de Datos para Negocios Digitales](/img/ultima1.png "BD.")

### 4. Commit
```
git commit -m "Practica venta con StoreProcedure"
```