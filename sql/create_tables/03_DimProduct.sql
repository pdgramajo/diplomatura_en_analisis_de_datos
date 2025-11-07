USE ContosoDB;
GO

-- =============================================
-- Crear tabla DimProduct
-- =============================================
IF OBJECT_ID('dbo.DimProduct', 'U') IS NOT NULL
    DROP TABLE dbo.DimProduct;
GO

CREATE TABLE dbo.DimProduct
(
    ProductKey INT PRIMARY KEY,
    ProductCode VARCHAR(20),
    ProductName VARCHAR(100),
    Manufacturer VARCHAR(50),
    Brand VARCHAR(50),
    Color VARCHAR(20),
    WeightUnit VARCHAR(50),
    Weight DECIMAL(10,2),
    Cost DECIMAL(18,2),
    Price DECIMAL(18,2),
    CategoryKey INT,
    CategoryName VARCHAR(50),
    SubCategoryKey INT,
    SubCategoryName VARCHAR(50)
);
GO