-- TEST 1 - Valid Customers

DECLARE @Customers RetailAnalytics.CustomerSegmentListType;

INSERT INTO @Customers
VALUES
(11223),
(11711),
(29614);

DECLARE @RC INT;

EXEC RetailAnalytics.usp_ProcessCustomerSegmentation
    @CustomerList = @Customers,
    @ReturnCode = @RC OUTPUT;

SELECT @RC AS ReturnCode;
GO


-- TEST 2 - Invalid Customers

DECLARE @Customers RetailAnalytics.CustomerSegmentListType;

INSERT INTO @Customers
VALUES
(000000),
(676767),
(986793);

DECLARE @RC INT;

EXEC RetailAnalytics.usp_ProcessCustomerSegmentation
    @CustomerList = @Customers,
    @ReturnCode = @RC OUTPUT;

SELECT @RC AS ReturnCode;
GO



-- TEST 3 - Mixed Customers

DECLARE @Customers RetailAnalytics.CustomerSegmentListType;

INSERT INTO @Customers
VALUES
(29509),
(69696),
(11632);

DECLARE @RC INT;

EXEC RetailAnalytics.usp_ProcessCustomerSegmentation
    @CustomerList = @Customers,
    @ReturnCode = @RC OUTPUT;

SELECT @RC AS ReturnCode;
GO

