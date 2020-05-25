CREATE DATABASE assignment3;

\c assignment3;


--Part 1
\qecho 'Part 1'

--Question 1
\qecho 'Question 1'

--Creating table and inserting values into it
\qecho 'Creating table and inserting values into it'
Create Table A(value int);
Create Table B(value int);

Insert into A VALUES
(1),(2),(3);

Insert into B VALUES
(1),(3);

--Creating view for A-B
\qecho 'Creating view for A-B'
create view AminusB AS(
select * from A
EXCEPT
select * from B
);

--Creating view for B-A
\qecho 'Creating view for B-A'
create view BminusA AS(
select * from B
EXCEPT
select * from A
);

--Creating view for AintersectB
\qecho 'Creating view for AintersectB'
Create view AintersectB as(
select * from A
intersect
select * from B
);

--Question 1a) Check Empty Condition for AMinusB, BminusA,AintersectB
\qecho 'Question 1a) Check Empty Condition for AMinusB, BminusA,AintersectB'
select not exists(select * from AminusB) as empty_a_minus_b,
       not exists(select * from BminusA) as empty_b_minus_a,
       not exists(select * from AintersectB) as empty_a_intersection_b;


--Question 1 b) Check Empty condition using IN, NOT IN, EXISTS, NOT EXISTS
\qecho 'Question 1 b) Check Empty condition using IN, NOT IN, EXISTS, NOT EXISTS'

--Creating view for AminusB
\qecho 'Creating view for AminusB'
Create view AminusB_Again as(
select a.value from A a
where a.value NOT IN(select b.value from B b)
);

--Creating view for BminusA
\qecho 'Creating view for BminusA'
Create view BminusA_Again as(
select b.value from B b
where b.value NOT IN(select a.value from A a)
);

--Creating view for AintersectB
\qecho 'Creating view for AintersectB'
Create view AintersectB_Again as(
select a.value from A a
where a.value IN(select b.value from B b)
);

select not exists(select * from AminusB_Again) as empty_a_minus_b,
       not exists(select * from BminusA_Again) as empty_b_minus_a,
       not exists(select * from AintersectB_Again) as empty_a_intersection_b;

drop TABLE A cascade;
drop TABLE B cascade;


--Question 2
\qecho 'Question 2'
--Creating table p,q,r

\qecho 'Creating table p,q,r'
Create Table p(value boolean);
Create Table q(value boolean);
Create Table r(value boolean);

--Inserting values into p,q,r
\qecho 'Inserting values into p,q,r'
Insert into p VALUES
(True),(False),(Null);

Insert into q VALUES
(True),(False),(Null);

Insert into r VALUES
(True),(False),(Null);

select p.value as p, q.value as q, r.value as r,((p.value AND (NOT q.value)) OR (NOT r.value)) AS values 
from p,q,r ;

drop TABLE p;
drop TABLE q;
drop TABLE r;

--Question 3 a)
\qecho 'Question 3 a)'
create table Point(pid integer, x float, y float);

insert into Point values
(1,0,0),
(2,0,1),
(3,1,0);

Create function calculate_distance(x1 float, y1 float, x2 float, y2 float)
returns float as
$$
Select sqrt(power(x1-x2,2) + power(y1-y2,2))
$$language sql;

select p1.pid, p2.pid
from Point p1, Point p2
where p1.pid<>p2.pid
AND calculate_distance(p1.x,p1.y,p2.x,p2.y)<=ALL(
select calculate_distance(p1_new.x,p1_new.y,p2_new.x,p2_new.y)
from Point p1_new, Point p2_new
where p1_new.pid<>p2_new.pid);

drop table Point;
drop function calculate_distance;

--Question 3 b)
\qecho 'Question 3 b)'
create table Point(pid float, x float, y float);

insert into Point values
(1,0,0),
(2,0,1),
(3,1,0),
(4,1,1),
(5,2,0);

\qecho 'Creating Function to check collinearity'
create function iscollinear(x1 float, y1 float, x2 float, y2 float, x3 float, y3 float)
returns float as
$$
select (x1*(y2 - y3) + x2*(y3 - y1) + x3*(y1 - y2));
$$ language sql;

\qecho 'Final Query'
select distinct p1.pid, p2.pid, p3.pid
from Point p1, Point p2, Point p3
where iscollinear(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y) =0
AND p1.pid<>p2.pid AND p2.pid<> p3.pid AND p3.pid<>p1.pid
AND p1.pid<p2.pid
AND p2.pid<p3.pid ;

