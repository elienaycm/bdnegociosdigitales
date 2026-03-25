# Scripts de consultas simples y de agregado, group by y having
## Base de Datos para Negocios Digitales
## Unidad l
#### Elienay Ivana Cantera Martinez 8EVND G1
##
## Procedimiento:
## 1. Consultas simples
Comandos:
1. `CREATE DATABASE`: Crea el contenedor de toda la información.
2. `USE`: Se utiliza para seleccionar una base de datos específica.
3. `CREATE TABLE`: Crea la lista o tabla donde se guardarán los datos.
4. `NOT NULL`: Sin datos vacíos.
5. `DEFAULT`: Si no se pone un dato, el sistema pone uno automáticamente.
6. `IDENTITY(1,1)`: Es un contador que pone el número de ID.
7.`PRIMARY KEY`: Identificador único para cada registro. Garantizando que no existan duplicados.
8. `UNIQUE`: Asegura que un dato (como un nombre) no se repita en la tabla.
9. `CHECK`: Es es una restricción que solo deja pasar datos que cumplan una condición.
10. `FOREIGN KEY`: Establece una relación entre dos tablas (como unir un producto con su proveedor).
11. `ON DELETE`: Se coloca al momento de crear o modificar una relación entre tablas
12. `UPDATE`: Se utiliza para modificar registros existentes en una tabla.
13. `ALTER TABLE`: Sirve para cambiar o arreglar una tabla que ya habías creado.
14. `DROP TABLE`: Borra la tabla.
15. `UPPER`: Convierte cualquier texto a MAYÚSCULAS automáticamente.
16. `ORDER BY`: sirve para clasificar y ordenar.

### Ejercicios
```sql
-- SELECCIONAR LOS PRODUCTOS Y CALCULAR EL VALOR DEL INVENTARIO
SELECT *, (UnitPrice * UnitsInStock)
FROM Products;

SELECT 
ProductID,
ProductName,
UnitsInStock,
(UnitPrice * UnitsInStock) AS [COSTO INVENTARIO]
FROM Products;
```
¿Qué hace la consulta? 
Toma el precio unitario y lo multiplica por las unidades en existencia. El `AS [COSTO INVENTARIO]` le pone un nombre legible a esa nueva columna.

```sql
-- CALCULAR EL IMPORTE DE VENTA
SELECT
OrderID,
ProductID,
UnitPrice,
Quantity,
(UnitPrice * Quantity) AS IMPORTE
From [Order Details];

-- SELECCIONAR LA VENTA CON EL CALCULO DEL IMPORTE CON DESCUENTO
SELECT 
    OrderID, 
    UnitPrice, 
    Quantity, 
    Discount,
    (UnitPrice * Quantity) AS Importe,
    (UnitPrice * Quantity) * (1 - Discount) AS [Importe con descuento]
FROM [Order Details];
```
¿Qué hace la consulta? Primero se saca el total bruto `Precio * Cantidad`.
En la segunda parte, se usa la fórmula `1 - Discount` para calcular el precio neto. Es una forma rápida de ver la ganancia real.

```sql
-- Seleccionar todos los productos con precio mayor a 30
SELECT 
ProductID AS [Numero de producto],
ProductName AS [Nombre Producto],
UnitPrice AS [Precio Unitario],
UnitsInStock AS [Stock]
FROM Products
WHERE UnitPrice > 30
Order by UnitPrice DESC;

-- Mostrar los clientes de Alemania, Francia y UK
SELECT *
FROM Customers
WHERE Country in('Germany','France', 'UK')
ORDER BY Country DESC;
```
¿Qué hace la consulta? El `WHERE` los ordena de mayor a menor. En el segundo, el `IN` busca coincidencias en una lista de países específica.

```sql
SELECT OrderID, OrderDate FROM Orders WHERE OrderDate > '1997-12-31';
```
Comparando la fecha completa

