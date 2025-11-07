USE ContosoDB;
GO
-- ============================================================
-- 🚀 Cargar datos en DimCurrencyExchange desde currencyexchange.csv
-- ============================================================

-- =============================================
-- 1️⃣ Crear tabla staging temporal
-- =============================================
IF OBJECT_ID('dbo.CustomerStaging', 'U') IS NOT NULL
    DROP TABLE dbo.CustomerStaging;
GO

CREATE TABLE dbo.CustomerStaging
(
    CustomerKey VARCHAR(MAX),
    GeoAreaKey VARCHAR(MAX),
    StartDT VARCHAR(MAX),
    EndDT VARCHAR(MAX),
    Continent VARCHAR(MAX),
    Gender VARCHAR(MAX),
    Title VARCHAR(MAX),
    GivenName VARCHAR(MAX),
    MiddleInitial VARCHAR(MAX),
    Surname VARCHAR(MAX),
    StreetAddress VARCHAR(MAX),
    City VARCHAR(MAX),
    State VARCHAR(MAX),
    StateFull VARCHAR(MAX),
    ZipCode VARCHAR(MAX),
    Country VARCHAR(MAX),
    CountryFull VARCHAR(MAX),
    Birthday VARCHAR(MAX),
    Age VARCHAR(MAX),
    Occupation VARCHAR(MAX),
    Company VARCHAR(MAX),
    Vehicle VARCHAR(MAX),
    Latitude VARCHAR(MAX),
    Longitude VARCHAR(MAX)
);
GO

-- =============================================
-- 2️⃣ BULK INSERT desde el archivo CSV usando formato
-- =============================================
BULK INSERT dbo.CustomerStaging
FROM '/data/customer.csv' -- Ruta del archivo CSV en el contenedor de datos
WITH (
    FORMATFILE = '/data/customer.fmt', -- Ruta del archivo de formato en el contenedor de datos
    FIRSTROW = 2,
    TABLOCK
);
GO


-- 3️⃣ Insertar en tabla final Customer con conversión de tipos
-- =============================================
INSERT INTO dbo.DimCustomer
    (
    CustomerKey, GeoAreaKey, StartDT, EndDT, Continent, Gender, Title, GivenName,
    MiddleInitial, Surname, StreetAddress, City, State, StateFull, ZipCode,
    Country, CountryFull, Birthday, Age, Occupation, Company, Vehicle, Latitude, Longitude
    )
SELECT
    CAST(CustomerKey AS INT),
    CAST(GeoAreaKey AS INT),
    TRY_CAST(StartDT AS DATE),
    TRY_CAST(EndDT AS DATE),
    Continent,
    Gender,
    Title,
    GivenName,
    MiddleInitial,
    Surname,
    StreetAddress,
    City,
    State,
    StateFull,
    ZipCode,
    Country,
    CountryFull,
    TRY_CAST(Birthday AS DATE),
    TRY_CAST(Age AS INT),
    Occupation,
    Company,
    Vehicle,
    TRY_CAST(Latitude AS FLOAT),
    TRY_CAST(Longitude AS FLOAT)
FROM dbo.CustomerStaging;
GO

-- =============================================
-- 4️⃣ Validar carga (opcional)
-- =============================================
SELECT TOP 5 CustomerKey, Vehicle, Latitude, Longitude
FROM dbo.DimCustomer;
GO

-- =============================================
-- 5️⃣ Limpiar tabla staging (opcional)
-- =============================================
DROP TABLE dbo.CustomerStaging;
GO
