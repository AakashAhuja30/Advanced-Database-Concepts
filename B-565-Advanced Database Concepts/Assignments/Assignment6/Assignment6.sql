\qecho 'Creating Database Assignment6'
CREATE DATABASE assignment6;

\qecho 'Connecting to Database'
\connect assignment6;

\qecho 'Creating and inserting into tables'
DELETE FROM cites;DELETE FROM buys;DELETE FROM major;DELETE FROM book;DELETE FROM student;
create table cites(bookno int, citedbookno int);
create table book(bookno int, title text, price int);
create table student(sid int, sname text);
create table major(sid int, major text);
create table buys(sid int, bookno int);
-- Data for the student relation.
INSERT INTO student VALUES(1001,'Jean');INSERT INTO student VALUES(1002,'Maria');INSERT INTO student VALUES(1003,'Anna');INSERT INTO student VALUES(1004,'Chin');INSERT INTO student VALUES(1005,'John');INSERT INTO student VALUES(1006,'Ryan');INSERT INTO student VALUES(1007,'Catherine');INSERT INTO student VALUES(1008,'Emma');INSERT INTO student VALUES(1009,'Jan');INSERT INTO student VALUES(1010,'Linda');INSERT INTO student VALUES(1011,'Nick');INSERT INTO student VALUES(1012,'Eric');INSERT INTO student VALUES(1013,'Lisa');INSERT INTO student VALUES(1014,'Filip');INSERT INTO student VALUES(1015,'Dirk');INSERT INTO student VALUES(1016,'Mary');INSERT INTO student VALUES(1017,'Ellen');INSERT INTO student VALUES(1020,'Ahmed');
-- Data for the book relation.
INSERT INTO book VALUES(2001,'Databases',40);INSERT INTO book VALUES(2002,'OperatingSystems',25);INSERT INTO book VALUES(2003,'Networks',20);INSERT INTO book VALUES(2004,'AI',45);INSERT INTO book VALUES(2005,'DiscreteMathematics',20);INSERT INTO book VALUES(2006,'SQL',25);INSERT INTO book VALUES(2007,'ProgrammingLanguages',15);INSERT INTO book VALUES(2008,'DataScience',50);INSERT INTO book VALUES(2009,'Calculus',10);INSERT INTO book VALUES(2010,'Philosophy',25);INSERT INTO book VALUES(2012,'Geometry',80);INSERT INTO book VALUES(2013,'RealAnalysis',35);INSERT INTO book VALUES(2011,'Anthropology',50);INSERT INTO book VALUES(3000,'MachineLearning',40);

-- Data for the buys relation.
INSERT INTO buys VALUES(1001,2002);INSERT INTO buys VALUES(1001,2007);INSERT INTO buys VALUES(1001,2009);INSERT INTO buys VALUES(1001,2011);INSERT INTO buys VALUES(1001,2013);INSERT INTO buys VALUES(1002,2001);
INSERT INTO buys VALUES(1002,2002);INSERT INTO buys VALUES(1002,2007);INSERT INTO buys VALUES(1002,2011);INSERT INTO buys VALUES(1002,2012);INSERT INTO buys VALUES(1002,2013);INSERT INTO buys VALUES(1003,2002);INSERT INTO buys VALUES(1003,2007);INSERT INTO buys VALUES(1003,2011);INSERT INTO buys VALUES(1003,2012);INSERT INTO buys VALUES(1003,2013);INSERT INTO buys VALUES(1004,2006);INSERT INTO buys VALUES(1004,2007);INSERT INTO buys VALUES(1004,2008);INSERT INTO buys VALUES(1004,2011);INSERT INTO buys VALUES(1004,2012);INSERT INTO buys VALUES(1004,2013);INSERT INTO buys VALUES(1005,2007);INSERT INTO buys VALUES(1005,2011);INSERT INTO buys VALUES(1005,2012);INSERT INTO buys VALUES(1005,2013);INSERT INTO buys VALUES(1006,2006);INSERT INTO buys VALUES(1006,2007);INSERT INTO buys VALUES(1006,2008);INSERT INTO buys VALUES(1006,2011);INSERT INTO buys VALUES(1006,2012);INSERT INTO buys VALUES(1006,2013);INSERT INTO buys VALUES(1007,2001);INSERT INTO buys VALUES(1007,2002);INSERT INTO buys VALUES(1007,2003);INSERT INTO buys VALUES(1007,2007);INSERT INTO buys VALUES(1007,2008);INSERT INTO buys VALUES(1007,2009);INSERT INTO buys VALUES(1007,2010);INSERT INTO buys VALUES(1007,2011);INSERT INTO buys VALUES(1007,2012);INSERT INTO buys VALUES(1007,2013);INSERT INTO buys VALUES(1008,2007);INSERT INTO buys VALUES(1008,2011);INSERT INTO buys VALUES(1008,2012);INSERT INTO buys VALUES(1008,2013);INSERT INTO buys VALUES(1009,2001);INSERT INTO buys VALUES(1009,2002);INSERT INTO buys VALUES(1009,2011);INSERT INTO buys VALUES(1009,2012);INSERT INTO buys VALUES(1009,2013);INSERT INTO buys VALUES(1010,2001);INSERT INTO buys VALUES(1010,2002);INSERT INTO buys VALUES(1010,2003);INSERT INTO buys VALUES(1010,2011);INSERT INTO buys VALUES(1010,2012);INSERT INTO buys VALUES(1010,2013);INSERT INTO buys VALUES(1011,2002);INSERT INTO buys VALUES(1011,2011);INSERT INTO buys VALUES(1011,2012);INSERT INTO buys VALUES(1012,2011);INSERT INTO buys VALUES(1012,2012);INSERT INTO buys VALUES(1013,2001);INSERT INTO buys VALUES(1013,2011);INSERT INTO buys VALUES(1013,2012);
INSERT INTO buys VALUES(1014,2008);INSERT INTO buys VALUES(1014,2011);INSERT INTO buys VALUES(1014,2012);INSERT INTO buys VALUES(1017,2001);INSERT INTO buys VALUES(1017,2002);INSERT INTO buys VALUES(1017,2003);INSERT INTO buys VALUES(1017,2008);INSERT INTO buys VALUES(1017,2012);INSERT INTO buys VALUES(1020,2012);

