CREATE DATABASE assignment1;
\connect assignment1;

--Creating sailor table
\qecho 'Creating sailor table'

create table Sailor(
sid integer,
sname text,
rating integer,
Primary key(sid)
);

--Inserting values into sailor table
\qecho 'Inserting values into sailor table'

INSERT INTO sailor VALUES(22,   'Dustin',       7),
(29,   'Brutus',       1),
(31,   'Lubber',       8),
(32,   'Andy',         8),
(58,   'Rusty',        10),
(64,   'Horatio',      7),
(71,   'Zorba',        10),
(75,   'David',        8),
(74,   'Horatio',      9),
(85,   'Art',          3),
(95,   'Bob',          3);

--Creating Boat table
\qecho 'Creating Boat table'

create table Boat(
bid integer,
bname text,
color text,
Primary key(bid)
);

--Inserting values into boat table
\qecho 'Inserting values into boat table'

INSERT INTO boat VALUES(101,  'Interlake','blue'),
                       (102,  'Sunset',   'red'),
                       (103,  'Clipper',  'green'),
                       (104,  'Marine',   'red'),
                       (105,  'Indianapolis',  'blue');

--Creating Reserves table
\qecho 'Creating Reserves table'

create table Reserves(
sid integer,
bid integer,
day text,
Primary key(sid,bid),
Foreign key(sid) references Sailor(sid),
Foreign key(bid) references Boat(bid)
);



--Inserting values into Reserves table
\qecho 'Inserting values into Reserves table'

INSERT INTO Reserves VALUES(22,    101,  'Monday'),
                           (22,    102,  'Tuesday'),
                           (22,    103,  'Wednesday'),
                           (22,    105,  'Wednesday'),
                           (31,    102,  'Thursday'),
                           (31,    103,  'Friday'),
                           (31,    104,  'Saturday'),
                           (64,    101,  'Sunday'),
                           (64,    102,  'Monday'),
                           (74,    102,  'Saturday');

\qecho 'Question 1.1'

\qecho 'Returning relation instance sailor'
select * from sailor; 

\qecho 'Returning relation instance boat'
select * from boat; 

\qecho 'Returning relation instance Reserves'
select * from Reserves;


--Question 1.2
\qecho 'Question 1.2'

-- In order to experiment with relation schemas and instances, creating new tables sailor1, boat1 and reserves1
\qecho 'In order to experiment with relation schemas and instances, creating new tables sailor1, boat1 and reserves1'

\qecho 'create table sailor1'
-- create table sailor1 	
CREATE TABLE sailor1 (
	sid INTEGER,
	sname TEXT,
	rating INTEGER,
	PRIMARY KEY(sid)
);

INSERT INTO sailor1 VALUES(22,   'Dustin',       7),
                          (29,   'Brutus',       1),
                          (31,   'Lubber',       8),
                          (32,   'Andy',         8),
                          (58,   'Rusty',        10),
                          (64,   'Horatio',      7),
                          (71,   'Zorba',        10),
                          (75,   'David',        8),
                          (74,   'Horatio',      9),
                          (85,   'Art',          3),
                          (95,   'Bob',          3);

