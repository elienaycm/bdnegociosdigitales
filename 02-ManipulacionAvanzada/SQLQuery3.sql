/*
Funciones de agregado
1.sum()
2.max()
3.min()
4.avg()
5.count(*)
6.count(campo)
*/

SELECT DISTINCT Country
FROM Customers


---Agregacion count (*) cuenta el numero de registros
--- que tiene una tabla


SELECT Count(*) as [Total de Ordenes]
From Orders;

SELECT ShipCountry, COUNT(*) AS [Total de orders]
FROM Orders
group by ShipCountry ;


SELECT Count(ShipCountry) , ShipCountry 
FROM Orders
WHere ShipCountry = 'Germany'
group by ShipCountry ;

------LIKE  

----SELECIONAR TODOS LOS CUSTOMERS QUE COMIENSEN CON LA LETRA A  esro son comodines

SELECT CustomerID, CompanyName, City, Region , Country
FROM Customers
WHERE CompanyName Like 'an%';

SELECT CustomerID, CompanyName, City, Region , Country
FROM Customers
WHERE City Like 'l_nd_o';

SELECT CustomerID, CompanyName, City, Region , Country
FROM Customers
WHERE City Like '%as';



---Seleccionar los clientes donde la ciudad contenga la palabra L

SELECT CustomerID, CompanyName, City, Region , Country
FROM Customers
WHERE City Like '%d.f%';

---Selecionar todos los clientes en su nombre que comience con a o b 

SELECT CustomerID, CompanyName, City, Region , Country
FROM Customers
WHERE CompanyName LIKE 'a%' or CompanyName Like 'b%';

----- ESTO SE OCUPA  el not entonces cabia 

SELECT CustomerID, CompanyName, City, Region , Country
FROM Customers
WHERE NOT CompanyName LIKE 'a%' or CompanyName Like 'b%';

---ahi se hace la convinacion de un parentesis ose que se hace primero lo parentesis 

SELECT CustomerID, CompanyName, City, Region , Country
FROM Customers
WHERE NOT (CompanyName LIKE 'a%' or CompanyName Like 'b%');

--- selecionar todos los clientes que comiense con b y termine con S

sELECT CustomerID, CompanyName, City, Region , Country
FROM Customers
WHERE CompanyName like 'b%s';


SELECT CustomerID, CompanyName, City, Region , Country
FROM Customers
WHERE CompanyName LIKE 'a__%';

---Selecionar todos los clientes (Nombre) que comiense con "b", "s" , "o", "p"


SELECT CustomerID, CompanyName, City, Region , Country
FROM Customers
WHERE CompanyName LIKE '[bsp]%';

---SAelecionar todos los Coustomer que comiense con a , c, d ,e or f

SELECT CustomerID, CompanyName, City, Region , Country
FROM Customers
WHERE CompanyName LIKE '[abcdef]%';



SELECT CustomerID, CompanyName, City, Region , Country
FROM Customers
WHERE CompanyName LIKE '[a-f]%'
ORDER BY 2 ASC;


SELECT CustomerID, CompanyName, City, Region , Country
FROM Customers
WHERE CompanyName LIKE '[^a-f]%'
ORDER BY 2 ASC;


---Selecionar todos los clientes de estados unidos o canada que inicia con b


SELECT CustomerID , CompanyName, city, region, Country
FROM Customers
WHERE Country in ( 'canada', 'USA') or CompanyName  like 'b%'  ;


SELECT CustomerID , CompanyName, city, region, Country
FROM Customers
WHERE Country in ( 'canada', 'USA') and CompanyName  like 'b%'  ;

----------------------------------
SELECT*
FROM Customers;

select count (CustomerID)
from Customers;

---	SELECCIONA DE CUANTAS CIUDADES SON LAS CIUDADES DE LOS CLIENTES----------
SELECT  count (city)
FROM Customers;

SELECT  distinct city
FROM Customers
order BY city Asc;

SELECT  count (distinct city) as [CIUDADES CLIENTES]
FROM Customers;

--selecciona el precio maximo de los productos---
SELECT*
FROM Products
order by UnitPrice DESC;

SELECT MAX (UnitPrice) as [Precio mas alto]
FROM Products;
---seleccionar la fecha de compra mas actual
SELECT *
FROM Orders;

SELECT MAX (OrderDate) AS [Ultima fecha de compra]
FROM Orders;


--seleccionar el year de la fecha de compra mas actual
SELECT MAX (YEAR(OrderDate))
FROM Orders;

SELECT MAX (DatePart(Year, OrderDate))
from orders;


SELECT DATEPART(YEAR,MAX(OrderDate)) as [YEAR]
from orders;

