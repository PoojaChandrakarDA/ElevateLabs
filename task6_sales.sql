use task6;
-- Displaying all dataset
select * from task6.salesdataset;

-- a extracting month, its text to first convert it to 
DESCRIBE salesdataset;
SELECT 
    OrderDate,
    EXTRACT(MONTH FROM STR_TO_DATE(OrderDate, '%m/%d/%Y')) AS OrderMonth
FROM salesdataset;

-- b group by year /month infer our data is from where to where
SELECT 
    EXTRACT(YEAR FROM STR_TO_DATE(TRIM(OrderDate), '%m/%d/%Y')) AS OrderYear
FROM salesdataset
GROUP BY OrderYear
ORDER BY OrderYear;

-- month
SELECT 
    EXTRACT(MONTH FROM STR_TO_DATE(TRIM(OrderDate), '%m/%d/%Y')) AS OrderMonth
FROM salesdataset
GROUP BY OrderMonth
ORDER BY OrderMonth;

-- grouping by both year and month
SELECT
    YearMonth,
    COUNT(*) AS TotalOrders,
    SUM(Amount) AS TotalSales
FROM salesdataset
GROUP BY YearMonth
ORDER BY YearMonth;

-- c. total revenue generated
SELECT 
    SUM(Amount) AS TotalRevenue
FROM salesdataset;

-- revenue generated yearwise
SELECT 
    EXTRACT(YEAR FROM STR_TO_DATE(OrderDate, '%m/%d/%Y')) AS OrderYear,
    SUM(Amount) AS TotalRevenue
FROM salesdataset
GROUP BY OrderYear
ORDER BY OrderYear;

-- count distinct order id
SELECT 
    COUNT(DISTINCT OrderId) AS TotalDistinctOrders
FROM salesdataset;

-- yearly
SELECT 
    EXTRACT(YEAR FROM STR_TO_DATE(OrderDate, '%m/%d/%Y')) AS OrderYear,
    COUNT(DISTINCT OrderId) AS OrderVolume,
    SUM(Amount) AS TotalRevenue
FROM salesdataset
GROUP BY OrderYear
ORDER BY OrderYear;

-- sort by
SELECT 
    EXTRACT(YEAR FROM STR_TO_DATE(OrderDate, '%m/%d/%Y')) AS OrderYear,
    COUNT(DISTINCT OrderId) AS DistinctOrders
FROM salesdataset
GROUP BY OrderYear
ORDER BY OrderYear;


-- filter for 2024
SELECT 
    EXTRACT(YEAR FROM STR_TO_DATE(OrderDate, '%m/%d/%Y')) AS OrderYear,
    COUNT(DISTINCT OrderId) AS DistinctOrders,
    SUM(Amount) AS TotalRevenue
FROM salesdataset
WHERE EXTRACT(YEAR FROM STR_TO_DATE(OrderDate, '%m/%d/%Y')) = 2024
GROUP BY OrderYear;

-- filter date range jan 2024 to june 2024
SELECT 
    EXTRACT(YEAR FROM STR_TO_DATE(OrderDate, '%m/%d/%Y')) AS OrderYear,
    EXTRACT(MONTH FROM STR_TO_DATE(OrderDate, '%m/%d/%Y')) AS OrderMonth,
    COUNT(DISTINCT OrderId) AS DistinctOrders,
    SUM(Amount) AS TotalRevenue
FROM salesdataset
WHERE STR_TO_DATE(OrderDate, '%m/%d/%Y') BETWEEN '2024-01-01' AND '2024-06-30'
GROUP BY OrderYear, OrderMonth
ORDER BY OrderYear, OrderMonth;

-- summary time trends

-- top 5 months by revenue
SELECT 
    DATE_FORMAT(STR_TO_DATE(OrderDate, '%m/%d/%Y'), '%Y-%m') AS YearMonths,
    SUM(Amount) AS TotalRevenue
FROM salesdataset
GROUP BY YearMonths
ORDER BY TotalRevenue DESC
LIMIT 5;

WITH YearlyCustomerRevenue AS (
    SELECT
        EXTRACT(YEAR FROM STR_TO_DATE(OrderDate, '%m/%d/%Y')) AS OrderYear,
        CustomerName,
        SUM(Amount) AS TotalRevenue
    FROM salesdataset
    GROUP BY OrderYear, CustomerName
)

SELECT *
FROM (
    SELECT
        OrderYear,
        CustomerName,
        TotalRevenue,
        ROW_NUMBER() OVER (PARTITION BY OrderYear ORDER BY TotalRevenue DESC) AS rn
    FROM YearlyCustomerRevenue
) AS ranked
WHERE rn <= 5
ORDER BY OrderYear, TotalRevenue DESC;