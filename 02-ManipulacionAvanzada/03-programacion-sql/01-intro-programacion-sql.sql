/*========================================Variables en transact-SQL============================*/
DECLARE @edad INT;
SET @edad = 21;

PRINT @edad 
SELECT @edad AS [EDAD];

DECLARE @nombre AS VARCHAR(30)='San Gallardo';
SELECT @nombre AS [Nombre];
SET @nombre ='San Adonai';
SELECT @nombre AS [Nombre];

/*========================================Ejercicios============================*/
/*
Ejercicio1.

-Declarar una variable @Precio
-Asignen el valor 150
-Calcular el IVA (16)
-Mostrar el total

*/

DECLARE @precio MONEY = 150;
DECLARE @Iva DECIMAL(10,2);
DECLARE @Total MONEY;

SET @Iva = @precio * 0.16;
SET @Total = @precio+@Iva;

SELECT 
@precio AS [Precio],
CONCAT('$',@Iva) AS [IVA(16%)], 
@Total AS [TOTAL]
/*======================================== IF/ELSE ============================*/
DECLARE @edad INT ;
SET @edad = 18;

IF @edad >= 18
    PRINT 'Eres mayor de edad';
ELSE
    PRINT 'Eres menaor de edad';
GO
/*======================================== Calificacion a 7 si es > aprovado de lo contario imprimir que esta reprovado ============================*/
DECLARE @calificacion DECIMAL (10,2) = 9.5 ;

IF @calificacion >= 0 AND @calificacion <=10
BEGIN
    IF @calificacion >=7.0
    BEGIN
        PRINT ('Aprovado')
        END
    ELSE
    BEGIN
        PRINT ('Reprovado')
        END
        END
    ELSE
BEGIN
    SELECT CONCAT(@calificacion, 'Esta fuera de rango') AS [RESPUESTA];
END
/*======================================== IWHILE ============================*/
DECLARE @limite int = 5;
DECLARE @i int = 1;

WHILE (@i <= @limite)
BEGIN
    PRINT CONCAT ('Numero: ',@i)
    SET @i = @i + 1
END