## 🐰Lenguaje Transact-SQL🐰(MSServer)
## 🪼Funfamentos Programables🪼
1. 🖥️Que es la parte programable de T-SQL?

Es todo lo que permite:
- Usar variables
- Controlar el flujo(if/else/while)
- Crear procedimientos almacenados (Store Procedures)
- Disparadores (Triggers)
- Manejar errore
- Crear Funciones
- Usar Transacciones

Es convertir SQL en un lenguaje casi C/Java pero dentro del motor de base de datos

2. 🎈Variable

Una variable almacena un valor temporal
```sql
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
```
3️⃣ IF/ELSE
📌Definicion
Permite ejecutar codigo segun condicion
``sql
/*======================================== IF/ELSE ============================*/
DECLARE @edad INT ;
SET @edad = 18;

IF @edad >= 18
    PRINT 'Eres mayor de edad';
ELSE
    PRINT 'Eres menaor de edad';
GO
/*======================================== Calificacion a 7 si es > aprovado de lo contario imprimir que esta reprovado ============================*/
```sql
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
```
4️⃣ WHILE (CICLOS)
```sql
/*======================================== WHILE ============================*/
DECLARE @limite int = 5;
DECLARE @i int = 1;

WHILE (@i <= @limite)
BEGIN
    PRINT CONCAT ('Numero: ',@i)
    SET @i = @i + 1
END
```