```sql
SELECT OrderID, OrderDate, YEAR(OrderDate) AS Año FROM Orders WHERE YEAR(OrderDate) > 1997;
```
Extrayendo el año con la función YEAR

```sql
SELECT OrderID, OrderDate, DATEPART(YEAR, OrderDate) AS Año2 FROM Orders WHERE DATEPART(YEAR, OrderDate) > 1997;
```
Usando DATEPART, Especifica qué parte de la fecha quieres obtener (año, mes, día, hora, minuto, etc.)

```sql
-- Seleccionar productos con precio mayor a 20 y poco stock (menos de 100)
SELECT ProductID, CategoryID, UnitPrice, UnitsInStock
FROM Products
WHERE UnitPrice > 20 AND UnitsInStock < 100;

-- Mostrar clientes que sean de Estados Unidos o de Canadá
SELECT CustomerID, CompanyName, city, region, country
FROM Customers
WHERE country = 'USA' OR country = 'CANADA';
```
¿Qué hace la consulta? Se usa `AND` para que se cumplan ambas condiciones. En la segunda usa `OR` para que se cumpla cualquiera de las dos.

```sql
-- Obtener los pedidos que SI tienen una región asignada
SELECT CustomerID, OrderDate, ShipRegion
FROM Orders
WHERE ShipRegion is not null;
```
¿Qué hace la consulta? `IS NOT NULL` filtra los registros para ignorar los dato de la región que estan vacíos, mostrando solo los pedidos con información completa de envío.
```sql
-- Obtener los productos donde la categoria sea 1, 3 o 5
SELECT ProductID, ProductName, CategoryID, UnitPrice
FROM Products
WHERE CategoryID IN (1, 3, 5)
ORDER BY CategoryID;
```
¿Qué hace la consulta? Selecciona productos que pertenecen a esos tres grupos específicos y se organizan por el número de categoría.
```sql
-- Mostrar los productos cuyo precio esta entre 20 y 40
SELECT *
FROM Products
WHERE UnitPrice BETWEEN 20 AND 40
ORDER BY UnitPrice;
```
¿Qué hace la consulta? `BETWEEN` selecciona automáticamente todo lo que esté dentro del rango 20-40.
```sql
SET LANGUAGE SPANISH;
SELECT OrderID, 
    OrderDate, 
    DATENAME(WEEKDAY, OrderDate) AS [Dia Semana Nombre]
FROM Orders;
```
¿Qué hace la consulta? `SET LANGUAGE` Cambia el idioma del sistema y usa DATENAME para convertir una fecha en el nombre del día (Lunes, Martes, etc.)

## 
## 2. Funciones de agregado
Comandos:
1. `SUM()`: Suma todos los valores de una columna numérica.
2. `MAX()`: Encuentra el valor más alto (máximo) en una columna.
3. `MIN()`: Encuentra el valor más bajo (mínimo) en una columna.
4. `AVG()`: Calcula el promedio (average) de los valores de una columna.
5. `COUNT(*)`: Cuenta el número total de filas o registros resultantes.
6. `COUNT(Campo)`: Cuenta cuántos valores hay en una columna específica (ignora los nulos).
7. `DISTINCT`: Se usa para eliminar duplicados y mostrar solo valores únicos.
8. `LIKE`: Se usa en la cláusula *WHERE* para buscar un patrón específico en una columna.
9. `%`: Comodín que representa cualquier número de caracteres (cero o más).
10. `_`: Comodín que representa un solo carácter.
11. `[ ]`: Permite buscar cualquier carácter individual dentro de un conjunto o rango. 
12. `^` : Se usa dentro de los corchetes para buscar caracteres que no estén en la lista.
13. `DESC`: Descendente. Mayor a menor
14. `ASC`: Ascendente.Menor a mayor

