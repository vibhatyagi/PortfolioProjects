--Let's explore the data once

Select *
FROM MyProject..superstore_test

--Let's see the sales of next row in the dataset

SELECT [Order ID], [Customer ID], [Customer Name], Segment, Country, City, [Product ID], Category, [Product Name], Sales,
LEAD(Sales, 1) OVER(
		Order by Sales
		) As Sales_Next
FROM MyProject..superstore_test

-- Sales of previous row


SELECT [Order ID], [Customer ID], [Customer Name], Segment, Country, City, [Product ID], Category, [Product Name], Sales,
LAG(Sales, 1) OVER(
		Order by Sales
		) As Sales_Previous
FROM MyProject..superstore_test

-- Rank the data based on sales in descending order
SELECT [Order ID], [Customer ID], [Customer Name], Segment, Country, City, [Product ID], Category, [Product Name], Sales,
RANK() OVER (
		Order by Sales desc
		) Rank
FROM MyProject..superstore_test

--Separate the date from hours in order date column


Select [Order Date], CONVERT(Date, [Order Date])
FROM MyProject..superstore_test

ALTER TABLE	Myproject..Superstore_test
ADD OrderDateConverted Date;

Update MyProject..superstore_test
SET OrderDateConverted = CONVERT(Date, [Order Date])


-- Lets's see the yearly, monthly and daily sales averages as  per Order Date
SELECT 
OrderDateConverted,
DATEPART(year, OrderDateConverted) AS OrderYear,
DATEPART(month, OrderDateConverted) AS OrderMonth,
DATEPART(day, OrderDateConverted) AS OrderDay
FROM MyProject..superstore_test


SELECT MONTH(OrderDateConverted), AVG(Sales)
FROM MyProject..superstore_test
	Group by MONTH(OrderDateConverted)
	Order by MONTH(OrderDateConverted);

SELECT Day(OrderDateConverted), AVG(Sales)
FROM MyProject..superstore_test
	Group by DAY(OrderDateConverted)
	Order by Day(OrderDateConverted);

SELECT year(OrderDateConverted), Month(OrderDateConverted), AVG(Sales)
FROM MyProject..superstore_test
	Group by year(OrderDateConverted), Month(OrderDateConverted)
	Order by year(OrderDateConverted), Month(OrderDateConverted);

-- Separate the date from hours in Ship Date
Select ShipDateConverted, CONVERT(Date, [Ship Date])
FROM MyProject..superstore_test


ALTER TABLE	Myproject..Superstore_test
ADD ShipDateConverted Date;

Update	MyProject..superstore_test
SET	ShipDateConverted =  CONVERT(Date, [Ship Date])


-- Let's see the yearly, monthly and daily sales averages as per Ship Date
SELECT 
ShipDateConverted,
DATEPART(year, ShipDateConverted) AS ShipYear,
DATEPART(month, ShipDateConverted) AS ShipMonth,
DATEPART(day, ShipDateConverted) AS ShipDay
FROM MyProject..superstore_test



SELECT year(ShipDateConverted), AVG(Sales)
FROM MyProject..superstore_test
	Group by year(ShipDateConverted)
	Order by year(ShipDateConverted);

SELECT MONTH(ShipDateConverted), AVG(Sales)
FROM MyProject..superstore_test
	Group by MONTH(ShipDateConverted)
	Order by MONTH(ShipDateConverted);

SELECT Day(ShipDateConverted), AVG(Sales)
FROM MyProject..superstore_test
	Group by DAY(ShipDateConverted)
	Order by Day(ShipDateConverted);


SELECT year(ShipDateConverted), Month(ShipDateConverted), AVG(Sales)
FROM MyProject..superstore_test
	Group by year(ShipDateConverted), Month(ShipDateConverted)
	Order by year(ShipDateConverted), Month(ShipDateConverted);

 