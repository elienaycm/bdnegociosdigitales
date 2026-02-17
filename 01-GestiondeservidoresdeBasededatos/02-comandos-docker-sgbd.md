 # Documentacion de Comandos de Contenedor Docker para SGBD
## Contenedores sin Volumen
``` shell
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=SqlPassword2026" \
   -p 1435:1433 --name servidorsqlserver \
   -d \
   mcr.microsoft.com/mssql/server:2019-latest
   ```
## Comando para contenedor de SQL Server con Volumen
``` shell
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=SqlPassword2026" \
   -p 1435:1433 --name servidorsqlserver \
   -v v-mssqlevnd:/var/opt/mssql \
   -d \
   mcr.microsoft.com/mssql/server:2019-latest
   ```
   /var/opt/mssql/data






   CREATE DATABASE bdevnd;
GO

USE bdevnd;
GO

CREATE TABLE tbl1(
id INT not null IDENTITY(1,1),
nombre NVARCHAR(20) not null,
CONSTRAINT pk_tbl1
PRIMARY KEY (id)
);
GO

INSERT INTO tbl1
VALUES ('Docker'),
       ('Git'),
       ('Github'),
       ('Postgres');
GO

SELECT *
FROM tbl1;

SELECT nombre
FROM tbl1;
