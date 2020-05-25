\qecho 'Creating Database Assignment2'
CREATE DATABASE assignment2;

\qecho 'Connecting to Database'
\connect assignment2;

--Creating table book
\qecho 'Creating Table Book'
create table book(
bookno int, 
title text, 
price int,
Primary key(bookno)
);

--Creating table student
\qecho 'Creating Table student'
create table student(sid int, 
sname text,
Primary key(sid)
);

--Creating table major
\qecho 'Creating Table major'
create table major(
sid int, 
major text,
Foreign key(sid) references student(sid)
);

--Creating table cites
\qecho 'Creating Table cites '
create table cites(bookno int, 
citedbookno int,
Foreign key(bookno) references book(bookno),
Foreign key(citedbookno) references book(bookno)
);

--Creating table buys
\qecho 'Creating Table buys'
create table buys(
sid int, 
bookno int,
Foreign key(sid) references student(sid),
Foreign key(bookno) references book(bookno)
);

\qecho 'Inserting Values into student'
INSERT INTO student VALUES(1001,'Jean'),
(1002,'Maria'),
(1003,'Anna'),
(1004,'Chin'),
(1005,'John'),
(1006,'Ryan'),
(1007,'Catherine'),
(1008,'Emma'),
(1009,'Jan'),
(1010,'Linda'),
(1011,'Nick'),
(1012,'Eric'),
(1013,'Lisa'),
(1014,'Filip'),
(1015,'Dirk'),
(1016,'Mary'),
(1017,'Ellen'),
(1020,'Ahmed');

\qecho 'Inserting Values into book'
INSERT INTO book VALUES(2001,'Databases',40),
(2002,'OperatingSystems',25),
(2003,'Networks',20),
(2004,'AI',45),
(2005,'DiscreteMathematics',20),
(2006,'SQL',25),
(2007,'ProgrammingLanguages',15),
(2008,'DataScience',50),
(2009,'Calculus',10),
(2010,'Philosophy',25),
(2012,'Geometry',80),
(2013,'RealAnalysis',35),
(2011,'Anthropology',50),
(3000,'MachineLearning',40);

\qecho 'Inserting Values into buys'
INSERT INTO buys VALUES(1001,2002),
(1001,2007),
(1001,2009),
(1001,2011),
(1001,2013),
(1002,2001),
(1002,2002),
(1002,2007),
(1002,2011),
(1002,2012),
(1002,2013),
(1003,2002),
(1003,2007),
(1003,2011),
(1003,2012),
(1003,2013),
(1004,2006),
(1004,2007),
(1004,2008),
(1004,2011),
(1004,2012),
(1004,2013),
(1005,2007),
(1005,2011),
(1005,2012),
(1005,2013),
(1006,2006),
(1006,2007),
(1006,2008),
(1006,2011),
(1006,2012),
(1006,2013),
(1007,2001),
(1007,2002),
(1007,2003),
(1007,2007),
(1007,2008),
(1007,2009),
(1007,2010),
(1007,2011),
(1007,2012),
(1007,2013),
(1008,2007),
(1008,2011),
(1008,2012),
(1008,2013),
(1009,2001),
(1009,2002),
(1009,2011),
(1009,2012),
(1009,2013),
(1010,2001),
(1010,2002),
(1010,2003),
(1010,2011),
(1010,2012),
(1010,2013),
(1011,2002),
(1011,2011),
(1011,2012),
(1012,2011),
(1012,2012),
(1013,2001),
(1013,2011),
(1013,2012),
(1014,2008),
(1014,2011),
(1014,2012),
(1017,2001),
(1017,2002),
(1017,2003),
(1017,2008),
(1017,2012),
(1020,2012);

\qecho 'Inserting Values into cites'
INSERT INTO cites VALUES(2012,2001),
(2008,2011),
(2008,2012),
(2001,2002),
(2001,2007),
(2002,2003),
(2003,2001),
(2003,2004),
(2003,2002),
(2012,2005);

\qecho 'Inserting Values into major'
INSERT INTO major VALUES(1001,'Math'),
(1001,'Physics'),
(1002,'CS'),
(1002,'Math'),
(1003,'Math'),
(1004,'CS'),
(1006,'CS'),
(1007,'CS'),
(1007,'Physics'),
(1008,'Physics'),
(1009,'Biology'),
(1010,'Biology'),
(1011,'CS'),
(1011,'Math'),
(1012,'CS'),
(1013,'CS'),
(1013,'Psychology'),
(1014,'Theater'),
(1017,'Anthropology');

--Question 1(a):
\qecho 'Question 1(a)'
select distinct(s.sid),s.sname
from student s, major m, buys bu, book b
where s.sid=m.sid
AND bu.sid=s.sid
AND b.bookno=bu.bookno
AND m.major='CS'
AND b.price>10;

--Question 1(b)
\qecho 'Question 1(b)'
select distinct(s.sid),s.sname
from student s, major m
where s.sid=m.sid
AND m.major='CS'
AND m.sid IN(
select bu.sid
from buys bu, book b
where bu.bookno=b.bookno
AND b.price>10
);


