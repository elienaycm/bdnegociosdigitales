
--Crea una base de datos
CREATE DATABASE tienda;
GO
USE tienda;
--Crear tabla cliente 
CREATE TABLE cliente(
id int not null,
nombre nvarchar(30) not null,
apaterno nvarchar(10)not null,
amaterno nvarchar(10)null,
sexo nchar(1) not null,
edad int not null,
direccion nvarchar (80) not null,
rfc nvarchar (20) not null,
limitedecredito money not null default 500.0,
);
GO

--Restricciones

CREATE TABLE clientes_2(
 cliente_id INT NOT NULL PRIMARY KEY,
 nombre NVARCHAR(30),
 apellido_paterno NVARCHAR(20) NOT NULL,
 apellido_materno NVARCHAR(20) NULL,
 edad INT NOT NULL,
 fecha_nacimiento DATE NOT NULL,
 limite_credito MONEY NOT NULL
 fecha_registro DATE DEFAULT GETDATE()
);
GO

INSERT INTO clientes
VALUES (3,'GOKU','LINTERNA','SUPERMAN', 450,'1578-01-17', 100);

INSERT INTO clientes
VALUES (2,'PANCRACIO','RIVERO','PATROCLO', 20,'1578-01-17', 100);

INSERT INTO clientes (nombre, cliente_id, limite_credito,fecha_nacimiento,apellido_paterno)
VALUES (5,'Arcadia', 3, 4500, '2000-01-22','Ramirez', 26)

INSERT INTO clientes
VALUES (4,'Vanesa','Buena Vista', 'ojo', 26, '2000-04-25', 3000)

INSERT INTO clientes
VALUES
(6, 'Soyla', 'Vaca', 'Del Corral', 42, '1983-04-06',78955),
(7, 'Voyla', 'Laca', 'Del Toro', 690, '1956-04-08',7865);


SELECT *
FROM clientes;

SELECT cliente_id, nombre, edad, limite_credito
FROM clientes;

SELECT GETDATE()--Obtiene la fecha del sistema

CREATE TABLE clientes_2(
cliente_id INT NOT NULL IDENTITY(1,1), 
nombre NVARCHAR(50) NOT NULL,
edad INT NOT NULL,
fecha_registro DATE DEFAULT GETDATE(),
limite_credito MONEY NOT NULL,
CONSTRAINT pk_clientes_2
PRIMARY KEY (cliente_id),
);
SELECT *
FROM clientes_2;

INSERT INTO clientes_2
VALUES ('Chespirito',78, DEFAULT,45500);

INSERT INTO clientes_2 (nombre, edad, limite_credito)
VALUES ('Batman', 45, 890000);

INSERT INTO clientes_2
VALUES ('Robin',35,'2026-01-19',89.32);

INSERT INTO clientes_2 (limite_credito,edad,nombre, fecha_registro)
VALUES (12.33,24,'Batman','2026-05-19' );

CREATE TABLE clientes_3(
 cliente_id INT NOT NULL PRIMARY KEY,
 nombre NVARCHAR(30),
 apellido_paterno NVARCHAR(20) NOT NULL,
 apellido_materno NVARCHAR(20) NULL,
 edad INT NOT NULL,
 fecha_nacimiento DATE NOT NULL,
 limite_credito MONEY NOT NULL
);
CREATE TABLE suppliers(
supplier_id int not null identity(1,1),
[name] nvarchar(30) not null,
date_register date not null DEFAULT GETDATE(),
tipo char(1) not null,
credit_limit money not null,
CONSTRAINT pk_suppliers
PRIMARY KEY (supplier_id),
CONSTRAINT unique_name
UNIQUE ([name]),
CONSTRAINT chk_credit_limit
CHECK (credit_limit > 0.0 and credit_limit <=50000),
CONSTRAINT chk_tipo
CHECK (tipo IN ('A','B','C'))
);

SELECT*
FROM suppliers;

INSERT INTO suppliers
VALUES (UPPER('bimbo'), DEFAULT,UPPER('c'),45000);

INSERT INTO suppliers
VALUES (UPPER('tia rosa'), '2026-01-21',UPPER('a'),49999.9999);

INSERT INTO suppliers ([name], tipo, credit_limit)
VALUES (UPPER('tia mensa'),UPPER('a'),49999.9999);

--Crear BD dborders
CREATE DATABASE dborders;
GO

USE dborders;
GO

--Crear tabla

