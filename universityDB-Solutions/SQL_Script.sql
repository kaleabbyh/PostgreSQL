create database university
use university
go


create table student(
roll_no int,
name nvarchar(50),
address  nvarchar(50),
phone nvarchar(50),
age int,
)


--inserting data to student table
insert into student values(1,'harsh','delhi','+251900000000',18)
insert into student values(2,'pratik','bahr','+251900000000',19)
insert into student values(3,'riyanka','silguri','+251900000000',20)
insert into student values(4,'deep','ramnagar','+251900000000',18)
insert into student values(5,'sapatarhi','kolkata','+251900000000',19)
insert into student values(6,'dhanraj','barabajar','+251900000000',20)
insert into student values(7,'rohit','balurghat','+251900000000',18)
insert into student values(8,'niraj','alibur','+251900000000',19)


create table StudentCourse (
course_id int,
roll_no int,
)


--inserting data to StudentCourse table
insert into StudentCourse values(1,1)
insert into StudentCourse values(2,2)
insert into StudentCourse values(2,3)
insert into StudentCourse values(3,4)
insert into StudentCourse values(1,5)
insert into StudentCourse values(4,9)
insert into StudentCourse values(5,10)
insert into StudentCourse values(5,11)

select * from student 

select * from  StudentCourse 

--inner join 

select  S.name, S.age,C.course_id
from student S
join StudentCourse C
on S.roll_no=C.roll_no



--left join

select  S.name, S.age,C.course_id
from student S
left join StudentCourse C
on S.roll_no=C.roll_no


--right join

select  S.name, S.age,C.course_id
from student S
right join StudentCourse C
on S.roll_no=C.roll_no




--full join or full outer join

select  S.name, S.age,C.course_id
from student S
full join StudentCourse C
on S.roll_no=C.roll_no