drop function iscollinear;
drop table Point;

--Question 4
\qecho 'Question 4'
-- 4(a)
\qecho 'Question 4(a)'
Create Table R(A int, B int, C int);

Insert into R Values
(1,5,8),
(2,6,8),
(3,7,19),
(4,7,68);

--Checking for Primary Key-A is a primary here. So my query returns true
\qecho 'Checking for Primary Key-A is a primary here. So my query returns true'

select not exists(
select *
from R r1, R r2
where (r1.B<>r2.B OR r1.c<>r2.c)
AND r1.A=r2.A
) as iskey;


insert into R VALUES (1,55,88);
--Checking for Primary Key-A is not a primary here. So my query returns false
\qecho 'Checking for Primary Key-A is not a primary here. So my query returns false'

select not exists(
select *
from R r1, R r2
where (r1.B<>r2.B OR r1.c<>r2.c)
AND r1.A=r2.A
) as iskey;

Drop Table R;

--Part 2
\qecho 'Part 2'
--Loading data from data.sql file
\qecho 'Loading data from data.sql file'

create table book(bookno int, title text, price int);
create table student(sid int, sname text);
create table major(sid int, major text);
create table buys(sid int, bookno int);


insert into student values (1021, 'Kris');

insert into major values (1021, 'CS'), (1021, 'Math');

insert into book values
   (4001, 'LinearAlgebra', 30),
   (4002, 'MeasureTheory', 75),
   (4003, 'OptimizationTheory', 30);

insert into buys values 
   (1001,3000),
   (1001,2004),
   (1021, 2001),
   (1021, 2002),
   (1021, 2003),
   (1021, 2004),
   (1021, 2005),
   (1021, 2006),
   (1021, 2007),
   (1021, 2008),
   (1021, 2009),
   (1021, 2010),
   (1021, 2011),
   (1021, 4003),
   (1021, 4001),
   (1021, 4002),
   (1015, 2001),
   (1015, 2002),
   (1016, 2001),
   (1016, 2002),
   (1015, 2004),
   (1015, 2008),
   (1015, 2012),
   (1015, 2011),
   (1015, 3000),
   (1016, 2004),
   (1016, 2008),
   (1016, 2012),
   (1016, 2011),
   (1016, 3000),
   (1002, 4003),
   (1011, 4003),
   (1015, 4003),
   (1015, 4001),
   (1015, 4002),
   (1016, 4001),
   (1016, 4002);

INSERT INTO student VALUES(1001,'Jean');
INSERT INTO student VALUES(1002,'Maria');
INSERT INTO student VALUES(1003,'Anna');
INSERT INTO student VALUES(1004,'Chin');
INSERT INTO student VALUES(1005,'John');
INSERT INTO student VALUES(1006,'Ryan');
INSERT INTO student VALUES(1007,'Catherine');
INSERT INTO student VALUES(1008,'Emma');
INSERT INTO student VALUES(1009,'Jan');
INSERT INTO student VALUES(1010,'Linda');
INSERT INTO student VALUES(1011,'Nick');
INSERT INTO student VALUES(1012,'Eric');
INSERT INTO student VALUES(1013,'Lisa');
INSERT INTO student VALUES(1014,'Filip');
INSERT INTO student VALUES(1015,'Dirk');
INSERT INTO student VALUES(1016,'Mary');
INSERT INTO student VALUES(1017,'Ellen');
INSERT INTO student VALUES(1020,'Ahmed');

-- Data for the book relation.
INSERT INTO book VALUES(2001,'Databases',40);
INSERT INTO book VALUES(2002,'OperatingSystems',25);
INSERT INTO book VALUES(2003,'Networks',20);
INSERT INTO book VALUES(2004,'AI',45);
INSERT INTO book VALUES(2005,'DiscreteMathematics',20);
INSERT INTO book VALUES(2006,'SQL',25);
INSERT INTO book VALUES(2007,'ProgrammingLanguages',15);
INSERT INTO book VALUES(2008,'DataScience',50);
INSERT INTO book VALUES(2009,'Calculus',10);
INSERT INTO book VALUES(2010,'Philosophy',25);
INSERT INTO book VALUES(2012,'Geometry',80);
INSERT INTO book VALUES(2013,'RealAnalysis',35);
INSERT INTO book VALUES(2011,'Anthropology',50);
INSERT INTO book VALUES(3000,'MachineLearning',40);


-- Data for the buys relation.

