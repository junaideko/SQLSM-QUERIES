/*EXE 5: show non bike product the customers  bought next after bike */
with AllPurchases as
(select t1.CustomerKey, SalesOrderNumber, OrderDate, t4.EnglishProductSubcategoryName,
ROW_NUMBER() over (partition by t1.CustomerKey order by OrderDate) as PurchaseNumber
from AdventureWorksDW2019.dbo.FactInternetSales t1
join AdventureWorksDW2019.dbo.DimCustomer t2
on t1.CustomerKey = t2.CustomerKey
join AdventureWorksDW2019.dbo.DimProduct t3
on t1.ProductKey = t3.ProductKey
join AdventureWorksDW2019.dbo.DimProductSubcategory t4
on t3.ProductSubcategoryKey = t4.ProductSubcategoryKey)
,
BikePurchases as
(select *, PurchaseNumber + 1 as NextPurchaseNum
from AllPurchases
where EnglishProductSubcategoryName in ('Mountain Bikes', 'Touring Bikes', 'Road Bikes'))
select t1.*, t2.EnglishProductSubcategoryName as NextProductPurch
from BikePurchases t1
left join AllPurchases t2
on t1.CustomerKey = t2.CustomerKey and t1.NextPurchaseNum = t2.PurchaseNumber
where 1=1
and t2.EnglishProductSubcategoryName not in ('Mountain Bikes', 'Touring Bikes', 'Road Bikes')
