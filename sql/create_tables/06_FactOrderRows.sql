USE ContosoDB;
GO

-- =============================================
-- 🧱 Crear tabla FactOrderRows
-- =============================================
IF OBJECT_ID('dbo.FactOrderRows', 'U') IS NOT NULL
    DROP TABLE dbo.FactOrderRows;
GO

CREATE TABLE dbo.FactOrderRows
(
    OrderKey INT NOT NULL,              -- Clave que referencia a Orders
    LineNumber INT NOT NULL,            -- Número de línea dentro de la orden
    ProductKey INT NOT NULL,            -- Clave que referencia a Product
    Quantity DECIMAL(18,2) NOT NULL,    -- Cantidad vendida
    UnitPrice DECIMAL(18,4) NOT NULL,   -- Precio unitario de venta
    NetPrice DECIMAL(18,4) NOT NULL,    -- Precio total neto (por línea)
    UnitCost DECIMAL(18,4) NOT NULL,    -- Costo unitario del producto
    CONSTRAINT PK_FactOrderRows PRIMARY KEY (OrderKey, LineNumber)  -- PK compuesta
);
GO