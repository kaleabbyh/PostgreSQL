use AdventureWorks2022
GO

--=========================================================================================================
--1) retrieve all rows and columns and sort by JobTitle
select * from  HumanResources.Employee order by JobTitle

--=========================================================================================================
--2) retrieve all rows and columns from the employee table using table aliasing in the Adventureworks database

select * from  HumanResources.Employee  E
select * from  Person.Person P

select E.BusinessEntityID,
	   ISNULL(P.PersonType,'') as PersonType,
	   ISNULL(nullif(P.NameStyle,0),'false') as NameStyle,
	   isnull(P.Title,'') as Title,
	   ISNULL(P.FirstName,'')as FirstName,
	   ISNULL(P.MiddleName,'') as MiddleName,
	   ISNULL(P.LastName,'') as LastName,
	   ISNULL( P.Suffix,'') as Suffix,
	   ISNULL( P.EmailPromotion,'') as EmailPromotion,
	   ISNULL(P.AdditionalContactInfo,'') as AdditionalContactInfo,
	   ISNULL(P.Demographics,'') as Demographics,
	   ISNULL(P.rowguid,'') as rowguid ,
	   ISNULL(P.ModifiedDate,'')as ModifiedDate
from  HumanResources.Employee  E
join Person.Person P
on E.BusinessEntityID= P.BusinessEntityID
order by P.LastName asc


--=========================================================================================================
--3) a query in SQL to return all rows and a subset of the columns (FirstName, LastName, businessentityid)

select * from  HumanResources.Employee  E
select * from  Person.Person P

select P.FirstName,
	   P.LastName,
	   P.BusinessEntityID as employee_id
from  Person.Person P
order by P.LastName asc


--=========================================================================================================
--4) a query to get products that have a sellstartdate that is not NULL and a productline of 'T'
-- Return productid, productnumber, and name. Arranged the output in ascending order on name.

select P.ProductID,
	   P.ProductNumber,
	   P.Name
from   production.Product P
where P.SellStartDate is not null and P.ProductLine='T'
order by P.Name asc

select * from  production.Product

--=========================================================================================================
--5) return all rows from the salesorderheader table in Adventureworks database and calculate the percentage of tax on the subtotal have decided.
--Return salesorderid, customerid, orderdate, subtotal, percentage of tax column. Arranged the result set in ascending order on subtotal.

select	salesorderid,
		customerid,
		orderdate,
		subtotal,
		TaxAmt,
		(TaxAmt/subtotal)as tax_percent 
from   sales.salesorderheader S
order by subtotal asc

select * from  sales.salesorderheader

--=========================================================================================================
--6) From the following table write a query in SQL to create a list of unique jobtitles in the employee table in Adventureworks database. 
--Return jobtitle column and arranged the resultset in ascending order.


select	distinct JobTitle
from   HumanResources.Employee
order by JobTitle asc

select * from  HumanResources.Employee

--=========================================================================================================
--7)From the following table write a query in SQL to calculate the total freight paid by each customer. Return customerid and total freight.
--Sort the output in ascending order on customerid.


select	customerid,sum(Freight) as total_freight
from   sales.salesorderheader
group by CustomerID
order by customerid asc

select * from  sales.salesorderheader

--=========================================================================================================
--8. From the following table write a query in SQL to find the average and the sum of the subtotal for every customer. 
--Return customerid, average and sum of the subtotal. Grouped the result on customerid and salespersonid. Sort the result on customerid column in descending order.


select	customerid,
		salespersonid,
		(sum(subtotal)/count(*)) as avg_subtotal,
		sum(subtotal) as sum_subtotal
from   sales.salesorderheader
group by customerid, salespersonid
order by customerid desc

select * from  sales.salesorderheader

--=========================================================================================================
--9. From the following table write a query in SQL to retrieve total quantity of each productid which are in shelf of 'A' or 'C' or 'H'.
--Filter the results for sum quantity is more than 500. Return productid and sum of the quantity. Sort the results according to the productid in ascending order.


