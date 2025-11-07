USE ContosoDB;
GO

-- ============================================================
-- 🗓️ Crear tabla DimDate
-- ============================================================

IF OBJECT_ID('dbo.DimDate', 'U') IS NOT NULL
    DROP TABLE dbo.DimDate;
GO

CREATE TABLE dbo.DimDate
(
    [Date] DATE NOT NULL,
    [DateKey] INT NOT NULL PRIMARY KEY,
    [Year] INT,
    [YearQuarter] NVARCHAR(10),
    [YearQuarterNumber] INT,
    [Quarter] NVARCHAR(5),
    [YearMonth] NVARCHAR(20),
    [YearMonthShort] NVARCHAR(15),
    [YearMonthNumber] INT,
    [Month] NVARCHAR(15),
    [MonthShort] NVARCHAR(10),
    [MonthNumber] INT,
    [DayOfWeek] NVARCHAR(15),
    [DayOfWeekShort] NVARCHAR(10),
    [DayOfWeekNumber] INT,
    [WorkingDay] BIT,
    [WorkingDayNumber] INT
);
GO