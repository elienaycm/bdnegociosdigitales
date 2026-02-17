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
