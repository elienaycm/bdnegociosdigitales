--D1
SELECT *
FROM Representantes;
SELECT e.Nombre AS [Empleado], 
 j.Nombre AS [Jefe],
 e.Puesto, 
 e.Fecha_Contrato
FROM Representantes AS e
LEFT JOIN Representantes AS j ON e.Jefe = j.Num_Empl
ORDER BY e.Nombre ASC;
--
SELECT 
    e.Nombre AS [Empleado], 
    j.Nombre AS [Jefe], 
    e.Puesto, 
    e.Fecha_Contrato
FROM Representantes AS e
LEFT JOIN Representantes AS j ON e.Jefe = j.Num_Empl
ORDER BY e.Nombre ASC;
--D2
SELECT r.Nombre [Representante], 
r.Puesto[Jefe Ventas],o.Ciudad,
o.Region,r.Cuota, r.Ventas[VP Ventas]
FROM Representantes AS r INNER JOIN Oficinas AS O 
ON r.Oficina_Rep=o.Oficina
ORDER BY o.Region, o.Ciudad,r.Nombre ;
--
SELECT 
    r.Nombre, r.Puesto, o.Ciudad, o.Region, r.Cuota, r.Ventas
FROM Representantes AS r
INNER JOIN Oficinas AS o ON r.Oficina_Rep = o.Oficina
WHERE r.Puesto IN ('Representante', 'Jefe Ventas', 'VP Ventas') 
  AND r.Oficina_Rep IS NOT NULL
ORDER BY o.Region, o.Ciudad, r.Nombre;
--D3
SELECT c.Num_Cli, c.Empresa,p.Producto AS [Productos Distintos]
FROM Clientes AS c INNER JOIN Pedidos AS p On c.Rep_Cli = p.Rep
WHERE p.Producto >=2
ORDER BY [Productos Distintos] DESC,c.Empresa ASC; 
--
SELECT 
    c.Num_Cli, 
    c.Empresa, 
    COUNT(DISTINCT p.Fab + p.Producto) AS [ProductosDistintos]
FROM Clientes AS c
INNER JOIN Pedidos AS p ON c.Num_Cli = p.Cliente
GROUP BY c.Num_Cli, c.Empresa
HAVING COUNT(DISTINCT p.Fab + p.Producto) >= 2
ORDER BY [ProductosDistintos] DESC, c.Empresa ASC;
--D4
SELECT Id_fab, Id_Producto, Descripcion, Precio,Stock
FROM Productos
WHERE Descripcion LIKE '%brazo%' AND Precio BETWEEN 400 AND 2000
ORDER BY Precio DESC 
--D5
SELECT COUNT(p.Num_Pedido), COUNT (p.Importe ) AS [Total Importe]
FROM Oficinas AS o INNER JOIN Representantes AS r ON o.Oficina =Oficina_Rep AND o.Ventas =r.Ventas
INNER JOIN Pedidos AS p ON p.Rep=r.Nombre
GROUP BY o.Region 
HAVING COUNT (p.Importe ) >= 30000
ORDER BY p.Importe DESC;
--
SELECT 
    o.Region, 
    COUNT(p.Num_Pedido) AS [NumPedidos], 
    SUM(p.Importe) AS [TotalImporte]
FROM Oficinas AS o
INNER JOIN Representantes AS r ON o.Oficina = r.Oficina_Rep
INNER JOIN Pedidos AS p ON r.Num_Empl = p.Rep
GROUP BY o.Region
HAVING SUM(p.Importe) >= 30000
ORDER BY [TotalImporte] DESC;
--D6
SELECT Num_Empl, Nombre,Cuota,Ventas
FROM Representantes
WHERE Cuota 
--D7
CREATE OR ALTER VIEW vw_PedidosPorCiudad_D
as
SELECT r.Num_Empl, r.Nombre,r. r.Cuota, r.Ventas
FROM Representantes AS r
WHERE ((r.Ventas/r.Cuota)*100) AS [Cumplimiento]
--
-- D7: Vista de Cumplimiento (Basada en la lógica de D6)
CREATE OR ALTER VIEW vw_CumplimientoRepresentantes_D AS
SELECT 
    Num_Empl, 
    Nombre, 
    Cuota, 
    Ventas,
    (Ventas / Cuota) * 100 AS [PorcentajeCumplimiento]
FROM Representantes
WHERE Cuota > 0 AND Cuota IS NOT NULL;
--D8
CREATE OR ALTER VIEW vw_PedidosPorCiudad_D
as
SELECT o.Ciudad, o.Region,COUNT (p.Num_Pedido)
FROM Oficinas AS o INNER JOIN Representantes AS r ON o.Oficina= r.Oficina_Rep
INNER JOIN Pedidos AS p ON r.Puesto= p.Rep
GROUP BY p.Num_Pedido >=2;
--
CREATE OR ALTER VIEW vw_PedidosPorCiudad_D AS
SELECT o.Ciudad, o.Region,
        COUNT(p.Num_Pedido) AS [TotalPedidos]
FROM Oficinas AS o
INNER JOIN Representantes AS r ON o.Oficina=r.Oficina_Rep
INNER JOIN Pedidos AS p ON r.Num_Empl = p.Rep
GROUP BY o.Ciudad,o.Region

