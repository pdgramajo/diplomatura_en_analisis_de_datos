USE ContosoDB;
GO

-- =============================================
-- 1️⃣ Crear tabla staging temporal
-- =============================================
IF OBJECT_ID('dbo.ProductStaging', 'U') IS NOT NULL
    DROP TABLE dbo.ProductStaging;
GO

CREATE TABLE dbo.ProductStaging
(
    ProductKey VARCHAR(MAX),
    ProductCode VARCHAR(MAX),
    ProductName VARCHAR(MAX),
    Manufacturer VARCHAR(MAX),
    Brand VARCHAR(MAX),
    Color VARCHAR(MAX),
    WeightUnit VARCHAR(MAX),
    Weight VARCHAR(MAX),
    Cost VARCHAR(MAX),
    Price VARCHAR(MAX),
    CategoryKey VARCHAR(MAX),
    CategoryName VARCHAR(MAX),
    SubCategoryKey VARCHAR(MAX),
    SubCategoryName VARCHAR(MAX)
);
GO

-- =============================================
-- 2️⃣ BULK INSERT desde CSV 
-- =============================================

BULK INSERT dbo.ProductStaging
FROM '/data/product.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    FIELDQUOTE = '"',
    FORMAT = 'CSV',
    FORMATFILE = '/data/product.fmt'
);
GO

-- =============================================
-- 3️⃣ Insertar en tabla final DimProduct con conversión de tipos
-- =============================================
INSERT INTO dbo.DimProduct
(
    ProductKey,
    ProductCode,
    ProductName,
    Manufacturer,
    Brand,
    Color,
    WeightUnit,
    Weight,
    Cost,
    Price,
    CategoryKey,
    CategoryName,
    SubCategoryKey,
    SubCategoryName
)
SELECT
    TRY_CAST(ProductKey AS INT),
    ProductCode,
    ProductName,
    Manufacturer,
    Brand,
    Color,
    WeightUnit,
    TRY_CAST(Weight AS DECIMAL(10,2)),
    TRY_CAST(Cost AS DECIMAL(18,2)),
    TRY_CAST(Price AS DECIMAL(18,2)),
    TRY_CAST(CategoryKey AS INT),
    CategoryName,
    TRY_CAST(SubCategoryKey AS INT),
    SubCategoryName
FROM dbo.ProductStaging;
GO

-- =============================================
-- 4️⃣ Validar carga
-- =============================================
SELECT TOP 10 ProductKey, ProductName, Manufacturer, Price
FROM dbo.DimProduct;
GO

-- =============================================
-- 5️⃣ Limpiar tabla staging
-- =============================================
DROP TABLE dbo.ProductStaging;
GO