select	ProductID,
		sum(Quantity) as sum_subtotal
from   production.productinventory
where shelf in ('A','C','H')
group by ProductID
order by productid asc

select * from  production.productinventory

--=========================================================================================================
--10.From the following table write a query in SQL to find the total quentity for a group of locationid multiplied by 10.

select	sum(Quantity)*10 as total_quantity
from   production.productinventory
group by LocationID


select * from  production.productinventory

--=========================================================================================================
--11. From the following tables write a query in SQL to find the persons whose last name starts with letter 'L'.
--Return BusinessEntityID, FirstName, LastName, and PhoneNumber. Sort the result on lastname and firstname.

select  P.BusinessEntityID,
		FirstName,
		LastName,
		F.PhoneNumber as person_phone
from   Person.Person P
join Person.PersonPhone F
on P.BusinessEntityID=F.BusinessEntityID
where LastName like 'L%'
order by LastName,FirstName
		



select * from  Person.PersonPhone
select * from  Person.Person

--=========================================================================================================
--12. From the following table write a query in SQL to find the sum of subtotal column. Group the sum on distinct salespersonid and customerid.
--Rolls up the results into subtotal and running total. Return salespersonid, customerid and sum of subtotal column i.e. sum_subtotal.

select  SalesPersonID,customerid,sum(subtotal) sum_subtotal
from   sales.salesorderheader
where SalesPersonID is not null
group by SalesPersonID , customerid
order by SalesPersonID , customerid
-------------------OR-------------------------------

SELECT salespersonid,customerid,sum(subtotal) AS sum_subtotal
FROM sales.salesorderheader s 
where SalesPersonID is not null
GROUP BY ROLLUP (salespersonid, customerid);


select * from sales.salesorderheader

--=========================================================================================================
--13. From the following table write a query in SQL to find the sum of the quantity of all combination of group of distinct locationid and shelf column. 
    --Return locationid, shelf and sum of quantity as TotalQuantity.

SELECT Null as locationid, '' as shelf, SUM(quantity) AS TotalQuantity
FROM production.productinventory
union all
SELECT locationid, shelf, SUM(quantity) AS TotalQuantity
FROM production.productinventory
GROUP BY locationid, shelf;
-------------------OR-------------------------------

SELECT locationid, shelf, SUM(quantity) AS TotalQuantity
FROM production.productinventory
GROUP BY  locationid, shelf;
-------------------OR-------------------------------

SELECT locationid, shelf, SUM(quantity) AS TotalQuantity
FROM production.productinventory
GROUP BY GROUPING SETS
    (    
         (locationid, shelf),
         ()
       
    )

select * from production.productinventory

--=========================================================================================================
--14. From the following table write a query in SQL to find the sum of the quantity with subtotal for each locationid. 
	--Group the results for all combination of distinct locationid and shelf column. Rolls up the results into subtotal and running total.
	--Return locationid, shelf and sum of quantity as TotalQuantity.

SELECT locationid, shelf, SUM(quantity) AS TotalQuantity
FROM production.productinventory
GROUP BY GROUPING SETS ( ROLLUP (locationid, Shelf), CUBE (locationid, shelf) );
-------------------OR-------------------------------
SELECT locationid, shelf, SUM(quantity) AS TotalQuantity
FROM production.productinventory
GROUP BY ROLLUP (locationid, Shelf)

-------------------OR-------------------------------
SELECT locationid, shelf, SUM(quantity) AS TotalQuantity
FROM production.productinventory
GROUP BY GROUPING SETS
    (    
         (locationid, shelf),
         ()
       
    )

select * from production.productinventory


--=========================================================================================================
--15. From the following table write a query in SQL to find the total quantity for each locationid and calculate the grand-total for all locations. 
--Return locationid and total quantity. Group the results on locationid.

select	locationid,sum(Quantity) totalquantity
from   production.productinventory
group by grouping sets (locationid,()) 



select * from  production.productinventory


