
select * from studInfo;
insert INTO studInfo VALUES('11','mamma',20);
update studInfo set name='enani' where id='001';
delete from studInfo where studId='121A';
select * from studInfo where name like '%a%';
select * from studInfo where name like '%n_n%';
ALTER TABLE studInfo RENAME COLUMN id to studId;
ALTER TABLE studInfo RENAME  to studInfo;