--Question 1(c)
\qecho 'Question 1(c)'
select distinct(s.sid),s.sname
from student s, major m
where s.sid=m.sid
AND m.major='CS'
AND m.sid= SOME(
select bu.sid
from buys bu, book b
where bu.bookno=b.bookno
AND b.price>10
);


--Question 1(d)
\qecho 'Question 1(d)'
select distinct(s.sid),s.sname
from student s
where EXISTS(
select m.sid
from major m
where m.major='CS'
AND s.sid=m.sid
AND m.sid IN(
select bu.sid
from buys bu, book b
where bu.bookno=b.bookno
AND b.price>10
)
);

--Question 2(a)
\qecho 'Question 2(a)'
select b.bookno, b.title, b.price
from book b
EXCEPT
(
select distinct(b.bookno),b.title,b.price
from book b,buys bu, major m
where m.sid=bu.sid
AND bu.bookno=b.bookno
AND m.major='Math'
);


--Question 2(b)
\qecho 'Question 2(b)'
select b.bookno, b.title,b.price
from book b
where b.bookno NOT IN(select bu.bookno
from buys bu
where bu.sid IN(
select m.sid
from major m
where m.major='Math'
)
);

--Question 2(c)
\qecho 'Question 2(c)'
select b.bookno,b.title,b.price
from book b
where b.bookno <> ALL(
select bu.bookno
from buys bu
where bu.sid=some(select m.sid
from major m 
where m.major='Math'
)
);

--Question 2(d)
\qecho 'Question 2(d)'
select b.bookno, b.title,b.price
from book b
where NOT EXISTS(
select bu.sid
from buys bu
where bu.bookno=b.bookno
AND EXISTS(select from major m
where m.sid=bu.sid
AND m.major='Math'
)
);

--Question 3(a)
\qecho 'Question 3(a)'
select distinct(b.bookno) ,b.title,b.price
from book b,book b1, book b2, cites c1, cites c2
where b.bookno=c1.bookno
AND b.bookno=c2.bookno
AND c1.bookno=c2.bookno
AND c1.citedbookno<>c2.citedbookno
AND c1.citedbookno=b1.bookno
AND c2.citedbookno=b2.bookno
AND b1.price<60
AND b2.price<60;


--Question 3(b)
\qecho 'Question 3(b)'
select distinct(b.bookno),b.title,b.price
from cites c1, cites c2, book b
where c1.bookno=b.bookno
AND c2.bookno=b.bookno
AND c1.bookno=c2.bookno
AND c1.citedbookno<>c2.citedbookno
AND (c1.citedbookno,c2.citedbookno) IN(
select b1.bookno, b2.bookno
from book b1, book b2
where b1.price<60
AND b2.price<60
);


--Question 3(c)
\qecho 'Question 3(c)'
select b.bookno, b.price, b.title
from book b
where EXISTS(
select 
from cites c1, cites c2
where c1.bookno=b.bookno
AND c2.bookno=b.bookno
AND c1.citedbookno<>c2.citedbookno
AND EXISTS(
select 
from book b1, book b2
where c1.citedbookno=b1.bookno
AND c2.citedbookno=b2.bookno
AND b1.price<60
AND b2.price<60
)
);


--Question 4(a)
\qecho 'Question 4(a)'
select s.sid, s.sname, b.title, b.price
from student s, buys bu, book b
where bu.bookno=b.bookno
AND bu.sid=s.sid 
EXCEPT(
select s1.sid, s1.sname, b1.title, b1.price
from student s1, buys bu1, book b1, buys bu2, book b2
where s1.sid=bu1.sid
AND bu2.sid=bu1.sid
AND b1.bookno=bu1.bookno
AND b2.bookno=bu2.bookno
AND b1.price<b2.price
)
order by 1;

--Question 4(b)
\qecho 'Question 4(b)'
select s.sid,s.sname,b.title,b.price
from buys bu1, student s, book b
where s.sid=bu1.sid
AND b.bookno=bu1.bookno
AND b.price>=all(
select b1.price
from buys bu2, book b1
where bu1.sid=bu2.sid
AND bu2.bookno=b1.bookno
);


--Question 5 
\qecho 'Question 5'
select s1.sid, s1.sname 
from student s1
EXCEPT
select distinct(s.sid),s.sname
from student s, buys bu1, book b1, buys bu2, book b2
where bu1.sid=s.sid
AND bu2.sid=s.sid
AND bu1.sid=bu2.sid
AND bu1.bookno<>bu2.bookno
AND bu1.bookno=b1.bookno
AND bu2.bookno=b2.bookno
AND b1.price>=20
AND b2.price>=20;


--Question 6
\qecho 'Question 6'
select b1.bookno, b1.title, b1.price
from book b1
where EXISTS(
select 
from book b2
where b1.price<b2.price
)
AND NOT EXISTS(
select 
from book b2, book b3
where b1.price<b2.price
AND b2.price<b3.price
);


