/* Aggregate functions (ag), used on colums that display values, returns a new column
that you can name us AS wild card, non values colums we may wish to display must be used with group by
*/
/* SUM of sales for each order date */
select OrderDate, sum(SalesAmount) as TotalSalesForEveryday /* ag ysed at the select statement*/
from AdventureWorksDW2019.dbo.FactInternetSales
group by OrderDate /* non aggregate column that we want to display*/
order by TotalSalesForEveryday desc /* result is in two decimal places and decreaasing order*/

/*rounding up values to any decimal places we want*/
select OrderDate, round(sum(SalesAmount),0) as TotalSalesForEveryday /*we input 
the number we want to round up to, my question here is, 
what if i want an whole number? */
from AdventureWorksDW2019.dbo.FactInternetSales
group by OrderDate
order by TotalSalesForEveryday desc

/* Having, similar to where, but used after groupby with aggregate function*/
select OrderDate, round(sum(SalesAmount),0) as TotalSalesForEveryday
from AdventureWorksDW2019.dbo.FactInternetSales
group by OrderDate
having round(sum(SalesAmount),0) > 50000
order by TotalSalesForEveryday desc

/* Exercise, show product and their total sales to 2dp, order by desc, include
product with no sales*/
select t1.EnglishProductName,round(sum(SalesAmount),0) as TotalSalesForEveryday
/* add t2.OrderDate if you want to show for different days in each month*/
from AdventureWorksDW2019.dbo.DimProduct as t1
left join AdventureWorksDW2019.dbo.FactInternetSales as t2
on t1.ProductKey = t2.productKey
group by/* OrderDate*/ EnglishProductName
order by TotalSalesForEveryday desc

/* COUNT: used at the select statement and also returns a new column. 
e.g how many orders per product */
select t1.EnglishProductName, count(SalesOrderNumber) as Orders
/*Add t2.OrderDate if you want to show orders for each pdts in different days 
of each month*/
from AdventureWorksDW2019.dbo.DimProduct as t1
left join AdventureWorksDW2019.dbo.FactInternetSales as t2
on t1.ProductKey = t2.productKey
group by /*OrderDate,*/ EnglishProductName /*always groups the non-aggre
grate column name that must show in our output*/
order by Orders desc

/* Max: display the order date with the highest sales, Min; lowest sales
for each day*/
select OrderDate, max(SalesAmount) as HighestSalesValue,
min(SalesAmount) as LowestSalesValue
from AdventureWorksDW2019.dbo.FactInternetSales
group by Orderdate
order by OrderDate desc

/* Average:shows the average sales amount for each day*/
select OrderDate, avg(SalesAmount) as AverageSalesValue
from AdventureWorksDW2019.dbo.FactInternetSales
group by Orderdate
order by OrderDate desc

/* shows total amount of sales value for a particular day*/
select OrderDate, sum(SalesAmount) as TotalSalesValue
from AdventureWorksDW2019.dbo.FactInternetSales
group by Orderdate
having OrderDate = '2014-01-28 00:00:00.000'
;
/*shows total number of sales for for a specific day*/
select OrderDate, count(SalesOrderNumber) as TotalNumberOfSales
from AdventureWorksDW2019.dbo.FactInternetSales
group by Orderdate
having OrderDate = '2014-01-28 00:00:00.000'
/* now divide the Totalsalesvalue by TotalNumberOfSales = avg for that day*/

/*Exercise: show names and no of orders of the customer 
with the highest number of orders*/
select t1.FirstName, t1.LastName, count(SalesOrderNumber) as CusNumOfOrders
from AdventureWorksDW2019.dbo.DimCustomer t1
inner join AdventureWorksDW2019.dbo.FactInternetSales t2
on t1.CustomerKey = t2.CustomerKey
group by FirstName, LastName
order by CusNumOfOrders desc

/* Exercise: Display each product with the recent date it was sold*/
select t1.EnglishProductName, T2.OrderDate
from AdventureWorksDW2019.dbo.DimProduct t1
join AdventureWorksDW2019.dbo.FactInternetSales t2
on t1.ProductKey = T2.ProductKey
group by EnglishProductName, OrderDate
order by OrderDate desc
 /* OR */
select distinct(t1.EnglishProductName) , T2.OrderDate
from AdventureWorksDW2019.dbo.DimProduct t1
join AdventureWorksDW2019.dbo.FactInternetSales t2
on t1.ProductKey = T2.ProductKey
order by OrderDate desc
/*well i missed both, the first code is very close to the ans */
select t1.EnglishProductName, max(T2.OrderDate) as RecentOrderDate
from AdventureWorksDW2019.dbo.DimProduct t1
join AdventureWorksDW2019.dbo.FactInternetSales t2
on t1.ProductKey = T2.ProductKey
group by EnglishProductName
order by RecentOrderDate desc