-- Example1 ( Inserting same key 95 with different name and rating. This won't work as same key cannot have different value)

\qecho 'Example 1(Inserting same key 95 with different name and rating.This wont work as same key cannot have different value)'

INSERT INTO sailor1 VALUES(95,   'John',   7);

-- Create table boat1
\qecho 'Create table boat1'

CREATE TABLE boat1 (
	bid INTEGER,
	bname TEXT,
	color TEXT,
	PRIMARY KEY(bid)
);

INSERT INTO boat1 VALUES(101,	'Interlake',	'blue'),
                        (102,	'Sunset',	'red'),
                        (103,	'Clipper',	'green'),
                        (104,	'Marine',	'red'),
                        (105,    'Indianapolis',     'blue');

-- Create table reserves1 
\qecho 'Create table reserves1 '

CREATE TABLE reserves1 (
	sid INTEGER,
	bid INTEGER,
	day TEXT,
	PRIMARY KEY(sid,bid),
	FOREIGN KEY(sid) REFERENCES sailor1(sid) on DELETE CASCADE ,
	FOREIGN KEY(bid) REFERENCES boat1(bid) on DELETE RESTRICT
);

INSERT INTO reserves1 VALUES(22,	101,	'Monday'),
                            (22,	102,	'Tuesday'),
                            (22,	103,	'Wednesday'),
                            (22,	105,	'Wednesday'),
                            (31,	102,	'Thursday'),
                            (31,	103,	'Friday'),
                            (31,    104,	'Saturday'),
                            (64,	101,	'Sunday'),
                            (64,	102,	'Monday'),
                            (74,	102,	'Saturday');

-- Example2 (Inserting value in reserves with sid and bid values not in sailor and boat relations. This wont work as it is not there in primary key)
\qecho 'Example2 (Inserting value in reserves with sid and bid values not in sailor and boat relations. This wont work as it is not there in primary key)'

INSERT INTO reserves1 VALUES(92,	110,	'Monday');

-- Example3 (Inserting value in reserves with sid in sailor relation but bid values not in boat relations. This wont work as it foreign key should map to values in primary key)
\qecho 'Example3 (Inserting value in reserves with sid in sailor relation but bid values not in boat relations. This wont work as it foreign key should map to values in primary key)'

INSERT INTO reserves1 VALUES(92,	106,	'Friday');

-- Example4 (Deleting sid = 22 from sailor table which will delete all rows in reserves table with sid = 22 as it satisfy cascade condition)
\qecho 'Example4 (Deleting sid = 22 from sailor table which will delete all rows in reserves table with sid = 22 as it satisfy cascade condition)'

DELETE from sailor1 where sid = 22;

-- Example5 (Deleting bid = 102 from boat table which will create error condition as it does not satisfy restrict condition)
\qecho 'Example5 (Deleting bid = 102 from boat table which will create error condition as it does not satisfy restrict condition)'

DELETE from boat1 where bid = 102;

-- Example6 (Deleting bid = 105 from boat table which is not present in reserves table)
\qecho 'Example6 (Deleting bid = 105 from boat table which is not present in reserves table)'

DELETE from boat1 where bid = 105;


--Question 2.1
\qecho 'Question 2.1'

select distinct(s.sid), s.rating
from sailor s;

--Question 2.2
\qecho 'Question 2.2'

select s.sid, s.sname, s.rating
from sailor s 
where s.rating between 2 AND 11
AND s.rating NOT BETWEEN 8 and 10;

--Question 2.3
\qecho 'Question 2.3'

select distinct(b.bid),b.bname,b.color
from boat b, reserves r, sailor s
where b.bid=r.bid
AND r.sid=s.sid
AND s.rating>7
AND b.color NOT IN ('red');

--Question 2.4
\qecho 'Question 2.4'

select distinct(b.bid),b.bname
from boat b, reserves r, sailor s
where b.bid=r.bid
AND r.sid=s.sid
AND r.day IN ('Saturday','Sunday')
AND b.bid NOT IN (
select r.bid
from reserves r
where r.day IN('Tuesday')
);

--Question 2.5
\qecho 'Question 2.5'

select distinct(r.sid)
from boat b, reserves r, sailor s
where b.bid = r.bid
AND r.sid=s.sid
AND b.color = ('red')
INTERSECT
select distinct(r.sid)
from boat b, reserves r, sailor s
where b.bid = r.bid
AND r.sid=s.sid
AND b.color = ('green');

--Question 2.6
\qecho 'Question 2.6'

select distinct(s.sid), s.sname
from sailor s, reserves r1, reserves r2
where s.sid=r1.sid
AND s.sid=r2.sid
AND r1.bid<>r2.bid ;

--Question 2.7
\qecho 'Question 2.7'

select r1.sid, r2.sid 
from reserves r1, reserves r2
where r1.bid=r2.bid
AND r1.sid<>r2.sid
GROUP BY r1.sid, r2.sid
ORDER BY r1.sid asc;

--Question 2.8
\qecho 'Question 2.8'

select distinct(s.sid) 
from sailor s
EXCEPT
(
select distinct(r.sid)
from reserves r
where r.day='Monday' OR r.day='Tuesday'
)
ORDER BY sid asc;

--Question 2.9
\qecho 'Question 2.9'

select s.sid, b.bid
from reserves r, sailor s, boat b
where r.sid=s.sid
AND r.bid=b.bid
AND s.rating>6
AND b.color NOT IN('red');


--Question 2.10
\qecho 'Question 2.10'

select distinct(b.bid)
from boat b
EXCEPT
(
select distinct(b.bid)
from boat b, reserves r1, reserves r2
where b.bid=r1.bid
AND b.bid=r2.bid
AND r1.sid<>r2.sid
);

--Question 2.11
\qecho 'Question 2.11'

select s.sid
from sailor s
except
(
select distinct(s.sid)
from sailor s,reserves r1,reserves r2,reserves r3
where s.sid=r1.sid and s.sid=r2.sid and s.sid=r3.sid 
and r1.bid<>r2.bid and r2.bid<>r3.bid and r3.bid<>r1.bid
) 
order by sid;

\qecho 'Dropping Database'

\c postgres
drop database assignment1;
\q