-- Data for the cites relation.
INSERT INTO cites VALUES(2012,2001);INSERT INTO cites VALUES(2008,2011);INSERT INTO cites VALUES(2008,2012);INSERT INTO cites VALUES(2001,2002);INSERT INTO cites VALUES(2001,2007);INSERT INTO cites VALUES(2002,2003);INSERT INTO cites VALUES(2003,2001);INSERT INTO cites VALUES(2003,2004);INSERT INTO cites VALUES(2003,2002);INSERT INTO cites VALUES(2012,2005);

-- Data for the major relation.
INSERT INTO major VALUES(1001,'Math');INSERT INTO major VALUES(1001,'Physics');INSERT INTO major VALUES(1002,'CS');INSERT INTO major VALUES(1002,'Math');INSERT INTO major VALUES(1003,'Math');INSERT INTO major VALUES(1004,'CS');INSERT INTO major VALUES(1006,'CS');INSERT INTO major VALUES(1007,'CS');INSERT INTO major VALUES(1007,'Physics');INSERT INTO major VALUES(1008,'Physics');INSERT INTO major VALUES(1009,'Biology');INSERT INTO major VALUES(1010,'Biology');INSERT INTO major VALUES(1011,'CS');INSERT INTO major VALUES(1011,'Math');INSERT INTO major VALUES(1012,'CS');INSERT INTO major VALUES(1013,'CS');INSERT INTO major VALUES(1013,'Psychology');INSERT INTO major VALUES(1014,'Theater');INSERT INTO major VALUES(1017,'Anthropology');

\qecho 'Creating SetUnion Function'
--Set Union Function
create or replace function setunion(A anyarray, B anyarray) returns anyarray as
$$
select array( select unnest(A) union select unnest(B) order by 1);
$$ language sql;

--Question 12 a)
\qecho 'Question 12 a)'
\qecho 'Creating Set Intersection Function'
--Set Intersection Function
create or replace function setintersect(A anyarray, B anyarray) returns anyarray as
$$
select array( select unnest(A) intersect select unnest(B) order by 1);
$$ language sql;

--Question 12 b)
\qecho 'Question 12 b)'
\qecho 'Creating Set Difference Function'
--Set Difference Function
create or replace function setdifference(A anyarray, B anyarray) returns anyarray as
$$
select array( select unnest(A) except select unnest(B) order by 1);
$$ language sql;

--IsIn Function
\qecho 'Creating isIn Function'
create or replace function isIn(x anyelement, S anyarray)
returns boolean as
$$
select x = SOME(S);
$$ language sql;

--CREATING STUDENT_BOOKS Relation
create or replace view student_books as
select s.sid, array(select t.bookno
from buys t
where t.sid = s.sid order by bookno) as books
from student s order by sid;


--Question 13 a)
\qecho 'Question 13 a)'

