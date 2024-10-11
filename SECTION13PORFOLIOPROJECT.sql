/* showing each countrys sales by customers age group.
we need to show country, sales thats unique and age 
when d sales was made which is did btw dob and orderdate*/
with cte_Main as
(select EnglishCountryRegionName, SalesOrderNumber,
datediff(month, BirthDate, OrderDate)/12 as AgeOfSales/* this method gives an acurate age*/
from AdventureWorksDW2019.dbo.FactInternetSales t1
join AdventureWorksDW2019.dbo.DimCustomer t2
on t1.CustomerKey = t2.CustomerKey
join AdventureWorksDW2019.dbo.DimGeography t3
on t2.GeographyKey = t3.GeographyKey)

select EnglishCountryRegionName,
case when AgeOfSales < 30 then 'a:Under 30'
when AgeOfSales between 30 and 40 then 'b: 30 - 40'
when AgeOfSales between 40 and 50 then 'c: 40 - 50'
when AgeOfSales between 50 and 60 then 'd: 50 - 60'
when AgeOfSales > 60 then 'e: Over 60'
else 'Other'
end as AgeGroup, count(SalesOrderNumber) as TotalSalesOrder
from cte_Main
group by EnglishCountryRegionName,
case when AgeOfSales < 30 then 'a:Under 30'
when AgeOfSales between 30 and 40 then 'b: 30 - 40'
when AgeOfSales between 40 and 50 then 'c: 40 - 50'
when AgeOfSales between 50 and 60 then 'd: 50 - 60'
when AgeOfSales > 60 then 'e: Over 60'
else 'Other'
end
Order by EnglishCountryRegionName, AgeGroup

/* EXE 2: showing each products sales by customers age group.
we need to show product, sales thats unique and age 
when d sales was made which is dif btw dob and orderdate */
with cte_Main2 as
(select t3.EnglishProductName,t4.EnglishProductSubcategoryName, SalesOrderNumber,
datediff(month, BirthDate, OrderDate)/12 as AgeOfSales/* this method gives an acurate age*/
from AdventureWorksDW2019.dbo.FactInternetSales t1
join AdventureWorksDW2019.dbo.DimCustomer t2
on t1.CustomerKey = t2.CustomerKey
join AdventureWorksDW2019.dbo.Dimproduct t3
on t1.ProductKey = t3.ProductKey
join AdventureWorksDW2019.dbo.DimProductSubcategory t4
on t3.ProductSubcategoryKey = t4.ProductSubcategoryKey
)
select EnglishProductSubcategoryName as ProductType,
case when AgeOfSales < 30 then 'a:Under 30'
when AgeOfSales between 30 and 40 then 'b: 30 - 40'
when AgeOfSales between 40 and 50 then 'c: 40 - 50'
when AgeOfSales between 50 and 60 then 'd: 50 - 60'
when AgeOfSales > 60 then 'e: Over 60'
else 'Other'
end as AgeGroup, count(SalesOrderNumber) as TotalSalesOrder
from cte_Main2
group by EnglishProductSubcategoryName,
case when AgeOfSales < 30 then 'a:Under 30'
when AgeOfSales between 30 and 40 then 'b: 30 - 40'
when AgeOfSales between 40 and 50 then 'c: 40 - 50'
when AgeOfSales between 50 and 60 then 'd: 50 - 60'
when AgeOfSales > 60 then 'e: Over 60'
else 'Other'
end
Order by EnglishProductSubcategoryName, AgeGroup

/* EXE 3: showing monthly sales for aus and cad compared
in the year 2012. sales thats unique to each day of each month*/
select substring(cast(OrderDateKey as varchar), 1,6) as SalesYearKey, 
SalesTerritoryCountry, SalesOrderNumber, OrderDate
from AdventureWorksDW2019.dbo.FactInternetSales t1
join AdventureWorksDW2019.dbo.DimSalesTerritory t2
on t1.SalesTerritoryKey = t2.SalesTerritoryKey
where SalesTerritoryCountry in ('Australia', 'United States')
and substring(cast(OrderDateKey as varchar), 1,4) = '2012'
Order by OrderDate
/* since its a time data, its best to display it on the
chart using a line chart style*/

/* EXE4: showing each product first reorder date*/
with cte_main as
(select EnglishProductName, OrderDateKey, ReorderPoint, OrderQuantity,
sum(OrderQuantity) as QuantitySold /* sum to get total order of each pdt for each day*/, 
SafetyStockLevel
from AdventureWorksDW2019.dbo.FactInternetSales t1
join AdventureWorksDW2019.dbo.DimProduct t2
on t1.ProductKey = t2.ProductKey
group by  EnglishProductName, OrderDateKey,
		ReorderPoint, SafetyStockLevel, OrderQuantity
),
Sq_Main as
(select *, sum(QuantitySold) over (partition by EnglishProductName order by OrderDateKey) as RunningQuantitySold
/* the sum here is adding order quantity of each product on different days of the month and year in a 
sequential running order. At the end of this, the value gotten at the last order date(also denotes the last order date) 
is the total quantity sold for that particular product over the year/years*/
from cte_main
group by EnglishProductName, OrderDateKey,
ReorderPoint, SafetyStockLevel, QuantitySold, OrderQuantity),
ReorderDate as
(select *, case when (SafetyStockLevel - RunningQuantitySold) <= ReorderPoint then 1 else 0 end as ReorderFlag
/*case where we get 1, then its time to re oder and the order date will be the day of first reorder but for 0
reorder has not been made on the product*/
from Sq_Main)
select EnglishProductName, Min(OrderDateKey) as FirstReorderDate /* this will cut out other years and give us the first reoder date
if we want the last reoder date we use max*/
from ReorderDate
where ReorderFlag = 1
Group by EnglishProductName