--==========================================================================
--16. From the following table write a query in SQL to retrieve the number of employees for each City. Return city and number of employees. 
--Sort the result in ascending order on city.

select AddressID, COUNT(AddressID) from  Person.BusinessEntityAddress group by AddressID

select City,COUNT(City) noofemployees
from Person.Address 
group by City order by City


--==========================================================================
--17. From the following table write a query in SQL to retrieve the total sales for each year. 
--Return the year part of order date and total due amount. Sort the result in ascending order on year part of order date.
select *  from Sales.SalesOrderHeader 


select YEAR(OrderDate) as [Year],
	   sum(SubTotal) as [Order Amount ]
from Sales.SalesOrderHeader 
group by YEAR(OrderDate) 
order by YEAR(OrderDate)



--==========================================================================
--18. From the following table write a query in SQL to retrieve the total sales for each year. 
--Filter the result set for those orders where order year is on or before 2016. Return the year part of orderdate and total due amount. 
--Sort the result in ascending order on year part of order date.

select YEAR(OrderDate) as [Year],
	   sum(SubTotal) as [Order Amount ]
from Sales.SalesOrderHeader 
where YEAR(OrderDate) < '2016'
group by YEAR(OrderDate) 
order by YEAR(OrderDate)


--==========================================================================
--19. From the following table write a query in SQL to find the contacts who are designated as a manager in various departments.
 --Returns ContactTypeID, name. Sort the result set in descending order.

select * from Person.ContactType
where Name like '%manager' 
order by ContactTypeID desc


--==========================================================================
--20. From the following tables write a query in SQL to make a list of contacts who are designated as 'Purchasing Manager'. 
--Return BusinessEntityID, LastName, and FirstName columns. Sort the result set in ascending order of LastName, and FirstName.

Select * from  Person.BusinessEntityContact
Select * from Person.ContactType
 



SELECT pp.BusinessEntityID, LastName, FirstName
FROM Person.BusinessEntityContact AS pb 
JOIN Person.ContactType AS pc
ON pc.ContactTypeID = pb.ContactTypeID
JOIN Person.Person AS pp
ON pp.BusinessEntityID = pb.PersonID
WHERE pc.Name = 'Purchasing Manager'
ORDER BY LastName, FirstName;

--==========================================================================
--21. From the following tables write a query in SQL to retrieve the salesperson for each PostalCode who belongs to a territory and SalesYTD is not zero.
 --Return row numbers of each group of PostalCode, last name, salesytd, postalcode column. Sort the salesytd of each postalcode group in descending order. 
 --Shorts the postalcode in ascending order.

select * from Sales.SalesPerson
select * from Person.Person
select * from Person.Address


select  ROW_NUMBER() OVER (PARTITION BY  pa.PostalCode ORDER BY  SalesYTD DESC) AS [Row Number],
		pp.LastName, ss.SalesYTD, pa.PostalCode
		
from Sales.SalesPerson ss
join Person.Person pp
on ss.BusinessEntityID=pp.BusinessEntityID
join person.Address pa
on pa.AddressID=ss.BusinessEntityID
WHERE TerritoryID IS NOT NULL
	  AND SalesYTD <> 0
ORDER BY PostalCode;



--==========================================================================
--22. From the following table write a query in SQL to count the number of contacts for combination of each type and name.
 --Filter the output for those who have 100 or more contacts. Return ContactTypeID and ContactTypeName and BusinessEntityContact.
 --Sort the result set in descending order on number of contacts.

select * from Person.BusinessEntityContact

select * from  Person.ContactType

select pb.contacttypeid,pc.Name ctypename,count(*) nocontacts
from Person.BusinessEntityContact pb
join Person.ContactType pc
on pb.ContactTypeID=pc.ContactTypeID
group by pb.ContactTypeID, pc.Name
having( count(*) >=100)
order by COUNT(*) desc


--==========================================================================
--23. From the following table write a query in SQL to retrieve the RateChangeDate, full name (first name, middle name and last name) and 
--weekly salary (40 hours in a week) of employees. In the output the RateChangeDate should appears in date format. Sort the output in 
--ascending order on NameInFull.

