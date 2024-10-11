/* Case statement: used to retun a specified value based on
a condition, also known as if else in other prog language
also used at the select statement*/
select OrderDateKey, SalesAmount,
case when SalesAmount <= 1000 then 'Under $1000'
	when SalesAmount between 1000 and 2000 then '$1k - $2k'
	when SalesAmount between 2000 and 3000 then '$2k - $3k'
	when SalesAmount between 3000 and 4000 then '$3k - $4k'
	when SalesAmount > 4000 then 'over $4k'
	else 'other' /* neccessary incase there is an error*/
	end as Sales,
count(SalesOrderNumber) as CountOfSales
from AdventureWorksDW2019.dbo.FactInternetSales sa
group by OrderDateKey, SalesAmount,
(case when SalesAmount <= 1000 then 'Under $1000'
	when SalesAmount between 1000 and 2000 then '$1k - $2k'
	when SalesAmount between 2000 and 3000 then '$2k - $3k'
	when SalesAmount between 3000 and 4000 then '$3k - $4k'
	when SalesAmount > 4000 then 'over $4k'
	else 'other'
	end)
order by OrderDateKey desc, Sales desc

/* flag- with case when, to flag each row and easily find
rows which meet d condition, and when d flag is 1/0 one can
also sum this column*/
/* show sales in canada and sales in canada over $3.5k */
select ProductKey, OrderDate, DueDateKey, ShipDateKey, CustomerKey,
SalesOrderNumber, TotalProductCost, SalesAmount, t2.SalesTerritoryCountry,
case when SalesTerritoryCountry = 'Canada' then 1 else 0 end as CANADA,
/* this colum is named canada and retuin 1 for canada sales*/
case when SalesTerritoryCountry = 'Canada' and SalesAmount > 3500 then 1 else 0 end as CANADAOVER$3500
/*this column is named cnov35k and return 1 for sales in cd over 3500 or 0 for ther wise*/
from AdventureWorksDW2019.dbo.FactInternetSales t1
join AdventureWorksDW2019.dbo.DimSalesTerritory t2
on t1.SalesTerritoryKey = t2.SalesTerritoryKey

/* create a cte and sum each colum flag to show
how many canada sales were over $3.5k*/
with CANADASALES as
(select ProductKey, OrderDateKey, DueDateKey, ShipDateKey, CustomerKey,
SalesOrderNumber, TotalProductCost, SalesAmount, t2.SalesTerritoryCountry,
case when SalesTerritoryCountry = 'Canada' then 1 else 0 end as CANADA,
/* this colum is named canada and retuin 1 for canada sales*/
case when SalesTerritoryCountry = 'Canada' and SalesAmount > 3500 then 1 else 0 end as CANADAOVER$3500
/*this column is named cnov35k and return 1 for sales in cd over 3500 or 0 for ther wise*/
from AdventureWorksDW2019.dbo.FactInternetSales t1
join AdventureWorksDW2019.dbo.DimSalesTerritory t2
on t1.SalesTerritoryKey = t2.SalesTerritoryKey)

select OrderDateKey, sum(CANADA) as CanadaSales,
sum(CANADAOVER$3500) as CanadaSalesOver3500
from CANADASALES
group by OrderDateKey
order by sum(CANADAOVER$3500) desc