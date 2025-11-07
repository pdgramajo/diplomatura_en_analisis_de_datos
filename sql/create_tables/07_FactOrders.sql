USE ContosoDB;
GO

-- ============================================================
-- 🚀 Cargar datos en FactOrders desde orders.csv
-- ============================================================

-- =============================================
-- 1️⃣ Crear tabla final FactOrders
-- =============================================
IF OBJECT_ID('dbo.FactOrders', 'U') IS NOT NULL
    DROP TABLE dbo.FactOrders;
GO

CREATE TABLE dbo.FactOrders
(
    OrderKey INT PRIMARY KEY,
    CustomerKey INT,
    StoreKey INT,
    OrderDate DATE,
    DeliveryDate DATE,
    CurrencyCode VARCHAR(10)
);
GO