USE ContosoDB;
GO

-- ============================================================
-- 🚀 Cargar datos en FactOrders desde orders.csv
-- ============================================================

-- =============================================
-- 1️⃣ Crear tabla staging temporal
-- =============================================
IF OBJECT_ID('dbo.FactOrders_Staging', 'U') IS NOT NULL
    DROP TABLE dbo.FactOrders_Staging;
GO

CREATE TABLE dbo.FactOrders_Staging
(
    [OrderKey] VARCHAR(MAX),
    [CustomerKey] VARCHAR(MAX),
    [StoreKey] VARCHAR(MAX),
    [OrderDate] VARCHAR(MAX),
    [DeliveryDate] VARCHAR(MAX),
    [CurrencyCode] VARCHAR(MAX)
);
GO

-- =============================================
-- 2️⃣ BULK INSERT desde el archivo CSV
-- =============================================
BULK INSERT dbo.FactOrders_Staging
FROM '/data/orders.csv'
WITH (
    FIRSTROW = 2,              -- salta el encabezado
    FIELDTERMINATOR = ',',     -- separador de campos
    ROWTERMINATOR = '\n',      -- fin de línea (Linux/Mac)
    TABLOCK
);
GO

-- =============================================
-- 3️⃣ Insertar datos en tabla final con conversión de tipos
-- =============================================
INSERT INTO dbo.FactOrders
    (OrderKey, CustomerKey, StoreKey, OrderDate, DeliveryDate, CurrencyCode)
SELECT
    TRY_CAST(LTRIM(RTRIM([OrderKey])) AS INT),
    TRY_CAST(LTRIM(RTRIM([CustomerKey])) AS INT),
    TRY_CAST(LTRIM(RTRIM([StoreKey])) AS INT),
    TRY_CAST(LTRIM(RTRIM([OrderDate])) AS DATE),
    TRY_CAST(LTRIM(RTRIM([DeliveryDate])) AS DATE),
    UPPER(LTRIM(RTRIM([CurrencyCode])))
FROM dbo.FactOrders_Staging;
GO

-- =============================================
-- 4️⃣ Validar carga (opcional)
-- =============================================
SELECT TOP (10) *
FROM dbo.FactOrders;
GO

-- =============================================
-- 5️⃣ Limpiar tabla staging (opcional)
-- =============================================
DROP TABLE dbo.FactOrders_Staging;
GO