USE ContosoDB;
GO
-- ============================================================
-- 🚀 Cargar datos en DimCurrencyExchange desde currencyexchange.csv
-- ============================================================

-- =============================================
-- 1️⃣ Crear tabla staging temporal
-- =============================================
IF OBJECT_ID('dbo.DimCurrencyExchange_Staging', 'U') IS NOT NULL
    DROP TABLE dbo.DimCurrencyExchange_Staging;
GO

CREATE TABLE dbo.DimCurrencyExchange_Staging
(
    [Date] VARCHAR(MAX),
    [FromCurrency] VARCHAR(MAX),
    [ToCurrency] VARCHAR(MAX),
    [Exchange] VARCHAR(MAX)
);
GO

-- =============================================
-- 2️⃣ BULK INSERT desde el archivo CSV
-- =============================================
BULK INSERT dbo.DimCurrencyExchange_Staging
FROM '/data/currencyexchange.csv'
WITH (
    FIRSTROW = 2,              -- salta el encabezado
    FIELDTERMINATOR = ',',     -- separador de campos
    ROWTERMINATOR = '\n',      -- fin de línea
    TABLOCK
);
GO

-- =============================================
-- 3️⃣ Insertar datos en tabla final con conversión de tipos
-- =============================================
INSERT INTO dbo.DimCurrencyExchange
    (ExchangeDate, FromCurrency, ToCurrency, ExchangeRate)
SELECT
    TRY_CAST([Date] AS DATE),
    UPPER(LTRIM(RTRIM([FromCurrency]))),
    UPPER(LTRIM(RTRIM([ToCurrency]))),
    -- TRY_CAST(REPLACE([Exchange], ',', '.') AS DECIMAL(18,5))
    -- 9999.99999 -- Valor temporal para evitar errores de conversión
    --  ISNULL(
    --     TRY_CAST(REPLACE([Exchange], ',', '.') AS DECIMAL(18,5)),
    --     9999.99999
    -- )
    ISNULL(
        TRY_CAST(
            REPLACE(
                REPLACE(
                    REPLACE(LTRIM(RTRIM([Exchange])), CHAR(13), ''), -- limpia \r
                CHAR(10), ''),                                      -- limpia \n
            '.' , '.') AS DECIMAL(18,5)
        ),
        9999.99999
    )
FROM dbo.DimCurrencyExchange_Staging;
GO

-- =============================================
-- 4️⃣ Validar carga (opcional)
-- =============================================
SELECT top(10) *
FROM dbo.DimCurrencyExchange
-- WHERE ExchangeRate = 9999.99999;
GO

-- =============================================
-- 5️⃣ Limpiar tabla staging (opcional)
-- =============================================
DROP TABLE dbo.DimCurrencyExchange_Staging;
GO
