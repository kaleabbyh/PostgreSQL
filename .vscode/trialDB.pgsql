select * from student;
insert INTO student VALUES('15','gsm',24,'t1');
update student set studid='14' where studid='001';
delete from student where studId='15';

select * from student where name like '%a%';
select * from student where name like '%n_n%';

ALTER TABLE student RENAME COLUMN id to studId;
ALTER TABLE student RENAME  to student;

select * from student WHERE studId not IN ('11','12');
select count(*) ,age from student  GROUP by age ;

ALTER TABLE student
ADD primary KEY (studid) ;

ALTER TABLE teacher
ADD primary KEY (teacherid) ;

ALTER TABLE student
ADD FOREIGN KEY (teacher_id) REFERENCES teacher(teacherid);

insert INTO teacher VALUES('t3','kinfe');
insert INTO student VALUES('18','moges',22);
delete from student WHeRE studId IN ('11','12','13','14');

SELECT * from teacher;
SELECT DISTINCT * from student;
SELECT DISTINCT * from student order by studid desc,name asc ;
select count(*) ,age ,sum(age) from student  GROUP by age  HAVING sum(age)>50;


SELECT teacher_id, avg(age) age_average,count(*) 
FROM student
WHERE age>22
GROUP BY teacher_id
HAVING avg(age) >= 20;



select  s.*,t.name teacher_name
from student s
join teacher t
on s.teacher_id = t.teacherid



