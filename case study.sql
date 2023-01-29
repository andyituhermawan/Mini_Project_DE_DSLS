
SELECT

	YEAR(o.OrderDate) AS 'year'
	, MONTH(o.OrderDate) AS 'month'
	, SUM(od.UnitPrice * od.Quantity) AS 'sum_sales'
	, ROUND(100.0*(SUM(od.UnitPrice * od.Quantity) - LAG(SUM(od.UnitPrice * od.Quantity), 1) OVER(ORDER BY YEAR(o.OrderDate), MONTH(o.OrderDate))) / 
			LAG(SUM(od.UnitPrice * od.Quantity), 1) OVER(ORDER BY YEAR(o.OrderDate), MONTH(o.OrderDate)), 2) AS '%_chg_sum_sales'
	
	, AVG(od.UnitPrice * od.Quantity) AS 'avg_sales'
	, COUNT(od.UnitPrice * od.Quantity) AS 'vol_sales'

	, SUM(od.Quantity) AS 'sum_qty'
	, ROUND(100.0*(SUM(od.Quantity) - LAG(SUM(od.Quantity), 1) OVER(ORDER BY YEAR(o.OrderDate), MONTH(o.OrderDate))) / 
			LAG(SUM(od.Quantity), 1) OVER(ORDER BY YEAR(o.OrderDate), MONTH(o.OrderDate)), 2) AS '%_chg_sum_qty'

	, AVG(od.UnitPrice) AS 'avg_u_price'
	, ROUND(100.0*(AVG(od.UnitPrice) - LAG(AVG(od.UnitPrice), 1) OVER(ORDER BY YEAR(o.OrderDate), MONTH(o.OrderDate))) / 
			LAG(AVG(od.UnitPrice), 1) OVER(ORDER BY YEAR(o.OrderDate), MONTH(o.OrderDate)), 2) AS '%_chg_avg_u_price'

FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)
ORDER BY YEAR(o.OrderDate), MONTH(o.OrderDate)
;
 
 
 
 

?

WITH company_sales AS
	(SELECT
		c.CompanyName
		, SUM(od.UnitPrice*od.Quantity) as 'sum_sales'
	FROM Orders o
	JOIN Customers c ON o.CustomerID = c.CustomerID
	JOIN [Order Details] od ON o.OrderID = od.OrderID
	WHERE o.OrderDate BETWEEN '1997-01-01' AND '1997-12-31'
	GROUP BY c.CompanyName)

