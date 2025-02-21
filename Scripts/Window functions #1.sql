
-- find the total sales accross the total orders (highest level of aggrigation)
select 
	SUM(sales) total_sales 
from Sales.Orders 

-- find the total sales for each product 
select 
	ProductID,
	SUM(sales) product_total_sales
from Sales.Orders
group by ProductID;

/* find the total orders for each product and additionally provide 
product id and order date */
-- it is not possible with group by 
-- we need to use windlow function to achieve this beheviour

-- over and partition by

	select 
		OrderID,
		OrderDate,
		ProductId,
		Sales,
		OrderStatus,
		SUM(Sales) over () totalSales,
		SUM(sales) over(partition by ProductId) sales_by_product,
		SUM(sales) over (partition by ProductId,OrderStatus) sales_by_product_and_orderStatus
	from Sales.Orders

-- order by 
/* rank each order based on their sales from hoghest to lowest and additionally provide the details 
like order id and order date*/

select 
	OrderId,
	OrderDate,
	Sales,
	RANK () over ( order by sales desc) SalesRank
from Sales.Orders 

-- Frames 
-- calculte the sum of current row and following 2 rows

select 
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(sales) 
	over (partition by orderstatus order by OrderDate 
	rows between current row and 2 following)  sumOfcurrentand2Following
from Sales.Orders

-- calculte the sum of current row and 2 preceding rows
/* frams are
-- unbounding preceding and unbounding following
-- n preciding and unbounding following
-- unbounding preceding and n following
-- n preciding and current
-- current and n following
-- current and unbounding following
-- unbounding preceding and current

*/

select 
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(sales) over(partition by orderStatus order by OrderDate
	rows between 2 preceding and current row) SumOfRows2Preceding
from Sales.Orders

-- default frame is unbounding preceding and current row 
--(it was hedden frame if you are not mention if in the query
select 
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(sales) over(partition by orderStatus order by OrderDate
	
	) SumOfRowsunBoundingPreceding
from Sales.Orders

-- Rules for window functions 
-- 1. We have to use them in select and order by only 
select 
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(sales) over(partition by orderStatus ) 
	SumOfRowsBySales
from Sales.Orders
order by SUM(sales) over(partition by orderStatus ) desc

-- 2. Nestes window Functions are not allowed 
-- 3. Sql Exicute the window function after Wheare clause

select 
	OrderID,
	 ProductID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(sales) over(partition by orderStatus ) 
	SumOfRowsBySales
from Sales.Orders
Where ProductID in (101,102)

-- 4. window functions are allowed to use with the gropuby clause ,
--    in the same query only if the same colums are used


-- EX: rank the customers based on their total sales

select 
	CustomerID,
	SUM(sales) TotalSales,
	RANK() over(order by SUM(sales) desc ) RankBySales
from Sales.Orders
group by CustomerID