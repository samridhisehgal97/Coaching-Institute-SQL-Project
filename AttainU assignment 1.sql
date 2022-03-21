create database AttainU;
show databases;
use AttainU;
show tables;

-- creating table with name USERS

CREATE TABLE users (
  id INTEGER PRIMARY KEY auto_increment NOT NULL,
  name VARCHAR(50) NOT NULL,
  active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- creating table for batches 
CREATE TABLE batches (
  id INTEGER PRIMARY KEY NOT NULL auto_increment,
  name VARCHAR(100) UNIQUE NOT NULL,
  active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);



-- creating table for mapping students with batches

CREATE TABLE student_batch_maps (
  id INTEGER PRIMARY KEY NOT NULL auto_increment,
  user_id INTEGER NOT NULL REFERENCES users(id),
  batch_id INTEGER NOT NULL REFERENCES batches(id),
  active BOOLEAN NOT NULL DEFAULT true,
  deactivated_at TIMESTAMP NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- creating table for mapping instructors with batches
CREATE TABLE instructor_batch_maps (
  id INTEGER PRIMARY KEY NOT NULL auto_increment,
  user_id INTEGER REFERENCES users(id),
  batch_id INTEGER REFERENCES batches(id),
  active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- creating table for recording sessions
CREATE TABLE sessions (
  id INTEGER PRIMARY KEY NOT NULL auto_increment ,
  conducted_by INTEGER NOT NULL REFERENCES users(id),
  batch_id INTEGER NOT NULL REFERENCES batches(id),
  start_time TIMESTAMP NOT NULL,
  end_time TIMESTAMP NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

 
 -- creating table for recording the attendances

CREATE TABLE attendances (
  student_id INTEGER NOT NULL REFERENCES users(id),
  session_id INTEGER NOT NULL REFERENCES sessions(id),
  rating DOUBLE PRECISION NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (student_id, session_id)
);

-- creating table for tests
CREATE TABLE tests (
   id INTEGER PRIMARY KEY NOT NULL auto_increment,
  batch_id INTEGER REFERENCES batches(id),
  created_by INTEGER REFERENCES users(id),
  total_mark INTEGER NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- creating the table for recording the test scores

CREATE TABLE test_scores (
  test_id INTEGER REFERENCES tests(id),
  user_id INTEGER REFERENCES users(id),
  score INTEGER NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY(test_id, user_id)
);


-- entering the users information 1 - 3 are the instructors and the remaining are students
insert into users (name) 
values("Ram"),("Laxman"),("Sita"),("Arjun"),("Sahadeva"),("Bheema"),("Nakula"),("Vibhushna"),("Ravana"),("Megnath"),("Khumbkarna"),("Bharath");
select * from users;

insert into batches (name) values("B1"),("B2"),("B3");
select * from batches;

insert into instructor_batch_maps (user_id, batch_id)
values (1,1),(2,2),(3,3);
select * from instructor_batch_maps;

insert into student_batch_maps(user_id, batch_id)
values(4,1),(5,1),(6,1),(7,2),(8,2),(9,2),(10,3),(11,3),(12,3);
select * from student_batch_maps;

insert into sessions(conducted_by, batch_id, start_time, end_time)
values(1,1,"2021-11-14 09:00:00","2021-11-14 10:00:00"),
(2,2,"2021-11-14 10:00:00","2021-11-14 11:00:00"),
(3,3,"2021-11-14 10:00:00","2021-11-14 11:00:00");
select * from sessions;

insert into attendances(student_id, session_id, rating)
values(4,1,3.75),(5,1,4.2),(7,2,4.8),(8,2,5),(9,2,3.1),(10,3,5),(11,3,2.1),(12,3,2.64);
select * from attendances;

insert into tests (batch_id, created_by,total_mark) 
values(1,1,20),(2,2,20),(3,3,20);
select * from tests;

insert into test_scores (test_id, user_id, score)
values(1,4,15),(1,5,19),(1,6,10),(2,7,11),(2,8,16),(2,9,18),(3,10,12),(3,11,5),(3,12,20);
select * from test_scores;



--  As of now there is only one test for student now we add few more tests such that we can find average scores for each student
select * from tests;
insert into tests(batch_id, created_by,total_mark)
values (1,1,25),(2,2,30),(3,3,20),(1,1,10);

-- Entering the scores scored by student

insert into test_scores (test_id, user_id, score)
values (4,4,25),(4,5,20),(4,6,10),(5,7,25),(5,8,29),(5,9,20),(6,10,10),(6,11,20),(6,12,15),(7,4,8),(7,5,9),(7,6,3);

select * from test_scores;

select user_id, round(avg(score),2) as avg_score from test_scores group by user_id;



--   getting the no of students passed along with their test id and batch name
alter table test_scores add column pass boolean default true;

select test_id, user_id, score from test_scores where test_scores.score > 0.4*20;
select test_id,user_id,score,total_mark from test_scores left join tests on test_scores.test_id = tests.id;

create table pass_table as (select test_id,user_id,score,total_mark from test_scores left join tests on test_scores.test_id = tests.id);
select * from pass_table;

alter table pass_table add column pass boolean default true;
update pass_table set pass = case when score > 0.4*total_mark then 1 else 0 end;

select * from test_scores;
select test_id, count(user_id) as No_of_students_passed from pass_table where pass = 1 group by test_id;

select C.test_id, C.batch_id, batches.name, C.No_of_students_passed from
(select test_id,batch_id, No_of_students_passed from tests left join (select test_id, count(user_id) as No_of_students_passed 
from pass_table where pass = 1 group by test_id) as B on tests.id = B.test_id) as C
left join batches
on C.batch_id = batches.id;

-- : finding the attendance percentage
select * from sessions;
select * from attendances;

select attendances.student_id, attendances.session_id, rating, conducted_by, batch_id from attendances left join sessions on attendances.session_id = sessions.id;


select sessions.batch_id, sessions.conducted_by,sessions.id as session_id, user_id as student from sessions
right join student_batch_maps on sessions.batch_id = student_batch_maps.batch_id;


select B.session_id,B.student,attendances.student_id from (select sessions.id as session_id, user_id as student from sessions
right join student_batch_maps on sessions.batch_id = student_batch_maps.batch_id) as B
left join attendances on B.session_id = attendances.session_id and B.student = attendances.student_id;



select * from student_batch_maps;

create table temp as 
select B.batch_id, B.cond_by,B.session_id, B.student,attendances.student_id from (select sessions.batch_id, sessions.conducted_by as cond_by,sessions.id as session_id, user_id as student from sessions
right join student_batch_maps on sessions.batch_id = student_batch_maps.batch_id) as B
left join attendances on B.session_id = attendances.session_id and B.student = attendances.student_id;

select * from temp;
alter table temp add column attendance boolean default true;

update temp set attendance = case when student = student_id then 1 else 0 end;

-- 
select A.session_id, A.batch_id, A.att_per, sessions.conducted_by, users.name,batches.name from
(select session_id, batch_id, round(avg(attendance)*100,2) as att_per from temp group by session_id, batch_id) as A
left join sessions on sessions.id = A.session_id 
left join users on conducted_by = users.id
left join batches on A.batch_id = batches.id;

-- 


select A.session_id,A.attendance,A.name, batches.name as batch from
(select temp.batch_id,temp.session_id,temp.attendance,users.name  from temp left join users on temp.cond_by = users.id) as A
left join batches 
on A.batch_id = batches.id;

select * from sessions;

select temp.batch_id,temp.session_id,temp.attendance,users.name as cond_by  from temp left join users on temp.cond_by = users.id;

-- 
select * from attendances;

select round(avg(attendances.rating),2) as avg_rating, sessions.conducted_by,batches.name, session_id  from attendances left join sessions
on attendances.session_id = sessions.id
left join batches
on batch_id = batches.id
group by session_id, conducted_by;



-- 

select * from student_batch_maps;
select * from attendances;
select * from sessions;
select * from batches;

-- 

insert into batches (name) values ("B4");
select * from student_batch_maps;
update student_batch_maps set active = 0 where user_id in (6,9,10);
insert into student_batch_maps(user_id, batch_id, deactivated_at) values (6,4),(9,4),(10,4);
update student_batch_maps set deactivated_at = "2021-11-13 16:00:00" where user_id in (6,9,10) and batch_id != 4;
select * from student_batch_maps;


-- 
select * from sessions;
insert into sessions(conducted_by, batch_id,start_time,end_time) 
values(1,1,"2021-11-15 09:00:00","2021-11-15 10:00:00"),
(2,2,"2021-11-15 10:00:00","2021-11-15 11:00:00"),
(3,3,"2021-11-15 09:00:00", "2021-11-15 10:00:00"),
(1,4,"2021-11-15 10:00:00","2021-11-15 11:00:00");
select * from batches;
select *  from student_batch_maps;

select * from student_batch_maps where active = 0;
select * from attendances;

insert into attendances(student_id, session_id,rating) 
values(4,4,5),(5,4,4.5),(7,5,2.5),(8,5,3.75),(11,6,4.85),(12,6,3.15),(6,7,3.56),(9,7,4.58),(10,7,1.25);

select * from attendances;
select * from sessions;
create table temp1 as (select A.student_id,A.session_id,student_batch_maps.deactivated_at,A.created_at, student_batch_maps.user_id from 
(select student_id, session_id,batch_id, attendances.created_at from attendances left join sessions on session_id = sessions.id) as A
right join student_batch_maps on A.student_id = student_batch_maps.user_id and A.batch_id = student_batch_maps.batch_id);
select * from student_batch_maps;

select created_at from temp1 where deactivated_at > created_at;
select * from temp1 where created_at not in (select created_at from temp1 where deactivated_at > created_at);

select * from temp1;
update temp1 set created_at = (select min(created_at)from batches) where temp1.created_at = null;
select * from temp1;
alter table temp1 add column dummy int primary key not null auto_increment;
alter table temp2 add column attend boolean default true;
select dummy from temp1 where deactivated_at > created_at;
create table temp2 as (select * from temp1 where dummy not in (select dummy from temp1 where deactivated_at > created_at));

update temp2 set attend = case when student_id = user_id then 1 else 0 end;

select * from temp2;

select user_id,round(avg(attend),2) as avg_att from temp2 group by user_id;


-- 
select * from (select student_id, session_id,batch_id, attendances.created_at from attendances left join sessions on session_id = sessions.id) as A
right join student_batch_maps on A.student_id = student_batch_maps.user_id and A.batch_id = student_batch_maps.batch_id;

select * from batches;




select max(created_at) from temp1;



SET sql_safe_updates=0;
















