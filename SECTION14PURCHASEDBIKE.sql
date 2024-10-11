/*Exe: profile of customers who purchased bike. show
countrys sales, commute distance, amount of purchase, yearly income,
bikes sales over time for customers who have children and those who dont*/
with BikeSales as
(select OrderDateKey, OrderDate, t1.CustomerKey, BirthDate, YearlyIncome,
TotalChildren, CommuteDistance,EnglishCountryRegionName as Country,
EnglishProductSubcategoryName as BikeType, SalesAmount, SalesOrderNumber
from AdventureWorksDW2019.dbo.FactInternetSales t1
join AdventureWorksDW2019.dbo.DimCustomer  t2
on t1.CustomerKey = t2.CustomerKey
join AdventureWorksDW2019.dbo.DimGeography t3
on t2.GeographyKey = t3.GeographyKey
join AdventureWorksDW2019.dbo.DimProduct t4
on t1.ProductKey = t4.ProductKey
join AdventureWorksDW2019.dbo.DimProductSubcategory t5
on t4.ProductSubcategoryKey = t5.ProductSubcategoryKey
where EnglishProductSubcategoryName in ('Mountain Bikes', 'Touring Bikes', 'Road Bikes')
)
/* EXE1: Bike sales by commute distance and country*/
select Country, CommuteDistance, count(distinct SalesOrderNumber) as CountrySales
from BikeSales
group by Country, CommuteDistance
order by Country, CommuteDistance

/*EXE2: yearly income and how many purchases the customer made*/
with BikeSales2 as
(select OrderDateKey, OrderDate, t1.CustomerKey, BirthDate, YearlyIncome,
TotalChildren, CommuteDistance,EnglishCountryRegionName as Country,
EnglishProductSubcategoryName as BikeType, SalesAmount, SalesOrderNumber
from AdventureWorksDW2019.dbo.FactInternetSales t1
join AdventureWorksDW2019.dbo.DimCustomer  t2
on t1.CustomerKey = t2.CustomerKey
join AdventureWorksDW2019.dbo.DimGeography t3
on t2.GeographyKey = t3.GeographyKey
join AdventureWorksDW2019.dbo.DimProduct t4
on t1.ProductKey = t4.ProductKey
join AdventureWorksDW2019.dbo.DimProductSubcategory t5
on t4.ProductSubcategoryKey = t5.ProductSubcategoryKey
where EnglishProductSubcategoryName in ('Mountain Bikes', 'Touring Bikes', 'Road Bikes')
)
select CustomerKey, case when YearlyIncome < 50000 then 'a:below $50k'
when YearlyIncome between 50000 and 75000 then 'b:$50k to $75k'
when YearlyIncome between 75000 and 100000 then 'c:$75k to $100k'
when YearlyIncome > 100000 then 'd: Above $100k'
else 'other'
end as Income,
count (distinct(SalesOrderNumber)) as IncomeSales
from BikeSales2
group by CustomerKey, YearlyIncome
order by CustomerKey, YearlyIncome

/*EXE3: Sales accross customers with and without children on a montly bases*/
with BikeSales3 as
(select OrderDateKey, OrderDate, t1.CustomerKey, BirthDate, YearlyIncome,
TotalChildren, CommuteDistance,EnglishCountryRegionName as Country,
EnglishProductSubcategoryName as BikeType, SalesAmount, SalesOrderNumber
from AdventureWorksDW2019.dbo.FactInternetSales t1
join AdventureWorksDW2019.dbo.DimCustomer  t2
on t1.CustomerKey = t2.CustomerKey
join AdventureWorksDW2019.dbo.DimGeography t3
on t2.GeographyKey = t3.GeographyKey
join AdventureWorksDW2019.dbo.DimProduct t4
on t1.ProductKey = t4.ProductKey
join AdventureWorksDW2019.dbo.DimProductSubcategory t5
on t4.ProductSubcategoryKey = t5.ProductSubcategoryKey
where EnglishProductSubcategoryName in ('Mountain Bikes', 'Touring Bikes', 'Road Bikes')
)
select substring(cast(OrderDateKey as char), 1,6) as MonthKey, 
case when TotalChildren = 0 then 'No children'
else 'Has children' end as 'NoOfChildren',
count (distinct(SalesOrderNumber)) as BikeSales
from BikeSales3
where substring(cast(OrderDateKey as char), 1,4) = '2012'
group by substring(cast(OrderDateKey as char), 1,6), TotalChildren
