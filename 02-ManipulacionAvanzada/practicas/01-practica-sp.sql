USE NORTHWND;
GO

DROP DATABASE bdpracticas;
GO
 
 --1.
CREATE DATABASE bdpracticas;
GO

USE bdpracticas;
GO


--2.
-- Tablas
CREATE TABLE CatCliente(
    id_cliente NVARCHAR(5) PRIMARY KEY,
    nombre_cliente VARCHAR(50),
    Pais VARCHAR(20),
    Ciudad VARCHAR(20)
);
CREATE TABLE CatProducto(
    --EL 1,1 es para marcar de 1 a uno
    id_producto INT PRIMARY KEY IDENTITY (1,1),
    nombre_Producto VARCHAR(50),
    existencia INT,
    precio DECIMAL(10,2)
);
CREATE TABLE tblVenta(
    id_venta INT PRIMARY KEY IDENTITY(1,1),
    --Pone automaticamnete la hora y dia
    fecha DATETIME DEFAULT GETDATE(),
    id_cliente NVARCHAR(5),
    --Primero existe un cliente para despues existir una venta
    CONSTRAINT FK_Venta_Cliente FOREIGN KEY (id_cliente) REFERENCES CatCliente(id_cliente)
);
CREATE TABLE tblDetalleVenta(
    id_venta INT,
    id_producto INT,
    precio_venta DECIMAL(10,2),
    cantidad_vendida INT,
    PRIMARY KEY (id_venta, id_producto),
    CONSTRAINT FK_Detalle_Venta FOREIGN KEY (id_venta) REFERENCES tblVenta(id_venta),
    CONSTRAINT FK_Detalle_Producto FOREIGN KEY (id_producto) REFERENCES CatProducto(id_producto)
);

--3.
-- Poner datos de Northwind a las tablas nuevas
--Clientes
INSERT INTO CatCliente (id_cliente, nombre_cliente, Pais, Ciudad)
SELECT CustomerID, ContactName, Country, City FROM NORTHWND.dbo.Customers;
--Productos
INSERT INTO CatProducto (nombre_Producto, existencia, precio)
SELECT ProductName, UnitsInStock, UnitPrice FROM NORTHWND.dbo.Products;
go
--4.
-------------------STORE PROCEDURE-------------------------
CREATE OR ALTER PROC usp_agregar_venta
@id_cliente NCHAR(5),
@id_producto INT,
@cantidad INT
AS  
BEGIN
    SET NOCOUNT ON;

--Calculos
    DECLARE @stockActual INT;
    DECLARE @precioActual DECIMAL(10,2);
    DECLARE @NuevoIdVenta INT;

    BEGIN TRY
    BEGIN TRANSACTION;

    --Si el cliente no existe
    --Sirve para que el sistema no intente registrar una venta a un cliente que no existe en la base de datos.
    IF NOT EXISTS (SELECT 1 FROM CatCliente WHERE id_cliente=@id_cliente)
    BEGIN
    PRINT 'ERROR: El cliente no existe. Proceso terminado';
    ROLLBACK;
    RETURN;
END


--Si el producto no existe
IF NOT EXISTS (SELECT 1 FROM CatProducto WHERE id_producto=@id_producto)
BEGIN
    PRINT 'ERROR: El producto no existe. Proceso terminado';
    ROLLBACK;
    RETURN;
END

--Stock y precios
SELECT @stockActual=existencia, @precioActual= precio
FROM CatProducto 
WHERE id_producto = @id_producto;

--Verificar si hay stock suficiente
IF @stockActual<@cantidad
BEGIN
    PRINT 'ERROR: Stock insuficiente. Existencia actual: ' + CAST(@stockActual AS VARCHAR);
    ROLLBACK;
    RETURN;
END

--Para insertar en tblVenta
INSERT INTO tblVenta (id_cliente, Fecha)
VALUES (@id_cliente, GETDATE());

--Obtener ID
SET @NuevoIdVenta = SCOPE_IDENTITY();

--Insertar en tblDetalleVenta
INSERT INTO tblDetalleVenta (id_venta, id_producto, precio_venta, cantidad_vendida)
VALUES (@NuevoIdVenta, @id_producto, @precioActual, @cantidad);

--Actualizar Stock
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

SELECT * FROM CatCliente;

EXEC usp_agregar_venta 'ELIENAY', 1,5;
EXEC usp_agregar_venta 'ANATR', 1, 6;
SELECT * FROM tblVenta;
SELECT * FROM tblDetalleVenta;
SELECT * FROM CatProducto;