create or replace view book_students as
select b.bookno as bookno, array(select bu.sid from buys bu where bu.bookno=b.bookno) as students
from book b order by 1;

select * from book_students;

--Question 13 b)
\qecho 'Question 13 b)'
create or replace view book_citedbooks as
select b.bookno as bookno, array(select c.citedbookno from cites c where c.bookno=b.bookno) as citedbooks
from book b order by 1;
select * from book_citedbooks;

--Question 13 c)
\qecho 'Question 13 c)'
create or replace view book_citingbooks as
select b.bookno as bookno, array(select c.bookno from cites c where c.citedbookno=b.bookno) as citingbooks
from book b order by 1;
select * from book_citingbooks;

--Question 13 d)
\qecho 'Question 13 d)'
create or replace view major_students as
select m.major, array_agg(m.sid) as students
from major m
group by m.major; 

select * from major_students;

--Question 13 e)
\qecho 'Question 13 e)'
create or replace view student_majors as
select s.sid as student, array(select m.major from major m where s.sid=m.sid) as major
from student s order by 1;

select * from student_majors;

--Question 14 a)
\qecho 'Question 14 a)'
With 
A as (select t1.bookno, unnest(t1.citedbooks) as citedbooks from  book_citedbooks t1 where cardinality(t1.citedbooks)>=3),
B as (select distinct A.bookno from book bo, A where bo.bookno=A.citedbooks and bo.price<50),
C as (select B.bookno, bo.title from book bo, B where bo.bookno=B.bookno )
select * from C;

--Question 14 b)
\qecho 'Question 14 b)'
With 
A as (select distinct student, major from student_majors sm where sm.major && '{CS}'),
B as (select distinct unnest(sb.books) as bookno from student_books sb, A where A.student=sb.sid),
C as (select b.bookno, b.title from book b where b.bookno not in(select bookno from B))
select * from C;

--Question 14 c)
\qecho 'Question 14 c)'
With 
A as (select array(select bookno from book where price >=50) as bookno),
B as (select  s.sid from student_books s, A where A.bookno <@ s.books )
select * from B;

--Question 14 d)
\qecho 'Question 14 d)'
With 
A as (select distinct student, major from student_majors sm where not '{CS}' <@ sm.major),
B as (select distinct unnest(sb.books) as books from A, student_books sb where A.student=sb.sid),
C as (select * from book bu, B where bu.bookno=B.books )
select bookno from C order by 1;


--Question 14 e)
\qecho 'Question 14 e)'
With 
A as (select array(select bookno from book where price >45) as bookno),
B as (select  s.sid from student_books s, A where A.bookno <@ s.books ) ,
C as (select distinct unnest(sb.books) as bookno from student_books sb where sb.sid not in(select sid from B) )
select * from C order by 1;


--Question 14 f)
\qecho 'Question 14 f)'
select distinct s.sid, b.bookno 
from   student_books s, book_citingbooks b 
where  not(s.books <@ b.citingbooks) 
order by 1,2;


--Question 14 g)
\qecho 'Question 14 g)'
select b1.bookno, b2.bookno 
from book_students b1, book_students b2  
where b1.students <@ b2.students 
and b2.students <@ b1.students; 


--Question 14 h)
\qecho 'Question 14 h)'
select b1.bookno, b2.bookno from book_students b1, book_students b2
where cardinality(b1.students)=cardinality(b2.students) 
order by 1,2;

--Question 14 i)
\qecho 'Question 14 i)'
With 
A as (select cardinality(array(select b.bookno from book b))-4 as allbut4 ),
B as (select sb.sid from student_books sb, A where cardinality(sb.books)=A.allbut4)
select * from B;

--Question 14 j)
\qecho 'Question 14 j)'
With
A as (select unnest(m.students) as students from major_students m where m.major='Psychology' ),
B as (select cardinality(sb.books) from student_books sb, A where sb.sid=A.students ),
C as (select sb1.sid from student_books sb1,B where cardinality(sb1.books)<= B.cardinality)
select * from C;


--Question 3
\qecho 'Question 3'
select s.sid, s.sname
from student s
where s.sid in (select m.sid from major m where m.major = 'CS') and
exists (select 1
from cites c, book b1, book b2
where (s.sid,c.bookno) in (select t.sid, t.bookno from buys t) and
c.bookno = b1.bookno and c.citedbookno = b2.bookno and
b1.price < b2.price);

