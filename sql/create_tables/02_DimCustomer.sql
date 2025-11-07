USE ContosoDB;
GO

-- ============================================================
-- Drop table if exists
IF OBJECT_ID('dbo.DimCustomer', 'U') IS NOT NULL
    DROP TABLE dbo.DimCustomer;
GO

-- ============================================================
-- Create table
CREATE TABLE dbo.DimCustomer (
    CustomerKey INT NOT NULL PRIMARY KEY,
    GeoAreaKey INT NULL,
    StartDT DATE NULL,
    EndDT DATE NULL,
    Continent NVARCHAR(50) NULL,
    Gender NVARCHAR(20) NULL,
    Title NVARCHAR(20) NULL,
    GivenName NVARCHAR(100) NULL,
    MiddleInitial CHAR(10) NULL,
    Surname NVARCHAR(100) NULL,
    StreetAddress NVARCHAR(255) NULL,
    City NVARCHAR(100) NULL,
    State NVARCHAR(50) NULL,
    StateFull NVARCHAR(255) NULL,
    ZipCode NVARCHAR(20) NULL,
    Country CHAR(10) NULL,
    CountryFull NVARCHAR(255) NULL,
    Birthday DATE NULL,
    Age INT NULL,
    Occupation NVARCHAR(255) NULL,
    Company NVARCHAR(255) NULL,
    Vehicle NVARCHAR(255) NULL,
    Latitude DECIMAL(10,6) NULL,
    Longitude DECIMAL(10,6) NULL
);
GO

-- ============================================================
-- Create indexes
CREATE INDEX IX_DimCustomer_GeoAreaKey ON dbo.DimCustomer (GeoAreaKey);
CREATE INDEX IX_DimCustomer_Country ON dbo.DimCustomer (Country);
CREATE INDEX IX_DimCustomer_Birthday ON dbo.DimCustomer (Birthday);
GO