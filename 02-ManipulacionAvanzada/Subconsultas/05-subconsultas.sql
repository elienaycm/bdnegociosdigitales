USE bdsubconsultas;
GO
IF OBJECT_ID('pedidos', 'U') IS NOT NULL DROP TABLE pedidos;
IF OBJECT_ID('clientes', 'U') IS NOT NULL DROP TABLE clientes;
GO
-- Crear tabla clientes
CREATE TABLE clientes(
    id_cliente int not null identity(1,1) primary key,
    nombre nvarchar(50) not null,
    ciudad nchar(20) not null
);

-- Crear tabla pedidos (Corregida la FK)
CREATE TABLE pedidos(
    pedido int not null identity(1,1) primary key,
    id_cliente int not null, -- Cambiado de nid_cliente a id_cliente para que coincida con la FK
    total money not null,
    fecha date not null,
    CONSTRAINT fk_pedidos_clientes
    FOREIGN KEY (id_cliente)
    REFERENCES clientes(id_cliente)
);
GO

-- Insertar tus datos de ejemplo
INSERT INTO clientes (nombre, ciudad) VALUES
('Ana', 'CDMX'), ('Luis', 'Guadalajara'), ('Marta', 'CDMX'),
('Pedro', 'Monterrey'), ('Sofia', 'Puebla'), ('Carlos', 'CDMX'), 
('Artemio', 'Pachuca'), ('Roberto', 'Veracruz');

INSERT INTO pedidos (id_cliente, total, fecha) VALUES
(1, 1000.00, '2024-01-10'), (1, 500.00,  '2024-02-10'),
(2, 300.00,  '2024-01-05'), (3, 1500.00, '2024-03-01'),
(3, 700.00,  '2024-03-15'), (1, 1200.00, '2024-04-01'),
(2, 800.00,  '2024-02-20'), (3, 400.00,  '2024-04-10');
GO
----------
--Mostrar nombre y promedio global (Escalar)
SELECT nombre,
(SELECT AVG(total) FROM pedidos) AS [Precio Promedio Global]
FROM clientes;
--Mostrar cada cliente y su cantidad de pedidos (Correlacionada)
SELECT nombre,
(
    SELECT COUNT(*)
    FROM pedidos AS p
    WHERE p.id_cliente = c.id_cliente
) AS [Numero de pedidos]
FROM clientes AS c;
--Mostrar cada cliente y la fecha de su �ltimo pedido
SELECT nombre,
(SELECT MAX(fecha) FROM pedidos AS p WHERE p.id_cliente = c.id_cliente) AS [Ultimo Pedido]
FROM clientes AS c;
--Mostrar pedidos con nombre del cliente
SELECT pedido, total,
(SELECT nombre FROM clientes AS c WHERE c.id_cliente = p.id_cliente) AS [Nombre Cliente]
FROM pedidos AS p;


---------
--Seleccionar los pedidos en donde el rotal sea igual
--al total maximo de ellos
SELECT MAX(total)
FROM pedidos;

SELECT * FROM pedidos
WHERE total =1500;



SELECT p.pedido,c.nombre,p.fecha,p.total
FROM pedidos AS p
INNER JOIN 
clientes AS c
ON p.id_cliente=c.id_cliente
WHERE p.total=(
SELECT MAX(total)
FROM pedidos
);

--Seleccionar los pedidos mayores al promedio
SELECT AVG(total)
FROM pedidos;

SELECT *
FROM pedidos 
WHERE total>(
SELECT AVG(total)
FROM pedidos
)

---Seleccionar todos los pedidos del cliente
--que tenga el menor id
SELECT MIN (id_cliente)
FROM pedidos;

SELECT id_cliente,COUNT(*) AS [Numero de pedidos]
FROM pedidos
WHERE id_cliente=(
SELECT MIN (id_cliente)
FROM pedidos
)
GROUp BY id_cliente;

--MOSTRAR los datos del pedido del ultima orden
SELECT MAX(fecha)
FROM pedidos;

SELECT p.pedido, c.nombre, p.fecha,p.total
FROM pedidos AS p
INNER JOIN clientes AS c
ON p.id_cliente = c.id_cliente
WHERE fecha=(
SELECT MAX(fecha)
FROM pedidos
);
--Mostrar todos los pedidos con un total que 
--sea el mas bajo.
SELECT *
FROM pedidos
WHERE total=(
SELECT MIN (total)
FROM pedidos
);
--Seleccionar los pedidos con el 
--nombre del cliente cuyo total(Freight) 
--sea mayor al promedio general de freight
USE NORTHWND;

SELECT AVG (Freight)
FROM Orders;

SELECT o.OrderID, c.CompanyName, o.Freight
FROM Orders AS o
INNER JOIN Customers AS c
ON o.CustomerID = c.CustomerID
WHERE o.Freight>(
SELECT AVG(Freight)
FROM Orders
)
ORDER BY o.Freight DESC;

--Subqueries con IN, ANY, ALL(llevan una sola columna)
--Con ls clausua IN
--Seleccionar clientes que an echo pedios
SELECT * 
FROM clientes;

