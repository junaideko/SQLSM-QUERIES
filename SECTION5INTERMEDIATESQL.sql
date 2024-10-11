/* INNER; returns mathing rows no duplicate just like distinct; its a 
practice to always include the table the colums are coming from; you can also use
use ordinary join as inner join, LEFT AND RIGHT JOIN */
SELECT OrderDate, T1.ProductKey, SalesOrderNumber,
OrderQuantity, SalesAmount, EnglishProductName, EnglishDescription
FROM AdventureWorksDW2019.dbo.FactInternetSales T1
INNER JOIN /* or only join*/
AdventureWorksDW2019.dbo.Dimproduct T2
ON
T1.ProductKey = T2.ProductKey /* column common to both tables */

SELECT OrderDate, T1.ProductKey, T2.SalesOrderNumber,
T2.OrderQuantity, T2.SalesAmount, T1.EnglishProductName, T1.EnglishDescription
FROM AdventureWorksDW2019.dbo.Dimproduct T1
LEFT JOIN /* return products that has sales and those that done have sales */
AdventureWorksDW2019.dbo.FactInternetSales T2
ON
T1.ProductKey = T2.ProductKey 
WHERE T2.OrderDate IS NULL /* will also return only product 
names with n sales/purchase */

SELECT OrderDate, T1.ProductKey, T1.SalesOrderNumber,
T1.OrderQuantity, T1.SalesAmount, T2.EnglishProductName, T2.EnglishDescription
FROM AdventureWorksDW2019.dbo.FactInternetSales T1
RIGHT JOIN /* return products that has sales and those that done have sales */
AdventureWorksDW2019.dbo.Dimproduct T2
ON
T1.ProductKey = T2.ProductKey 

/*EXERCISE: SHOWS MATCHING CUSTOMER*/
SELECT T2.FirstName, T2.LastName, T1.SalesOrderNumber, T1.SalesAmount
FROM AdventureWorksDW2019.dbo.FactInternetSales T1
JOIN AdventureWorksDW2019.dbo.DimCustomer T2
ON T1.CustomerKey = T2.CustomerKey /* column common to both tables */

/*EXERCISE 2: SHOW ALL ORDERS BY CUSTOMERS WITH LAST NAME HILL EVEN IF THEY MADE NO ORDER */
SELECT FirstName, LastName, EmailAddress, OrderDate, SalesAmount
FROM AdventureWorksDW2019.dbo.DimCustomer T1
LEFT JOIN AdventureWorksDW2019.dbo.FactInternetSales T2
ON T1.CustomerKey = T2.CustomerKey
WHERE LastName = 'Hill'

/* UNION: REMOVES DUPLICATE AND UNION ALL: INCLUDES DUPLICATE.
both must have same number of colums and data type*/
select 'customer' as type, firstname, lastname, emailaddress /* returns
a new column named type, with rows as customer or employee as stated in
each select statement to denotes the table each data came from */
from AdventureWorksDW2019.dbo.DimCustomer
union
select 'employee' as type, firstname, lastname, emailaddress
from AdventureWorksDW2019.dbo.DimEmployee

select 'customer' as type, firstname, lastname, emailaddress /* returns
a new column named type, with rows as customer or employee as stated in
each select statement including duplicates from either or both tables */
from AdventureWorksDW2019.dbo.DimCustomer
union all
select 'employee' as type, firstname, lastname, emailaddress
from AdventureWorksDW2019.dbo.DimEmployee