--Consultas simples con AQL-LMD
SELECT *
FROM Categories;

SELECT *
FROM Products;

Select *
FROM Orders;

SELECT *
FROM [Order Details];

--Proyeccion (seleccionar algunops campos)
SELECT 
ProductID, 
ProductName, 
UnitsInStock
FROM Products;

--Alias de columnas

SELECT 
ProductID AS [NUMERO DE PRODUCTO], 
ProductName AS 'NOMBRE DE PRODUCTO',
UnitPrice AS [PRECIO UNITARIO],
UnitsInStock AS STOK
FROM Products;

SELECT 
CompanyName AS CLIENTE,
City AS CIUDAD,
Country AS PAIS
FROM Customers;

--CAMPOS CALCULADOS (SALE A PARTIR DE UNA OPERACION)

--SELECCIONAR LOS PRODUCTOS Y CALCULAR EL VALOR DEL INVENTARIO

SELECT *, (UnitPrice * UnitsInStock)
FROM Products;

SELECT 
ProductID,
ProductName,
UnitsInStock,
(UnitPrice * UnitsInStock) AS [COSTO INVENTARIO]
FROM Products;

SELECT *
FROM [Order Details];

--CALCULAR EL IMPORTE DE VENTA
SELECT
OrderID,
ProductID,
UnitPrice,
Quantity,
(UnitPrice * Quantity) AS IMPORTE
From [Order Details];

--SELECCIONAR LA VENTA CON EL CALCULO DEL IMPORTE CON DESCUENTO
SELECT *
FROM [Order Details];

--Selecciona la vesnta con el calculo del importe con descuento
SELECT 
	OrderID, 
	UnitPrice, 
	Quantity, 
	Discount,
	(UnitPrice * Quantity) AS Importe,
	(UnitPrice * Quantity) -((UnitPrice * Quantity) * Discount) AS [Importe con descuento 1],
	(UnitPrice * Quantity) * (1 - Discount) AS [Importe con descuento 2]
FROM [Order Details];

--Operadores Relacioneales (<,>,<=,>=,=,!= o <> (diferente) )
/*
Seleccionar todos los productos con precio mayor a 30
Seleccionar los productos con stock menor o igual a 20
Seleccionar los pedidos posteriores a 1997
*/

SELECT 
ProductID AS [Numero de producto],
ProductName AS [Nombre Producto],
UnitPrice AS [Precio Unitario],
UnitsInStock AS [Stock]
FROM Products
WHERE UnitPrice>30
Order by UnitPrice DESC;

SELECT 
ProductID AS [NUMERO DE PRODUCTO], 
ProductName AS [NOMBRE DE PRODUCTO],
UnitPrice AS [PRECIO UNITARIO],
UnitsInStock AS [STOK]
FROM Products
WHERE UnitsInStock <=20;

--FORMAS DE Seleccionar los pedidos posteriores a 1997

SELECT OrderID, 
	OrderDate, 
	CustomerID,
	ShipCountry,
	YEAR(OrderDate) AS Año,
	MONTH(OrderDate) AS Mes,
	DAy(orderdate) AS Dia,
	DATEPART(YEAR, OrderDate) AS Año2,
	DATEPART(QUARTER, OrderDate) AS Trimestre,
	DATEPART(WEEKDAY, OrderDate) as [Dia Semana],
	DATENAME(WEEKDAY, OrderDate) AS [Dia Semana Nombre]
FROM Orders
WHERE OrderDate > '1997-12-31';

SELECT OrderID, 
	OrderDate, 
	CustomerID,
	ShipCountry,
	YEAR(OrderDate) AS Año,
	MONTH(OrderDate) AS Mes,
	DAy(orderdate) AS Dia,
	DATEPART(YEAR, OrderDate) AS Año2,
	DATEPART(QUARTER, OrderDate) AS Trimestre,
	DATEPART(WEEKDAY, OrderDate) as [Dia Semana],
	DATENAME(WEEKDAY, OrderDate) AS [Dia Semana Nombre]
FROM Orders
WHERE YEAR(OrderDate) > 1997;

SELECT OrderID, 
	OrderDate, 
	CustomerID,
	ShipCountry,
	YEAR(OrderDate) AS Año,
	MONTH(OrderDate) AS Mes,
	DAy(orderdate) AS Dia,
	DATEPART(YEAR, OrderDate) AS Año2,
	DATEPART(QUARTER, OrderDate) AS Trimestre,
	DATEPART(WEEKDAY, OrderDate) as [Dia Semana],
	DATENAME(WEEKDAY, OrderDate) AS [Dia Semana Nombre]
FROM Orders
WHERE DATEPART(YEAR,OrderDate) > 1997;


SET LANGUAGE SPANISH;
SELECT OrderID, 
	OrderDate, 
	CustomerID,
	ShipCountry,
	YEAR(OrderDate) AS Año,
	MONTH(OrderDate) AS Mes,
	DAy(orderdate) AS Dia,
	DATEPART(YEAR, OrderDate) AS Año2,
	DATEPART(QUARTER, OrderDate) AS Trimestre,
	DATEPART(WEEKDAY, OrderDate) as [Dia Semana],
	DATENAME(WEEKDAY, OrderDate) AS [Dia Semana Nombre]
FROM Orders
WHERE YEAR(OrderDate) > 1997;

--Operadores logicos (not, ant, or)
/*
Seleccionar los productos que tengan un precio mayor a 20 
y menos de 100 unidades en stock

Mostrar los clientes que sean de estados unidos o de canada

Obtener los pedidos que no tengan region
*/

SELECT 
ProductID AS [Numero de producto],
ProductName AS [Nombre Producto],
UnitPrice AS [Precio Unitario],
UnitsInStock AS [Stock]
FROM Products
WHERE UnitPrice >20 AND UnitsStock < 100
Order by UnitPrice DESC;

SELECT ProductID, CategoryID, UnitPrice, UnitsInStock
FROM Products
WHERE UnitPrice > 20
AND
UnitsInStock<100;

SELECT CustomerID, CompanyName, city, region, country
FROM Customers
WHERE country = 'USA'
OR
country = 'CANADA';

SELECT CustomerID, OrderDate, ShipRegion
FROM Orders
WHERE ShipRegion is not null;

SELECT
FROM Customers;

Select
From Orde;

--Operador IN
/*
Mostrar los clientes de Alemania, Francia y UK
*/

SELECT *
FROM Customers
WHERE Country in('Germany','France', 'UK')
ORDER BY Country DESC;

SELECT *
FROM Customers
WHERE Country ='Germany'
or
Country='France'
or 
Country='UK';

/*
OBTENER LOS PRODUCTOS DONDE LA CATEGORIA SEA 1,3 O 5
*/


--Operador Between
/*
Mostrar los productos cuyo precio esta entre 20 y 40
*/
SELECT *
FROM Products
WHERE UnitPrice BETWEEN 20 AND 40
ORDER BY UnitPrice;

SELECT *
FROM Products
WHERE UnitPrice>=20 and UnitPrice <=40
ORDER BY UnitPrice;

--Operador Like