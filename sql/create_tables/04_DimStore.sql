USE ContosoDB;
GO

-- =============================================
-- Crear tabla DimStore
-- =============================================
IF OBJECT_ID('dbo.DimStore', 'U') IS NOT NULL
    DROP TABLE dbo.DimStore;
GO

CREATE TABLE dbo.DimStore
(
    StoreKey INT PRIMARY KEY,
    StoreCode VARCHAR(20),
    GeoAreaKey INT,
    CountryCode CHAR(2),
    CountryName VARCHAR(50),
    State VARCHAR(100),
    OpenDate DATE,
    CloseDate DATE NULL,
    Description VARCHAR(255),
    SquareMeters DECIMAL(10,2) NULL,
    Status VARCHAR(20)
);
GO