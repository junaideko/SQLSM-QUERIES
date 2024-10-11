/*Google Sheet: used to visualise output after pasting on d 
sheet. then pivot tables can be used to create simple charts from it*/
select top (3000) t1.*, t2.SalesTerritoryCountry
from AdventureWorksDW2019.dbo.FactInternetSales t1
join AdventureWorksDW2019.dbo.DimSalesTerritory t2
on t1.SalesTerritoryKey = t2.SalesTerritoryKey
where substring(cast(OrderDateKey as Varchar),1,4) = '2012'
/* cltr A d output from the query above
right click n copy with header. paste on google spreadsheet
*/