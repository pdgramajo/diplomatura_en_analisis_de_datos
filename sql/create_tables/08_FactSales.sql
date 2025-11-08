USE ContosoDB;
GO

-- =============================================
-- 🧱 Crear tabla FactSales
-- =============================================
IF OBJECT_ID('dbo.FactSales', 'U') IS NOT NULL
    DROP TABLE dbo.FactSales;
GO

CREATE TABLE dbo.FactSales
(
    OrderKey INT NOT NULL,
    LineNumber INT NOT NULL,
    OrderDate DATE,
    DeliveryDate DATE,
    CustomerKey INT,
    StoreKey INT,
    ProductKey INT,
    Quantity INT,
    UnitPrice DECIMAL(18,4),
    NetPrice DECIMAL(18,4),
    UnitCost DECIMAL(18,4),
    CurrencyCode VARCHAR(10),
    ExchangeRate DECIMAL(18,5),
    CONSTRAINT PK_FactSales PRIMARY KEY (OrderKey, LineNumber)
);
GO