select * from  HumanResources.EmployeePayHistory
select * from  Person.Person

select	CAST(HE.RateChangeDate as date ) AS FromDate,
		--( ISNULL(pp.FirstName,'')+', '+ ISNULL(pp.MiddleName,'')+' '+ISNULL(pp.LastName,'')) nameinfull,
		CONCAT(PP.LastName, ', ', PP.FirstName, ' ', PP.MiddleName) AS NameInFull,
		(HE.Rate*40) salaryinaweek
from HumanResources.EmployeePayHistory HE
join Person.Person PP
on HE.BusinessEntityID=pp.BusinessEntityID
order by nameinfull

--==========================================================================
--24. From the following tables write a query in SQL to calculate and display the latest weekly salary of each employee.
--Return RateChangeDate, full name (first name, middle name and last name) and weekly salary (40 hours in a week) of employees Sort the output
--in ascending order on NameInFull.

select * from  HumanResources.EmployeePayHistory
select * from  Person.Person

select	CAST(HE.RateChangeDate as date ) AS FromDate,
		CONCAT(PP.LastName, ', ', PP.FirstName, ' ', PP.MiddleName) AS NameInFull,
		(HE.Rate*40) salaryinaweek
from HumanResources.EmployeePayHistory HE
join Person.Person PP
on HE.BusinessEntityID=pp.BusinessEntityID
 WHERE HE.RateChangeDate = (SELECT MAX(RateChangeDate)
                                FROM HumanResources.EmployeePayHistory 
                                WHERE BusinessEntityID = HE.BusinessEntityID
								)
order by nameinfull


--==========================================================================
--25. From the following table write a query in SQL to find the sum, average, count, minimum, and maximum order quentity for those orders 
--whose id are 43659 and 43664. Return SalesOrderID, ProductID, OrderQty, sum, average, count, max, and min order quantity.

select * from  Sales.SalesOrderDetail

select SalesOrderId,
		productid,
		orderqty,
		 sum(orderqty) OVER (PARTITION BY  ss.SalesOrderId ) [Total Quantity],
		 avg(orderqty)  OVER (PARTITION BY  ss.SalesOrderId ) [Avg Quantity],
		 count(*)      OVER (PARTITION BY  ss.SalesOrderId ) [No of Orders],
		 min(OrderQty) OVER (PARTITION BY  ss.SalesOrderId ) [Min Quantity],
		 max(OrderQty) OVER (PARTITION BY  ss.SalesOrderId ) [Max Quantity]
from Sales.SalesOrderDetail ss
where ss.SalesOrderId in (43659 , 43664)


SELECT SalesOrderID, ProductID, OrderQty
    ,SUM(OrderQty) OVER win AS "Total Quantity"
    ,AVG(OrderQty) OVER win AS "Avg Quantity"
    ,COUNT(OrderQty) OVER win AS "No of Orders"
    ,MIN(OrderQty) OVER win AS "Min Quantity"
    ,MAX(OrderQty) OVER win AS "Max Quantity"
FROM Sales.SalesOrderDetail
WHERE SalesOrderID IN(43659,43664)
WINDOW win AS (PARTITION BY SalesOrderID);

--==========================================================================
--26. From the following table write a query in SQL to find the sum, average, and number of order quantity for those orders whose 
--ids are 43659 and 43664 and product id starting with '71'. Return SalesOrderID, OrderNumber,ProductID, OrderQty, sum, average, 
--and number of order quantity.


select * from  Sales.SalesOrderDetail


SELECT SalesOrderID AS OrderNumber, ProductID,
    OrderQty AS Quantity,
    SUM(OrderQty) OVER (ORDER BY SalesOrderID, ProductID) AS Total,
    AVG(OrderQty) OVER(PARTITION BY SalesOrderID ORDER BY SalesOrderID, ProductID) AS Avg,
    COUNT(OrderQty) OVER(ORDER BY SalesOrderID, ProductID ROWS BETWEEN UNBOUNDED PRECEDING AND 1 FOLLOWING) AS Count