INSERT INTO buys VALUES(1001,2002);
INSERT INTO buys VALUES(1001,2007);
INSERT INTO buys VALUES(1001,2009);
INSERT INTO buys VALUES(1001,2011);
INSERT INTO buys VALUES(1001,2013);
INSERT INTO buys VALUES(1002,2001);
INSERT INTO buys VALUES(1002,2002);
INSERT INTO buys VALUES(1002,2007);
INSERT INTO buys VALUES(1002,2011);
INSERT INTO buys VALUES(1002,2012);
INSERT INTO buys VALUES(1002,2013);
INSERT INTO buys VALUES(1003,2002);
INSERT INTO buys VALUES(1003,2007);
INSERT INTO buys VALUES(1003,2011);
INSERT INTO buys VALUES(1003,2012);
INSERT INTO buys VALUES(1003,2013);
INSERT INTO buys VALUES(1004,2006);
INSERT INTO buys VALUES(1004,2007);
INSERT INTO buys VALUES(1004,2008);
INSERT INTO buys VALUES(1004,2011);
INSERT INTO buys VALUES(1004,2012);
INSERT INTO buys VALUES(1004,2013);
INSERT INTO buys VALUES(1005,2007);
INSERT INTO buys VALUES(1005,2011);
INSERT INTO buys VALUES(1005,2012);
INSERT INTO buys VALUES(1005,2013);
INSERT INTO buys VALUES(1006,2006);
INSERT INTO buys VALUES(1006,2007);
INSERT INTO buys VALUES(1006,2008);
INSERT INTO buys VALUES(1006,2011);
INSERT INTO buys VALUES(1006,2012);
INSERT INTO buys VALUES(1006,2013);
INSERT INTO buys VALUES(1007,2001);
INSERT INTO buys VALUES(1007,2002);
INSERT INTO buys VALUES(1007,2003);
INSERT INTO buys VALUES(1007,2007);
INSERT INTO buys VALUES(1007,2008);
INSERT INTO buys VALUES(1007,2009);
INSERT INTO buys VALUES(1007,2010);
INSERT INTO buys VALUES(1007,2011);
INSERT INTO buys VALUES(1007,2012);
INSERT INTO buys VALUES(1007,2013);
INSERT INTO buys VALUES(1008,2007);
INSERT INTO buys VALUES(1008,2011);
INSERT INTO buys VALUES(1008,2012);
INSERT INTO buys VALUES(1008,2013);
INSERT INTO buys VALUES(1009,2001);
INSERT INTO buys VALUES(1009,2002);
INSERT INTO buys VALUES(1009,2011);
INSERT INTO buys VALUES(1009,2012);
INSERT INTO buys VALUES(1009,2013);
INSERT INTO buys VALUES(1010,2001);
INSERT INTO buys VALUES(1010,2002);
INSERT INTO buys VALUES(1010,2003);
INSERT INTO buys VALUES(1010,2011);
INSERT INTO buys VALUES(1010,2012);
INSERT INTO buys VALUES(1010,2013);
INSERT INTO buys VALUES(1011,2002);
INSERT INTO buys VALUES(1011,2011);
INSERT INTO buys VALUES(1011,2012);
INSERT INTO buys VALUES(1012,2011);
INSERT INTO buys VALUES(1012,2012);
INSERT INTO buys VALUES(1013,2001);
INSERT INTO buys VALUES(1013,2011);
INSERT INTO buys VALUES(1013,2012);
INSERT INTO buys VALUES(1014,2008);
INSERT INTO buys VALUES(1014,2011);
INSERT INTO buys VALUES(1014,2012);
INSERT INTO buys VALUES(1017,2001);
INSERT INTO buys VALUES(1017,2002);
INSERT INTO buys VALUES(1017,2003);
INSERT INTO buys VALUES(1017,2008);
INSERT INTO buys VALUES(1017,2012);
INSERT INTO buys VALUES(1020,2012);

-- Data for the major relation.

INSERT INTO major VALUES(1001,'Math');
INSERT INTO major VALUES(1001,'Physics');
INSERT INTO major VALUES(1002,'CS');
INSERT INTO major VALUES(1002,'Math');
INSERT INTO major VALUES(1003,'Math');
INSERT INTO major VALUES(1004,'CS');
INSERT INTO major VALUES(1006,'CS');
INSERT INTO major VALUES(1007,'CS');
INSERT INTO major VALUES(1007,'Physics');
INSERT INTO major VALUES(1008,'Physics');
INSERT INTO major VALUES(1009,'Biology');
INSERT INTO major VALUES(1010,'Biology');
INSERT INTO major VALUES(1011,'CS');
INSERT INTO major VALUES(1011,'Math');
INSERT INTO major VALUES(1012,'CS');
INSERT INTO major VALUES(1013,'CS');
INSERT INTO major VALUES(1013,'Psychology');
INSERT INTO major VALUES(1014,'Theater');
INSERT INTO major VALUES(1017,'Anthropology');