CREATE TABLE customers(
customer_id INT NOT NULL IDENTITY(1,1),
first_name NVARCHAR(20) NOT NULL,
last_name NVARCHAR(30),
[address] NVARCHAR(80) NOT NULL,
number int,
CONsTRAINT pk_customers
PRIMARY KEY (customer_id)
);

CREATE TABLE suppliers(
supplier_id int not null,
[name] nvarchar(30) not null,
date_register date not null DEFAULT GETDATE(),
tipo char(1) not null,
credit_limit money not null,
CONSTRAINT pk_suppliers
PRIMARY KEY (supplier_id),
CONSTRAINT unique_name
UNIQUE ([name]),
CONSTRAINT chk_credit_limit
CHECK (credit_limit > 0.0 and credit_limit <=50000),
CONSTRAINT chk_tipo
CHECK (tipo IN ('A','B','C'))
);


DROP TABLE products;
DROP TABLE suppliers;


CREATE TABLE products(
product_id INT NOT NULL IDENTITY(1,1),
[name] NVARCHAR (40) NOT NULL,
quantity int NOT NULL,
unit_price money NOT NULL,
supplier_id int,
CONSTRAINT pk_products
PRIMARY KEY (product_id),
CONSTRAINT unique_name_name_products
unique ([name]),
CONSTRAINT chk_quantity
CHECK (quantity between 1 AND 100),
CONSTRAINT chk_unitprice
CHECK (unit_price > 0 and unit_price <= 100000),
CONSTRAINT fk_products_suppliers
FOREIGN KEY (supplier_id)
REFERENCES suppliers (supplier_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
);
GO

ALTER TABLE products
DROP CONSTRAINT fk_products_suppliers;

UPDATE products
SET supplier_id = null;

DROP TABLE suppliers


--Permite cambiar la estructura de una columna en la tabla
ALTER TABLE products
ALTER COLUMN supplier_id INT NULL;

--DROP TABLE PRODUCTS
DROP TABLE products;

INSERT INTO suppliers
VALUES (1,UPPER('Chino S.A'), DEFAULT,UPPER('c'),45000);

INSERT INTO suppliers
VALUES (2,UPPER('Chaclotas'), '2026-01-21',UPPER('a'),49999.9999);

INSERT INTO suppliers (supplier_id,[name], tipo, credit_limit)
VALUES (3,UPPER('rama_ma'),UPPER('a'),49999.9999);

SELECT*
FROM suppliers;

INSERT INTO products
VALUES ('Papas', 10, 5.3,1);

INSERT INTO products
VALUES ('Rollos primavera', 20, 100,1);

INSERT INTO products
VALUES ('Chanclas pata de gallo', 50, 20,10);

INSERT INTO products
VALUES ('Chanclas buenas', 30, 56.7,10),
('Ramita chiquita', 56, 78.23,3);

INSERT INTO products
VALUES ('Azulito', 100, 15.3, NULL);

--Comprobacion de ON DELETE NO ACTION

--Eliminar los hijos
DELETE FROM products
WHERE supplier_id = 1;

--Eliminar al padre
DELETE FROM suppliers
WHERE supplier_id = 1;


--Comprobar el UPDATE NO ACTION
UPDATE products
SET supplier_id = null
WHERE supplier_id = 2;

UPDATE suppliers
SET supplier_id = 10
WHERE supplier_id = 2;

UPDATE products
SET supplier_id = 10
WHERE product_id in (3,4);

SELECT *
FROM products;

SELECT*
FROM suppliers;

------------------------------------------------------Cambias a SET NULL---------------------------------------

CREATE TABLE products(
product_id INT NOT NULL IDENTITY(1,1),
[name] NVARCHAR (40) NOT NULL,
quantity int NOT NULL,
unit_price money NOT NULL,
supplier_id int,
CONSTRAINT pk_products
PRIMARY KEY (product_id),
CONSTRAINT unique_name_name_products
unique ([name]),
CONSTRAINT chk_quantity
CHECK (quantity between 1 AND 100),
CONSTRAINT chk_unitprice
CHECK (unit_price > 0 and unit_price <= 100000),
CONSTRAINT fk_products_suppliers
FOREIGN KEY (supplier_id)
REFERENCES suppliers (supplier_id)
ON DELETE SET NULL
ON UPDATE SET NULL
);


--------Compronar ON DELETE SET NULL--------------

DELETE suppliers
WHERE supplier_id = 10

----------Comprobar ON UPDATE SET NULL------

UPDATE suppliers
SET supplier_id = 20
WHERE supplier_id = 1;


SELECT *
FROM products;

SELECT*
FROM suppliers;
