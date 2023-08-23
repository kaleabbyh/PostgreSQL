create database demo;
alter database demo1 modify name =demo

--sp_renameDB 'demo1' ,'demo2'
--drop database demo2;




use [demo]
GO

create table tblGender
(
ID int not null primary key ,
Gender nvarchar(50) not null
)
create table tblperson
(
id int not null primary key ,
name nvarchar(50) not null,
email nvarchar(50) not null,
genderId nvarchar(50) 
)


ALTER TABLE tblperson
ADD CONSTRAINT tblperson_genderId_FK
FOREIGN KEY (genderId) REFERENCES tblGender(ID)
ON DELETE CASCADE
 ON UPDATE CASCADE;

alter table tblperson
add constraint df_tblperson_genderId  
default 3 for genderId;

alter table tblperson drop constraint tblperson_genderId_FK;
alter table tblperson drop constraint df_tblperson_genderId

select * from tblGender
select * from tblperson

insert into tblperson(id,name,email) values(4,'reach','d@d.com')
insert into tblperson(id,name,email) values(5,'hawi','e@e.com');
insert into tblGender

delete from tblperson where genderId is null;
delete from tblGender where id =2;

alter table tblperson add  age int;

insert into tblGender values(6,'male')
delete from tblGender where id =6
insert into tblGender values(2,'female')

--check constraint 
insert into tblperson(id,name,email,genderId,age) values(7,'haime','f@f.com',2,199)
insert into tblperson(id,name,email,genderId,age) values(9,'haime','f@f.com',2,29)

alter table tblperson
add constraint ck_tblperson_age  
check (age >0 AND age<150);

alter table tblperson drop constraint ck_tblperson_age





--identity column
--incrementing by its own
--set identity_insert tblperson on

--unique key constraint 
alter table tblperson 
add constraint UQ_tblperson_email
unique(email)

insert into tblperson(id,name,email,genderId,age) values(7,'haime','g@g.com',2,19)
insert into tblperson(id,name,email,genderId,age) values(9,'haime','f@f.com',2,29)







--keywords 
select  distinct genderId from tblperson
select * from tblperson order by age

select count(*) ,g.Gender
from tblperson p
join tblGender g
on g.ID=p.genderId
group by g.Gender

select *
from tblperson p
where name like '[^mr]%'

select *
from tblperson p
where name like '[mr]%'

select top 2 *
from tblperson p
order by age desc

select *
from tblperson p
where age in (19,29)

select *
from tblperson p
where age not in (19,20)

select distinct age 
from tblperson p;

update  tblperson set age=20 where age is null







--where and having clause
--where clause is filtering rows before aggregatioin but having clause after aggregation
select genderId,age, sum(age),count(genderId),avg(age)
from tblperson p
where age>15
group by genderId,age

select genderId,age, sum(age),count(genderId),avg(age)
from tblperson p
group by genderId,age
having age>15

--group by multiple columns
select genderId,age, sum(age),count(genderId),avg(age)
from tblperson p
group by genderId,age

--can use aggregate functions in having clause
select genderId,age, sum(age),count(genderId),avg(age)
from tblperson p
group by genderId,age
having sum(age)>30

--can not use aggregate functions in where clause
select genderId,age, sum(age),count(genderId),avg(age)
from tblperson p
where sum(age)>30
group by genderId,age







--inner join, left join,right join,cross join ,self join,full outer join

select p.id,p.name,p.age,p.age,g.Gender
from tblperson p
join tblGender g
on g.ID=p.genderId
where age  in (19,20,29)

select p.id,p.name,p.age,p.age,g.Gender
from tblperson p
left join tblGender g
on g.ID=p.genderId
where age  in (19,20,29)

select p.id,p.name,p.age,p.age,g.Gender
from tblperson p
right join tblGender g
on g.ID=p.genderId
where age  in (19,20,29)

select p.id,p.name,p.age,p.age,g.Gender
from tblperson p
cross join tblGender g
where age  in (19,20,29)


--intellegent joins
select p.id,p.name,p.age,p.age,g.Gender
from tblperson p
right join tblGender g
on g.ID=p.genderId
where p.genderId is null

--self join
create table employe(
id int primary key,
name nvarchar(50),
managerId int foreign key references employe(id)
)

select * from employe

select e.name employe, m.name manager
from employe e
left join employe m
on e.managerId=m.id







--different ways of substituting null value with more expressive  terms
select e.name employe,ISNULL( m.name,'no manager') manager
from employe e
left join employe m
on e.managerId=m.id

select e.name employe,COALESCE( m.name,'no manager') manager
from employe e
left join employe m
on e.managerId=m.id

select e.name employe,
case when m.name is null then 'no manager' else m.name end manager
from employe e
left join employe m
on e.managerId=m.id

--union union all
--union removes duplicates and sorts but union all combines the two tables 
-- no of columns ,data type should be the same even the order of columns should also be the same
create table worker(
id int primary key,
name nvarchar(50),
managerId int foreign key references employe(id)
)

select * from employe
union 
select * from worker


select * from employe
union all
select * from worker








--creating stored procedure
create procedure spGetEmployeesByParamaters
@name nvarchar(50),
@managerId int
as
begin
select * from employe 
where name=@name and managerId=@managerId
end

--updating stored procedure
alter procedure spGetEmployeesByParamaters
@name nvarchar(50),
@managerId int
with encryption
as
begin
select * from employe 
where name=@name or managerId=@managerId 
order by name
end

--calling ways for stored procedure
spGetEmployeesByParamaters 'admasu' ,2;
exec spGetEmployeesByParamaters 'admasu' ,2;
execute spGetEmployeesByParamaters 'admasu' ,2;
execute spGetEmployeesByParamaters  @managerId=2, @name='admasu';

--getting a query used to create stored procedure
sp_helptext spGetEmployeesByParamaters


--stored procedure with output parametrs
create proc spEmployeWithOutputParametrs
@managerId int ,
@totalCount int output
as
begin
select @totalCount=COUNT(*) from employe
where managerId=@managerId
end


create proc spEmployeWithOutputParametrs1
@totalCount int output
as
begin
select @totalCount=COUNT(*) from employe
group by managerId
end

declare @total int
exec spEmployeWithOutputParametrs @managerId= 2,@totalCount= @total output
if (@total is null)
	print' @total is null'
else
	print '@total is: '+ CAST(@total AS varchar(20))

declare @total1 int
exec spEmployeWithOutputParametrs1 @total1 output
print @total1

--using return keyword
--used only for sp that returns ineger value
create proc spEmployeWithOutputParametrs2
as
begin
return (select COUNT(*) from employe)
end

declare @total1 int
exec @total1=spEmployeWithOutputParametrs2
print @total1

--sp retains execution plan and reuses code even if parameter values changed
--sp reduces network traffic
--sp have better secuirity








--built in functions
declare @start int
set @start=65

 while(@start<90)
 begin
 print char(@start)
 set @start=@start+1
 end

 select TRIM('  holla')

 select id,name ,len(rtrim(ltrim(name))) as nameLength from employe;

--LTRIM, RTRIM , LOWER ,UPPER,CHAR,ASCII,LEN are some of built in functiions used over strings
--LEFT, RIGHT , replicate ,CHARINDEX,SUBSTRING,REPLACE,PATINDEX are also some of built in functiions used over strings

select LEFT('holla',3) --select SUBSTRING(string,numOfStrings) 
select RIGHT('holla',3) --select SUBSTRING(string,numOfStrings) 
select CHARINDEX('l','holla')  --select SUBSTRING(char,string) 
select SUBSTRING('holla',3,2) --select SUBSTRING(string,starting,numOfStrings) 

declare @word nvarchar(20)
set @word='holla@gmail.com'
select SUBSTRING(@word, CHARINDEX('@',@word)+1, len(@word)-CHARINDEX('@',@word) )


select * from employe

select *,PATINDEX('%.com',email) as pattern from tblperson
where PATINDEX('%.com',email) >0

select *,REPLACE(email,'.com','.NET') as pattern from tblperson
where PATINDEX('%.com',email) >0







--datetime functions

alter table tblperson add DOB datetime
select * from tblperson

