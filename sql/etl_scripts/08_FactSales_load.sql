USE ContosoDB;
GO

-- ============================================================
-- 🚀 Cargar datos en FactSales desde sales.csv
-- ============================================================

-- =============================================
-- 1️⃣ Crear tabla staging temporal
-- =============================================
IF OBJECT_ID('dbo.FactSales_Staging', 'U') IS NOT NULL
    DROP TABLE dbo.FactSales_Staging;
GO

CREATE TABLE dbo.FactSales_Staging
(
    [OrderKey] VARCHAR(MAX),
    [LineNumber] VARCHAR(MAX),
    [OrderDate] VARCHAR(MAX),
    [DeliveryDate] VARCHAR(MAX),
    [CustomerKey] VARCHAR(MAX),
    [StoreKey] VARCHAR(MAX),
    [ProductKey] VARCHAR(MAX),
    [Quantity] VARCHAR(MAX),
    [UnitPrice] VARCHAR(MAX),
    [NetPrice] VARCHAR(MAX),
    [UnitCost] VARCHAR(MAX),
    [CurrencyCode] VARCHAR(MAX),
    [ExchangeRate] VARCHAR(MAX)
);
GO

-- =============================================
-- 2️⃣ BULK INSERT desde el archivo CSV
-- =============================================
BULK INSERT dbo.FactSales_Staging
FROM '/data/sales.csv'
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
INSERT INTO dbo.FactSales
    (
    OrderKey,
    LineNumber,
    OrderDate,
    DeliveryDate,
    CustomerKey,
    StoreKey,
    ProductKey,
    Quantity,
    UnitPrice,
    NetPrice,
    UnitCost,
    CurrencyCode,
    ExchangeRate
    )
SELECT
    TRY_CAST(LTRIM(RTRIM([OrderKey])) AS INT),
    TRY_CAST(LTRIM(RTRIM([LineNumber])) AS INT),
    TRY_CAST(LTRIM(RTRIM([OrderDate])) AS DATE),
    TRY_CAST(LTRIM(RTRIM([DeliveryDate])) AS DATE),
    TRY_CAST(LTRIM(RTRIM([CustomerKey])) AS INT),
    TRY_CAST(LTRIM(RTRIM([StoreKey])) AS INT),
    TRY_CAST(LTRIM(RTRIM([ProductKey])) AS INT),
    TRY_CAST(LTRIM(RTRIM([Quantity])) AS INT),
    TRY_CAST(REPLACE(LTRIM(RTRIM([UnitPrice])), ',', '.') AS DECIMAL(18,4)),
    TRY_CAST(REPLACE(LTRIM(RTRIM([NetPrice])), ',', '.') AS DECIMAL(18,4)),
    TRY_CAST(REPLACE(LTRIM(RTRIM([UnitCost])), ',', '.') AS DECIMAL(18,4)),
    UPPER(LTRIM(RTRIM([CurrencyCode]))),
    TRY_CAST(
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(LTRIM(RTRIM([ExchangeRate])), CHAR(13), ''),
                    CHAR(10), ''
                ),
                CHAR(9), ''
            ),
            ' ', ''
        ) AS DECIMAL(18,5)
    )
FROM dbo.FactSales_Staging
WHERE
    [OrderKey] IS NOT NULL
    AND [LineNumber] IS NOT NULL;
GO

-- =============================================
-- 4️⃣ Validar carga (opcional)
-- =============================================
SELECT TOP (1)
    *
FROM dbo.FactSales;
GO

-- =============================================
-- 5️⃣ Limpiar tabla staging (opcional)
-- =============================================
DROP TABLE dbo.FactSales_Staging;
GO
