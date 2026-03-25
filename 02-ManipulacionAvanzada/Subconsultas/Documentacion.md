# Que es una subconsulta?
Una subconsulta (subquery) es un select dentro de otro SELECT. Puede devolver:
1. Un solo valor (escalar)
2. Una lista de valores (una columna, varias filas)
3. Una tabla (varias columnas y/o varias filas)
4. Segun lo que devulva, se elige el operador correcto (=, in, exists, etc).

Una subconsulta es una consulta anidada dentro de otra consulta que permine resolver problemas en varios niveles de informacion.

```
Dependiendo de donde se coloque y que retorne, cambia su comportamiento
```
### 5 grandes formas de usarlas
1. Subconsultas escalares.
2. Subconsultas con IN, ANY, ALL.
3. Subconsultas correlacionadas.
4. Subconsultas en Select.
5. Subconsultas en From (Tablas derivadas).

## 1. Escalares
Devuelven un unico valor, por eso se puden utilizar con operadores =, >,<.
Ejemplo:
```sql
SELECT p.id_pedido,c.nombre,p.fecha,p.total
FROM pedidos AS p
INNER JOIN 
clientes AS c
ON p.id_cliente=c.id_cliente
WHERE p.total=(
SELECT MAX(total)
FROM pedidos;
);
```

## 2. Subconsultas con IN, ANY, ALL.
Devuelve varios valores con una sola columna(IN)
> Seleccionar todos los clientes que han hecho pedidos
```sql
SELECT id_cliente 
FROM clientes
WHERE id_cliente in(
SELECT id_cliente 
FROM clientes
)
```
```sql
--Subqueries con IN, ANY, ALL(llevan una sola columna)
--Con ls clausua IN
--Seleccionar clientes que an echo pedios
SELECT * 
FROM clientes;


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
```
1.Seleccionar todos los clientes cuyo pedido maximo sea mayor a 1200
```sql
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
```
2. Seleccionar los Pediods de clientes de Monterrey
```sql
SELECT id_cliente
FROM Pedidos;

SELECT *
FROM pedidos
WHERE id_cliente in(
    SELECT id_cliente
FROM clientes
WHERE ciudad = 'Monterrey'
);
```

## Clausula ANY 
1. Compara un valor contra una Lista
2. La condicion se cumple con AL MENOS UNO

```sql
valor > ANY (subconculta)
```
Es decir: Mayor que al menos uno de los valores

-Seleccioanr Pedidos mayores que algun pedido de Luis (id_cliente=2)
```sql
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

```
## Clausula ALL
Se cumple contra todos los valores
```sql
valor > ALL(subconsulta)
```
- Significa: `MAYOR` que todos los valores
```sql
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
```

## Subconcultas correlacionadas
> Una subconsulta correlacionada depende de la fila actual de la consulta principal y se ejecuta una vez por cada fila
---
1. Seleccionar los clientes cuyo total de compras sea mayor a 1000

## Creacion de Vistas
1. Crear una vista que visualice el total de los importes agrupados por productos

-Esta vita es sin WHERE ni ORDER BY

1. 
```sql
CREATE OR ALTER VIEW vw_importes_productos
as
SELECT pr.Descripcion AS [Nombre Producto],
SUM(p.Importe) AS [Total],
SUM(p.Importe*1.15) AS [ImporteDescuento]
FROM Pedidos AS p
INNER JOIN Productos AS pr
ON  p.Fab = pr.Id_fab
AND p.Producto = pr.Id_producto
GROUP BY pr.Descripcion;
```
Se asigna un nombre 
```sql
CREATE OR ALTER VIEW vw_importes_productos 
```
2. 
```sql

SELECT * FROM vw_importes_productos
WHERE [Nombre Producto] LIKE '%brazo%'
AND ImporteDescuento > 34000;
```

Cuando se utiliza
```sql
SELECT * FROM vw_importes_productos
```
## 