\qecho 'Creating Database Assignment2'
CREATE DATABASE assignment5;

\qecho 'Connecting to Database'
\connect assignment5;

create table cites(bookno int, citedbookno int);
create table book(bookno int, title text, price int);
create table student(sid int, sname text);
create table major(sid int, major text);
create table buys(sid int, bookno int);


-- Data for the student relation.
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

-- Data for the cites relation.
INSERT INTO cites VALUES(2012,2001);
INSERT INTO cites VALUES(2008,2011);
INSERT INTO cites VALUES(2008,2012);
INSERT INTO cites VALUES(2001,2002);
INSERT INTO cites VALUES(2001,2007);
INSERT INTO cites VALUES(2002,2003);
INSERT INTO cites VALUES(2003,2001);
INSERT INTO cites VALUES(2003,2004);
INSERT INTO cites VALUES(2003,2002);
INSERT INTO cites VALUES(2012,2005);


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

--Question 7
\qecho 'Question 7'
With 
E1 as (select distinct bookno from book b where price >10),
E2 as (select distinct sid from buys natural join E1),
E3 as (select distinct sid from major where major='CS'),
E4 as (select distinct s.sid, s.sname from student s natural join E3 e33),
E5 as (select distinct e44.sid, e44.sname from E4 e44 natural join E2 e22)
select * from E5;

--Question 8
\qecho 'Question 8'
With
E1 as (select b.bookno from book b where b.price<60),
E2 as (select c1.bookno, c1.citedbookno from cites c1 join E1 on E1.bookno=c1.citedbookno),
E3 as (select b1.bookno from book b1 where b1.price<60),
E4 as (select c2.bookno,c2.citedbookno from cites c2 join E3 on E3.bookno=c2.citedbookno),
E5 as (select distinct E4.bookno from (E4 join E2 on E2.bookno=E4.bookno and E2.citedbookno!=E4.citedbookno)),
E6 as (select b1.bookno, b1.title, b1.price from book b1 join E5 e55 on b1.bookno=e55.bookno )
select * from E6;


--Question 9
\qecho 'Question 9'

With 
E1 as (select distinct m.sid from major m where m.major='Math'),
E2 as (select * from buys t natural join  E1 e11),
E3 as (select distinct b.bookno, b.title, b.price from book b natural join E2 e22),
E4 as (select distinct b1.bookno, b1.title, b1.price from book b1 except select * from E3)
select * from E4;

--Question 10
\qecho 'Question 10'
With 
E1 as (select s.sid, s.sname, b.title, b.price from (student s natural join buys t natural join book b )),
E2 as (select s.sid, s.sname, b.title, b.price from (student s natural join buys t natural join book b )),
E3 as (select E1.sid, E1.sname, E1.title, E1.price from (E1 join E2 on E1.sid=E2.sid and E1.price<E2.price)),
E4 as (select s.sid, s.sname, b.title, b.price from (student s natural join buys t natural join book b )),
E5 as (select * from E4 except select * from E3)
select * from E5;



--Question 11
\qecho 'Question 11'
With 
E1 as (select distinct b2.bookno, b2.title, b2.price from (book b1 join book b2 on b1.price>b2.price)),
E2 as (select distinct b3.bookno, b3.title, b3.price from (book b3 join E1 e11 on e11.price>b3.price )),
E3 as (select * from E1 except select * from E2)
select * from E3;

--Question 12
\qecho 'Question 12'
With 
E1 as (select distinct b2.bookno, b2.title, b2.price from (book b1 join book b2 on b1.price>b2.price)),
E2 as (select * from book b3 except select * from E1), 
E3 as (select c.bookno from (cites c join E2 e22 on c.citedbookno != e22.bookno)), 
E4 as (select * from book b4 natural join E3)
select distinct bookno, title, price from E4;

--Question 13
\qecho 'Question 13'

With
E1 as (select distinct m1.sid from major m1 join major m2 on m1.sid!=m2.sid),
E2 as (select distinct t.sid from (book b join buys t on (t.bookno=b.bookno and b.price<=40))),
E3 as (select sid from buys except select * from E2 ),
E4 as (select * from E1 intersect select * from E3),
E5 as (select * from student natural join E4)
select * from E5;

--Question 14
\qecho 'Question 14'
With 
E1 as (select m.sid from major m where m.major='CS'),
E2 as (select m.sid from major m where m.major='Math'),
E3 as (select * from E1 intersect select * from E2),
E4 as (select * from Buys Natural join E3),
E5 as (select distinct te1.bookno from (E4 te1 join E4 te2 on te1.sid!=te2.sid and te1.bookno=te2.bookno))
select * from E5;


--Question 15
\qecho 'Question 15'
WITH 
E1 as (select bookno from book where price>=70),
E2 as (select bookno from book where price <30),
E3 as (select distinct sid from buys natural join E1),
E4 as (select distinct sid from buys natural join E2),
E5 as (select * from E3 intersect select * from E4),
E6 as (select sid from student except select sid from buys),
E7 as (select * from E5 union select * from E6)
select * from E7 order by 1;

--Question 16
\qecho 'Question 16'

With 
E1 as (select distinct m1.sid as sid1 ,m2.sid as sid2 from (major m1 join major m2 on m1.sid!=m2.sid and m1.major=m2.major)),
E2 as (select distinct t1.sid as sid1,t2.sid as sid2 from (buys t1 join buys t2 on t1.sid!=t2.sid and t1.bookno!=t2.bookno)),
E3 as (select * from E1 as s1 intersect select * from E2 as s2)
select distinct sid1, sid2 from E3;


--Connecting to Default
\c postgres;

--Drop Database Created
drop database assignment5;

\q

