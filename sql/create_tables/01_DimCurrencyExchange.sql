USE ContosoDB;
GO
-- ============================================================
IF OBJECT_ID('dbo.DimCurrencyExchange', 'U') IS NOT NULL
    DROP TABLE dbo.DimCurrencyExchange;
GO

CREATE TABLE dbo.DimCurrencyExchange (
    ExchangeDate DATE NOT NULL,
    FromCurrency CHAR(3) NOT NULL,
    ToCurrency CHAR(3) NOT NULL,
    ExchangeRate DECIMAL(18,5) NOT NULL,
    CONSTRAINT PK_DimCurrencyExchange PRIMARY KEY (ExchangeDate, FromCurrency, ToCurrency)
);
GO

CREATE INDEX IX_DimCurrencyExchange_ExchangeDate 
    ON dbo.DimCurrencyExchange (ExchangeDate);
GO
