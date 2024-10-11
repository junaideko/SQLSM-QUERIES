/* EXE5: showing the days between the first order and first reorder date.
i.e how long it took to reorder a pdt. over a year proves the product takes too long before
it gets sold out*/
with cteMain2 as
(select EnglishProductName, OrderDateKey, OrderQuantity, ReorderPoint, SafetyStockLevel
,sum(OrderQuantity) as QuantitySoldPerDay
from AdventureWorksDW2019.dbo.FactInternetSales t1
join AdventureWorksDW2019.dbo.DimProduct t2
on t1.ProductKey = t2.ProductKey
Group by EnglishProductName, OrderDateKey, OrderQuantity, ReorderPoint, SafetyStockLevel
),

ReorderFlagSq as
(select *, case when (SafetyStockLevel - RuningQuantitySold) <= ReorderPoint then 1 else 0 end as ReorderFlag
from
(Select *, sum(QuantitySoldPerDay) over (partition by EnglishProductName Order by OrderDateKey) as RuningQuantitySold
from cteMain2
group by EnglishProductName, OrderQuantity, ReorderPoint, SafetyStockLevel, OrderDateKey, QuantitySoldPerDay) RunningQuantity)

select *, datediff(day, cast(ProductFirstOrderDate as char), cast(FirstReorderDate as char)) as DaysToReorder
/* to get the difference in days to reorder */
from
(select EnglishProductName, max(ProductFirstOrderDate) as ProductFirstOrderDate, max(FirstReOrderDate) as FirstReorderDate
from
(select EnglishProductName, min(OrderDateKey) as ProductFirstOrderDate, Null as FirstReOrderDate
from cteMain2
group by EnglishProductName
union all
select EnglishProductName, Null as ProductFirstOrderDate, min(OrderDateKey) as FirstReorderDate
from ReorderFlagSq
where ReorderFlag = 1
Group by EnglishProductName) FirstAndReorder
group by EnglishProductName) MaxFirstAndReorder
where datediff(day, cast(ProductFirstOrderDate as char), cast(FirstReorderDate as char)) > 365 
/* show pdts thattook over a yr to reorder*/

/*EXE6: show all sales on promotion and new sales prices if 25%
discount is added*/
select OrderDate, t1.SalesOrderNumber, SalesReasonName, SalesAmount, round((SalesAmount*0.75), 2) as NewSalesPrice
from AdventureWorksDW2019.DBO.FactInternetSales t1
join AdventureWorksDW2019.dbo.FactInternetSalesReason t2
on t1.SalesOrderNumber = t2.SalesOrderNumber
join AdventureWorksDW2019.dbo.DimSalesReason t3
on t2.SalesReasonKey = t3.SalesReasonKey
where SalesReasonName = 'On Promotion'

/*EXE7: change in value between a customers first and last order*/
with FirstQ as
(select CustomerKey, OrderDate, SalesAmount,
row_number() over (partition by CustomerKey order by OrderDate Asc) as SalesValue1
from AdventureWorksDW2019.dbo.FactInternetSales),
SecondQ as
(select CustomerKey, OrderDateKey, SalesAmount,
row_number() over (partition by CustomerKey order by OrderDate Desc) as SalesValue2
from AdventureWorksDW2019.dbo.FactInternetSales)
select CustomerKey, sum(FirstPurchase) as FirstPurchase, sum(LastPurchase) as LastPurchase,
(sum(LastPurchase) - sum(FirstPurchase)) as ChangeInPurchase
from
(select CustomerKey, SalesAmount as FirstPurchase, null as LastPurchase
from FirstQ
where SalesValue1 = 1
union all
select CustomerKey, Null as FirstPurchase, SalesAmount as LastPurchase
from SecondQ
where SalesValue2 = 1) PurchaseQ
group by CustomerKey
having sum(LastPurchase) - sum(FirstPurchase) <> 0
Order by CustomerKey