FROM Sales.SalesOrderDetail SS
WHERE SalesOrderID IN(43659,43664) and CAST(ProductID AS varchar(10)) LIKE '71%';

--==========================================================================
--27. From the following table write a query in SQL to retrieve the total cost of each salesorderID that exceeds 100000. Return SalesOrderID, total cost.
SELECT SalesOrderID, SUM(orderqty*unitprice) AS OrderIDCost  
FROM Sales.SalesOrderDetail  
GROUP BY SalesOrderID  
HAVING SUM(orderqty*unitprice) > 100000.00  
ORDER BY SalesOrderID;

--==========================================================================
--28. From the following table write a query in SQL to retrieve products whose names start with 'Lock Washer'. 
--Return product ID, and name and order the result set in ascending order on product ID column.
 select productid,name 
 from Production.Product
 where Name like 'Lock Washer%'
 order by ProductID

 --==========================================================================
 --29. Write a query in SQL to fetch rows from product table and order the result set on an unspecified column listprice.
 --Return product ID, name, and color of the product.

 SELECT ProductID, Name, isnull(Color,'') color
FROM Production.Product  
ORDER BY ListPrice asc;

select * from Production.Product 

--==========================================================================
--30. From the following table write a query in SQL to retrieve records of employees. 
--Order the output on year (default ascending order) of hiredate. Return BusinessEntityID, JobTitle, and HireDate.

select businessentityid,jobtitle ,hiredate
from HumanResources.Employee
order by YEAR(hiredate)

--==========================================================================
--31. From the following table write a query in SQL to retrieve those persons whose last name begins with letter 'R'. Return lastname,
 --and firstname and display the result in ascending order on firstname and descending order on lastname columns.
SELECT LastName, FirstName 
FROM Person.Person  
WHERE LastName LIKE 'R%'  
ORDER BY FirstName ASC, LastName DESC ;

--==========================================================================
--32. From the following table write a query in SQL to ordered the BusinessEntityID column descendingly when SalariedFlag set to 'true' 
--and BusinessEntityID in ascending order when SalariedFlag set to 'false'. Return BusinessEntityID, SalariedFlag columns.
SELECT BusinessEntityID, SalariedFlag  
FROM HumanResources.Employee  
ORDER BY  CASE  SalariedFlag WHEN 'false' THEN BusinessEntityID END asc,
			CASE SalariedFlag WHEN 'true' THEN BusinessEntityID END DESC  
       
--==========================================================================
--33. From the following table write a query in SQL to set the result in order by the column TerritoryName when 
--the column CountryRegionName is equal to 'United States' and by CountryRegionName for all other rows.
SELECT BusinessEntityID, LastName, TerritoryName, CountryRegionName  
FROM Sales.vSalesPerson  
WHERE TerritoryName IS NOT NULL  
ORDER BY CASE CountryRegionName WHEN 'United States' THEN TerritoryName  
         ELSE CountryRegionName END;


--==========================================================================
--34. From the following table write a query in SQL to find those persons who lives in a territory and the value of salesytd except 0. 
--Return first name, last name,row number as 'Row Number', 'Rank', 'Dense Rank' and NTILE as 'Quartile', salesytd and postalcode. 
--Order the output on postalcode column.
SELECT p.FirstName, p.LastName  
    ,ROW_NUMBER() OVER (ORDER BY a.PostalCode) AS "Row Number"  
    ,RANK() OVER (ORDER BY a.PostalCode) AS "Rank"  
    ,DENSE_RANK() OVER (ORDER BY a.PostalCode) AS "Dense Rank"  
    ,NTILE(4) OVER (ORDER BY a.PostalCode) AS "Quartile"  
    ,s.SalesYTD, a.PostalCode  
