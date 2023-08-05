select * from studinfo;
insert INTO studInfo VALUES('13','gsm',20);
update studInfo set studid='14' where studid='001';
delete from studInfo where studId='121A';
select * from studInfo where name like '%a%';
select * from studInfo where name like '%n_n%';
ALTER TABLE studInfo RENAME COLUMN id to studId;
ALTER TABLE studInfo RENAME  to studInfo;

select * from studinfo WHERE studId not IN ('11','12');

SELECT * from teacher;