SELECT id_cliente 
FROM clientes
WHERE id_cliente in(
SELECT id_cliente 
FROM clientes
)

SELECT DISTINCT 
    c.id_cliente, 
    c.nombre, 
    c.ciudad
FROM clientes AS c
INNER JOIN pedidos AS p
    ON c.id_cliente = p.id_cliente;

--Clientes que han hecho pedidos mayores a 800
--Subconsulata
SELECT id_cliente
FROM pedidos
WHERE total>800;
--Consulta princicipal
SELECT *
FROM pedidos
WHERE id_cliente in(
SELECT id_cliente
FROM pedidos
WHERE total>800
);
--Seleccionar todos los clientes de la ciudad de Mexico que han hecho pedidos
SELECT id_cliente
FROM Pedidos;

SELECT *
FROM clientes
WHERE ciudad='CDMX'
AND id_cliente IN (
    SELECT id_cliente
FROM Pedidos
);
--Seleccionar clientes que no han echo pedidos
SELECT c.id_cliente, c.nombre, c.ciudad
FROM pedidos as p
RIGHT JOIN
clientes as c 
ON p.id_cliente = c.id_cliente
WHERE p.id_cliente IS NULL;

SELECT  id_cliente
FROM pedidos;

SELECT *
FROM clientes
WHERE id_cliente NOT IN(
   SELECT  id_cliente
FROM Pedidos
)
--Seleccionar los Pediods de clientes de Monterrey
SELECT id_cliente
FROM Pedidos;

SELECT *
FROM pedidos
WHERE id_cliente in(
    SELECT id_cliente
FROM clientes
WHERE ciudad = 'Monterrey'
);

--Operador ANY
--Seleccioanr Pedidos mayores que algun pedido de Luis (id_cliente=2)
--Primero la subconsulta
SELECT total
FROM pedidos
WHERE id_cliente=2;
--Consulta principal
SELECT *
FROM pedidos
WHERE total > ANY (
SELECT total
FROM pedidos
WHERE id_cliente=2
)
--Seleccionar los pedidos mayores (total) de algun pedido de Ana
SELECT total
FROM pedidos
WHERE id_cliente=1

SELECT *
FROM pedidos
WHERE total > ANY(
SELECT total
FROM pedidos
WHERE id_cliente=1
);
--SELECCIONAR los pedidos mayores que algun pedido superior(osea total) a 500
SELECT total
FROM pedidos

WHERE total>500

SELECT *
FROM pedidos
WHERE total > ANY(
SELECT total
FROM pedidos
WHERE total>500
);

--ALL
--Seleccionar los pedidos donde el total sea mayor a todos los totales de los pedidos de luis
--1. Subconsulta
SELECT total
FROM pedidos
WHERE id_cliente=2
--2. Consulta principal
SELECT *
FROM pedidos 
WHERE total > ALL(
SELECT total
FROM pedidos
WHERE id_cliente=2
);
--Seleccionar todos los clientes donde su ID sea menor que todos los clientes de la Ciudad de mexico
SELECT id_cliente
FROM clientes
WHERE ciudad ='CDMX'

SELECT*
FROM clientes
WHERE id_cliente <ALL (
SELECT id_cliente
FROM clientes
WHERE ciudad ='CDMX'
)

--Subconsultas correlacionadas
--Seleccionar los clientes cuyo total de compras sea mayor a 1000
--Subconsulta
SELECT SUM (total)
FROM pedidos AS p

--Consulta
SELECT *
FROM clientes AS c
WHERE (
SELECT SUM (total)
FROM pedidos AS p
WHERE p.id_cliente=c.id_cliente
)> 1000;

--Esto es lo que hace la subconsulta ( ) primero, compara uno por uno
SELECT SUM (total)
FROM pedidos AS p
WHERE p.id_cliente=1

--Seleccionar todo los clientes que han hecho mas de un pedido
--Sub
SELECT COUNT (*)
FROM pedidos AS p
WHERE id_cliente=1
--Consulta
SELECT id_cliente,nombre,ciudad
FROM clientes AS c
WHERE(
SELECT COUNT (*)
FROM pedidos AS p
WHERE id_cliente=c.id_cliente
) > 1; 

--Seleccionar todos los pedidos en donde su total debe ser mayor al promedio de los totales echo por los clientes
--Sub
SELECT AVG(total)
FROM pedidos AS pe
WHERE pe.id_cliente=

--Consulta
SELECT *
FROM pedidos as p
WHERE total >(
SELECT AVG(total)
FROM pedidos AS pe
WHERE pe.id_cliente=p.id_cliente
);

--Seleccionar todos los clientes cuyo pedido maximo sea mayor a 1200
SELECT max(total)
FROM pedidos AS p
where p.id_cliente =


SELECT *
FROM clientes as c
WHERE(
SELECT max(total)
FROM pedidos AS p
where p.id_cliente =c.id_cliente
)>1200;






SELECT total
FROM pedidos


SELECT * FROM clientes;
SELECT * FROM pedidos;