SELECT 
	*
	, 100.0 * sum_sales / (SELECT SUM(sum_sales) FROM company_sales) AS '%_sales'
	, 100.0 * SUM(sum_sales) OVER(ORDER BY sum_sales DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / (SELECT SUM(sum_sales) FROM company_sales) as '%_cumsum_sales'
FROM company_sales
;
 
 
 

WITH product_sales AS
	(SELECT
		p.ProductName
		, SUM(od.UnitPrice*od.Quantity) as 'sum_sales'
	FROM Orders o	
	JOIN [Order Details] od ON o.OrderID = od.OrderID
	JOIN Products p ON od.ProductID = p.ProductID
	WHERE o.OrderDate BETWEEN '1997-01-01' AND '1997-12-31'
	GROUP BY p.ProductName)

SELECT 
	*
	, 100.0 * sum_sales / (SELECT SUM(sum_sales) FROM product_sales) AS '%_sales'
	, 100.0 * SUM(sum_sales) OVER(ORDER BY sum_sales DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / (SELECT SUM(sum_sales) FROM product_sales) as '%_cumsum_sales'
FROM product_sales;
 
 
 
?

WITH category_sales AS
	(SELECT
		c.CategoryName
		, SUM(od.UnitPrice*od.Quantity) as 'sum_sales'
	FROM Orders o	
	JOIN [Order Details] od ON o.OrderID = od.OrderID
	JOIN Products p ON od.ProductID = p.ProductID
	JOIN Categories c ON p.CategoryID = c.CategoryID
	WHERE o.OrderDate BETWEEN '1997-01-01' AND '1997-12-31'
	GROUP BY c.CategoryName)

SELECT 
	*
	, 100.0 * sum_sales / (SELECT SUM(sum_sales) FROM category_sales) AS '%_sales'
	, 100.0 * SUM(sum_sales) OVER(ORDER BY sum_sales DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / (SELECT SUM(sum_sales) FROM category_sales) as '%_cumsum_sales'
FROM category_sales
;


 




 



 


WITH teritory_sales AS
	(SELECT
		t.TerritoryDescription
		, SUM(od.UnitPrice*od.Quantity) as 'sum_sales'
	FROM Orders o	
	JOIN [Order Details] od ON o.OrderID = od.OrderID
	JOIN Employees e ON e.EmployeeID = o.EmployeeID
	JOIN EmployeeTerritories et ON et.EmployeeID = o.EmployeeID
	JOIN Territories t ON et.TerritoryID = t.TerritoryID
	WHERE o.OrderDate BETWEEN '1997-01-01' AND '1997-12-31'
	GROUP BY t.TerritoryDescription)

SELECT 
	*
	, 100.0 * sum_sales / (SELECT SUM(sum_sales) FROM teritory_sales) AS '%_sales'
	, 100.0 * SUM(sum_sales) OVER(ORDER BY sum_sales DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / (SELECT SUM(sum_sales) FROM teritory_sales) as '%_cumsum_sales'
FROM teritory_sales
;

 

 
 

?

WITH region_sales AS
	(SELECT
		r.RegionDescription
		, SUM(od.UnitPrice*od.Quantity) as 'sum_sales'
	FROM Orders o	
	JOIN [Order Details] od ON o.OrderID = od.OrderID
	JOIN Employees e ON e.EmployeeID = o.EmployeeID
	JOIN EmployeeTerritories et ON et.EmployeeID = o.EmployeeID
	JOIN Territories t ON et.TerritoryID = t.TerritoryID
	JOIN Region r ON r.RegionID = t.RegionID
	WHERE o.OrderDate BETWEEN '1997-01-01' AND '1997-12-31'
	GROUP BY r.RegionDescription)

SELECT 
	*
	, 100.0 * sum_sales / (SELECT SUM(sum_sales) FROM region_sales) AS '%_sales'
	, 100.0 * SUM(sum_sales) OVER(ORDER BY sum_sales DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / (SELECT SUM(sum_sales) FROM region_sales) as '%_cumsum_sales'
FROM region_sales
;


 


 



 



WITH territory_sales AS
	(SELECT
		t.TerritoryDescription
		, SUM(od.UnitPrice*od.Quantity) as 'sum_sales'
	FROM Orders o	
	JOIN [Order Details] od ON o.OrderID = od.OrderID
	JOIN Employees e ON e.EmployeeID = o.EmployeeID
	JOIN EmployeeTerritories et ON et.EmployeeID = o.EmployeeID
	JOIN Territories t ON et.TerritoryID = t.TerritoryID
	JOIN Region r ON r.RegionID = t.RegionID
	WHERE (o.OrderDate BETWEEN '1997-01-01' AND '1997-12-31') AND (RegionDescription = 'Eastern')
	GROUP BY t.TerritoryDescription)

SELECT 
	*
	, 100.0 * sum_sales / (SELECT SUM(sum_sales) FROM territory_sales) AS '%_sales'
	, 100.0 * SUM(sum_sales) OVER(ORDER BY sum_sales DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / (SELECT SUM(sum_sales) FROM territory_sales) as '%_cumsum_sales'
FROM territory_sales
;

 

 

?
WITH category_sales AS
	(SELECT
		c.CategoryName
		, SUM(od.UnitPrice*od.Quantity) as 'sum_sales'
	FROM Orders o	
	JOIN [Order Details] od ON o.OrderID = od.OrderID
	JOIN Products p ON od.ProductID = p.ProductID
	JOIN Categories c ON p.CategoryID = c.CategoryID
	JOIN Employees e ON e.EmployeeID = o.EmployeeID
	JOIN EmployeeTerritories et ON et.EmployeeID = o.EmployeeID
	JOIN Territories t ON et.TerritoryID = t.TerritoryID
	JOIN Region r ON r.RegionID = t.RegionID
	WHERE (o.OrderDate BETWEEN '1997-01-01' AND '1997-12-31') AND (RegionDescription = 'Eastern')
	GROUP BY c.CategoryName)

SELECT 
	*
	, 100.0 * sum_sales / (SELECT SUM(sum_sales) FROM category_sales) AS '%_sales'
	, 100.0 * SUM(sum_sales) OVER(ORDER BY sum_sales DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / (SELECT SUM(sum_sales) FROM category_sales) as '%_cumsum_sales'
FROM category_sales
;


 

 


 


WITH product_sales AS
	(SELECT
		p.ProductName
		, SUM(od.UnitPrice*od.Quantity) as 'sum_sales'
	FROM Orders o	
	JOIN [Order Details] od ON o.OrderID = od.OrderID
	JOIN Products p ON od.ProductID = p.ProductID
	JOIN Categories c ON p.CategoryID = c.CategoryID
	JOIN EmployeeTerritories et ON et.EmployeeID = o.EmployeeID
	JOIN Territories t ON et.TerritoryID = t.TerritoryID
	JOIN Region r ON r.RegionID = t.RegionID
	WHERE (o.OrderDate BETWEEN '1997-01-01' AND '1997-12-31') AND (RegionDescription = 'Eastern')
	GROUP BY p.ProductName)

SELECT 
	*
	, 100.0 * sum_sales / (SELECT SUM(sum_sales) FROM product_sales) AS '%_sales'
	, 100.0 * SUM(sum_sales) OVER(ORDER BY sum_sales DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / (SELECT SUM(sum_sales) FROM product_sales) as '%_cumsum_sales'
FROM product_sales
;

 

 
 


WITH region_sales AS
	(SELECT
		r.RegionDescription
		, SUM(od.UnitPrice*od.Quantity) as 'sum_sales'
	FROM Orders o	
	JOIN [Order Details] od ON o.OrderID = od.OrderID
	JOIN EmployeeTerritories et ON et.EmployeeID = o.EmployeeID
	JOIN Territories t ON et.TerritoryID = t.TerritoryID
	JOIN Region r ON r.RegionID = t.RegionID
	WHERE o.OrderDate BETWEEN '1997-11-01' AND '1998-04-30'
	GROUP BY r.RegionDescription)

SELECT 
	*
	, 100.0 * sum_sales / (SELECT SUM(sum_sales) FROM region_sales) AS '%_sales'
	, 100.0 * SUM(sum_sales) OVER(ORDER BY sum_sales DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / (SELECT SUM(sum_sales) FROM region_sales) as '%_cumsum_sales'
FROM region_sales
;

 
 
 

?

WITH territory_sales AS
	(SELECT
		t.TerritoryDescription
		, SUM(od.UnitPrice*od.Quantity) as 'sum_sales'
	FROM Orders o	
	JOIN [Order Details] od ON o.OrderID = od.OrderID
	JOIN Employees e ON e.EmployeeID = o.EmployeeID
	JOIN EmployeeTerritories et ON et.EmployeeID = o.EmployeeID
	JOIN Territories t ON et.TerritoryID = t.TerritoryID
	JOIN Region r ON r.RegionID = t.RegionID
	WHERE (o.OrderDate BETWEEN '1997-11-01' AND '1998-04-30') AND (RegionDescription = 'Eastern')
	GROUP BY t.TerritoryDescription)

SELECT 
	*
	, 100.0 * sum_sales / (SELECT SUM(sum_sales) FROM territory_sales) AS '%_sales'
	, 100.0 * SUM(sum_sales) OVER(ORDER BY sum_sales DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / (SELECT SUM(sum_sales) FROM territory_sales) as '%_cumsum_sales'
FROM territory_sales
;

 

 


-- pareto category name on sales in eastern region
-- category name in eastern with the highest sales on Nov 97 to Apr 98 period
WITH category_sales AS
	(SELECT
		c.CategoryName
		, SUM(od.UnitPrice*od.Quantity) as 'sum_sales'
	FROM Orders o	
	JOIN [Order Details] od ON o.OrderID = od.OrderID
	JOIN Products p ON od.ProductID = p.ProductID
	JOIN Categories c ON p.CategoryID = c.CategoryID
	JOIN Employees e ON e.EmployeeID = o.EmployeeID
	JOIN EmployeeTerritories et ON et.EmployeeID = o.EmployeeID
	JOIN Territories t ON et.TerritoryID = t.TerritoryID
	JOIN Region r ON r.RegionID = t.RegionID
	WHERE (o.OrderDate BETWEEN '1997-11-01' AND '1998-04-30') AND (RegionDescription = 'Eastern')
	GROUP BY c.CategoryName)

SELECT 
	*
	, 100.0 * sum_sales / (SELECT SUM(sum_sales) FROM category_sales) AS '%_sales'
	, 100.0 * SUM(sum_sales) OVER(ORDER BY sum_sales DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / (SELECT SUM(sum_sales) FROM category_sales) as '%_cumsum_sales'
FROM category_sales
;


 


 
 


?

WITH product_sales AS
	(SELECT
		p.ProductName
		, SUM(od.UnitPrice*od.Quantity) as 'sum_sales'
	FROM Orders o	
	JOIN [Order Details] od ON o.OrderID = od.OrderID
	JOIN Products p ON od.ProductID = p.ProductID
	JOIN Categories c ON p.CategoryID = c.CategoryID
	JOIN EmployeeTerritories et ON et.EmployeeID = o.EmployeeID
	JOIN Territories t ON et.TerritoryID = t.TerritoryID
	JOIN Region r ON r.RegionID = t.RegionID
	WHERE (o.OrderDate BETWEEN '1997-11-01' AND '1998-04-30') AND (RegionDescription = 'Eastern')
	GROUP BY p.ProductName)

SELECT 
	*
	, 100.0 * sum_sales / (SELECT SUM(sum_sales) FROM product_sales) AS '%_sales'
	, 100.0 * SUM(sum_sales) OVER(ORDER BY sum_sales DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / (SELECT SUM(sum_sales) FROM product_sales) as '%_cumsum_sales'
FROM product_sales
;


 
 

 

?


-- 1. rfm score for each customer id
WITH 
base_rfm_score AS
	(SELECT
		o.CustomerID
		, COUNT(DISTINCT o.OrderID) as 'frequency_value'
		, DATEDIFF(DAY, MAX(o.OrderDate), '1998-01-07') as 'recency_value'
		, SUM((1-od.Discount)*(od.UnitPrice*od.Quantity)) as 'monetary_value'
		, NTILE(5) OVER(ORDER BY COUNT(DISTINCT o.OrderID) ASC) as 'frequency_score'
		, NTILE(5) OVER(ORDER BY DATEDIFF(DAY, MAX(o.OrderDate), '1998-01-07') DESC) as 'recency_score'
		, NTILE(5) OVER(ORDER BY SUM((1-od.Discount)*(od.UnitPrice*od.Quantity)) ASC) as 'monetary_score'
	FROM Orders o
	JOIN [Order Details] od ON o.OrderID = od.OrderID
	WHERE o.OrderDate BETWEEN '1997-01-01' AND '1997-12-31'
	GROUP BY o.CustomerID),

-- 2. from the rfm score, group each customer to rfm segment
rfm_segment_table AS
	(SELECT
		*
		, (monetary_score + recency_score + frequency_score)/3 as 'rfm_score'
		, CASE WHEN (recency_score = 5) AND ((frequency_score=5) OR (frequency_score=4)) THEN 'champion'
		WHEN ((recency_score = 3) OR (recency_score = 4)) AND ((frequency_score=5) OR (frequency_score=4)) THEN 'loyal customer'
		WHEN ((recency_score = 1) OR (recency_score = 2)) AND (frequency_score=5) THEN 'cant lose them'
		WHEN ((recency_score = 5) OR (recency_score = 4)) AND ((frequency_score=3) OR (frequency_score=2)) THEN 'potential loyalist'
		WHEN (recency_score = 3) AND (frequency_score=3) THEN 'need attention'
		WHEN ((recency_score = 1) OR (recency_score = 2)) AND ((frequency_score=3) OR (frequency_score=4)) THEN 'at risk'
		WHEN (recency_score = 5) AND (frequency_score=1) THEN 'new customer'
		WHEN (recency_score = 4) AND (frequency_score=1) THEN 'promising'
		WHEN (recency_score = 3) AND ((frequency_score=1) OR (frequency_score=2)) THEN 'about to sleep'
		ELSE 'hibernating' END AS 'rfm_segment'
	FROM base_rfm_score)

-- 3. for each customer segment, calcuate its proportion & avg monetary value
SELECT
	rfm_segment
	, 100.0*COUNT(CustomerID)/(SELECT COUNT(*) FROM rfm_segment_table) AS '%_segment'
	, AVG(monetary_value) AS 'avg_monetary'
FROM rfm_segment_table
GROUP BY rfm_segment
ORDER BY 100.0*COUNT(CustomerID)/(SELECT COUNT(*) FROM rfm_segment_table) DESC
;

 
 
 

 


 



?

USE Northwind;

WITH
-- 1. for each customer id, find their first time order (month)
first_buy AS(
	SELECT
		o.CustomerID
		, DATEPART(MONTH, MIN(o.OrderDate)) first_time_buy
	FROM Orders o
	WHERE o.OrderDate BETWEEN '1997-01-01' AND '1997-12-31'
	GROUP BY o.CustomerID),

-- 2. for each customer id, find all of their time order (month)
next_purchase AS(
	SELECT
		o.CustomerID
		, DATEPART(MONTH, o.OrderDate) - first_time_buy AS buy_interval 
	FROM Orders o
	JOIN first_buy f ON o.CustomerID = f.CustomerID
	WHERE o.OrderDate BETWEEN '1997-01-01' AND '1997-12-31'),

-- 3. for each first time buy (month), calculate the number of total distinct customer
initial_user AS(
	SELECT
		first_time_buy
		, COUNT(DISTINCT CustomerID) AS users
	FROM first_buy
	GROUP BY first_time_buy),

-- 4. calculate the retention for each first time buy (month) & for each buy interval (month)
retention AS(
	SELECT
		f.first_time_buy
		, buy_interval
		, COUNT(DISTINCT n.CustomerID) AS users_transacting
	FROM first_buy f
	JOIN next_purchase n ON f.CustomerID = n.CustomerID
	WHERE buy_interval IS NOT NULL
	GROUP BY f.first_time_buy, buy_interval)

-- 5. put it all together, convert the retention into percentage
SELECT
	r.first_time_buy,
	i.users ,
	r.buy_interval,
	r.users_transacting,
	100.0*r.users_transacting/i.users AS '%_user_transacting'
FROM retention r
LEFT JOIN initial_user i ON r.first_time_buy = i.first_time_buy
ORDER BY r.first_time_buy, r.buy_interval
;

 

 
 
 
 
 