--SQL Translation
\qecho 'SQL Translation'
select distinct s.sid, s.sname
from student s join major m on (s.sid=m.sid and m.major='CS')  cross join (cites c join book b1 on c.bookno=b1.bookno join book b2 on (c.citedbookno=b2.bookno and b1.price<b2.price)) join buys t on s.sid=t.sid
where c.bookno=t.bookno;

With
X as (select distinct s.sid, s.sname, t.bookno from student s join major m on (s.sid=m.sid and m.major='CS') join buys t on t.sid=s.sid),
books as (select bookno, price from book),
Y as (select distinct c.bookno from cites c join books b1 on c.bookno=b1.bookno join books b2 on c.citedbookno=b2.bookno and b1.price<b2.price ),
Z as (select distinct sid, sname from X join Y on X.bookno=Y.bookno)
select * from Z;


--Query Optimization
\qecho 'Query Optimization'
With
CS as (select sid from major where major='CS'),
books as (select bookno, price from book),
X as (select distinct sid, sname, bookno from student natural join CS natural join buys),
Y as (select distinct cites.bookno from cites join books b1 on cites.bookno=b1.bookno join books b2 on cites.citedbookno=b2.bookno and b1.price<b2.price ),
Z as (select distinct sid, sname from X natural join Y)
select * from Z;



--Question 4
\qecho 'Question 4'
select distinct s.sid, s.sname, m.major
from student s, major m
where s.sid = m.sid and s.sid not in (select m.sid from major m where m.major = 'CS') and
s.sid <> ALL (select t.sid
from buys t, book b
where t.bookno = b.bookno and b.price < 30) and
s.sid in (select t.sid
from buys t, book b
where t.bookno = b.bookno and b.price < 60);


--SQL Translation
\qecho 'SQL Translation'
With 
V as (select distinct s.sid, s.sname from student s 
      except 
      select distinct s.sid , s.sname
      from student s join major m on s.sid=m.sid 
      where m.major = 'CS'),
W as (select distinct s.sid, s.sname
      from student s join buys t on s.sid=t.sid join book b on t.bookno=b.bookno
      where b.price<30),
X as (select sid, sname from V except select sid, sname from W) , 
Y as (select distinct X.sid, X.sname, m.major from X join major m on X.sid=m.sid join buys t on t.sid=X.sid join book b on t.bookno=b.bookno where b.price<60)
select * from Y;


--Query Optimization
\qecho 'Query Optimization'
with 
books as (select bookno, price from book),
CS as (select sid from major where major='CS'),
V as (select distinct s.sid, s.sname from student s except select distinct s.sid,s.sname from student s natural join CS),
W as (select distinct s.sid, s.sname from student s natural join buys t natural join books b where b.price<30),
X as (select * from V except select * from W),
Y as (select distinct X.sid, X.sname, m.major from X natural join major m natural join buys t natural join books b where b.price<60)
select * from Y;



--Question 5
\qecho 'Question 5'
select distinct s.sid, s.sname, b.bookno
from student s, buys t, book b
where s.sid = t.sid and t.bookno = b.bookno and
b.price >= ALL (select b.price
from book b
where (s.sid,b.bookno) in (select t.sid, t.bookno from buys t));

--SQL Translation
\qecho 'SQL Translation'
With 
X as (select distinct s.sid, s.sname, b.bookno
      from student s join buys t on s.sid=t.sid join book b on t.bookno=b.bookno),
Y as (select distinct s.sid, s.sname, b.bookno
      from (student s join buys t on t.sid=s.sid join book b on t.bookno=b.bookno) join (buys t1 join book b1 on t1.bookno=b1.bookno)        
      on (t1.sid = t.sid and b.price < b1.price)),      
Z as (select * from X except select * from Y)
select * from Z
order by 1,2;      


--Query Optimization
\qecho 'Query Optimization'
with 
books as (select bookno, price from book),
X as (select s.sid, s.sname, b.bookno     
      from student s natural join  buys t natural join books b),
Y as (select s.sid, s.sname, b1.bookno        
      from (student s natural join buys t natural join books b1) join (buys t1 natural join books b2) 
      on(t.sid = t1.sid and b1.price < b2.price)),
Z as (select * from X except select * from Y)
select sid , sname , bookno from Z
order by 1,2;

select distinct q.sid, q.sname, q.bookno
from   (select s.sid, s.sname, b.bookno     
        from student s natural join  buys t natural join books b        
        except        
        select s.sid, s.sname, b1.bookno        
        from (student s natural join buys t natural join books b1) join (buys t1 natural join books b2) 
              on(t.sid = t1.sid and b1.price < b2.price)) q
        order by 1,2;