SELECT  DATEDIFF(YEAR, '2022-11-30 19:45:31.793', GETDATE())-
CASE 
WHEN 
(MONTH('2022-11-30 19:45:31.793') > MONTH(GETDATE())) 
OR
(MONTH('2022-11-30 19:45:31.793') = MONTH(GETDATE()) AND DAY('2022-11-30 19:45:31.793') > DAY(GETDATE())) 
THEN 1 ELSE 0 
END

SELECT  DATEADD(YEAR, 1, '2022-01-30 19:45:31.793');







--casting and converting 
SELECT (GETDATE())
SELECT CAST(GETDATE() as date)
SELECT CONVERT(VARCHAR(50), GETDATE())
SELECT CONVERT(VARCHAR(10),GETDATE(),105)

select  cast(DOB as date) dateOfRegistration, count(id) countOfPersons from tblperson
group by  cast(DOB as date)




--mathematical operations
Select CEILING(15.2) -- Returns 16
Select CEILING(-15.2) -- Returns -15
Select FLOOR(15.2) -- Returns 15
Select FLOOR(-15.2) -- Returns -16


Declare @Counter INT
Set @Counter = 1
While(@Counter <= 10)
Begin
 Print FLOOR(RAND() * 100)
 Set @Counter = @Counter + 1
End

Select ROUND(850.556, 1, 1) -- Returns 850.500
Select ROUND(850.556, 1, 1) -- Returns 850.500
Select ROUND(850.556,   -2) -- Returns 900.000

--scalar functions
CREATE FUNCTION fnComputeAge(@DOB DATETIME)
RETURNS NVARCHAR(50)
AS
BEGIN
DECLARE @tempdate DATETIME, @years INT, @months INT, @days INT
SELECT @tempdate = @DOB

SELECT @years = DATEDIFF(YEAR, @tempdate, GETDATE()) - 
CASE 
WHEN
(MONTH(@DOB) > MONTH(GETDATE()))
OR
(MONTH(@DOB) = MONTH(GETDATE()) AND DAY(@DOB) > DAY(GETDATE())) 
THEN 1 ELSE 0 
END

SELECT @tempdate = DATEADD(YEAR, @years, @tempdate)

SELECT @months = DATEDIFF(MONTH, @tempdate, GETDATE()) - CASE WHEN DAY(@DOB) > DAY(GETDATE()) THEN 1 ELSE 0 END
SELECT @tempdate = DATEADD(MONTH, @months, @tempdate)

SELECT @days = DATEDIFF(DAY, @tempdate, GETDATE())

DECLARE @Age NVARCHAR(50)
SET @Age = Cast(@years AS  NVARCHAR(4)) + ' Years ' + Cast(@months AS  NVARCHAR(2))+ ' Months ' + Cast(@days AS  NVARCHAR(2))+ ' Days Old'
RETURN @Age
End

select id,name, email, DOB,dbo.fnComputeAge(DOB) calculatedDOB from tblperson
select dbo.fnComputeAge( '2022-01-30 19:45:31.793')







--inline functions or table valued functions
select * from tblperson 

CREATE FUNCTION fn_EmployeesByAge(@Age int)
RETURNS TABLE
AS
RETURN (Select Id, Name,email,  age,DOB
      from tblperson
      where age = @age)

--calling inline function 
select * from fn_EmployeesByAge(20)
select * from fn_EmployeesByAge(20) where email='a@a.com'



--Multi-statement Table Valued function(MSTVF):
Create Function fn_MSTVF_GetTblperson()
Returns @Table Table (Id int, Name nvarchar(20), DOB Date)
as
Begin
 Insert into @Table
 Select Id, Name,DOB from tblperson
 Return
End

--Calling the Multi-statement Table Valued Function:
Select * from fn_MSTVF_GetTblperson()



--Deterministic and Nondeterministic Functions
--Deterministic 
	--Sum(), AVG(), Square(), Power() and Count() almost all aggregate functions
--Nondeterministic 
	--GetDate() and CURRENT_TIMESTAMP





	
-- local Temporary tables
-- accessed for one users,single session, ended when the user connection is ended
Create Table #PersonDetails(Id int, Name nvarchar(20))

Select name from tempdb..sysobjects 
where name like '#PersonDetails%'

drop table #PersonDetails
--creating local temporary tables in side stored procedure

Create Procedure spCreateLocalTempTabl
as
Begin
Create Table #PersonDetails(Id int, Name nvarchar(20))
Insert into #PersonDetails Values(1, 'Mike')
Insert into #PersonDetails Values(2, 'John')
Insert into #PersonDetails Values(3, 'Todd')
Select * from #PersonDetails
End


exec spCreateLocalTempTable
Select * from #PersonDetails --reurns error after execution of sp temp table b/c it is drop immediately

-- global Temporary tables
-- accessed for all users,sessions, ended when the last connection is ended
Create Table ##PersonDetails(Id int, Name nvarchar(20))

--index is for referencing and high performance 
select * from tblperson

CREATE Clustered Index IX_tblperson_tblperson
ON tblperson (age ASC)

drop index tblperson.PK_tblperson;
delete from tblperson where id =2
alter table tblperson
add constraint PK_tblperson
primary key(id)

CREATE Clustered Index IX_tblperson_ID
ON tblperson (id ASC)


 sp_helpIndex tblperson
 
 --non clustered index eg. primary key
insert into tblperson(id,name,email) values(10,'reach','d@d.com')
insert into tblperson(id,name,email) values(2,'hawi','e@e.com');

alter table tblperson 
drop constraint UQ_tblperson_email

--non clustered index:
	--stores address of rows on the separate tabeland  used it for refering specific row without scanning all rows
	-- more than one non clustered index is allowed
 --clustered index
	-- only one clustered index is allowed
	--sorts the table






--view
--virtual table that contains only query for retrieving data but not the actual table
--not possible to pass parameters to views
Create View vwTblperson
as
select * 
from tblperson where age >=20

Create View vwTblperson_no_ageId
as
select name,email,DOB 
from tblperson 

select * from vwTblperson --row level security
select * from vwTblperson_no_ageId  --column level security

update vwTblperson
set name='kaleab' where id =1

delete from vwTblperson
where id =10

insert into vwTblperson(id,name,email) values(10,'fact','g@g.com')




--indexed view or materialized view in oracle
Create Table tblProduct
(
 ProductId int primary key,
 Name nvarchar(20),
 UnitPrice int
)


Insert into tblProduct Values(1, 'Books', 20)
Insert into tblProduct Values(2, 'Pens', 14)
Insert into tblProduct Values(3, 'Pencils', 11)
Insert into tblProduct Values(4, 'Clips', 10)


Create Table tblProductSales
(
 ProductId int,
 QuantitySold int
)


Insert into tblProductSales values(1, 10)
Insert into tblProductSales values(3, 23)
Insert into tblProductSales values(4, 21)
Insert into tblProductSales values(2, 12)
Insert into tblProductSales values(1, 13)
Insert into tblProductSales values(3, 12)
Insert into tblProductSales values(4, 13)
Insert into tblProductSales values(1, 11)
Insert into tblProductSales values(2, 12)
Insert into tblProductSales values(1, 14)

select * from tblProduct
select * from tblProductSales

--creating view
Create view vWTotalSalesByProduct
with SchemaBinding
as
Select Name, 
SUM(ISNULL((QuantitySold * UnitPrice), 0)) as TotalSales, 
COUNT_BIG(*) as TotalTransactions
from dbo.tblProductSales
join dbo.tblProduct
on dbo.tblProduct.ProductId = dbo.tblProductSales.ProductId
group by Name

select * from vWTotalSalesByProduct