FROM Sales.SalesPerson AS s   
    INNER JOIN Person.Person AS p   
        ON s.BusinessEntityID = p.BusinessEntityID  
    INNER JOIN Person.Address AS a   
        ON a.AddressID = p.BusinessEntityID  
WHERE TerritoryID IS NOT NULL AND SalesYTD <> 0;


--==========================================================================
--From the following table write a query in SQL to skip the first 10 rows from the sorted result set and return all remaining rows.

SELECT DepartmentID, Name, GroupName  
FROM HumanResources.Department  
ORDER BY DepartmentID OFFSET 10 ROWS;

--==========================================================================
--36. From the following table write a query in SQL to skip the first 5 rows and return the next 5 rows from the sorted result set.
SELECT DepartmentID, Name, GroupName  
FROM HumanResources.Department  
ORDER BY DepartmentID   
    OFFSET 5 ROWS  
    FETCH NEXT 5 ROWS ONLY;

--==========================================================================
--37. From the following table write a query in SQL to list all the products that are Red or Blue in color. Return name, color 
--and listprice.Sorts this result by the column listprice.

SELECT Name, Color, ListPrice  
FROM Production.Product  
WHERE Color = 'Blue'  
UNION ALL  
SELECT Name, Color, ListPrice  
FROM Production.Product  
WHERE Color = 'Red'  


ORDER BY ListPrice ASC;


--==========================================================================
--38. Create a SQL query from the SalesOrderDetail table to retrieve the product name and any associated sales orders.
 --Additionally, it returns any sales orders that don't have any items mentioned in the Product table as well as any products that 
 --have sales orders other than those that are listed there. Return product name, salesorderid. Sort the result set on product name column.

SELECT pp.Name, SS.SalesOrderID  
FROM Production.Product AS pp
FULL OUTER JOIN Sales.SalesOrderDetail AS SS  
ON pp.ProductID = SS.ProductID  
ORDER BY pp.Name ;

--==========================================================================
--39. From the following table write a SQL query to retrieve the product name and salesorderid. 
--Both ordered and unordered products are included in the result set.
SELECT pp.Name, ss.SalesOrderID  
FROM Production.Product AS pp
LEFT OUTER JOIN Sales.SalesOrderDetail AS ss  
ON pp.ProductID = ss.ProductID  
ORDER BY pp.Name ;


--==========================================================================
--40. From the following tables write a SQL query to get all product names and sales order IDs. Order the result set on product name column.
SELECT pp.Name, ss.SalesOrderID  
FROM Production.Product AS pp 
INNER JOIN Sales.SalesOrderDetail AS ss  
ON pp.ProductID = ss.ProductID  
ORDER BY pp.Name ;


--==========================================================================
--41. From the following tables write a SQL query to retrieve the territory name and BusinessEntityID. 
--The result set includes all salespeople, regardless of whether or not they are assigned a territory.
SELECT isnull(st.Name,'') AS Territory, sp.BusinessEntityID  
FROM Sales.SalesTerritory AS st   
RIGHT  JOIN Sales.SalesPerson AS sp  
ON st.TerritoryID = sp.TerritoryID ;


--==========================================================================
--42. Write a query in SQL to find the employee's full name (firstname and lastname) and city from the following tables.
 --Order the result set on lastname then by firstname.
select *from Person.Person
select * from HumanResources.Employee
select * from Person.Address
select *from Person.BusinessEntityAddress

SELECT concat(pp.FirstName,' ', pp.LastName) AS Name, sub.City  
FROM Person.Person AS pp
JOIN HumanResources.Employee HE
	ON pp.BusinessEntityID = HE.BusinessEntityID   
JOIN  (SELECT pb.BusinessEntityID, pa.City   
		FROM Person.Address AS pa 
		JOIN Person.BusinessEntityAddress AS pb  
			ON pa.AddressID = pb.AddressID
		) AS sub  
ON pp.BusinessEntityID = sub.BusinessEntityID  
ORDER BY pp.LastName, pp.FirstName;