--Question 6
\qecho 'Question 6'
select b.bookno, b.title
from book b
where exists (select s.sid
from student s where s.sid in (select m.sid from major m where m.major = 'CS'
UNION
select m.sid from major m where m.major = 'Math') 
and s.sid not in (select t.sid from buys t where t.bookno = b.bookno));

--SQL Translation
\qecho 'SQL Translation'
With
V as (select s.sid,b.bookno from student s cross join book b),
W as (select m.sid from major m where m.major = 'CS' union select m.sid from major m where m.major = 'Math') ,
X as (select V.sid, V.bookno from V join W on V.sid=W.sid),
Y as (select * from X except select * from buys),
Z as (select distinct b.bookno, b.title from book b join Y on b.bookno=Y.bookno)
select * from Z;


--Query Optimization
\qecho 'Query Optimization'
With
Books as (select bookno, title from book),
V as (select s.sid,b.bookno from student s cross join Books b),
W as (select m.sid from major m where m.major = 'CS' union select m.sid from major m where m.major = 'Math') ,
X as (select * from V natural join W),
Y as (select * from X except select * from buys),
Z as (select distinct bookno, title from Books natural join Y)
select * from Z;

--Part 3:
\qecho 'Part 3:'
--Creating Function R
\qecho 'Creating Function R'
create or replace function makerandomR(m integer, n integer, l integer)
returns void as
$$
declare i integer; j integer;
begin
drop table if exists Ra; drop table if exists Rb;
drop table if exists R;
create table Ra(a int); create table Rb(b int);
create table R(a int, b int);
for i in 1..m loop insert into Ra values(i); end loop;
for j in 1..n loop insert into Rb values(j); end loop;
insert into R select * from Ra a, Rb b order by random() limit(l);
end;
$$ LANGUAGE plpgsql;

--Create function S
\qecho 'Creating Function S'
create or replace function makerandomS(n integer, l integer)
returns void as
$$
declare i integer;
begin
drop table if exists Sb;
drop table if exists S;
create table Sb(b int);
create table S(b int);
for i in 1..n loop insert into Sb values(i); end loop;
insert into S select * from Sb order by random() limit (l);
end;
$$ LANGUAGE plpgsql;



--Question 7:
\qecho 'Question 7:'
select makerandomR(1000,1000,100);
select makerandomR(1000,1000,1000);
select makerandomR(1000,1000,10000);

select makerandomS(1000,100);
select makerandomS(1000,1000);
select makerandomS(1000,10000);

--Main Query
\qecho 'Main Query'
explain analyze(
select distinct r1.a
from R r1, R r2, R r3
where r1.b = r2.a and r2.b = r3.a
);

--Query Optimization
explain analyze(
select distinct r1.a
from R r1 natural join (select distinct r2.a as b from R r2 natural join (select distinct r3.a as b from R r3) r3) r2
);


--Question 8:
\qecho 'Question 8'
--Main Query
explain analyze
(
select ra.a
from Ra ra
where not exists (select r.b
from R r
where r.a = ra.a and
r.b not in (select s.b from S s))
);

--Query Optimization
explain analyze(
select ra.a
from Ra ra
except
select distinct q.a 
from(select * from r except select r.* from r natural join s) q
);


--Question 9:
\qecho 'Question 9'
explain analyze(
select ra.a
from Ra ra
where not exists (select s.b
from S s
where s.b not in (select r.b
from R r
where r.a = ra.a))
);

explain analyze(
SELECT x.a
FROM (SELECT ra.a
      from Ra ra
      EXCEPT
      SELECT y.a
      FROM (SELECT ra.a FROM Ra ra, S s
            EXCEPT
            SELECT ra.a
            FROM Ra ra NATURAL JOIN R r NATURAL JOIN S s)y
      )x
);

--Question 10:
\qecho 'Question 10'
explain analyze(
with NestedR as (select r.a, array_agg(r.b order by 1) as Bs
from R r
group by (r.a)),
SetS as (select array(select s.b from S s order by 1) as Bs)
select r.a
from NestedR r, SetS s
where r.Bs <@ s.Bs
union
select ra.a
from Ra ra
except
select r.a
from R r
);

--Question 11:
\qecho 'Question 11'
explain analyze(
with NestedR as (select r.a, array_agg(r.b order by 1) as Bs
from R r
group by (r.a)),
SetS as (select array(select s.b from S s order by 1) as Bs)
select r.a
from NestedR r, SetS s
where s.Bs <@ r.Bs);

--Connecting to Default
\c postgres;

--Drop Database Created
drop database assignment6;

\q