--CUAL ES LA MINIMA CANTIDAD DE LOS PEDIDOS
SELECT MIN(UnitPrice) as [precio minimo de venta]
from [Order Details]
---cual es el importe mas bajo de las compras
SELECT (UnitPrice *Quantity *(1-Discount)) as [Importe]
from [Order Details]
order by [Importe] ASC

SELECT min (UnitPrice *Quantity *(1-Discount)) as [Importe]
from [Order Details]

--total de los precios de los productos
Select sum (UnitPrice) 
from Products

--Obtener el total de dinero percivido por las ventas

SELECT SUM ((UnitPrice * Quantity* (1-Discount))) as [Importe mas bajo]
from [Order Details]

--seleccionar  las ventas totales de los productos 4, 10 y 20
select SUM (UnitPrice) as [Total]
from Products
where ProductID in ('4', '10', '20')

-- selecionar el numero de ordenes hechas por los sig clientes: around the horn, bolido comidas 
--preparadas y chop-suey chinese
SELECT*
from Orders

select sum (Orders) as [Numero de ordenes echas]
from Customers
where CustomerID = ('Around the horn', 'Bolido comidas preparadas', 'Chop-suey chinese')


--seleccionar el total de ordenes del segundo trimestre de 1996


--seleccionar el numero de ordenes entre 1996 a 1997
SeLECT COUNT(*) AS [Numero de ordenes]
from Orders
WHERE DATEPART(YEAR ,OrderDate) between 1996 and 1997;


--selecionar el numero de clientes que comienzan con a o que comienzan con b
SELECT COUNT(*)
FROM Customers
where companyName like 'a%'
or Companyname like 'b%';
---selecionar el numero de clientes que comienzan con b y terminan con s
SELECT COUNT(*)
FROM Customers
where companyName like 'b%s'
--seleccionar el numero de ordenes realizadas por el cliente Chop-suey Chinese en 1995
select *
from Customers
where CompanyName='Chop-suey Chinese'

SELECT COUNT(*) AS [Numero de ordenes] 
from Orders
where CustomerID='chops'
and year(OrderDate)=1996
----------------------------------------------------------------------------------------------------------
/*
GROUP BY Y HAVING
*/
----En un SELECT NUNCA puede ir un campo normasl y un campo de agrgado sin el group by
SELECT customerId,  COUNT(*) as [Numero de Ordenes]
FROM orders
INNER JOIN
Customers
ON CustomerId=CustomerId
GROUP BY CustomerID
ORDER BY 2 DESC;

SELECT c.CompanyName,  COUNT(*) as [Numero de Ordenes]
FROM orders as o
INNER JOIN
Customers as c
ON o.CustomerID=c. CustomerId
GROUP BY c.CompanyName
ORDER BY 2 DESC;

--Seleccionar el numero de productos (conteo) por categoria,
--mostar CategoriaID, el TOTAL de los productos
--ordenar de MAYOR a MENOR por el total de productos.
SELECT CategoryID, COUNT(*) as [Numero de productos]
FROM Products
GROUP BY CategoryID
ORDER BY [Numero de productos] desc;

SELECT CategoryID, COUNT(*) as [Numero de productos]
FROM Products
GROUP BY CategoryID
ORDER BY 2 desc;

SELECT CategoryID, COUNT(*) as [Numero de productos]
FROM Products
GROUP BY CategoryID
ORDER BY COUNT(*) desc;

--Seleccionar el precio promedio por provedor de los podructos, 
SELECT SupplierId,ROUND (AVG(UnitPrice),2) as [promedio de los prcios]
FROM Products
GROUP BY SupplierID;


--redondear a dos decimales el resultado y 
--ordenar de forma descendente por el precio promedio.
SELECT 
    SupplierID, 
    ROUND(AVG(UnitPrice), 2) AS [Promedio de los Precios]
FROM Products
GROUP BY SupplierID
ORDER BY [Promedio de los Precios] DESC;

--Seleccionar el numero de clientes por pais y
--ordenarlos por el alfabeto
SELECT 
    Country, 
    COUNT(CustomerID) AS [Total de Clientes]
FROM Customers
GROUP BY Country
ORDER BY Country ASC;
--Obtener la cantidad total vendida agtrupada por producto y por pedido
SELECT *,(UnitPrice * Quantity ) AS [Total]
FROM [Order Details];

SELECT SUM (UnitPrice * Quantity ) AS [Total]
FROM [Order Details];

SELECT ProductId,OrderID, SUM (UnitPrice * Quantity ) AS [Total]
FROM [Order Details]
GROUP BY ProductID, OrderID
ORDER BY ProductID

SELECT ProductId,OrderID, SUM (UnitPrice * Quantity ) AS [Total]
FROM [Order Details]
GROUP BY ProductID, OrderID
 desc