### Ejercicios
```sql
-- Selecciona de cuantas ciudades son los clientes (sin repetir)
SELECT COUNT(DISTINCT city) AS [CIUDADES CLIENTES]
FROM Customers;
```
¿Qué hace la consulta? `DISTINCT city` hace una lista de las ciudades sin repetir.`COUNT` las cuenta. El resultado es el número total de ciudades diferentes donde tienes clientes.
```sql
SELECT MAX(OrderDate) AS [Ultima fecha de compra]
FROM Orders;
```
 Se usa`MAX` para buscar fecha de compra más actual.
```sql
SELECT MIN(UnitPrice) AS [precio minimo de venta]
FROM [Order Details];
```
Se usa `MIN` para buscar la mínima cantidad de precio en los detalles de pedidos.

```sql
-- Obtener el total de dinero percibido por las ventas (con descuento aplicado)
SELECT SUM((UnitPrice * Quantity * (1 - Discount))) AS [Total de Ventas Reales]
FROM [Order Details];
```
¿Qué hace la consulta? Realiza el cálculo del precio neto para cada fila de la tabla *Order Details* , y al final, la función `SUM` suma todos esos resultados para darte la cifra total de dinero ingresado.
```sql
-- Seleccionar clientes cuyo nombre comience con A o B
SELECT CustomerID, CompanyName, City
FROM Customers
WHERE CompanyName LIKE 'a%' OR CompanyName LIKE 'b%';

-- Seleccionar ciudades que tengan una 'l', luego dos letras cualquiera, luego 'nd', luego otra letra y terminen en 'o'
SELECT CustomerID, CompanyName, City
FROM Customers
WHERE City LIKE 'l_nd_o'; -- (Ejemplo para buscar London)
```
¿Qué hace la consulta? El `%` le dice a SQL que no importa qué siga después de la "a". El guion bajo `_` obliga a que exista exactamente un carácter en esa posición.

```sql
-- Seleccionar clientes cuyo nombre comience con letras de la A a la F
SELECT CustomerID, CompanyName, Country
FROM Customers
WHERE CompanyName LIKE '[a-f]%'
ORDER BY 2 ASC;

-- Seleccionar clientes cuyo nombre NO comience con letras de la A a la F
SELECT CustomerID, CompanyName, Country
FROM Customers
WHERE CompanyName LIKE '[^a-f]%'
ORDER BY 2 ASC;
```
¿Qué hace la consulta? Los corchetes `[a-f]` funcionan como un filtro de alfabeto. Si se agrega el símbolo `^` al inicio dentro del corchete, busca todo lo que sea diferente a ese rango.
```sql
-- Seleccionar el número de órdenes entre 1996 y 1997
SELECT COUNT(*) AS [Numero de ordenes]
FROM Orders
WHERE DATEPART(YEAR, OrderDate) BETWEEN 1996 AND 1997;
```
¿Qué hace la consulta? Utiliza `DATEPART` para obtener año de las fechas, filtra ese año usando un rango con `BETWEEN` y cuenta cuántos registros cumplieron esa condición.
## 
## 3. GROUP BY
Se utiliza para agrupar filas que tienen valores iguales en una o más columnas, de manera que puedas aplicar funciones de agregación sobre cada grupo.

¿Cuándo usarlo? Cuando la pregunta diga: `Por cada...`, `El total de...`, Cuántos hay de cada...".

Siempre debes agrupar por la columna que quieres categorizar

## 4. HAVING
Se utiliza para filtrar los resultados de grupos creados con `GROUP BY`. Aplica condiciones sobre los datos agregados después de la agrupación.


### El Orden de SQL

1. `SELECT`
2. `FROM` 
3. `WHERE` 
4. `GROUP BY` 
5. `HAVING` 
6. `ORDER BY` \