--==========================================================================
--43. Write a SQL query to return the businessentityid,firstname and lastname columns of all persons in the person table (derived table)
 --with persontype is 'IN' and the last name is 'Adams'. Sort the result set in ascending order on firstname.
 --A SELECT statement after the FROM clause is a derived table.

 select businessentityid,firstname,lastname
 from ( select businessentityid,firstname,lastname
		from Person.Person
		where lastname in('Adams')
		) as derived
order by FirstName


--==========================================================================
--44. Create a SQL query to retrieve individuals from the following table with a businessentityid inside 1500, a lastname starting with 'Al', 
--and a firstname starting with 'M'.
SELECT businessentityid, firstname,LastName  
FROM person.person 
WHERE businessentityid <= 1500 AND LastName LIKE 'Al%' AND FirstName LIKE 'M%';


--==========================================================================
--45. Write a SQL query to find the productid, name, and colour of the items 'Blade', 'Crown Race' and 'AWC Logo Cap' 
--using a derived table with multiple values.
SELECT ProductID, a.Name, Color  
FROM Production.Product AS a  
INNER JOIN (VALUES ('Blade'), ('Crown Race'), ('AWC Logo Cap')) AS b(Name)   
ON a.Name = b.Name;


--==========================================================================
--45. Write a SQL query to find the productid, name, and colour of the items 'Blade', 'Crown Race' and 'AWC Logo Cap' 
--using a derived table with multiple values.

select productid, name, isnull(Color,'') Color
from (select productid, name, Color 
		from Production.Product 
		where name in ('Blade', 'Crown Race' , 'AWC Logo Cap' )
		) as derv
order by ProductID


--==========================================================================
--46. Create a SQL query to display the total number of sales orders each sales representative receives annually. 
--Sort the result set by SalesPersonID and then by the date component of the orderdate in ascending order. 
--Return the year component of the OrderDate, SalesPersonID, and SalesOrderID.

WITH Sales_CTE (SalesPersonID, SalesOrderID, SalesYear)
AS
(
    SELECT SalesPersonID, SalesOrderID, year(OrderDate) AS SalesYear
    FROM Sales.SalesOrderHeader
    WHERE SalesPersonID IS NOT NULL
)
SELECT SalesPersonID, COUNT(SalesOrderID) AS TotalSales, SalesYear
FROM Sales_CTE
GROUP BY SalesYear, SalesPersonID
ORDER BY SalesPersonID, SalesYear;

-----------OR---------------
SELECT  SalesPersonID, COUNT(SalesOrderID) AS TotalSales,     year(OrderDate) AS SalesYear 
FROM Sales.SalesOrderHeader
WHERE SalesPersonID IS NOT NULL
GROUP BY year(OrderDate), SalesPersonID
ORDER BY SalesPersonID, SalesYear

--==========================================================================
--47. From the following table write a query in SQL to find the average number of sales orders for all the years of the sales representatives.
WITH Sales_CTE (SalesPersonID, NumberOfOrders)
AS
(
    SELECT SalesPersonID, COUNT(*)
    FROM Sales.SalesOrderHeader
    WHERE SalesPersonID IS NOT NULL
    GROUP BY SalesPersonID
)
SELECT AVG(NumberOfOrders) AS "Average Sales Per Person"
FROM Sales_CTE;

SELECT AVG(NumberOfOrders) AS "Average Sales Per Person"
FROM (
		SELECT SalesPersonID, COUNT(*) AS  NumberOfOrders 
		FROM Sales.SalesOrderHeader
		WHERE SalesPersonID IS NOT NULL
		GROUP BY SalesPersonID
		) derived


--==========================================================================
--48. Write a SQL query on the following table to retrieve records with the characters green_ in the LargePhotoFileName field. 
--The following table's columns must all be returned.

select productphotoid,thumbnailphoto   from Production.ProductPhoto where LargePhotoFileName like '%green_%'
		

--==========================================================================
--49. Write a SQL query to retrieve the mailing address for any company that is outside the United States (US) and in a city whose name starts with Pa. 
--Return Addressline1, Addressline2, city, postalcode, countryregioncode columns.

