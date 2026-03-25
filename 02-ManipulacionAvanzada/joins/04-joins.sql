----JOINS------------------------------------------------------------------------
--Estructura:
--SELECT [TABLA]
--FROM
--Tablaizquierda
--Joins
--Tabla derecha
--On=campo1=campo2;

--El AS _ ES PARA crear un alias

---Inner Join = Join: son todas las coincidencias en ambas tablas, con lo que esta en el ON
--Left Join: son todos los datos de la tabla left y todos los que coinciden de la otra tabla, 
   --aqui si importa el orden: los que no coinciden se ponen en NULL
--Righ Join: son todos los datos de la tabla righ y todos los que coinciden de la otra tabla
--Full Join: todos los valores de las dos tablas los que coinciden y los que no los pone en NULL

/**



**/

--Seleccionar las categorias y sus productos
SELECT 
      categories.CategoryID, 
      categories.CategoryName,
      Products.ProductID,
      products.ProductName,
      products.UnitPrice,
      products.UnitsInStock,
      products.UnitsInStock,
      (products.UnitPrice * Products.UnitsInStock)
      AS [Precio Inventario]
FROM Categories
INNER JOIN Products
on Categories.CategoryID =products.CategoryID
WHERE categories.CategoryID = 9;

--Tarea 01,02,03 de manipulacion avanzada lo hjacemos en unlo solo en un .md en visual studio

-------------------------------------------------------------------------------------------------
--Crear una tabla a partir de una consulta
-------------------------------------------------------------------------

-- Crear una tabla a partir de una consuta 

SELECT TOP 0
	CategoryID,
	CategoryName
	INTO  categoria
	FROM categories;
	DROP TABLE categoria;

ALTER TABLE categoria
ADD CONSTRAINT pk_categoria
PRIMARY KEY (CategoryID);

INSERT INTO categoria
VALUES ('C1'),('C2'),('C3'),('C4'),('C5');

SELECT TOP 0
	ProductID AS [numero producto],
	ProductName AS [nombre_producto],
	CategoryID AS [catego_id]
FROM Products;

SELECT TOP 0
	ProductID AS [numero_producto],
	ProductName AS [nombre_producto],
	CategoryID AS [catego_id]
INTO producto
FROM Products;

DROP TABLE producto;

ALTER TABLE producto
ADD CONSTRAINT pk_producto
PRIMARY KEY (numero_producto);

ALTER TABLE producto
ADD CONSTRAINT fk_producto_categoria
FOREIGN KEY (catego_id)
REFERENCES categoria (CategoryID)
ON DELETE CASCADE;

INSERT INTO producto
VALUES ('P1',1),
		('P2',1),
		('P3',2),
		('P4',2),
		('P5',3),
		('P6',NULL);

--INNER JOIN


SELECT *
FROM categoria AS c
INNER JOIN 
producto AS P
ON c.CategoryID = p.catego_id;

--LEFT JOIN
SELECT *
FROM categoria AS c
LEFT JOIN 
producto AS P
ON c.CategoryID = p.catego_id;

-- RIGHT JOIN
SELECT *
FROM categoria AS c
RIGHT JOIN 
producto AS P
ON c.CategoryID = p.catego_id;

-- FULL JOIN
SELECT *
FROM categoria AS c
FULL JOIN 
producto AS P
ON c.CategoryID = p.catego_id;

-- SIMULAR EL RIGHT JOIN DEL QUERY ANTERIOR 
-- CON UN LEFT JOIN

SELECT c.CategoryID, c.CategoryName,
	p.numero_producto, p.nombre_producto,
	p.catego_id
FROM categoria AS c
RIGHT JOIN 
producto AS P
ON c.CategoryID = p.catego_id;


SELECT c.CategoryID, c.CategoryName,
	p.numero_producto, p.nombre_producto,
	p.catego_id
FROM producto AS p
LEFT JOIN  
categoria AS c
ON c.CategoryID = p.catego_id;

-- VISUALIZAR TODAS LAS CATEGORIAS QUE NO TIENEN PRODUCTOS 

