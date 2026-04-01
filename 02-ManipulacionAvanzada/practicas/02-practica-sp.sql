USE bdpracticas;
GO

----------------------------STORE PROCEDURE----------------------------------
CREATE OR ALTER PROCEDURE dbo.usp_agregar_venta_n_productos
    @id_cliente NVARCHAR(5),
    @tabla_productos dbo.udt_ListaProductos READONLY 
AS  
BEGIN
    SET NOCOUNT ON;
    DECLARE @NuevoIdVenta INT;  

    BEGIN TRY
        BEGIN TRANSACTION;

        --SI EL CLIENTE EXISTE
        IF NOT EXISTS (SELECT 1 FROM dbo.CatCliente AS CC WHERE CC.id_cliente = @id_cliente)
        BEGIN
            PRINT 'ERROR: El cliente no existe.';
            ROLLBACK TRANSACTION; RETURN;
        END

        --TIENE QUE EXISTIR UN STOCK
        IF EXISTS (
            SELECT 1 FROM @tabla_productos AS TP
            INNER JOIN dbo.CatProducto AS CP ON TP.id_producto = CP.id_producto
            WHERE TP.cantidad > CP.existencia
        )
        BEGIN
            PRINT 'ERROR: Stock insuficiente.';
            ROLLBACK TRANSACTION; RETURN;
        END


        INSERT INTO dbo.tblVenta (id_cliente, fecha) VALUES (@id_cliente, GETDATE());
        SET @NuevoIdVenta = SCOPE_IDENTITY();

        
        INSERT INTO dbo.tblDetalleVenta (id_venta, id_producto, precio_venta, cantidad_vendida)
        SELECT @NuevoIdVenta, TP.id_producto, CP.precio, TP.cantidad
        FROM @tabla_productos AS TP
        INNER JOIN dbo.CatProducto AS CP ON TP.id_producto = CP.id_producto;

        --ACTUALIZAR STOCK
        UPDATE CP
        SET CP.existencia = CP.existencia - TP.cantidad
        FROM dbo.CatProducto AS CP
        INNER JOIN @tabla_productos AS TP ON CP.id_producto = TP.id_producto;

        COMMIT TRANSACTION;
        PRINT 'VENTA REALIZADA CON EXITO. ID: ' + CAST(@NuevoIdVenta AS VARCHAR);

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        PRINT 'OCURRIO UN ERROR: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


USE bdpracticas;
GO

-- 1. Limpiar transacciones previas por si acaso
IF @@TRANCOUNT > 0 ROLLBACK;

-- 2. Preparar carrito
DECLARE @Compra AS dbo.udt_ListaProductos;

-- Asegúrate de que los productos 1, 2 y 3 existan en CatProducto
INSERT INTO @Compra (id_producto, cantidad) VALUES (1, 1), (2, 1), (3, 1);

-- 3. Ejecutar
EXEC dbo.usp_agregar_venta_n_productos 
    @id_cliente = 'ALFKI', 
    @tabla_productos = @Compra;

-- 4. Ver resultados
SELECT * FROM dbo.tblVenta;
SELECT * FROM dbo.tblDetalleVenta;
GO