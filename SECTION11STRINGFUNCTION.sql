/* concatenate: use to merge two or more columns togeher*/
select Title, FirstName, MiddleName,LastName,
concat(FirstName, ' ', LastName) as FullName /* merged 2 columns
to give a new colum, and we added space in between d new name*/
FROM AdventureWorksDW2019.dbo.DimCustomer

/* sub string: this returns the length of any string column 
specified. its only used on a string character. */
select substring(cast(OrderDateKey as varchar), 1,6) monthkey
/* we had to convert to a char b4 getting our month key */
from AdventureWorksDW2019.dbo.FactInternetSales
;/* another e.g*/
select distinct substring(EnglishCountryRegionName, 1,3) as Countrycode,
EnglishCountryRegionName
from AdventureWorksDW2019.dbo.DimGeography