SELECT AddressLine1, AddressLine2, City, PostalCode, CountryRegionCode    
FROM Person.Address AS a  
JOIN Person.StateProvince AS s ON a.StateProvinceID = s.StateProvinceID  
WHERE CountryRegionCode NOT IN ('US')  
AND City LIKE 'Pa%' ;


--==========================================================================
--50. From the following table write a query in SQL to fetch first twenty rows. Return jobtitle, hiredate.
 --Order the result set on hiredate column in descending order.
 SELECT JobTitle, HireDate  
FROM HumanResources.Employee
ORDER BY HireDate desc
 OFFSET 0 ROWS 
FETCH FIRST 20 ROWS ONLY;


--==========================================================================
--51. From the following tables write a SQL query to retrieve the orders with orderqtys greater than 5 or unitpricediscount less than 1000,
 --and totaldues greater than 100. Return all the columns from the tables.
 select * from  Sales.SalesOrderHeader
select * from  Sales.SalesOrderDetail 

select * from  Sales.SalesOrderHeader ss
join Sales.SalesOrderDetail so
on ss.SalesOrderID=so.SalesOrderID
where (so.OrderQty>5 or so.UnitPriceDiscount<1000) and ss.TotalDue>100



--==========================================================================
--52. From the following table write a query in SQL that searches for the word 'red' in the name column. Return name, and color columns from the table.
SELECT Name, isnull(Color,'') Color   
FROM Production.Product
WHERE name like ('%red%');

--==========================================================================
--53. From the following table write a query in SQL to find all the products with a price of $80.99 that contain the word Mountain. 
--Return name, and listprice columns from the table.

SELECT Name, ListPrice  
FROM Production.Product  
WHERE ListPrice = 80.99  
and name like ('%Mountain%');

--==========================================================================
--54. From the following table write a query in SQL to retrieve all the products that contain either the phrase Mountain or Road.
 --Return name, and color columns.

 SELECT Name, isnull(Color,'') Color  
FROM Production.Product  
WHERE name like ('%Mountain%') or name like ('%Road%');

--==========================================================================
--55. From the following table write a query in SQL to search for name which contains both the word 'Mountain' and the word 'Black'. 
--Return Name and color.

 SELECT Name, isnull(Color,'') Color  
FROM Production.Product  
WHERE name like ('%Mountain%') and name like ('%Black%');

--==========================================================================
--56. From the following table write a query in SQL to return all the product names with at least one word starting with the prefix chain in the Name column.

 SELECT Name, isnull(Color,'') Color  
FROM Production.Product  
WHERE  name like ('%chain%');

--==========================================================================
--57. From the following table write a query in SQL to return all category descriptions containing strings with prefixes of either chain or full.

 SELECT Name, isnull(Color,'') Color  
FROM Production.Product  
WHERE name like ('%chain%') or name like ('%full%');

--==========================================================================
--58. From the following table write a SQL query to output an employee's name and email address, separated by a new line character.
SELECT concat(pp.FirstName,' ', pp.LastName) + ' '+'¶'+  pe.EmailAddress   
FROM Person.Person pp
INNER JOIN Person.EmailAddress pe ON pp.BusinessEntityID = pe.BusinessEntityID  	 
where pp.BusinessEntityID = 1;
								
--==========================================================================
--59. From the following table write a SQL query to locate the position of the string "yellow" where it appears in the product name.
SELECT name, CHARINDEX('yellow', name) as "String Position" 
from production.product
where CHARINDEX('yellow', name)>0
order by CHARINDEX('yellow', name)


--==========================================================================
--60 From the following table write a query in SQL to concatenate the name, color, and productnumber columns.
SELECT CONCAT( name, '   color:-',color,' Product Number:', productnumber ) AS result, isnull(color,'') color
FROM production.product;

--==========================================================================
--61 Write a SQL query that concatenate the columns name, productnumber, colour, and a new line character from
--the following table, each separated by a specified character.