--Question 7
\qecho 'Question 7'
select distinct(b.bookno),b.title, b.price
from book b,book b1, cites c, cites c1
where b.bookno=c.bookno
AND b1.bookno=c1.citedbookno
AND b1.price>=ALL(
select b2.price
from book b2
)
ORDER BY 1;


--Question 8
\qecho 'Question 8'
select s.sid, s.sname
from major m, student s
where m.sid=s.sid
AND m.sid NOT IN(
select m1.sid
from major m1, major m2
where m1.sid=m2.sid
AND m1.major<>m2.major
)
AND m.sid NOT IN(
select bu1.sid
from buys bu1, book b1
where bu1.bookno=b1.bookno
AND b1.price <40
);

--Question 9
\qecho 'Question 9'

select distinct (b.bookno), b.title 
from book b 
where NOT EXISTS (
select m1.sid 
from major m1, major m2 
where m1.sid = m2.sid 
and m1.major = 'CS' 
and m2.major = 'Math' 
and m1.sid NOT IN (select bu.sid 
		from buys bu 
		where bu.bookno = b.bookno)
) order by 1;


--Question 10
\qecho 'Question 10'
(select distinct(s.sid), s.sname
from student s
where s.sid IN(
select bu1.sid
from buys bu1, book b1
where bu1.bookno=b1.bookno
AND b1.price>=70
AND bu1.sid IN(
select bu2.sid
from buys bu2, book b2
where bu2.bookno=b2.bookno
AND b2.price<30
)
)
)
UNION										  
(select distinct s.sid,s.sname 
from student s,buys bu,book b
where s.sid NOT IN (select bu.sid 
					from buys bu,book b 
					where bu.bookno=b.bookno 
					and b.price>70)) order by 1;
			 
			

--Question 11

\qecho 'Question 11'

select distinct(m1.sid), m2.sid
from major m1, major m2, buys bu1, buys bu2
where m1.major=m2.major
AND m1.sid<>m2.sid
AND m1.sid=bu1.sid
AND m2.sid=bu2.sid
AND(bu1.bookno<>ALL(
select bookno 
from buys bu3
where bu3.sid=bu2.sid)
OR(
bu2.bookno<>ALL(
select bookno 
from buys bu4
where bu4.sid=bu1.sid)
)
);


--Question 12

\qecho 'Question 12'

select count(1)
from
((select (s1.sid,b1.bookno,s2.sid,b2.bookno)
from student s1,student s2,book b1,book b2)
EXCEPT
(select (s1.sid,bu1.bookno,s2.sid,bu2.bookno)
from student s1,student s2,buys bu1,buys bu2
where s1.sid=bu1.sid and s2.sid=bu2.sid)) student;

--Question 13
\qecho 'Question 13'

\qecho 'Creating View'
--Creating View
create view bookAtLeast30 as
select bookno,title,price 
from book where price>=30;

\qecho 'Running Query'
--Runnin Query
select distinct(s.sid), s.sname from student s
where NOT EXISTS(select bu1.sid from buys bu1, buys bu2
where bu1.sid=s.sid
AND s.sid=bu2.sid
AND bu1.sid=bu2.sid
AND bu1.bookno<>bu2.bookno
AND bu1.bookno NOT IN(select b30.bookno from bookAtLeast30 b30)
AND bu2.bookno NOT IN(select b30.bookno from bookAtLeast30 b30)
);
\qecho 'Dropping View'
DROP VIEW bookAtLeast30;


--Question 14
\qecho 'Question 14'
WITH bookatleast30 as (
select bookno,title,price 
from book where price>=30
)
select distinct s.sid,s.sname 
from student s 
where NOT EXISTS(select bu1.sid from buys bu1, buys bu2
where bu1.sid=s.sid
AND s.sid=bu2.sid
AND bu1.sid=bu2.sid
AND bu1.bookno<>bu2.bookno
AND bu1.bookno NOT IN(select b30.bookno from bookAtLeast30 b30)
AND bu2.bookno NOT IN(select b30.bookno from bookAtLeast30 b30)
);

--Question 15
\qecho 'Question 15'

create function citesBooks(b integer)
returns Table(bookno integer,title Text,price integer) AS
$$
select bu.bookno,bu.title,bu.price 
from book bu,cites c
where c.bookno=b
AND bu.bookno=c.citedbookno 
;
$$
language sql;



--Question 15(a)
\qecho 'Question 15(a)'

select b.bookno,b.title,b.price
from book b
where exists(
select * 
from citesBooks(b.bookno) c 
where c.bookno=2001
)
AND exists
(select * 
from citesBooks(b.bookno) c 
where c.price<50
);

--Question 15(b)
\qecho 'Question 15(b)'

select b1.bookno,b2.title
from book b1,book b2 
where exists(
select *
from citesBooks(b1.bookno) c1,citesBooks(b2.bookno) c2
where b1.bookno=b2.bookno and c1.bookno<>c2.bookno
);

--Connecting to Default
\c postgres;

--Drop Database Created
drop database assignment2;

\q









