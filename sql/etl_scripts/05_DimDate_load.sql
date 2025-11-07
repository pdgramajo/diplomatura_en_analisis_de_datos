USE ContosoDB;
GO

-- ============================================================
-- 🗓️ Cargar datos en DimDate desde date.csv
-- ============================================================

-- =============================================
-- 1️⃣ Crear tabla staging temporal
-- =============================================
IF OBJECT_ID('dbo.DimDate_Staging', 'U') IS NOT NULL
    DROP TABLE dbo.DimDate_Staging;
GO

CREATE TABLE dbo.DimDate_Staging
(
    [Date] NVARCHAR(20),
    [DateKey] NVARCHAR(20),
    [Year] NVARCHAR(10),
    [YearQuarter] NVARCHAR(10),
    [YearQuarterNumber] NVARCHAR(10),
    [Quarter] NVARCHAR(5),
    [YearMonth] NVARCHAR(20),
    [YearMonthShort] NVARCHAR(15),
    [YearMonthNumber] NVARCHAR(10),
    [Month] NVARCHAR(15),
    [MonthShort] NVARCHAR(10),
    [MonthNumber] NVARCHAR(10),
    [DayOfWeek] NVARCHAR(15),
    [DayOfWeekShort] NVARCHAR(10),
    [DayOfWeekNumber] NVARCHAR(10),
    [WorkingDay] NVARCHAR(5),
    [WorkingDayNumber] NVARCHAR(5)
);
GO

-- =============================================
-- 2️⃣ Cargar datos desde el CSV
-- =============================================
BULK INSERT dbo.DimDate_Staging
FROM '/data/date.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
GO

-- =============================================
-- 3️⃣ Insertar datos transformados en la tabla final
-- =============================================
INSERT INTO dbo.DimDate
(
    [Date],
    [DateKey],
    [Year],
    [YearQuarter],
    [YearQuarterNumber],
    [Quarter],
    [YearMonth],
    [YearMonthShort],
    [YearMonthNumber],
    [Month],
    [MonthShort],
    [MonthNumber],
    [DayOfWeek],
    [DayOfWeekShort],
    [DayOfWeekNumber],
    [WorkingDay],
    [WorkingDayNumber]
)
SELECT
    TRY_CAST([Date] AS DATE),
    TRY_CAST([DateKey] AS INT),
    TRY_CAST([Year] AS INT),
    [YearQuarter],
    TRY_CAST([YearQuarterNumber] AS INT),
    [Quarter],
    [YearMonth],
    [YearMonthShort],
    TRY_CAST([YearMonthNumber] AS INT),
    [Month],
    [MonthShort],
    TRY_CAST([MonthNumber] AS INT),
    [DayOfWeek],
    [DayOfWeekShort],
    TRY_CAST([DayOfWeekNumber] AS INT),
    TRY_CAST([WorkingDay] AS BIT),
    TRY_CAST([WorkingDayNumber] AS INT)
FROM dbo.DimDate_Staging;
GO

-- =============================================
-- 4️⃣ Validar los datos cargados
-- =============================================
SELECT TOP 10 * FROM dbo.DimDate;
GO

-- =============================================
-- 5️⃣ Limpiar la tabla staging
-- =============================================
DROP TABLE dbo.DimDate_Staging;
GO