# Triggers en SQLSERVER

## 1. Que es un trigger?

Un trigger (disparador) es un bloque de codigo SQL que se ejecuta automaticamente cuando ocurre un evento en una tabla.

🍭 Eventos pricipales:
    -Insert
    -Update
    -Delete
Nota: No se ejecutan manualmente,se activan solos

## 2. Para que sirven
    -Validaciones
    -Auditoria (guardar historial)
    -Reglas de negocio
    -Automatizacion

## 3. Tipos de Triggers en SQL Server
    -AFTER TRIGGER
        Se ejecuta despues del evento.
    -INSTEAD OF TRIGGER
        Remplaza la operacion original.

## 4. Sintaxis basica
    
    ```sql
    CREATE OR ALTER TRIGGER nombre_trigger
    ON nombre_tabla
    AFTER INSERT
    AS
    BEGIN
    END;
    ```

## 5. Tablas especiales

| Título Columna A | Título Columna B |
| :--- | :--- |
| inserted | Nuevos Datos |
| deleted | Datos anteriores |