### Orden con 3 Tablas
```sql
SELECT: Qué quieres ver (ej. Ciudad y la Suma).

FROM: La primera tabla (Oficinas).

INNER JOIN (1er puente): La segunda tabla (Representantes) y su ON.

INNER JOIN (2do puente): La tercera tabla (Pedidos) y su ON.

GROUP BY: La columna que no tiene suma (Ciudad).

HAVING: (Solo si quieres filtrar el total de la suma).

ORDER BY: (Para acomodar de la A a la Z).
```
##
## WHERE
Para qué sirve: Filtra filas individuales antes de hacer cualquier cuenta.
```SQL
Ejemplo: 
WHERE Ciudad = 'México'.
--Es como decir: "De toda mi lista, solo saca los tickets de Walmart"
```

Comandos:
```sql
SELECT ShipCountry, COUNT(*) AS [Total de orders]
FROM Orders
GROUP BY ShipCountry;
```
¿Qué hace la consulta? `GROUP BY ShipCountry` agrupa todas las órdenes que pertenecen al mismo país en un solo grupo. Esto permite que `COUNT(*)` calcule cuántas órdenes hay dentro de cada grupo.
```sql
SELECT Count(ShipCountry), ShipCountry 
FROM Orders
WHERE ShipCountry = 'Germany'
GROUP BY ShipCountry;
```
¿Qué hace la consulta? Después de que `WHERE` filtra solo Alemania, `GROUP BY ShipCountry` agrupa los registros restantes.
```sql
SELECT customerId, COUNT(*) as [Numero de Ordenes]
FROM orders
GROUP BY CustomerID;
```
¿Qué hace la consulta? `GROUP BY CustomerID` agrupa todas las órdenes que pertenecen al mismo cliente. Sin el GROUP BY, no se podría mostrar el ID del cliente junto con el conteo.
```sql
SELECT c.CompanyName, COUNT (*) as [Numero de ordenes]
FROM Orders AS o
INNER JOIN Customers AS c
ON o.CustomerID=c.CustomerID
group by c.CompanyName
HAVING COUNT(*)>10
ORDER BY 2 DESC;
```
¿Qué hace la consulta? `HAVING COUNT(*) > 10` filtra los grupos ya formados. Solo deja visibles las empresas cuyo total de órdenes sea mayor a 10.
```sql
SELECT customerid,ShipCountry,COUNT (*) as [Numero de ordenes]
FROM Orders
WHERE ShipCountry IN ('GERMANY','FRANCE','BRAZIL')
group by Customerid, ShipCountry
HAVING COUNT(*)>10
ORDER BY 2 DESC;
```
¿Qué hace la consulta? Después de contar las órdenes de cada grupo, `HAVING` elimina los grupos que no superen las 10 órdenes.
```sql
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
```
¿Qué hace la consulta? `HAVING`Calcula la suma total de ventas dentro de cada grupo y luego filtra dejando solo los empleados cuya suma supere los 100000.
```sql
--Obtener los productos que han sido vendidos en más de 20 pedidos distintos.
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
```
¿Qué hace la consulta? `GROUP BY p.ProductID, p.ProductName` reúne todas esas filas que pertenecen al mismo producto para poder contarlas. `HAVING COUNT(DISTINCT o.OrderID) > 20` filtra esos grupos y deja solo los productos que aparecen en más de 20 pedidos diferentes.

```sql
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
```
¿Qué hace la consulta? Obtiene los productos activos (no descontinuados), mostrando su precio máximo, pero solo si el total de unidades en stock del grupo es menor a 200.
```sql
SELECT p.ProductName, ROUND (avg (od.UnitPrice),2) as [Precio promedio]
FROM Products as p
INNER JOIN [Order Details]AS od ON p.ProductID=od.ProductID
WHERE p.Discontinued =0
GROUP BY p.ProductName
HAVING COUNT (OrderID) < 15;
```
¿Qué hace la consulta? Muestra productos no descontinuados vendidos en menos de 15 pedidos.


## JOINS
Siempre que veas que piden `Nombre del Producto` y `Nombre de la Categoría`, necesitas un JOIN porque esa información vive en tablas separadas.