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