SELECT *, (UnitPrice * Quantity) as [TOTAL]
FROM [Order Details]
WHERE OrderID=10847
and ProductID=1

--Seleccionar la cantidad maxima vendida por cada procuto en cada pedido
SELECT ProductID, OrderId,MAX (QUANTITY) as [cantidad maxima]
FROM [Order Details]
GROUP BY ProductID,OrderId
ORDER BY ProductID, OrderID;

--Flujo logico de ejecucion de sql
--1. from
--2.JOIN
--3.WHERE
--4.GROUP BY
--5.HAVING
--6.SELECT
--7.DISTING
--8.ORDER BY

--Having (filtro por grupos0

--Seleccionar los clientes que hayan realizadomas de 10 pedidos

SELECT c.CompanyName, COUNT (*) as [Numero de ordenes]
FROM Orders AS o
INNER JOIN Customers AS c
ON o.CustomerID=c.CustomerID
group by c.CompanyName
HAVING COUNT(*)>10
ORDER BY 2 DESC;

SELECT customerid,ShipCountry,COUNT (*) as [Numero de ordenes]
FROM Orders
WHERE ShipCountry IN ('GERMANY','FRANCE','BRAZIL')
group by Customerid, ShipCountry
HAVING COUNT(*)>10
ORDER BY 2 DESC;

SELECT customerid,count(*) as [Numero de ordenes]
FROM Orders
group by Customerid
HAVING COUNT(*)>10
ORDER BY 2 DESC;

--Seleccionar los empleados que hayan gestionado pedidos por un total superior a 100000 en ventas
--1. mostrar el nombre del empleado y el Id
--2. el total de compras
SELECT *
FROM Employees as e
INNER JOIN Orders as o
on e.EmployeeID=o.EmployeeID
INNER JOIN [Order Details]as od
on o.OrderID =od.OrderID

SELECT  CONCAT (e.FirstName,' ', e.LastName)AS [Nombre completo],
(od.Quantity* od.UnitPrice*(1-od. Discount)) as [IMPORTE]
FROM Employees as e
INNER JOIN Orders as o
on e.EmployeeID=o.EmployeeID
INNER JOIN [Order Details]as od
on o.OrderID =od.OrderID
ORDER BY e.FirstName

SELECT  CONCAT (e.FirstName,' ', e.LastName) AS [Nombre completo],
 ROUND (SUM(od.Quantity* od.UnitPrice*(1-od. Discount)),2) as [IMPORTE]
FROM Employees as e
INNER JOIN Orders as o
on e.EmployeeID=o.EmployeeID
INNER JOIN [Order Details]as od
on o.OrderID =od.OrderID
GROUP BY e.FirstName, e.LastName
HAVING SUM(od.Quantity* od.UnitPrice*(1-od. Discount)) > 100000
ORDER BY [IMPORTE] DESC;

--Seleccionar el numero de productos vendidos en mas de 20 pedidos distintos
--mostrar el id del producto
--el nombre del producto
--y el numero de ordenes

SELECT p.ProductID, 
       p.ProductName, 
       COUNT (DISTINCT o.OrderID) AS [Numero de PEDIDOS]
FROM Products as p
inner join  [Order Details] as od
ON p.ProductID = od.ProductID
inner join Orders as o
on o.OrderID = od.OrderID
GROUP BY p.ProductID, 
       p.ProductName
HAVING COUNT (DISTINCT o.OrderID)>20;

--PASO1 Seleccionar los productos no descontinuados, 
--2 calcular el precio promedio vendido,
--3 y mostrar solo aquellos que se hayan vendido en menosde 15 pedidos

--1 
SELECT*
FROM Products as p
WHERE p.Discontinued =0

--2
SELECT p.ProductName, ROUND (avg (od.UnitPrice),2) as [Precio promedio]
FROM Products as p
INNER JOIN [Order Details]AS od ON p.ProductID=od.ProductID
WHERE p.Discontinued =0
GROUP BY p.ProductName
HAVING COUNT (OrderID) < 15;


--Seleccionar el precio maximo de productos por
--categoria, pero solo si la suma de unidades es menor a 200
--y ademas que no esten descontinuados
SELECT c.CategoryID, c.CategoryName, p.ProductName,
       MAX (p.UnitPrice) as [Precio Maximo]
FROM Products as p
INNER JOIN Categories AS c
ON p.CategoryID=c.CategoryId
WHERE p.Discontinued =0
GROUP BY c.CategoryID,
c.CategoryName,
p.ProductName
HAVING SUM(p.UnitsInStock) < 200
ORDER BY CategoryName, p.ProductName ASC;