--Question 5
\qecho 'Question 5'
create table M(row int, colmn int, value int);

insert into M values
(1,1,1),
(1,2,2),
(1,3,3),
(2,1,1),
(2,2,-3),
(2,3,5),
(3,1,4),
(3,2,0),
(3,3,-2);


Create View FindSquares as
(select m1.row, m2.colmn,sum(m1.value*m2.value)
from m m1, m m2
where m1.colmn=m2.row
group by(m1.row,m2.colmn)); 

select m11.row, m22.colmn, sum(m11.sum*m22.sum)
from FindSquares m11, FindSquares m22
where m11.colmn=m22.row
group by(m11.row,m22.colmn);

drop view FindSquares;
drop table M;

--Question 6
\qecho 'Question 6'
create table A(x int);
insert into A values (10),(22),(33),(44),(55);
	 
SELECT (a.x - 4*(a.x/4)) AS Remainder, count(a.x - 4*(a.x/4)) AS numberofelements 
FROM A a 
GROUP BY Remainder 
ORDER BY Remainder;

drop table A;
					 
--Question 7
\qecho 'Question 7'

Create table A(x int);
insert into A values(5),(3),(3),(2),(1),(3),(5);

select a.x
from A a
group by(a.x)
order by (a.x);

drop Table A;

--Question 8 a)
\qecho 'Question 8 a)'
select b.bookno, b.title
from book b
where b.price<40
AND(
select count(1)
from buys bu
where bu.bookno=b.bookno
AND bu.sid IN(
select m.sid
from major m
where m.major='CS'
)
)<3;

--Question 8 b)
\qecho 'Question 8 b)'
select s.sid, s.sname, count(bu.bookno) as numberofbooksbought
from student s, buys bu, book b
where bu.sid=s.sid
AND bu.bookno=b.bookno
group by s.sid, s.sname
having sum(b.price)<200
order by 1;

--Question 8 c)
\qecho 'Question 8 c)'
select s.sid, s.sname, sum(b.price) as spent
from student s, buys bu, book b
where bu.sid=s.sid
AND bu.bookno=b.bookno
group by s.sid, s.sname
having sum(b.price)>0
order by 3 desc
limit 1;


--Question 8 d)
\qecho 'Question 8 d)'
select m.major, sum(b.price)
from major m, buys bu, book b
where m.sid=bu.sid
AND bu.bookno=b.bookno
group by m.major
order by 1;

--Question 8 e)
\qecho 'Question 8 e)'
select bu1.bookno, bu2.bookno
from buys bu1, buys bu2
where bu1.bookno<>bu2.bookno
AND 
(select count(*) from buys b1 where b1.bookno=bu1.bookno AND b1.sid IN(select m.sid from major m where m.major='CS'))=(select count(*) from buys b11 where b11.bookno=bu2.bookno AND b11.sid IN(select m1.sid from major m1 where m1.major='CS'))
group by (bu1.bookno, bu2.bookno);


--Part 3: Queries with Quantifiers using Venn Diagrams
\qecho 'Part 3: Queries with Quantifiers using Venn Diagrams'
--Question 9:
\qecho 'Question 9:'

create function books_bought(s int)
returns table(bookno integer) AS
$$
select (bu.bookno)
from buys bu
where bu.sid=s
$$language sql;


create view booksgreaterthan50 as(select b.bookno from book b where b.price>50);

SELECT S.sid, S.sname FROM Student S WHERE EXISTS(
(SELECT bookno FROM booksgreaterthan50)
EXCEPT
(SELECT bookno FROM books_bought(S.sid))
);

drop view booksgreaterthan50;
drop function books_bought;

--Question 10
\qecho 'Question 10'

\qecho 'Creating Function'
create function sidforbookno(b int)
returns table(sid int) AS
$$
select bu.sid
from buys bu
where bu.bookno=b;
$$language sql;

\qecho 'Creating View'
create view mathcsmajors as(
(select m.sid
from major m
where m.major='CS') 
UNION 
(select m.sid
from major m
where m.major='Math')
);

