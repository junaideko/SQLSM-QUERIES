/*Sub queries-  a query that appears inside another query, 
usually in bracket and the name of the subquery is type after the closing
bracket. and CTE's */
select OrderDate, count(SalesOrderNumber) as TotalNumberOfOrders
from AdventureWorksDW2019.dbo.FactInternetSales
group by OrderDate
having count(SalesOrderNumber) /* this will take the aggrt funtion and not the 
what we name d aggrt function output as*/ 
> /* we are taking the number of orders greater than the avg number of order*/
(select avg(TotalNumberOfOrders) as AvgTotalNumberOfOrders/* taking the avg order for eachday
using a sub query because one cant take an aggregate of an aggrt*/
from
(select OrderDate, count(SalesOrderNumber) as TotalNumberOfOrders
from AdventureWorksDW2019.dbo.FactInternetSales
Group by OrderDate) NumberOfOrders) /* this is a sub query */
/*having a subquery inside a sub query, output is 53 which is d avg */
 
/*Common Table Expressions (CTEs): its another way of writing
 sub query and its preferly used because its easier to understand
 here, we name the CTE first followed by the query in bracket, then use 
 query the cte name. separte multiple cte by comme, and you dont have
 to use with to name the 2nd and other ctes that follows.*/
with NumberOfOrders as
(select OrderDate, count(SalesOrderNumber) as TotalNumberOfOrders
from AdventureWorksDW2019.dbo.FactInternetSales
Group by OrderDate), /*1st cte */

AvgTotNumberOfOrders as 
(select avg(TotalNumberOfOrders) as AvgTotalNumberOfOrders
from NumberOfOrders) /* 2nd cte, which is also the last doesnt require a comma*/

select *
from NumberOfOrders n
where TotalNumberOfOrders > (select AvgTotalNumberOfOrders from
AvgTotNumberOfOrders)
order by OrderDate /*our last query*/
