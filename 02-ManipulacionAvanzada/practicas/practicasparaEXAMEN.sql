DROP DATABASE bdpracticas;
GO

--------------------------------------------------------
--Ejercicio 1 Crear base de tados y tabla
CREATE DATABASE TiendaMacotas;
GO

USE TiendaMacotas
GO

CREATE TABLE Macotas(
    id_mascota INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(30),
    especie VARCHAR(20),
    precio DECIMAL(10,2)
);
--Ejer 2 Variables y un IF de
DECLARE @edadMascota INT
SET @edadMascota = 2
IF (@edadMascota < 1)
BEGIN
    PRINT 'Es un chachorro';
    END
    ELSE
    BEGIN
        PRINT 'Es un adulto';
    END
--Ejer 3 Insertar
INSERT INTO Macotas (nombre, especie, precio) VALUES ('Pepita', 'Perro', 150.00);
INSERT INTO Macotas (nombre, especie, precio) VALUES ('Landy', 'Perro', 180.00);
INSERT INTO Macotas (nombre, especie, precio) VALUES ('Benito', 'Gato', 450.00);
--Consultar con filtros
DECLARE @especieBusqueda VARCHAR(20)
SET @especieBusqueda = 'Perro';
--aqui decimos que tabla consultar
SELECT * FROM Macotas
WHERE especie = @especieBusqueda;
--Ejer 4 Ciclo WHILE
DECLARE @contador INT
SET @contador=1;
WHILE (@contador<=5)
BEGIN
    PRINT '¡Bienvenidos a la Tienda!'
    SET @contador = @contador + 1;
END
--Ejer 5 CAST
DECLARE @stock INT
SET @stock = 20
BEGIN
    PRINT 'El inventario actual es: ' + CAST(@stock AS VARCHAR);
END
--TRY-CATCH Y TRANSACTION
BEGIN TRY
    BEGIN TRANSACTION;
    UPDATE Macotas
    SET precio = 200.00
    WHERE id_mascota= 1;
    select 1/0;
    COMMIT;
END TRY
BEGIN CATCH
ROLLBACK;
PRINT 'Error detectado, deshaciendo cambios'
END CATCH
GO
--Final STORE PROCEDURE
/*
Crea un procedimiento llamado usp_ActualizarPrecio que reciba dos parámetros:
-@id (un INT).
-@nuevoPrecio (un DECIMAL).

Adentro del procedimiento debe haber:
1.Un IF que revise si el ID existe (IF EXISTS (SELECT 1 FROM Mascotas WHERE id_mascota = @id)).
2.Si NO existe, que imprima 'Error: Mascota no encontrada'.
3.Si SÍ existe, que haga el UPDATE que acabas de escribir arriba (con su TRY...CATCH y su TRANSACTION).
*/
CREATE OR ALTER PROC usp_ActualizarPrecio
    @id INT,
    @nuevoPrecio DECIMAL(10,2)
AS 
BEGIN
    SET NOCOUNT ON; -- Mejora el rendimiento al no enviar mensajes de filas afectadas al cliente

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Realizamos el UPDATE directamente
        UPDATE Macotas
        SET precio = @nuevoPrecio
        WHERE id_mascota = @id;

        -- Si @@ROWCOUNT es 0, significa que el ID no existía
        IF @@ROWCOUNT = 0
        BEGIN
            ROLLBACK TRANSACTION;
            PRINT 'Error: La mascota con ID ' + CAST(@id AS VARCHAR) + ' no existe.';
        END
        ELSE
        BEGIN
            COMMIT TRANSACTION;
            PRINT 'Precio actualizado con éxito.';
        END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        PRINT 'Error detectado: ' + ERROR_MESSAGE();
    END CATCH
END
GO
--Para actualizar la mascota con ID 5 a un precio de 45.99
EXEC usp_ActualizarPrecio @id = 2, @nuevoPrecio = 45.99;
------------------------EJERCICIO--------------------------
----------------------------2------------------------------
--Ejer 1
CREATE DATABASE ClinicaVeterinaria
GO
USE ClinicaVeterinaria
GO
CREATE TABLE Pacientes(
    id_paciente INT PRIMARY KEY IDENTITY(100,1), 
    -- Aquí era el cambio (Inicio, Incremento)
    nombre_animal VARCHAR(50) NOT NULL,
    tipo_especie VARCHAR(30),
    fecha_ingreso DATETIME DEFAULT GETDATE(),
    costo_consulta DECIMAL(10,2)

);
--Ejer 2
INSERT INTO Pacientes (nombre_animal, tipo_especie,costo_consulta) VALUES ('Thor','Canino',150.50)
DECLARE @ultimo_id INT;
SET @ultimo_id = @@IDENTITY;-- Esta es la función que captura el último ID
BEGIN
    PRINT 'El paciente registrado tiene el código: ' + CAST(@ultimo_id AS VARCHAR);
END
    --Ejer 2.1
    /*1.Inserte un nuevo paciente con los siguientes datos: Nombre: 'Michi', Especie: 'Felino', Costo: $80.00.
    2.Declare una variable de tipo entero llamada @ID_Generado.
    3.Capture el valor del último ID insertado en dicha variable (usando @@IDENTITY).
    4.Declare una segunda variable de tipo VARCHAR(100) llamada @MensajeFinal.
    5.Asigne a la variable @MensajeFinal la frase: "Confirmación: El paciente Michi ha sido guardado con el ID #" seguido del valor de la variable @ID_Generado. (No olvides el CAST).
    6.Imprima el contenido de la variable @MensajeFinal.*/
    INSERT INTO Pacientes (nombre_animal, tipo_especie,costo_consulta) VALUES ('Michi','Felino',80.00)
    DECLARE @ID_Generado INT;
    SET @ID_Generado = @@IDENTITY
    DECLARE @MensajeFinal VARCHAR(100);
    SET @MensajeFinal = 'Confirmación: El paciente Michi ha sido guardado con el ID #' + CAST(@ID_Generado AS VARCHAR)
    BEGIN
        PRINT @MensajeFinal
    END
--Ejer 3 IF/ELSE
-- 1. Declaramos las variables
DECLARE @CostoLimite DECIMAL(10,2) = 100.00;
DECLARE @Conteo INT;

-- 2. ASIGNACIÓN: Aquí guardamos el resultado del conteo en la variable
SELECT @Conteo = COUNT(*) 
FROM Pacientes 
WHERE costo_consulta > @CostoLimite;

-- 3. EVALUACIÓN: El IF para tomar la decisión
IF (@Conteo > 0)
BEGIN
    PRINT 'Atención: Existen ' + CAST(@Conteo AS VARCHAR) + ' pacientes con costos elevados.';
    PRINT CONCAT('Atención: Existen ', @Conteo, ' pacientes con costos elevados.');
END
ELSE
BEGIN
    PRINT 'Todos los costos se encuentran bajo el límite establecido.';
END