\qecho 'Final Query'
select b.bookno,b.title
from book b
where exists(select sid from sidforbookno(b.bookno)
             EXCEPT
             select sid from mathcsmajors )
ORDER BY 1;

drop view mathcsmajors;
drop function sidforbookno;

--Question 11
\qecho 'Question 11'
\qecho 'Creating View'
create view leastExpensiveBook as (select b.bookno from book
b where b.price = (select min(b1.price) from book b1));

\qecho 'Creating Function'
create function booknoforsid(s int)
returns table(bookno int) AS
$$
select bu.bookno
from buys bu
where bu.sid=s;
$$language sql;

\qecho 'Final Query'
select s.sid, s.sname
from student s
where NOT EXISTS(select bookno from booknoforsid(s.sid)
                 INTERSECT
                 select bookno from leastExpensiveBook);

drop function booknoforsid;
drop view leastExpensiveBook;

--Question 12
\qecho 'Question 12'

\qecho 'Creating Function'
create function booksbycsstudents(b int)
returns table(sid int) AS
$$
  SELECT bu.sid FROM buys bu, major m
  WHERE bu.bookno = b 
  AND bu.sid=m.sid
  AND m.major='CS';
$$ LANGUAGE SQL;


SELECT b1.bookno, b2.bookno
FROM book b1, book b2
WHERE b1.bookno <> b2.bookno 
AND(
SELECT COUNT(*)
FROM booksbycsstudents(b1.bookno) b11
WHERE b11.sid NOT IN(
SELECT b22.sid
FROM booksbycsstudents(b2.bookno) b22)
) = 0
AND(
SELECT COUNT(*)
FROM booksbycsstudents(b2.bookno)b11
WHERE b11.sid NOT IN(
SELECT b22.sid
FROM booksbycsstudents(b1.bookno) b22)
) = 0;

drop function booksbycsstudents;

--Part 4: Queries with quantifiers using Venn diagrams with counting conditions
\qecho 'Part 4: Queries with quantifiers using Venn diagrams with counting conditions'

--Question 13
\qecho 'Question 13'

\qecho 'Creating View'
create view bookslessthan50 as(
select bu.bookno
from buys bu, book b
where bu.bookno=b.bookno
AND b.price<50
);

\qecho 'Creating Function'
create function booknoforsid(s int)
returns table(bookno int) AS
$$
select bu.bookno
from buys bu
where bu.sid=s;
$$language sql;

\qecho 'Actual Query'
select s.sid, s.sname
from student s, major m
where s.sid=m.sid
AND m.major='CS'
AND (
select count(*) from
(select bookno
from bookslessthan50 
INTERSECT
select bookno
from booknoforsid(s.sid) ab)
cd) <4;
drop function booknoforsid;
drop view bookslessthan50;
--Question 14
\qecho 'Question 14'

create function cs_students_books(b int)
returns bigint as
$$
select count(m.sid)
from major m, buys bu
where m.sid=bu.sid
AND m.major='CS'
AND bu.bookno=b;

$$language sql;

\qecho 'Final Query'
select b.bookno, b.title
from book b
where cs_students_books(b.bookno)%2=1;

drop function cs_students_books;

--Question 15
\qecho 'Question 15'

\qecho 'Creating View'
create view booknos AS (select bookno from book);

\qecho 'Creating function'
create function booksforsids(s int) 
returns table(bookno int) AS
$$
SELECT Bu.bookno 
from buys bu 
WHERE bu.sid = s; 
$$ LANGUAGE SQL;

\qecho 'Final Query'
select s.sid, s.sname
from student s where(
select count(*) from (select bookno from booknos
                      EXCEPT
                      select bookno from booksforsids(s.sid)) ab
)=3;

drop function booksforsids;
drop view booknos;

--Question 16
\qecho 'Question 16'
\qecho 'Creating function'

create function sidforbooks(b int)
returns table(sid int) AS
$$
select bu.sid
from buys bu
where bu.bookno=b
$$ language sql;

select distinct(bu1.bookno) as b1, bu2.bookno as b2
from buys bu1, buys bu2
where bu1.bookno<>bu2.bookno
AND (select count(*) from (
select sid from sidforbooks(bu1.bookno)
EXCEPT 
select sid from sidforbooks(bu2.bookno)
)ab )= 0 ;

drop function sidforbooks;

--Connect to default database
\c postgres;

--Drop database which you created
--drop database assignment3;