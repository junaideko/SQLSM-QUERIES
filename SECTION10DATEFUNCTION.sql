/* Year, Month and Day: return a new column based on whats
specified in the bracket, its also used at the selct statement*/
select CustomerKey, FirstName, LastName, BirthDate,
year(BirthDate) as YearBorn, /*extracts and returns the year*/
month(BirthDate) as MonthBorn,/*extracts and returns the month*/
day(BirthDate) as DayBorn /*extracts and returns the day*/
from AdventureWorksDW2019.dbo.DimCustomer

/*getdate : this is used to get todays date, its used at the
select statement as well, can be used often in report,
to calculate age*/
select getdate() 

/* Datediff: used to show the differnce betwen 2dates based on
the interval you enter. Its often used with getdate function.
e.g find date of employee in a data*/
select FirstName, LastName, BirthDate,
datediff(year, BirthDate, getdate()) as age /* yr btw bday and todays date*/
from AdventureWorksDW2019.dbo.DimEmployee
 /* you can do same for month and day as shwon below*/
select FirstName, LastName, BirthDate,
datediff(month, BirthDate, getdate()) as age /* mth btw bday and todays date*/
from AdventureWorksDW2019.dbo.DimEmployee
;
select FirstName, LastName, BirthDate,
datediff(day, BirthDate, getdate()) as age /* day btw bday and todays date*/
from AdventureWorksDW2019.dbo.DimEmployee
;
select FirstName, LastName, BirthDate,
datediff(day, getdate() - 31, getdate()) as age /* yr btw bday and todays date*/
from AdventureWorksDW2019.dbo.DimEmployee

/*dateadd : can be used to add or subtract D,M,Y etc from any
date column. e.g use to show sales for past/present
years/months. best used in the where clause*/
select *, dateadd(year, -10, getdate()) as TenYearsAgo
from AdventureWorksDW2019.dbo.FactInternetSales
where OrderDate between dateadd(year, -10, getdate()) and dateadd(year, -9, getdate())

/* Date table: its useful to join a query to this type of data
because one can use columns of it e.g year, day of week etc.
it saves use from using those date functions*/
select t1.OrderDate, t1.SalesOrderNumber, t2.*
from AdventureWorksDW2019.dbo.FactInternetSales t1
join AdventureWorksDW2019.dbo.DimDate t2
on t1.OrderDateKey = t2.DateKey

/* cast: simply used to change data type. commonly used when
joining 2 tables with diff data type. you can cast mutiple 
times. Also, sql server can not cast integer as a date,
hence int has to be casted to cahr then from char to date*/
select cast(OrderDateKey as varchar) as CalDate, SalesOrderNumber,
SalesAmount, OrderDateKey
from AdventureWorksDW2019.dbo.FactInternetSales
;
/* the above wont realy show any diff but the conversion
from int to char has been done. now cast to date*/
select cast(cast(OrderDateKey as varchar) as Date) as CalDate, SalesOrderNumber,
SalesAmount, OrderDateKey
from AdventureWorksDW2019.dbo.FactInternetSales
/* notice the difference now? d column now appears as a date.
you can also include time as shown below*/
select cast(cast(OrderDateKey as varchar) as DateTime) as CalDate, SalesOrderNumber,
SalesAmount, OrderDateKey
from AdventureWorksDW2019.dbo.FactInternetSales
/* convert: this will do the same as cast but the syntax is dif*/
select convert(date, convert(varchar,OrderDateKey)) as CalDate, SalesOrderNumber,
SalesAmount, OrderDateKey
from AdventureWorksDW2019.dbo.FactInternetSales

/*Joining tables on more than one condition by adding AND, 
and changing data type*/
select OrderDate, SalesOrderNumber, SalesAmount, FirstName,
LastName, t2.DateFirstPurchase
from AdventureWorksDW2019.dbo.FactInternetSales t1
join AdventureWorksDW2019.dbo.Dimcustomer t2
on t1.CustomerKey = t2.CustomerKey 
and cast(cast(t1.OrderDateKey as varchar) as date) = t2.DateFirstPurchase
/* in the above, order date shows timw , to remove the timw
and show as date we will cast it as shown below*/
select cast(OrderDate as date) as OrderDate, SalesOrderNumber, SalesAmount, FirstName,
LastName, t2.DateFirstPurchase
from AdventureWorksDW2019.dbo.FactInternetSales t1
join AdventureWorksDW2019.dbo.Dimcustomer t2
on t1.CustomerKey = t2.CustomerKey 
and cast(cast(t1.OrderDateKey as varchar) as date) = t2.DateFirstPurchase

/*Excercise1; display each customer and their age when they ma
de their 1st purchase*/
select FirstName, Title, MiddleName, LastName,
CustomerKey, DateFirstPurchase, BirthDate,
DateDiff(year, BirthDate, DateFirstPurchase) as AgeAtFirstPurchase
from AdventureWorksDW2019.dbo.DimCustomer

/* Exercise 2: show year, each days name in english, and the
total count of sale, ordered by calender year and day*/
select year(OrderDate) as CalenderYear, t2.DayNumberOfWeek,
datename(weekday,OrderDate) as EnglishDayNameOfWeek,
count(SalesOrderNumber) as Sales
from AdventureWorksDW2019.dbo.FactInternetSales t1
join AdventureWorksDW2019.dbo.DimDate t2
on t1.OrderDateKey = t2.DateKey
group by year(OrderDate), t2.DayNumberOfWeek,
datename(weekday,OrderDate)
order by year(OrderDate),datename(weekday,OrderDate),
t2.DayNumberOfWeek


