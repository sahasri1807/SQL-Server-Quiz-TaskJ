-- TASK J - BULK CUSTOMER SEGMENTATION PROCESSOR

-- Create Schema 

CREATE SCHEMA RetailAnalytics;
GO


-- Create Table 

CREATE TYPE RetailAnalytics.CustomerSegmentListType AS TABLE
(
    CustomerID INT
);
GO


-- Create Stored Procedure

CREATE PROCEDURE RetailAnalytics.usp_ProcessCustomerSegmentation
(
    @CustomerList RetailAnalytics.CustomerSegmentListType READONLY,
    @ReturnCode INT OUTPUT
)
AS
BEGIN

    BEGIN TRY


-- Details

        SELECT
            CL.CustomerID,

            ISNULL(P.FirstName + ' ' + P.LastName, 'Unknown') AS CustomerName,

            COUNT(SOH.SalesOrderID) AS TotalOrders,

            ISNULL(SUM(SOH.TotalDue),0) AS TotalRevenue,

            CASE
                WHEN C.CustomerID IS NULL THEN 'Invalid Customer'
                WHEN COUNT(SOH.SalesOrderID) = 0 THEN 'No Purchase History'
                WHEN SUM(SOH.TotalDue) >= 100000 THEN 'Strategic Customer'
                WHEN SUM(SOH.TotalDue) >= 25000 THEN 'Growth Customer'
                ELSE 'Standard Customer'
            END AS CustomerSegment,

            CASE
                WHEN C.CustomerID IS NULL THEN 'CustomerID Not Found'
                ELSE 'Valid Customer'
            END AS ValidationMessage

        FROM @CustomerList CL

        LEFT JOIN Sales.Customer C
            ON CL.CustomerID = C.CustomerID

        LEFT JOIN Person.Person P
            ON C.PersonID = P.BusinessEntityID

        LEFT JOIN Sales.SalesOrderHeader SOH
            ON C.CustomerID = SOH.CustomerID

        GROUP BY
            CL.CustomerID,
            C.CustomerID,
            P.FirstName,
            P.LastName;


-- Summary

        SELECT
            COUNT(*) AS TotalCustomersSubmitted,

            SUM(CASE WHEN C.CustomerID IS NOT NULL THEN 1 ELSE 0 END)
                AS TotalValidCustomers,

            SUM(CASE WHEN C.CustomerID IS NULL THEN 1 ELSE 0 END)
                AS TotalInvalidCustomers

        FROM @CustomerList CL

        LEFT JOIN Sales.Customer C
            ON CL.CustomerID = C.CustomerID;

        SET @ReturnCode = 0;

    END TRY

    BEGIN CATCH

        SET @ReturnCode = ERROR_NUMBER();

        SELECT
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorMessage;

    END CATCH

END;
GO


