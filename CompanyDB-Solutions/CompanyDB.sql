create database CompanyDB;
use CompanyDB
GO



create table Employee(
			EmpId int primary key ,
			Fname nvarchar(20),
			Lname nvarchar(20),
			Email nvarchar(20),
			HireDate Date,
			Salary int,
			Dept_Id int
			)

select * from Department

alter table Employee 
add constraint fk_Deparatment_ID
foreign key(Dept_Id) references Department(Dept_Id)


create table Department(
			Dept_Id int primary key,
			Dept_name nvarchar(20)
			)

INSERT INTO Department VALUES( 1,'CSE' )
INSERT INTO Department VALUES( 2,'Mechanical' )
INSERT INTO Department VALUES( 3,'Civil' )
INSERT INTO Department VALUES( 4,'Architecture' )
INSERT INTO Department VALUES( 5,'Applied' )

select * from Department



--===================================================================================================
--1. SP for inserting data into Employee
Create proc AddEpmployee
	@EmpId int ,
	@Fname nvarchar(20)= NULL,
	@Lname nvarchar(20)= NULL,
	@Email nvarchar(20)= NULL,
	@HireDate Date= NULL,
	@Salary int= NULL,
	@Dept_Id int= NULL
AS
BEGIN
	set @HireDate=ISNULL(@HireDate,GETDATE()) 
	INSERT INTO Employee VALUES( @EmpId , @Fname , @Lname , @Email , @HireDate, @Salary, @Dept_Id )
END



--execution of stored procedure to insert
EXEC AddEpmployee
    @EmpId = 8,
    @Fname = 'Abebe',
	@Lname='kefale',
    @Email = 'abebe@gmail.com',
    @Salary = 2000,
    @Dept_Id = 3;


select * from Employee



--===================================================================================================
--SP for update employee salary 
create proc UpdateEmployeeSalary
	@EmpId int,
	@Salary int
AS
BEGIN
	update Employee set Salary=@Salary where EmpId =@EmpId
END


--execution of stored procedure
exec UpdateEmployeeSalary
	@EmpId =1,
	@Salary =7000


select * from Employee


--===================================================================================================
--SP for count of Employees
Create proc GetEmployeeCountByDepartment
	@Dept_name varchar(50)
AS
BEGIN 
	select D.Dept_name, count(*) as TotalEmployee 
	from Employee E
	join Department D
	on E.Dept_Id=D.Dept_Id
	where D.Dept_name=@Dept_name
	group by D.Dept_name
END


-----------OR-----------------------------
--SP to count of Employees using sub query
alter proc GetEmployeeCountByDepartment
	@Dept_name varchar(50)
AS
BEGIN 
select count(*) as total ,Table1.Dept_name
from( select D.Dept_name,E.Fname
			from Employee E
			join Department D
			on E.Dept_Id=D.Dept_Id
			) Table1
where Table1.Dept_name=@Dept_name
group by Table1.Dept_name
END

exec GetEmployeeCountByDepartment @Dept_name='CSE'




--====================================================================================================
--SP to delete employee 
create proc DeleteEmployee
	@EmpId int
AS
BEGIN
	DELETE FROM Employee  where EmpId =@EmpId
END


exec DeleteEmployee @EmpId =5

select * from Employee



--===============================================================================================
--SP for average of salary for each department of Employees
Alter proc GetAverageSalaryByDepartment
	
AS
BEGIN 
	select D.Dept_name, count(*) as TotalEmployee,sum(salary) as TotalSalary ,avg(salary) as as AverageSalary 
	from Employee E
	join Department D
	on E.Dept_Id=D.Dept_Id
	group by D.Dept_name
END

exec GetAverageSalaryByDepartment



--====================================================================================================
--SP to get employee details
create proc GetEmployeeDetails
@EmpId int
AS
BEGIN
select E.Fname,E.Lname,E.Email,D.Dept_name, E.HireDate
from Employee E
join Department D
on E.Dept_Id=D.Dept_Id
where E.EmpId=@EmpId
END

EXEC GetEmployeeDetails @EmpId=1



--====================================================================================================
--SP GetEmployeesWithSalaryAbove
Alter proc GetEmployeesWithSalaryAbove
@Salary int
AS
BEGIN
select Fname,Lname,Salary
from Employee
where Salary > @Salary
END

EXEC GetEmployeesWithSalaryAbove @Salary=1000