--creating index for a view
create unique clustered index UIX_productSalesByProductName
on vWTotalSalesByProduct(Name


drop view vWTotalSalesByProduct


--limmitations of views
	--it can't accept parameters to a view.
	--Rules and Defaults cannot be associated with views.
	--The ORDER BY clause is invalid in views unless TOP or FOR XML is also specified.
	--Views cannot be based on temporary tables.






--Triggers

--DML Triggers
--DML Triggers is fired if one of (INSERT, UPDATE, and DELETE) is used
	--1. After triggers (Sometimes called as FOR triggers)
	--2. Instead of triggers

CREATE TABLE tblEmployee
(
  Id int Primary Key,
  Name nvarchar(30),
  Salary int,
  Gender nvarchar(10),
  DepartmentId int
)

Insert into tblEmployee values (1,'John', 5000, 'Male', 3)
Insert into tblEmployee values (2,'Mike', 3400, 'Male', 2)
Insert into tblEmployee values (3,'Pam', 6000, 'Female', 1)

CREATE TABLE tblEmployeeAudit
(
  Id int identity(1,1) primary key,
  AuditData nvarchar(1000)
)
select * from tblEmployeeAudit



--INSERT Trigger
CREATE TRIGGER tr_tblEMployee_ForInsert
ON tblEmployee
FOR INSERT
AS
BEGIN
 Declare @Id int
 Select @Id = Id from inserted
 
 insert into tblEmployeeAudit 
 values('New employee with Id  = ' + Cast(@Id as nvarchar(5)) + ' is added at ' + cast(Getdate() as nvarchar(20)))
 select * from tblEmployeeAudit where Id=@Id
END

Insert into tblEmployee values (5,'hana', 2300, 'Female', 3)




--DELETE Trigger
CREATE TRIGGER tr_tblEMployee_ForDelete
ON tblEmployee
FOR DELETE
AS
BEGIN
 Declare @Id int
 Select @Id = Id from deleted
 
 insert into tblEmployeeAudit 
 values('An existing employee with Id  = ' + Cast(@Id as nvarchar(5)) + ' is deleted at ' + Cast(Getdate() as nvarchar(20)))
END

delete from tblEmployee where id =3



--UPDATE Trigger
Create trigger tr_tblEmployee_ForUpdate
on tblEmployee
for Update
as
Begin
 Select * from deleted --data before update
 Select * from inserted --data after update
End

Update tblEmployee set Name = 'Tods', Salary = 2000, 
Gender = 'Female' where Id = 2








--after UPDATE Trigger in more complex way

Alter trigger tr_tblEmployee_ForUpdate
on tblEmployee
for Update
as
Begin
      -- Declare variables to hold old and updated data
      Declare @Id int
      Declare @OldName nvarchar(20), @NewName nvarchar(20)
      Declare @OldSalary int, @NewSalary int
      Declare @OldGender nvarchar(20), @NewGender nvarchar(20)
      Declare @OldDeptId int, @NewDeptId int
     
	  -- Variable to build the audit string
      Declare @AuditString nvarchar(1000)
      
	 -- Load the updated records into temporary table
      Select *
      into #TempTable
      from inserted
     
	 -- Loop through the records in temp table
      While(Exists(Select Id from #TempTable))
      Begin
		    --Initialize the audit string to empty string
            Set @AuditString = ''
           
		    -- Select first row data from temp table
            Select Top 1 @Id = Id, @NewName = Name, 
            @NewGender = Gender, @NewSalary = Salary,
            @NewDeptId = DepartmentId
            from #TempTable
           
            -- Select the corresponding row from deleted table
            Select @OldName = Name, @OldGender = Gender, 
            @OldSalary = Salary, @OldDeptId = DepartmentId
            from deleted where Id = @Id
   
            -- Build the audit string dynamically           
            Set @AuditString = 'Employee with Id = ' + Cast(@Id as nvarchar(4)) + ' changed'
            if(@OldName <> @NewName)
                  Set @AuditString = @AuditString + ' NAME from ' + @OldName + ' to ' + @NewName
                 
            if(@OldGender <> @NewGender)
                  Set @AuditString = @AuditString + ' GENDER from ' + @OldGender + ' to ' + @NewGender
                 
            if(@OldSalary <> @NewSalary)
                Set @AuditString = @AuditString + ' SALARY from ' + Cast(@OldSalary as nvarchar(10))+ ' to ' + Cast(@NewSalary as nvarchar(10))
                  
			if(@OldDeptId <> @NewDeptId)
                  Set @AuditString = @AuditString + ' DepartmentId from ' + Cast(@OldDeptId as nvarchar(10))+ ' to ' + Cast(@NewDeptId as nvarchar(10))
           
            insert into tblEmployeeAudit values(@AuditString)
            
            -- Delete the row from temp table, so we can move to the next row
            Delete from #TempTable where Id = @Id
      End
End


Update tblEmployee set Name = 'kidist', Salary = 4000, 
Gender = 'Female' where Id = 5

select * from tblEmployeeAudit
select * from tblEmployee







--INSTEAD OF INSERT triggers

CREATE TABLE tblEmployee
(
  Id int Primary Key,
  Name nvarchar(30),
  Gender nvarchar(10),
  DepartmentId int  
)


CREATE TABLE tblDepartment
(
 DeptId int Primary Key,
 DeptName nvarchar(20)
)


Insert into tblDepartment values (1,'IT')
Insert into tblDepartment values (2,'Payroll')
Insert into tblDepartment values (3,'HR')
Insert into tblDepartment values (4,'Admin')


Insert into tblEmployee values (1,'John', 'Male', 3)
Insert into tblEmployee values (2,'Mike', 'Male', 2)
Insert into tblEmployee values (3,'Pam', 'Female', 1)
Insert into tblEmployee values (4,'Todd', 'Male', 4)
Insert into tblEmployee values (5,'Sara', 'Female', 1)
Insert into tblEmployee values (6,'Ben', 'Male', 3)


Create view vWEmployeeDetails
as
Select Id, Name, Gender, DeptName
from tblEmployee 
join tblDepartment
on tblEmployee.DepartmentId = tblDepartment.DeptId

Select * from vWEmployeeDetails

--gives error vWEmployeeDetails is not updatable because the modification affects multiple base tables.
Insert into vWEmployeeDetails values(7, 'Valarie', 'Female', 'IT')

--solution using trigger
Create trigger tr_vWEmployeeDetails_InsteadOfInsert
on vWEmployeeDetails
Instead Of Insert
as
Begin
	 Declare @DeptId int

	 --Check if there is a valid DepartmentId for the given DepartmentName
	 Select @DeptId = DeptId 
	 from tblDepartment 
	 join inserted
	 on inserted.DeptName = tblDepartment.DeptName
 
	 --If DepartmentId is null throw an error and stop processing
	 if(@DeptId is null)
		 Begin
			Raiserror('Invalid Department Name. Statement terminated', 16, 1)
			return
		 End
 
	 --Finally insert into tblEmployee table
	 Insert into tblEmployee(Id, Name, Gender, DepartmentId)
	 Select Id, Name, Gender, @DeptId
	 from inserted
End

--this succesfully inserts
Insert into vWEmployeeDetails values(7, 'Valarie', 'Female', 'IT')

sp_depends 'tblEmployee'








--create INSTEAD OF UPDATE trigger
Create Trigger tr_vWEmployeeDetails_InsteadOfUpdate
on vWEmployeeDetails
instead of update
as
Begin
 -- if EmployeeId is updated
 if(Update(Id))
	 Begin
	  Raiserror('Id cannot be changed', 16, 1)
	  Return
	 End
 
 -- If DeptName is updated
  --returns true if DeptName is used under set clause
 if(Update(DeptName))
	 Begin
	  Declare @DeptId int

	  Select @DeptId = DeptId
	  from tblDepartment
	  join inserted
	  on inserted.DeptName = tblDepartment.DeptName
  
	  if(@DeptId is NULL )
		  Begin
		   Raiserror('Invalid Department Name', 16, 1)
		   Return
		  End
  
	  Update tblEmployee set DepartmentId = @DeptId
	  from inserted
	  join tblEmployee
	  on tblEmployee.Id = inserted.id
	End
 
 -- If gender is updated
 if(Update(Gender))
	 Begin
	  Update tblEmployee set Gender = inserted.Gender
	  from inserted
	  join tblEmployee
	  on tblEmployee.Id = inserted.id
	 End
 
 -- If Name is updated
 if(Update(Name))
	 Begin
	  Update tblEmployee set Name = inserted.Name
	  from inserted
	  join tblEmployee
	  on tblEmployee.Id = inserted.id
	 End
End


Update vWEmployeeDetails 
set DeptName = 'IT'
where Id = 1

Update vWEmployeeDetails 
set Name = 'Johny', Gender = 'Female', DeptName = 'IT' 
where Id = 1






--create INSTEAD OF DELETE trigger:
Create Trigger tr_vWEmployeeDetails_InsteadOfDelete
on vWEmployeeDetails
instead of delete
as
Begin
 Delete tblEmployee 
 from tblEmployee
 join deleted
 on tblEmployee.Id = deleted.Id
 
 -- OR Subquery
 --Delete from tblEmployee 
 --where Id in (Select Id from deleted)
End







--CTE
--Temporary result set statement
--syntax for creating a CTE.
WITH cte_name (Column1, Column2, ..)
AS
( CTE_query )


--SQL query using CTE:
With EmployeeCount(DepartmentId, TotalEmployees)
as
(
 Select DepartmentId, COUNT(*) as TotalEmployees
 from tblEmployee
 group by DepartmentId
)


Select DeptName, TotalEmployees
from tblDepartment
join EmployeeCount
on tblDepartment.DeptId = EmployeeCount.DepartmentId
order by TotalEmployees



-- CTE with complex queries
With EmployeesCountBy_Payroll_IT_Dept(DepartmentName, Total)
as
(
 Select DeptName, COUNT(Id) as TotalEmployees
 from tblEmployee
 join tblDepartment 
 on tblEmployee.DepartmentId = tblDepartment.DeptId
 where DeptName IN ('Payroll','IT')
 group by DeptName
),
EmployeesCountBy_HR_Admin_Dept(DepartmentName, Total)
as
(
 Select DeptName, COUNT(Id) as TotalEmployees
 from tblEmployee
 join tblDepartment 
 on tblEmployee.DepartmentId = tblDepartment.DeptId
 group by DeptName 
)


Select * from EmployeesCountBy_HR_Admin_Dept 
UNION
Select * from EmployeesCountBy_Payroll_IT_Dept
 order by Total







--CTE UPDATE 

With Employees_Name_Gender
as
(
 Select Id, Name, Gender from tblEmployee
)
Update Employees_Name_Gender Set Gender = 'male' where Id = 1

select * from tblEmployee


--possible update bc it affects one base table
With EmployeesByDepartment
as
(
 Select Id, Name, Gender, DeptName 
 from tblEmployee
 join tblDepartment
 on tblDepartment.DeptId = tblEmployee.DepartmentId
)
Update EmployeesByDepartment set Gender = 'Male' where Id = 1




--not possible update bc it affects multiple base tables
With EmployeesByDepartment
as
(
 Select Id, Name, Gender, DeptName 
 from tblEmployee
 join tblDepartment
 on tblDepartment.DeptId = tblEmployee.DepartmentId
)
Update EmployeesByDepartment set Gender = 'Male',DeptName='IT' where Id = 1



-- A CTE is based on more than one base table, and if the UPDATE affects only one base table,
--the UPDATE succeeds(but not as expected always)
With EmployeesByDepartment
as
(
 Select Id, Name, Gender, DeptName 
 from tblEmployee
 join tblDepartment
 on tblDepartment.DeptId = tblEmployee.DepartmentId
)
Update EmployeesByDepartment set DeptName='IT' where Id = 1







--Recursive function 
drop table tblEmployee
Create Table tblEmployee
(
  EmployeeId int Primary key,
  Name nvarchar(20),
  ManagerId int
)

Insert into tblEmployee values (1, 'Tom', 2)
Insert into tblEmployee values (2, 'Josh', null)
Insert into tblEmployee values (3, 'Mike', 2)
Insert into tblEmployee values (4, 'John', 3)
Insert into tblEmployee values (5, 'Pam', 1)
Insert into tblEmployee values (6, 'Mary', 3)
Insert into tblEmployee values (7, 'James', 1)
Insert into tblEmployee values (8, 'Sam', 5)
Insert into tblEmployee values (9, 'Simon', 1)


--
Select Employee.Name as [Employee Name],
IsNull(Manager.Name, 'Super Boss') as [Manager Name]
from tblEmployee Employee
left join tblEmployee Manager
on Employee.ManagerId = Manager.EmployeeId



--using a self referencing CTE(RECURSIVE).
With
  EmployeesCTE (EmployeeId, Name, ManagerId, [Level])
  as
  (
    Select EmployeeId, Name, ManagerId, 1
    from tblEmployee
    where ManagerId is null
    
    union all
    
    Select tblEmployee.EmployeeId, tblEmployee.Name, 
    tblEmployee.ManagerId, EmployeesCTE.[Level] + 1
    from tblEmployee
    join EmployeesCTE
    on tblEmployee.ManagerID = EmployeesCTE.EmployeeId
  )


Select EmpCTE.Name as Employee, Isnull(MgrCTE.Name, 'Super Boss') as Manager, EmpCTE.[Level] 
from EmployeesCTE EmpCTE
left join EmployeesCTE MgrCTE
on EmpCTE.ManagerId = MgrCTE.EmployeeId








--pivot
Create Table tblProductSales
(
 SalesAgent nvarchar(50),
 SalesCountry nvarchar(50),
 SalesAmount int
)

Insert into tblProductSales values('Tom', 'UK', 200)
Insert into tblProductSales values('John', 'US', 180)
Insert into tblProductSales values('John', 'UK', 260)
Insert into tblProductSales values('David', 'India', 450)
Insert into tblProductSales values('Tom', 'India', 350)
Insert into tblProductSales values('David', 'US', 200)
Insert into tblProductSales values('Tom', 'US', 130)
Insert into tblProductSales values('John', 'India', 540)
Insert into tblProductSales values('John', 'UK', 120)
Insert into tblProductSales values('David', 'UK', 220)
Insert into tblProductSales values('John', 'UK', 420)
Insert into tblProductSales values('David', 'US', 320)
Insert into tblProductSales values('Tom', 'US', 340)
Insert into tblProductSales values('Tom', 'UK', 660)
Insert into tblProductSales values('John', 'India', 430)
Insert into tblProductSales values('David', 'India', 230)
Insert into tblProductSales values('David', 'India', 280)
Insert into tblProductSales values('Tom', 'UK', 480)
Insert into tblProductSales values('John', 'US', 360)
Insert into tblProductSales values('David', 'UK', 140)



Select * from tblProductSales

Select SalesCountry, SalesAgent, SUM(SalesAmount) as Total
from tblProductSales
group by SalesCountry, SalesAgent
order by SalesCountry, SalesAgent



--if primary key is there not working
Select SalesAgent, India, US, UK
from tblProductSales
Pivot
(
   Sum(SalesAmount) for SalesCountry in ([India],[US],[UK])
) as PivotTable



--working for every
Select SalesAgent, India, US, UK
from
(
   Select SalesAgent, SalesCountry, SalesAmount from tblProductsSale
) as SourceTable
Pivot
(
 Sum(SalesAmount) for SalesCountry in (India, US, UK)
) as PivotTable




SELECT <non-pivoted column>,
    [first pivoted column] AS <column name>,
    [second pivoted column] AS <column name>,
    ...
    [last pivoted column] AS <column name>
FROM
	(
	<SELECT query that produces the data>
	)
    AS <alias for the source query>
PIVOT
(
  <aggregation function>(<column being aggregated>)
FOR
    [<column that contains the values that will become column headers>]
    IN ( [first pivoted column], [second pivoted column], ... [last pivoted column])
)
AS <alias for the pivot table>
<optional ORDER BY clause>;







--Error handling

--Syntax:
BEGIN TRY
     { Any set of SQL statements }
END TRY
BEGIN CATCH
     [ Optional: Any set of SQL statements ]
END CATCH
[Optional: Any other SQL Statements]

Select * from tblProduct
Select * from tblProductSales 




drop table tblProduct
Create Table tblProduct
(
 ProductId int NOT NULL primary key,
 Name nvarchar(50),
 UnitPrice int,
 QtyAvailable int
)

alter table tblProduct
add  QtyAvailable int


Insert into tblProduct values(1, 'Laptops', 2340, 100)
Insert into tblProduct values(2, 'Desktops', 3467, 50)


Create Table tblProductSales
(
 ProductSalesId int primary key,
 ProductId int,
 QuantitySold int
)







Create Procedure spSellProduct
@ProductId int,
@QuantityToSell int
as
Begin
	 -- Check the stock available, for the product we want to sell
	 Declare @StockAvailable int
	 Select @StockAvailable = QtyAvailable 
	 from tblProduct where ProductId = @ProductId
 
	 -- Throw an error to the calling application, if enough stock is not available
	 if(@StockAvailable < @QuantityToSell)
	   Begin
	  Raiserror('Not enough stock available',16,1)
	   End
	 -- If enough stock available
	 Else
	   Begin
		Begin Try
		 Begin Transaction
			 -- First reduce the quantity available
	  Update tblProduct set QtyAvailable = (QtyAvailable - @QuantityToSell)
	  where ProductId = @ProductId
  
	  Declare @MaxProductSalesId int
	  -- Calculate MAX ProductSalesId  
	  Select @MaxProductSalesId = CASE WHEN MAX(ProductSalesId) IS NULL THEN 0
									   ELSE MAX(ProductSalesId) 
								   END 
	  from tblProductSales
	  --Increment @MaxProductSalesId by 1, so we don't get a primary key violation
	  Set @MaxProductSalesId = @MaxProductSalesId + 1
	  Insert into tblProductSales values ( @ProductId,@QuantityToSell,@MaxProductSalesId)
		 Commit Transaction
		End Try
		Begin Catch 
	  Rollback Transaction
	  Select 
	   ERROR_NUMBER() as ErrorNumber,
	   ERROR_MESSAGE() as ErrorMessage,
	   ERROR_PROCEDURE() as ErrorProcedure,
	   ERROR_STATE() as ErrorState,
	   ERROR_SEVERITY() as ErrorSeverity,
	   ERROR_LINE() as ErrorLine
		End Catch 
	   End
End

exec spSellProduct 1,10

Select * from tblProduct
Select * from tblProductSales







--sub query
Select P.ProductId, P.Name, S.ProductId
from tblProduct P
left join tblProductSales S
on P.ProductId = S.ProductId
where S.ProductId IS NULL


--correlated subQuery
Select P.ProductId, P.Name, S.ProductId,
(Select SUM(QuantitySold) from tblProductSales where tblProductSales.ProductId = tblProduct.ProductId) as TotalQuantity
from tblProduct P
order by Name




If (Exists (select * from information_schema.tables  where table_name = 'tblProductSales'))
Begin
 Drop Table tblProductSales
End

If (Exists (select *  from information_schema.tables   where table_name = 'tblProducts') )
Begin
 Drop Table tblProducts
End


-- Recreate tables
Create Table tblProducts
(
 [Id] int identity primary key,
 [Name] nvarchar(50),
 [Description] nvarchar(250)
)

Create Table tblProductSales
(
 Id int primary key identity,
 ProductId int foreign key references tblProducts(Id),
 UnitPrice int,
 QuantitySold int
)


Declare @Id int
Set @Id = 1

While(@Id <= 100000)
Begin
 Insert into tblProducts values('Product - ' + CAST(@Id as nvarchar(20)), 
 'Product - ' + CAST(@Id as nvarchar(20)) + ' Description')
 
 Print @Id
 Set @Id = @Id + 1
End


-- Declare variables to hold a random ProductId, 
-- UnitPrice and QuantitySold
declare @RandomProductId int
declare @RandomUnitPrice int
declare @RandomQuantitySold int

-- Declare and set variables to generate a 
-- random ProductId between 1 and 100000
declare @UpperLimitForProductId int
declare @LowerLimitForProductId int

set @LowerLimitForProductId = 1
set @UpperLimitForProductId = 100000

-- Declare and set variables to generate a 
-- random UnitPrice between 1 and 100
declare @UpperLimitForUnitPrice int
declare @LowerLimitForUnitPrice int

set @LowerLimitForUnitPrice = 1
set @UpperLimitForUnitPrice = 100

-- Declare and set variables to generate a 
-- random QuantitySold between 1 and 10
declare @UpperLimitForQuantitySold int
declare @LowerLimitForQuantitySold int

set @LowerLimitForQuantitySold = 1
set @UpperLimitForQuantitySold = 10

--Insert Sample data into tblProductSales table
Declare @Counter int
Set @Counter = 1

While(@Counter <= 450000)
Begin
 select @RandomProductId = Round(((@UpperLimitForProductId - @LowerLimitForProductId) * Rand() + @LowerLimitForProductId), 0)
 select @RandomUnitPrice = Round(((@UpperLimitForUnitPrice - @LowerLimitForUnitPrice) * Rand() + @LowerLimitForUnitPrice), 0)
 select @RandomQuantitySold = Round(((@UpperLimitForQuantitySold - @LowerLimitForQuantitySold) * Rand() + @LowerLimitForQuantitySold), 0)
 
 Insert into tblProductsales 
 values(@RandomProductId, @RandomUnitPrice, @RandomQuantitySold)

 Print @Counter
 Set @Counter = @Counter + 1
End


Select * from tblProducts
Select * from tblProductSales






---clean the query and execution plan cache using the following T-SQL command. 
CHECKPOINT; 
GO 
DBCC DROPCLEANBUFFERS; -- Clears query cache
Go
DBCC FREEPROCCACHE; -- Clears execution plan cache
GO


---Performance Check

Select Id, Name, Description
from tblProducts
where ID IN
(
 Select ProductId from tblProductSales
)


Select distinct tblProducts.Id, Name, Description
from tblProducts
inner join tblProductSales
on tblProducts.Id = tblProductSales.ProductId










--rerunnable scripts
Use demo
If not exists (select * from information_schema.tables where table_name = 'tblEmployee')
Begin
 Create table tblEmployee
 (
  ID int identity primary key,
  Name nvarchar(100),
  Gender nvarchar(10),
  DateOfBirth DateTime
 )
 Print 'Table tblEmployee successfully created'
End
Else
Begin
 Print 'Table tblEmployee already exists'
End

--rerunnable scripts
IF OBJECT_ID('tblEmployee') IS NULL
Begin
   -- Create Table Script
    Create table tblEmployee
 (
  ID int identity primary key,
  Name nvarchar(100),
  Gender nvarchar(10),
  DateOfBirth DateTime
 )
   Print 'Table tblEmployee created'
End
Else
Begin
   Print 'Table tblEmployee already exists'
End



IF OBJECT_ID('tblEmployee') IS NOT NULL
Begin
 Drop Table tblEmploye
End
Create table tblEmploye
(
 ID int identity primary key,
 Name nvarchar(100),
 Gender nvarchar(10),
 DateOfBirth DateTime
)


--To make this script re-runnable, check for the column existence
Use demo
if not exists(Select * from INFORMATION_SCHEMA.COLUMNS where COLUMN_NAME='EmailAddress' and TABLE_NAME = 'tblEmployee' and TABLE_SCHEMA='dbo') 
Begin
 ALTER TABLE tblEmployee
 ADD EmailAddress nvarchar(50)
End
Else
BEgin
 Print 'Column EmailAddress already exists'
End

------------------------------------------------------
--Col_length() function can also be used to check for the existence of a column
If col_length('tblEmployee','EmailAddress') is not null
Begin
 Print 'Column already exists'
End
Else
Begin
 Print 'Column does not exist'
End

--altering column data type without droping table
Alter table tblEmployee
Alter column Salary int
------------------------------------------------------






------------------------------------------------------
--optional parametrs
select * from tblEmployee

Create Proc spSearchEmployees
@Name nvarchar(50) = NULL,
@EmployeeId int = NULL
as
Begin
 Select * from tblEmployee where
 (Name = @Name OR @Name IS NULL) AND
 (EmployeeId = @EmployeeId OR @EmployeeId IS NULL) 
End

exec spSearchEmployees 
------------------------------------------------------






--Merge statement
--Merge statement syntax
------------------------------------------------------
MERGE [TARGET] AS T
USING [SOURCE] AS S
   ON [JOIN_CONDITIONS]
 WHEN MATCHED THEN 
      [UPDATE STATEMENT]
 WHEN NOT MATCHED BY TARGET THEN
      [INSERT STATEMENT] 
 WHEN NOT MATCHED BY SOURCE THEN
      [DELETE STATEMENT]
------------------------------------------------------
Create table StudentSource
(
     ID int primary key,
     Name nvarchar(20)
)
GO
------------------------------------------------------
Insert into StudentSource values (1, 'Mike')
Insert into StudentSource values (2, 'Sara')
GO
------------------------------------------------------
Create table StudentTarget
(
     ID int primary key,
     Name nvarchar(20)
)
GO
------------------------------------------------------
Insert into StudentTarget values (1, 'Mike M')
Insert into StudentTarget values (3, 'John')
GO
------------------------------------------------------
--inserting and deleting to source table and target table respectively using MERGE
MERGE StudentTarget AS T
USING StudentSource AS S
ON T.ID = S.ID
WHEN MATCHED THEN
     UPDATE SET T.NAME = S.NAME
WHEN NOT MATCHED BY TARGET THEN
     INSERT (ID, NAME) VALUES(S.ID, S.NAME)
WHEN NOT MATCHED BY SOURCE THEN
     DELETE;
------------------------------------------------------
--inserting to target table only
MERGE StudentTarget AS T
USING StudentSource AS S
ON T.ID = S.ID
WHEN MATCHED THEN
     UPDATE SET T.NAME = S.NAME
WHEN NOT MATCHED BY TARGET THEN
     INSERT (ID, NAME) VALUES(S.ID, S.NAME);
------------------------------------------------------
--selecting 
if OBJECT_ID('StudentTarget') is not null
begin
drop table StudentTarget
end
------------------------------------------------------
if OBJECT_ID('StudentSource') is not null
begin
drop table StudentSource
end
------------------------------------------------------
select * from StudentTarget;
select * from StudentSource
------------------------------------------------------







---Transactin problems
-- Transfer $100 from Mark to Mary Account
------------------------------------------------------
BEGIN TRY
    BEGIN TRANSACTION
         UPDATE Accounts SET Balance = Balance - 100 WHERE Id = 1
         UPDATE Accounts SET Balance = Balance + 100 WHERE Id = 2
    COMMIT TRANSACTION
    PRINT 'Transaction Committed'
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION
    PRINT 'Transaction Rolled back'
END CATCH
------------------------------------------------------

------------------------------------------------------
--Some of the common concurrency problems
	--Dirty Reads
	--Lost Updates
	--Nonrepeatable Reads
	--Phantom Reads
------------------------------------------------------








--Dirty Reads
------------------------------------------------------
Create table tblInventory
(
    Id int identity primary key,
    Product nvarchar(100),
    ItemsInStock int
)
Go
------------------------------------------------------
Insert into tblInventory values ('iPhone', 10)
------------------------------------------------------



--Transaction 1 : 
------------------------------------------------------
Begin Tran
Update tblInventory set ItemsInStock = 9 where Id=1
Waitfor Delay '00:00:15'
Rollback Transaction
------------------------------------------------------

--Transaction 2 :
Set Transaction Isolation Level Read Uncommitted
Select * from tblInventory where Id=1
------------------------------------------------------









--lost update problem.


-- Transaction 1
------------------------------------------------------
Set Transaction Isolation Level Repeatable Read --prevents lost update problem

Begin Tran
Declare @ItemsInStock int
Select @ItemsInStock = ItemsInStock
from tblInventory where Id=1

-- Transaction takes 10 seconds
Waitfor Delay '00:00:10'
Set @ItemsInStock = @ItemsInStock - 1

Update tblInventory
Set ItemsInStock = @ItemsInStock where Id=1
Print @ItemsInStock
Commit Transaction
------------------------------------------------------



-- Transaction 2
------------------------------------------------------
Set Transaction Isolation Level Repeatable Read  --prevents lost update problem
Begin Tran
Declare @ItemsInStock int
Select @ItemsInStock = ItemsInStock
from tblInventory where Id=1

Waitfor Delay '00:00:1'
Set @ItemsInStock = @ItemsInStock - 2
Update tblInventory
Set ItemsInStock = @ItemsInStock where Id=1
Print @ItemsInStock
Commit Transaction
------------------------------------------------------

select * from HumanResources.Employee
------------------------------------------------------







--transaction isolation level repeatable read
-- Transaction 1
------------------------------------------------------
Set transaction isolation level repeatable read
Begin Transaction
Select ItemsInStock from tblInventory where Id = 1

-- Do Some work
waitfor delay '00:00:10'

Select ItemsInStock from tblInventory where Id = 1
Commit Transaction
------------------------------------------------------

-- Transaction 2
------------------------------------------------------
Update tblInventory set ItemsInStock = 5 where Id = 1
------------------------------------------------------







--transaction isolation level serializable
--Transaction 1
------------------------------------------------------
Set transaction isolation level serializable
Begin Transaction
Update tblInventory set ItemsInStock = 5 where Id = 1
waitfor delay '00:00:10'
Commit Transaction
------------------------------------------------------
------------------------------------------------------
-- Transaction 2
Set transaction isolation level serializable
Select ItemsInStock from tblInventory where Id = 1
------------------------------------------------------






------------------------------------------------------
-- Transaction 2
-- Enable snapshot isloation for the database
Alter database demo SET ALLOW_SNAPSHOT_ISOLATION ON
-- Set the transaction isolation level to snapshot
Set transaction isolation level snapshot
Select ItemsInStock from tblInventory where Id = 1
------------------------------------------------------



------------------------------------------------------
--Transaction 1
--transaction isolation level snapshot
Alter database demo SET ALLOW_SNAPSHOT_ISOLATION ON
Set transaction isolation level snapshot
Begin Transaction
Update tblInventory set ItemsInStock = 8 where Id = 1
waitfor delay '00:00:10'
Commit Transaction
------------------------------------------------------
------------------------------------------------------
-- Transaction 2
Set transaction isolation level snapshot
Begin Transaction
Update tblInventory set ItemsInStock = 5 where Id = 1
Commit Transaction
------------------------------------------------------


------------------------------------------------------
--Disable Snapshot Isolation
Alter database SampleDB SET ALLOW_SNAPSHOT_ISOLATION OFF
-- Enable Read Committed Sanpshot Isolation at the database level
Alter database SampleDB SET READ_COMMITTED_SNAPSHOT ON
------------------------------------------------------
--Transaction 1
Set transaction isolation level read committed
Begin Transaction
Update tblInventory set ItemsInStock = 8 where Id = 1
waitfor delay '00:00:10'
Commit Transaction

-- Transaction 2
Set transaction isolation level read committed
Begin Transaction
Update tblInventory set ItemsInStock = 5 where Id = 1
Commit Transaction
------------------------------------------------------







------------------------------------------------------
--Deadlock
Create table TableA
(
    Id int identity primary key,
    Name nvarchar(50)
)
Go

Insert into TableA values ('Mark')
Go
------------------------------------------------------
Create table TableB
(
    Id int identity primary key,
    Name nvarchar(50)
)
Go

Insert into TableB values ('Mary')

Go
------------------------------------------------------


------------------------------------------------------
-- Transaction 1
Begin Tran
Update TableA Set Name = 'Mark Transaction 1' where Id = 1

-- From Transaction 2 window execute the first update statement

Update TableB Set Name = 'Mary Transaction 1' where Id = 1

-- From Transaction 2 window execute the second update statement
Commit Transaction
------------------------------------------------------

------------------------------------------------------
-- Transaction 2
Begin Tran
Update TableB Set Name = 'Mark Transaction 2' where Id = 1

-- From Transaction 1 window execute the second update statement

Update TableA Set Name = 'Mary Transaction 2' where Id = 1

-- After a few seconds notice that one of the transactions complete
-- successfully while the other transaction is made the deadlock victim

Commit Transaction
------------------------------------------------------







------------------------------------------------------
--deadlock two
select * from TableA
select * from TableB

exec procedure1

Alter proc procedure1
as
begin
	begin try
		begin transaction
			update TableA set Name='abebe' where id=1
			Waitfor delay '00:00:05' 
			update TableB set Name='alemu' where id=1
		commit transaction
		select 'transaction is sucessful'
	end try
	begin catch
		select 'transaction is unsucessful'
		rollback
	end catch

end
------------------------------------------------------

------------------------------------------------------
--deadlock two
select * from TableA
select * from TableB

exec procedure2

create proc procedure2
as
begin
	begin try
		begin transaction
		update TableB set Name='kebed' where id=1
		Waitfor delay '00:00:05' 
		update TableA set Name='chala' where id=1
		commit transaction
		select 'transaction is sucessful'
	end try
	begin catch
		select 'transaction is unsucessful'
		rollback
	end catch

end
------------------------------------------------------









------------------------------------------------------
--Except operator
--order and type of columns must be similar
if OBJECT_ID('TableA') is not null 
begin
drop table TableA
end

if OBJECT_ID('TableB') is not null 
begin
drop table TableB
end
------------------------------------------------------
Create Table TableA
(
    Id int primary key,
    Name nvarchar(50),
    Gender nvarchar(10)
)
Go

Insert into TableA values (1, 'Mark', 'Male')
Insert into TableA values (2, 'Mary', 'Female')
Insert into TableA values (3, 'Steve', 'Male')
Insert into TableA values (4, 'John', 'Male')
Insert into TableA values (5, 'Sara', 'Female')
Go
------------------------------------------------------
Create Table TableB
(
    Id int primary key,
    Name nvarchar(50),
    Gender nvarchar(10)
)
Go

Insert into TableB values (4, 'John', 'Male')
Insert into TableB values (5, 'Sara', 'Female')
Insert into TableB values (6, 'Pam', 'Female')
Insert into TableB values (7, 'Rebeka', 'Female')
Insert into TableB values (8, 'Jordan', 'Male')
Go
------------------------------------------------------
-- returns the unique rows from the left query that aren’t in the right query’s results.
Select Id, Name, Gender
From TableA
Except
Select Id, Name, Gender
From TableB
------------------------------------------------------

Select Id, Name, Gender
From TableA
where Id not in ( Select Id From TableB )
------------------------------------------------------

Select Id, Name, Gender from TableA
Intersect
Select Id, Name, Gender from TableB

------------------------------------------------------









------------------------------------------------------
--cross apply=inner join
--outer apply =left join

Create table Department
(
    Id int primary key,
    DepartmentName nvarchar(50)
)
Go

Insert into Department values (1, 'IT')
Insert into Department values (2, 'HR')
Insert into Department values (3, 'Payroll')
Insert into Department values (4, 'Administration')
Insert into Department values (5, 'Sales')
Go
------------------------------------------------------
Create table Employee
(
    Id int primary key,
    Name nvarchar(50),
    Gender nvarchar(10),
    Salary int,
    DepartmentId int foreign key references Department(Id)
)
Go

Insert into Employee values (1, 'Mark', 'Male', 50000, 1)
Insert into Employee values (2, 'Mary', 'Female', 60000, 3)
Insert into Employee values (3, 'Steve', 'Male', 45000, 2)
Insert into Employee values (4, 'John', 'Male', 56000, 1)
Insert into Employee values (5, 'Sara', 'Female', 39000, 2)
Go
------------------------------------------------------

Create function fn_GetEmployeesByDepartmentId(@DepartmentId int)
Returns Table
as
Return
(
    Select Id, Name, Gender, Salary, DepartmentId
    from Employee where DepartmentId = @DepartmentId
)
Go

--returns the employees of the department with Id =1.
Select * from fn_GetEmployeesByDepartmentId(1)
------------------------------------------------------
-- Inner or Left join between Department table and fn_GetEmployeesByDepartmentId() function you will get an error.
Select D.DepartmentName, E.Name, E.Gender, E.Salary
from Department D
Inner Join fn_GetEmployeesByDepartmentId(D.Id) E
On D.Id = E.DepartmentId
------------------------------------------------------


--solution is using cross apply
Select D.DepartmentName, E.Name, E.Gender, E.Salary
from Department D
Cross Apply fn_GetEmployeesByDepartmentId(D.Id) E
------------------------------------------------------









------------------------------------------------------
--Syntax for creating DDL trigger
CREATE TRIGGER [Trigger_Name]
ON [Scope (Server|Database)]
FOR [EventType1, EventType2, EventType3, ...],
AS
BEGIN
   -- Trigger Body
END
------------------------------------------------------

--trigger for CREATE_TABLE
CREATE TRIGGER trMyFirstTrigger
ON Database
FOR CREATE_TABLE
AS
BEGIN
   Print 'New table created'
END
------------------------------------------------------

--trigger for CREATE_TABLE,...
ALTER TRIGGER trMyFirstTrigger
ON Database
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS
BEGIN
   Print 'A table has just been created, modified or deleted'
END
------------------------------------------------------


------------------------------------------------------
DISABLE TRIGGER trMyFirstTrigger ON DATABASE
ENABLE TRIGGER trMyFirstTrigger ON DATABASE
DROP TRIGGER trMyFirstTrigger ON DATABASE
------------------------------------------------------

------------------------------------------------------
CREATE TRIGGER trRenameTable
ON DATABASE
FOR RENAME
AS
BEGIN
    Print 'You just renamed something'
END
------------------------------------------------------

------------------------------------------------------
--server scope
CREATE TRIGGER tr_ServerScopeTrigger
ON ALL SERVER
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS
BEGIN
    ROLLBACK
    Print 'You cannot create, alter or drop a table in any database on the server'
END
------------------------------------------------------

------------------------------------------------------
DISABLE TRIGGER tr_ServerScopeTrigger ON ALL SERVER
ENABLE TRIGGER tr_ServerScopeTrigger ON ALL SERVER
DROP TRIGGER tr_ServerScopeTrigger ON ALL SERVER
------------------------------------------------------

-- The server-scope trigger marked First
-- Other server-scope triggers
-- The server-scope trigger marked Last
-- The database-scope trigger marked First
-- Other database-scope triggers
-- The database-scope trigger marked Last











--audit

--retrives even audit during CREATE_TABLE, ALTER_TABLE, DROP_TABLE
--CREATE TRIGGER tr_AuditTableChanges
--ON ALL SERVER
--FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
--AS
--BEGIN
  --  SELECT  EVENTDATA()
--END



--saves audit to tables
create table TableChanges(
	DatabaseName varchar(250) ,
	TableName varchar(250), 
	EventType varchar(250),
	LoginName varchar(250),
	SQLCommand varchar(250),
	AuditDateTime varchar(250)
	)


ALTER TRIGGER tr_AuditTableChanges
ON ALL SERVER
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS
BEGIN
    DECLARE @EventData XML
    SELECT @EventData = EVENTDATA()

    INSERT INTO demo.dbo.TableChanges
    (DatabaseName, TableName, EventType, LoginName,
     SQLCommand, AuditDateTime)
    VALUES
    (
         @EventData.value('(/EVENT_INSTANCE/DatabaseName)[1]', 'varchar(250)'),
         @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(250)'),
         @EventData.value('(/EVENT_INSTANCE/EventType)[1]', 'nvarchar(250)'),
         @EventData.value('(/EVENT_INSTANCE/LoginName)[1]', 'varchar(250)'),
         @EventData.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'nvarchar(2500)'),
         GetDate()
    )

	select * from demo.dbo.TableChanges
END


create table try( id int )
drop trigger tr_AuditTableChanges


--LOGON Triggers

CREATE TRIGGER tr_LogonAuditTriggers
ON ALL SERVER
FOR LOGON
AS
BEGIN
    DECLARE @LoginName NVARCHAR(100)

    Set @LoginName = ORIGINAL_LOGIN()

    IF (SELECT COUNT(*) FROM sys.dm_exec_sessions   --allows only up to 3 users to login 
         WHERE is_user_process = 1
         AND original_login_name = @LoginName) > 3
    BEGIN
         Print 'Fourth connection of ' + @LoginName + ' blocked'
         ROLLBACK
    END
END







-- SELECT INTO
--creating a table and insertinge(copying) data from Employee to EmployeesBackup
SELECT * INTO EmployeesBackup FROM Employee

SELECT * INTO EmployeesBackup FROM Employee WHERE DeptId = 1







--can't use aggregate functions
SELECT Product, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY Product
WHERE SUM(SaleAmount) > 1000 --not possible bc aggregate function

--possible
SELECT Product, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY Product
WHERE product > 1000 -- possible



----can use aggregate functions
SELECT Product, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY Product
HAVING SUM(SaleAmount) > 1000 --possible

--possible
SELECT Product, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY Product
WHERE product > 1000 -- possible









--Create User-defined Table Type
CREATE TYPE EmpTableType AS TABLE
(
    Id INT PRIMARY KEY,
    Name NVARCHAR(50),
    Gender NVARCHAR(10)
)
Go


CREATE PROCEDURE spInsertEmployees
@EmpTableType EmpTableType READONLY
AS
BEGIN
    INSERT INTO Employees
    SELECT * FROM @EmpTableType
END


DECLARE @EmployeeTableType EmpTableType

INSERT INTO @EmployeeTableType VALUES (1, 'Mark', 'Male')
INSERT INTO @EmployeeTableType VALUES (2, 'Mary', 'Female')
INSERT INTO @EmployeeTableType VALUES (3, 'John', 'Male')
INSERT INTO @EmployeeTableType VALUES (4, 'Sara', 'Female')
INSERT INTO @EmployeeTableType VALUES (5, 'Rob', 'Male')

EXECUTE spInsertEmployees @EmployeeTableType








--GROUPING SETS
 
Select Country, Gender, Sum(Salary) TotalSalary
From Employees
Group BY
      GROUPING SETS
      (
            (Country, Gender), -- Sum of Salary by Country and Gender
            (Country),               -- Sum of Salary by Country
            (Gender) ,               -- Sum of Salary by Gender
            ()                             -- Grand Total
      )
Order By Grouping(Country), Grouping(Gender), Gender


--==

Select Country, Gender, Sum(Salary) as TotalSalary
From Employees 
Group By Country, Gender
UNION ALL
Select Country, NULL, Sum(Salary) as TotalSalary
From Employees 
Group By Country
UNION ALL
Select NULL, Gender, Sum(Salary) as TotalSalary
From Employees 
Group By Gender
UNION ALL
Select NULL, NULL, Sum(Salary) as TotalSalary
From Employees 








------------------------------------------------------
--returns sum group by country and total sum
SELECT Country, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY ROLLUP(Country)


--==

SELECT Country, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY Country
UNION ALL
SELECT NULL, SUM(Salary) AS TotalSalary
FROM Employees
------------------------------------------------------







------------------------------------------------------
--OVER CLAUSE

Create Table Employees
(
     Id int ,
     Name nvarchar(50),
     Gender nvarchar(10),
     Salary int
)
Go

Insert Into Employees Values (1, 'Mark', 'Male', 5000)
Insert Into Employees Values (1, 'Mark', 'Male', 5000)
Insert Into Employees Values (2, 'John', 'Male', 4500)
Insert Into Employees Values (3, 'Pam', 'Female', 5500)
Insert Into Employees Values (4, 'Sara', 'Female', 4000)
Insert Into Employees Values (4, 'Sara', 'Female', 4000)
Insert Into Employees Values (5, 'Todd', 'Male', 3500)
Insert Into Employees Values (6, 'Mary', 'Female', 5000)
Insert Into Employees Values (7, 'Ben', 'Male', 6500)
Insert Into Employees Values (8, 'Jodi', 'Female', 7000)
Insert Into Employees Values (9, 'Tom', 'Male', 5500)
Insert Into Employees Values (10, 'Ron', 'Male', 5000)
Go
------------------------------------------------------

------------------------------------------------------
SELECT Name, Salary, Employees.Gender, Genders.GenderTotals,
        Genders.AvgSal, Genders.MinSal, Genders.MaxSal   
FROM Employees
INNER JOIN
(SELECT	Gender, 
		COUNT(*) AS GenderTotals,
		AVG(Salary) AS AvgSal,
		MIN(Salary) AS MinSal,
		MAX(Salary) AS MaxSal
FROM Employees
GROUP BY Gender) AS Genders
ON Genders.Gender = Employees.Gender

--== equivalent output using OVER CLAUSE

SELECT Name, Salary, Gender,
        COUNT(Gender) OVER(PARTITION BY Gender) AS GenderTotals,
        AVG(Salary) OVER(PARTITION BY Gender) AS AvgSal,
        MIN(Salary) OVER(PARTITION BY Gender) AS MinSal,
        MAX(Salary) OVER(PARTITION BY Gender) AS MaxSal
FROM Employees
------------------------------------------------------








------------------------------------------------------
--ROW_NUMBER  must have an OVER clause with ORDER BY.
SELECT Name, Gender, Salary,
        ROW_NUMBER() OVER (ORDER BY Gender) AS RowNumber
FROM Employees

SELECT Name, Gender, Salary,
        ROW_NUMBER() OVER (PARTITION BY Gender ORDER BY salary desc) AS RowNumber
FROM Employees



--delete all duplicate rows except one
--WITH can be followed by one delete ,select...statement only
WITH EmployeesCTE AS
(
   SELECT *, ROW_NUMBER() OVER(PARTITION BY ID ORDER BY ID) AS RowNumber
   FROM Employees
)
DELETE FROM EmployeesCTE WHERE RowNumber > 1
select * from EmployeesCTE
------------------------------------------------------







------------------------------------------------------
--RANK and DENSE_RANK
--ORDER BY clause is required
--PARTITION BY clause is optional

SELECT Name, Salary, Gender,
RANK() OVER (ORDER BY Salary DESC) AS [Rank], --Rank function skips ranking(s) if there is a tie where as Dense_Rank will not.
DENSE_RANK() OVER (ORDER BY Salary DESC) AS DenseRank
FROM Employees


SELECT Name, Gender,Salary,
ROW_NUMBER() OVER (ORDER BY Salary DESC) AS RowNumber,
RANK() OVER (ORDER BY Salary DESC) AS [Rank],
DENSE_RANK() OVER (ORDER BY Salary DESC) AS DenseRank
FROM Employees


SELECT Name, Gender,Salary,
ROW_NUMBER() OVER (ORDER BY Salary DESC) AS RowNumber,
NTILE(2) OVER (ORDER BY Salary DESC) AS [NTILE],
DENSE_RANK() OVER (ORDER BY Salary DESC) AS DenseRank
FROM Employees


SELECT Name, Gender, Salary,
        SUM(Salary) OVER (ORDER BY ID) AS RunningTotal
FROM Employees
------------------------------------------------------



------------------------------------------------------
--Syntax LEAD LAG
LEAD(Column_Name, Offset, Default_Value) OVER (ORDER BY Col1, Col2, ...)
LAG(Column_Name, Offset, Default_Value) OVER (ORDER BY Col1, Col2, ...)
------------------------------------------------------
SELECT Name, Gender, Salary,
        LEAD(Salary, 2, -1) OVER (ORDER BY Salary) AS Lead_2,
        LAG(Salary, 1, -1) OVER (ORDER BY Salary) AS Lag_1
FROM Employees ORDER BY Salary
------------------------------------------------------
SELECT Name, Gender, Salary,
        LEAD(Salary, 2, -1) OVER (PARTITION By Gender ORDER BY Salary) AS Lead_2,
        LAG(Salary, 1, -1) OVER (PARTITION By Gender ORDER BY Salary) AS Lag_1
FROM Employees
------------------------------------------------------
SELECT Name, Gender, Salary,
FIRST_VALUE(Name) OVER (ORDER BY Salary) AS FirstValue
FROM Employees
------------------------------------------------------
SELECT Name, Gender, Salary,
FIRST_VALUE(Name) OVER (PARTITION BY Gender ORDER BY Salary) AS FirstValue
FROM Employees
------------------------------------------------------




------------------------------------------------------
--Windows FUNCTIONS
--In SQL Server we have different categories of window functions
--Aggregate functions - AVG, SUM, COUNT, MIN, MAX etc..
--Ranking functions - RANK, DENSE_RANK, ROW_NUMBER etc..
--Analytic functions - LEAD, LAG, FIRST_VALUE, LAST_VALUE etc...
------------------------------------------------------
SELECT Name, Gender, Salary,
        AVG(Salary) OVER(ORDER BY Salary						 --avg for 3 rows
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS Average
FROM Employees
------------------------------------------------------
SELECT Name, Gender, Salary,
        AVG(Salary) OVER(ORDER BY Salary ROWS BETWEEN			 --avg for all rows
        UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Average
FROM Employees
------------------------------------------------------
--it's default value RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW.
SELECT Name, Gender, Salary,
    LAST_VALUE(Name) OVER (ORDER BY Salary) AS LastValue
FROM Employees

------------------------------------------------------
SELECT Name, Gender, Salary,
    LAST_VALUE(Name) OVER (ORDER BY Salary ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LastValue
FROM Employees
------------------------------------------------------
SELECT Name, Gender, Salary,
    LAST_VALUE(Name) OVER (ORDER BY Salary ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LastValue
FROM Employees
------------------------------------------------------