SELECT *
FROM categoria AS c
LEFT JOIN
producto AS p
ON c.CategoryID = p.catego_id
WHERE numero_producto is null;

-- SELECCIONAR TODOS LOS PRODUCTOS QUE 
-- NO TIENE CATEGORIA

SELECT *
FROM producto AS p
LEFT JOIN
categoria AS c
ON c.CategoryID = p.catego_id
WHERE catego_id is null;

SELECT *
FROM producto;

SELECT *
FROM categoria;



--GUARDADR EN UNA TABLA DE PRODUCTOS NUEVOS TODOS AQUELLOS PRODUCTOS QUE FUERON AGREGADOS 
--RECIEMTEMENTE Y NO ESTAN EN ESTA TABLA DE APOYO

--Crear la tabla product_new apartir de products, mediante una consulta
--Paso 1
SELECT 
       TOP 0
	   ProductID as [product_number],
       ProductName AS [product_name],
	   UnitPrice as [unit_ptice],
	   UnitsInStock as [stock],
	   (UnitPrice * UnitsInStock) AS [total]
	   INTO	products_new
FROM Products

ALTER TABLE products_new
ADD CONsTRAINT pk_products_new
PRIMARY KEY ([product_number]);

SELECT 
p.ProductID, 
p.ProductName, 
p.UnitsInStock, 
(p.UnitPrice * p.UnitsInStock) AS [Total],
pw. *
FROM Products as p
LEFT JOIN products_new as pw
ON p.ProductID = pw.product_number;

INSERT INTO products_new
SELECT 
p.ProductName, 
p.UnitPrice,
p.UnitsInStock, 
(p.UnitPrice * p.UnitsInStock) AS [Total]
FROM Products as p
LEFT JOIN products_new as pw
ON p.ProductID = pw.product_number
WHERE pw.product_number IS NULL;

INSERT INTO products_new
SELECT 
p.ProductName, 
p.UnitPrice,
p.UnitsInStock, 
(p.UnitPrice * p.UnitsInStock) AS [Total]
FROM Products as p
INNER JOIN products_new as pw
ON p.ProductID = pw.product_number

SELECT*
FROM products_new;
--------------------------------------------------
--Seleccionar la descripción y el precio 
--de los productos que tengan un Stock entre 100 y 300 y
--cuya descripción comience con 'Serie'

SELECT Descripcion, Precio 
FROM Productos 
WHERE Descripcion LIKE 'Serie%' 
  AND Stock BETWEEN 100 AND 300;

--Seleccionar el Número de Pedido, la Cantidad y la 
--Descripción del producto (Unión de Pedidos y Productos)

SELECT p.Num_Pedido, p.Cantidad, pr.Descripcion 
FROM Pedidos AS p
INNER JOIN Productos AS pr 
    ON p.Fab = pr.Id_fab 
    AND p.Producto = pr.Id_producto;

--Seleccionar el Número de Pedido, Empresa del cliente
 --y Nombre del Representante (Triple Join con Importe > 15,000)

SELECT p.Num_Pedido, c.Empresa, r.Nombre
FROM Pedidos AS p
INNER JOIN Clientes AS c 
    ON p.Cliente = c.Num_Cli
INNER JOIN Representantes AS r 
    ON c.Rep_Cli = r.Num_Empl
WHERE p.Importe > 15000;

--Obtener el número de pedido, el importe y una columna calculada 
--llamada 'IVA' (que sea el 16% del importe) de todos los pedidos 
--realizados entre el 1 de enero de 1989 y el 31 de diciembre de 1989. 
--Además, obtén el Gran Total (Importe + IVA)
 --bajo el alias 'Total_Facturado'.

 SELECT 
    Num_Pedido, 
    Importe,  
    (Importe * 0.16) AS [IVA],
    (Importe + (Importe * 0.16)) AS [Total_Facturado] 
FROM Pedidos 
WHERE Fecha_Pedido BETWEEN '1989-01-01' AND '1989-12-31';


