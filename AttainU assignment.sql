show databases;
use attainu;

CREATE TABLE users (
  id INTEGER PRIMARY KEY auto_increment NOT NULL,
  name VARCHAR(50) NOT NULL,
  active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


create table instructor (
id INTEGER PRIMARY KEY auto_increment NOT NULL,
  name VARCHAR(50) NOT NULL,
  active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);



CREATE TABLE batches (
  id INTEGER PRIMARY KEY NOT NULL auto_increment,
  name VARCHAR(100) UNIQUE NOT NULL,
  active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);




CREATE TABLE student_batch_maps (
  id INTEGER PRIMARY KEY NOT NULL,
  user_id INTEGER NOT NULL REFERENCES users(id),
  batch_id INTEGER NOT NULL REFERENCES batches(id),
  active BOOLEAN NOT NULL DEFAULT true,
  deactivated_at TIMESTAMP NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
alter table student_batch_maps modify id int auto_increment;





CREATE TABLE instructor_batch_maps (
  id INTEGER PRIMARY KEY NOT NULL,
  user_id INTEGER REFERENCES instructor(id),
  batch_id INTEGER REFERENCES batches(id),
  active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
alter table instructor_batch_maps modify id int auto_increment;


CREATE TABLE sessions (
  id INTEGER PRIMARY KEY NOT NULL auto_increment ,
  conducted_by INTEGER NOT NULL REFERENCES instructor(id),
  batch_id INTEGER NOT NULL REFERENCES batches(id),
  start_time TIMESTAMP NOT NULL,
  end_time TIMESTAMP NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
alter table sessions modify start_time int, modify end_time int;
 



CREATE TABLE attendances (
  student_id INTEGER NOT NULL REFERENCES users(id),
  session_id INTEGER NOT NULL REFERENCES sessions(id),
  rating DOUBLE PRECISION NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (student_id, session_id)
);




CREATE TABLE tests (
   id INTEGER PRIMARY KEY NOT NULL auto_increment,
  batch_id INTEGER REFERENCES batches(id),
  created_by INTEGER REFERENCES instructor(id),
  total_mark INTEGER NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);





CREATE TABLE test_scores (
  test_id INTEGER REFERENCES tests(id),
  user_id INTEGER REFERENCES users(id),
  score INTEGER NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY(test_id, user_id)
);




insert into users (name) values ('Bheema'), ('Arjuna'),('Yudhishthira'), ('Nakula'), ('Sahadeva'), ('Krishna'), ('Draupati'), ('Duryodhana'), ('Dushasana'), ('karna');
select * from users;


insert into instructor (name) values ('Rama'), ('Lakshmana'),('Bharata'), ('Shatrugana'), ('Sita');
select * from instructor;



insert into batches (name) values ('B1'), ('B2'),('B3'), ('B4');
insert into batches (name) values ('B5'), ('B6'),('B7'), ('B8'), ('B9'), ('B10');
select * from batches;


insert into student_batch_maps (user_id, batch_id) values (1,1), (2,2), (3,3), (4,4), (5,5), (6,6) , (7, 7) ,(8,8), (9,9), (10,10);
select * from student_batch_maps;


insert into instructor_batch_maps (user_id, batch_id) values (1,1), (1,2), (2,3), (2,4), (3,5), (3,6) , (4, 7) ,(4,8), (5,9), (5,10);
select * from   instructor_batch_maps;



insert into sessions (conducted_by, batch_id, start_time, end_time) values (1,1, 9, 10), (1,2, 10,11), (2,3, 9,10), (2,4,10,11), (3,5,9,10),(3,6,10,11), 
(4,7,9,10), (4,8,10,11), (5,9,9,10), (5,10,10,11);
select * from sessions;



insert into attendances (student_id, session_id, rating) values (1,1,4.5), (2,2,3.5),(3,3,3.3),(4,4,2.5),(5,5,4.3),(6,6,4.5),(7,7,1.5),(8,8,2.5),(9,9,3.5),(10,10,4.5);
select * from attendances;


insert into tests (batch_id, created_by, total_mark) values (1,1,10),(2,1,10),(3,2,10),(4,2,10),(5,3,10),(6,3,10),(7,4,10),(8,4,10),(9,5,10),(10,5,10);
select * from tests;




insert into test_scores (test_id, user_id, score) values (1,1,7),(2,2,6),(3,3,5),(4,4,5),(5,5,6),(6,6,7),(7,7,3),(8,8,4),(9,9,6),(10,10,8);
select * from test_scores;













select avg(a.rating) as Average_Rating, s.id, s.batch_id, s.conducted_by, b.name 
from attendances as a
 inner join sessions as s 
on a.session_id=s.id 
inner join batches as b on b.id=s.batch_id group by s.conducted_by, s.id;



















