
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

CREATE TABLE clientes(
 cliente_id INT NOT NULL PRIMARY KEY,
 nombre NVARCHAR(30),
 apellido_paterno NVARCHAR(20) NOT NULL,
 apellido_materno NVARCHAR(20) NULL,
 edad INT NOT NULL,
 fecha_nacimiento DATE NOT NULL,
 limite_credito MONEY NOT NULL
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
