USE ContosoDB;
GO

-- ============================================================
-- 🚀 Cargar datos en DimStore desde Store.csv
-- ============================================================

-- =============================================
-- 1️⃣ Crear tabla staging temporal
-- =============================================
IF OBJECT_ID('dbo.DimStore_Staging', 'U') IS NOT NULL
    DROP TABLE dbo.DimStore_Staging;
GO

CREATE TABLE dbo.DimStore_Staging
(
    StoreKey VARCHAR(MAX),
    StoreCode VARCHAR(MAX),
    GeoAreaKey VARCHAR(MAX),
    CountryCode VARCHAR(MAX),
    CountryName VARCHAR(MAX),
    State VARCHAR(MAX),
    OpenDate VARCHAR(MAX),
    CloseDate VARCHAR(MAX),
    Description VARCHAR(MAX),
    SquareMeters VARCHAR(MAX),
    Status VARCHAR(MAX)
);
GO

-- =============================================
-- 2️⃣ BULK INSERT desde el archivo CSV
-- =============================================
BULK INSERT dbo.DimStore_Staging
FROM '/data/store.csv'
WITH (
    FIRSTROW = 2,              -- Salta el encabezado
    FIELDTERMINATOR = ',',     -- Separador de campos
    ROWTERMINATOR = '\n',      -- Fin de línea (mac/Linux)
    TABLOCK
);
GO

-- =============================================
-- 3️⃣ Insertar datos en tabla final con conversión de tipos
-- =============================================
INSERT INTO dbo.DimStore
    (StoreKey, StoreCode, GeoAreaKey, CountryCode, CountryName,
     State, OpenDate, CloseDate, Description, SquareMeters, Status)
SELECT
    TRY_CAST(LTRIM(RTRIM(StoreKey)) AS INT),
    LTRIM(RTRIM(StoreCode)),
    TRY_CAST(LTRIM(RTRIM(GeoAreaKey)) AS INT),
    UPPER(LTRIM(RTRIM(CountryCode))),
    LTRIM(RTRIM(CountryName)),
    LTRIM(RTRIM(State)),
    TRY_CAST(NULLIF(LTRIM(RTRIM(OpenDate)), '') AS DATE),
    TRY_CAST(NULLIF(LTRIM(RTRIM(CloseDate)), '') AS DATE),
    LTRIM(RTRIM(Description)),
    TRY_CAST(NULLIF(LTRIM(RTRIM(SquareMeters)), '') AS DECIMAL(10,2)),
    LTRIM(RTRIM(Status))
FROM dbo.DimStore_Staging;
GO

-- =============================================
-- 4️⃣ Validar carga (opcional)
-- =============================================
SELECT TOP (10) *
FROM dbo.DimStore;
GO

-- =============================================
-- 5️⃣ Limpiar tabla staging (opcional)
-- =============================================
DROP TABLE dbo.DimStore_Staging;
GO