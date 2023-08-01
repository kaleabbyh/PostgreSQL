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

--functions
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
SET @Age = Cast(@years AS  NVARCHAR(4)) + ' Years ' + Cast(@months AS  NVARCHAR(2))+ ' Months ' + 
Cast(@days AS  NVARCHAR(2))+ ' Days Old'
RETURN @Age

End

select id,name, email, DOB,dbo.fnComputeAge(DOB) calculatedDOB from tblperson



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
Select ROUND(850.556, -2) -- 900.000