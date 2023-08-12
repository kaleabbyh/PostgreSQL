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

Select C.Name,C.ContactTypeID, B.BusinessEntityID
from  Person.BusinessEntityContact B
join Person.ContactType C
on B.ContactTypeID=C.ContactTypeID
where C.Name like '%Purchasing Manager%' 



Select P.businessentityid,lastname ,firstname 
from Person.Person P 
					--where P.businessentityid>360 
					--order by P.businessentityid
where  P.BusinessEntityID in (Select B.BusinessEntityID
								from  Person.BusinessEntityContact B
								join Person.ContactType C
								on B.ContactTypeID=C.ContactTypeID
								where C.Name like '%Purchasing Manager%') 
