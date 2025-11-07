USE ContosoDB;
GO

-- ============================================================
-- 🚀 Cargar datos en FactOrderRows desde orderrows.csv
-- ============================================================

-- =============================================
-- 1️⃣ Crear tabla staging temporal
-- =============================================
IF OBJECT_ID('dbo.FactOrderRows_Staging', 'U') IS NOT NULL
    DROP TABLE dbo.FactOrderRows_Staging;
GO

CREATE TABLE dbo.FactOrderRows_Staging
(
    [OrderKey] VARCHAR(MAX),
    [LineNumber] VARCHAR(MAX),
    [ProductKey] VARCHAR(MAX),
    [Quantity] VARCHAR(MAX),
    [UnitPrice] VARCHAR(MAX),
    [NetPrice] VARCHAR(MAX),
    [UnitCost] VARCHAR(MAX)
);
GO

-- =============================================
-- 2️⃣ BULK INSERT desde el archivo CSV
-- =============================================
BULK INSERT dbo.FactOrderRows_Staging
FROM '/data/orderrows.csv'
WITH (
    FIRSTROW = 2,              
    FIELDTERMINATOR = ',',    
    ROWTERMINATOR = '\n',     
    TABLOCK
);
GO


-- =============================================
-- 3️⃣ Insertar datos en tabla final con conversión de tipos
-- =============================================
INSERT INTO dbo.FactOrderRows
    (
    OrderKey,
    LineNumber,
    ProductKey,
    Quantity,
    UnitPrice,
    NetPrice,
    UnitCost
    )
SELECT
    TRY_CAST(LTRIM(RTRIM([OrderKey])) AS INT),
    TRY_CAST(LTRIM(RTRIM([LineNumber])) AS INT),
    TRY_CAST(LTRIM(RTRIM([ProductKey])) AS INT),
    TRY_CAST(LTRIM(RTRIM([Quantity])) AS DECIMAL(18,2)),
    TRY_CAST(LTRIM(RTRIM([UnitPrice])) AS DECIMAL(18,4)),
    TRY_CAST(LTRIM(RTRIM([NetPrice])) AS DECIMAL(18,4)),
    ISNULL(
        TRY_CAST(
            REPLACE(
                REPLACE(
                    REPLACE(LTRIM(RTRIM([UnitCost])), CHAR(13), ''),  -- limpia \r
                CHAR(10), ''),                                       -- limpia \n
            ',' , '.')                                               -- convierte coma a punto
        AS DECIMAL(18,4)),
        9999.9999
    )
FROM dbo.FactOrderRows_Staging;
GO

-- =============================================
-- 4️⃣ Validar carga (opcional)
-- =============================================
SELECT TOP 10
    *
FROM dbo.FactOrderRows
GO

-- =============================================
-- 5️⃣ Limpiar tabla staging (opcional)
-- =============================================
DROP TABLE dbo.FactOrderRows_Staging;
GO