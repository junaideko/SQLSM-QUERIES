/* row number: assigns a sequential number to each row
based on a partition of a result set*/
/* show each customers orders in a result set, ordered in
asc*/
select OrderDateKey, t1.CustomerKey, t2.FirstName,
t2.LastName, SalesOrderNumber, EnglishProductName,
TotalProductCost, SalesAmount,
ROW_NUMBER() over (partition by t1.CustomerKey order by OrderDateKey) as row
/* this shows each customer and all orders they every made */
from AdventureWorksDW2019.dbo.FactInternetSales t1
join AdventureWorksDW2019.dbo.DimCustomer t2
on t1.CustomerKey = t2.CustomerKey
join AdventureWorksDW2019.dbo.DimProduct t3
on t1.ProductKey = t3.ProductKey

/* to show only the firt order each customer made we do d ffg*/
with CteMain as
(select OrderDateKey, t1.CustomerKey, t2.FirstName,
t2.LastName, SalesOrderNumber, EnglishProductName,
TotalProductCost, SalesAmount,
ROW_NUMBER() over (partition by t1.CustomerKey order by OrderDateKey) as row
from AdventureWorksDW2019.dbo.FactInternetSales t1
join AdventureWorksDW2019.dbo.DimCustomer t2
on t1.CustomerKey = t2.CustomerKey
join AdventureWorksDW2019.dbo.DimProduct t3
on t1.ProductKey = t3.ProductKey)

select *
from CteMain
where row = 1

/*exercise:display each products and the most recent order date*/
with CteMain as
(select EnglishProductName, OrderDate, row_number() over (partition by t2.EnglishProductName order by OrderDate desc) as row
from AdventureWorksDW2019.dbo.FactInternetSales t1
join AdventureWorksDW2019.dbo.DimProduct t2
on t1.ProductKey = t2.ProductKey)

select *
from CteMain
where row = 1

/* Lead: is used to access data in the next row of ordered output
the syntax is similar to row-number and looks like this*/
select CustomerKey, OrderDate, SalesTerritoryKey, SalesOrderNumber,
OrderQuantity, sum(UnitPrice) as SalesValue,
lead(sum(UnitPrice)) over (partition by CustomerKey order by OrderDate) as NextSalesPurchaseValue
from AdventureWorksDW2019.dbo.FactInternetSales
group by CustomerKey, OrderDate, SalesTerritoryKey,
SalesOrderNumber, OrderQuantity
order by CustomerKey, OrderDate
/* to show result for a particular customer key
we will see all the orders madefrom the first of each day in a month and of the year*/
select CustomerKey, OrderDate, SalesTerritoryKey, SalesOrderNumber,
OrderQuantity, sum(UnitPrice) as SalesValue,
lead(sum(UnitPrice)) over (partition by CustomerKey order by OrderDate) as NextSalesPurchaseValue
from AdventureWorksDW2019.dbo.FactInternetSales
where CustomerKey = 11019
group by CustomerKey, OrderDate, SalesTerritoryKey,
SalesOrderNumber, OrderQuantity
order by CustomerKey, OrderDate

/* Lag: is used to access data in the previous row of ordered output
the syntax is similar to row-number and looks like this*/
select CustomerKey, OrderDate, SalesTerritoryKey, SalesOrderNumber,
OrderQuantity, sum(UnitPrice) as SalesValue,
lag(sum(UnitPrice)) over (partition by CustomerKey order by OrderDate) as PrevSalesPurchaseValue
from AdventureWorksDW2019.dbo.FactInternetSales
group by CustomerKey, OrderDate, SalesTerritoryKey,
SalesOrderNumber, OrderQuantity
order by CustomerKey, OrderDate
/* to show result for a particular customer key
we will see all the orders made each day in a month and of the year*/
select CustomerKey, OrderDate, SalesTerritoryKey, SalesOrderNumber,
OrderQuantity, sum(UnitPrice) as SalesValue,
lag(sum(UnitPrice)) over (partition by CustomerKey order by OrderDate) as PrevSalesPurchaseValue
from AdventureWorksDW2019.dbo.FactInternetSales
where CustomerKey = 11019
group by CustomerKey, OrderDate, SalesTerritoryKey,
SalesOrderNumber, OrderQuantity
order by CustomerKey, OrderDate