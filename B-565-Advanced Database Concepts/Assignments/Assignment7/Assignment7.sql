\qecho 'Creating Database Assignment7'
CREATE DATABASE assignment7;

\qecho 'Connecting to Database'
\connect assignment7;

\qecho 'Question 1'

\qecho 'a)- Projection '
-- a)
create  table R(A integer, B integer, C integer);
insert into R values(1,2,3),(1,2,4),(2,3,4),(2,3,5),(3,4,5),(3,4,6);
select * from r;

create table encodingofR (key text, value jsonb);

insert into encodingofR select 'R' as Key, json_build_object('a', r.a, 'b', r.b)::jsonb as Value
                        from   R r;

-- Mapper function
CREATE OR REPLACE FUNCTION Mapper(KeyIn text, ValueIn jsonb)
RETURNS TABLE(KeyOut jsonb, ValueOut jsonb) AS
$$
    SELECT ValueIn::jsonb, json_build_object('RelName', KeyIn::text)::jsonb;
$$ LANGUAGE SQL;

-- Reducer function
CREATE OR REPLACE FUNCTION Reducer(KeyIn jsonb, ValuesIn jsonb[])
RETURNS TABLE(KeyOut text, ValueOut jsonb) AS
$$
    SELECT 'R'::text, KeyIn 
    WHERE array['{"RelName": "R"}']::jsonb[] <@ ValuesIn::jsonb[];
$$ LANGUAGE SQL;

-- Simulation Phase

WITH
Map_Phase AS (SELECT m.KeyOut, m.ValueOut
              FROM   encodingOfR, LATERAL(SELECT KeyOut, ValueOut FROM Mapper(key, value)) m),
Group_Phase AS (SELECT KeyOut, array_agg(Valueout) as ValueOut
                FROM   Map_Phase
                GROUP  BY (KeyOut)),
Reduce_Phase AS (SELECT r.KeyOut, r.ValueOut
                 FROM   Group_Phase gp, LATERAL(SELECT KeyOut, ValueOut FROM Reducer(gp.KeyOut, gp.ValueOut)) r)
SELECT valueOut->'a' as A, valueOut->'b' as B 
FROM Reduce_Phase 
order by 1;

-------

\qecho 'b)- Set Difference '
-- b)
drop table R;
create  table R(A integer);
create table S(A integer);
insert into R values(1),(2),(3),(4),(5);
insert into S values(3),(4),(5),(6),(7);

create table EndodingOfRAndS(key text, value jsonb);

insert into EndodingOfRAndS
select 'R' as Key, json_build_object('a', A)::jsonb as Value
from   R
union
select 'S' as Key, json_build_object('a', A)::jsonb as Value
from   S order by 1;

-- Mapper function
CREATE OR REPLACE FUNCTION Mapper(KeyIn text, ValueIn jsonb)
RETURNS TABLE(KeyOut jsonb, ValueOut jsonb) AS
$$
SELECT ValueIn::jsonb, json_build_object('RelName', KeyIn::text)::jsonb;
$$ LANGUAGE SQL;

-- Reduce function
CREATE OR REPLACE FUNCTION Reducer(KeyIn jsonb, ValuesIn jsonb[])
RETURNS TABLE(KeyOut text, ValueOut jsonb) AS
$$
SELECT 'R - S'::text, KeyIn 
WHERE array['{"RelName": "R"}']::jsonb[] <@ ValuesIn::jsonb[]
EXCEPT
SELECT 'R - S'::text, KeyIn 
WHERE array['{"RelName": "S"}']::jsonb[] <@ ValuesIn::jsonb[]
$$ LANGUAGE SQL;

--Simulation
WITH
Map_Phase AS (SELECT m.KeyOut, m.ValueOut
              FROM EndodingOfRAndS,LATERAL(select KeyOut, ValueOut from Mapper(key, value)) m),
Group_Phase AS (SELECT KeyOut, array_agg(Valueout) as ValueOut
                FROM   Map_Phase
                GROUP  BY (KeyOut)),
Reduce_Phase AS (SELECT r.KeyOut, r.ValueOut
                  FROM Group_Phase gp, LATERAL(SELECT KeyOut, ValueOut FROM Reducer(gp.KeyOut, gp.ValueOut))r)
SELECT valueOut->'a' as A 
FROM Reduce_Phase 
order by 1;

--------------


\qecho 'c)- Semi Join Simulation'
--c)
drop table r;
drop table s;

create table R(A integer, B integer);
create table S(B integer, C integer);

insert into R values (1,2),(3,4),(5,6),(7,8);
insert into S values (2,10),(4,12),(5,6),(7,8);

With 
mapper_phase as (select b, array[text('r'), text(a)] as one from r union select b, array[text('s'), text(c)] from s),
group_phase as (select m1.one as a, m1.b
           from mapper_phase m1,mapper_phase m2 
		   where m1.b=m2.b and m1.one != m2.one),
reducer as (select cast(g.a[2] as integer) as a, b from group_phase g where array['r']<@ a )		   
select * from reducer order by a;


\qecho 'd)- Query Simulation'
--d)
------------
drop table r;
drop table s;

create table R(A integer);
create table S(A integer);
create table T(A integer);

insert into R values(1),(2),(3),(4),(5),(6),(7),(8);
insert into S values(7),(8),(12),(13);
insert into T values (5),(10),(13),(15);

create table EncodingOfRandSandT(key text, value jsonb);

insert into EncodingOfRandSandT
select 'R' as Key, json_build_object('a', a)::jsonb as Value
from   R
union
select 'S' as Key, json_build_object('a', a)::jsonb as Value
from   S
union
select 'T' as Key, json_build_object('a', a)::jsonb as Value
from T order by 1;

-- Mapper function
CREATE OR REPLACE FUNCTION Mapper(KeyIn text, ValueIn jsonb)
RETURNS TABLE(KeyOut jsonb, ValueOut jsonb) AS
$$
SELECT ValueIn::jsonb, json_build_object('RelName', KeyIn::text)::jsonb;
$$LANGUAGE SQL;

-- Reducer function
CREATE OR REPLACE FUNCTION Reducer(KeyIn jsonb, ValuesIn jsonb[])
RETURNS TABLE(KeyOut text, ValueOut jsonb) AS
$$
SELECT 'R - (S U T)'::text, KeyIn 
WHERE array['{"RelName": "R"}']::jsonb[] <@ ValuesIn::jsonb[]
EXCEPT
(SELECT 'R - (S U T)'::text, KeyIn 
WHERE array['{"RelName": "S"}']::jsonb[] <@ ValuesIn::jsonb[] or array['{"RelName": "T"}']::jsonb[] <@ ValuesIn::jsonb[])
$$ LANGUAGE SQL;

--Simulation
With
mapper_phase as (select a, 'r' as one from r union select a, 's' as one from s union select a, 't' as one from t),
group_phase as (select m.a, array_agg(m.one) as one from mapper_phase m group by m.a),
reducer as (select g.a from group_phase g where array['r']<@g.one and g.one<@array['r'])
select * from reducer order by a;
-------------


\qecho 'Question 2'
--Question 2
drop table R;
drop table S;
drop table T;

create table R(A integer, B int);

insert into R values(1,2),(1,6),(1,8),(2,12),(2,16),(3,22),(3,8),(1,16);
select * from R;

WITH
-- mapper phase:   
mapper_phase AS (select r.a, array[1,r.b] as b from R r),
-- group (shuffle) phase: 
group_phase as (select m.a, array_agg(m.b[2]) as b from mapper_phase m group by m.a),
-- reducer (phase):    
reducer AS (select g.a, g.b, cardinality(g.b) from group_phase g where cardinality(g.b)>=2)
--Output
select * from reducer;


\qecho 'Question 3-a'
--Question 3-a)

drop table R;
drop table S;

create table R(k text, v int);
create table S(k text, w int);

insert into R values ('a', 1),                     
                     ('a', 2),
                     ('b', 1),
                     ('c', 3);


insert into S values ('a', 1),                     
                     ('a', 3),                     
                     ('c', 2),                     
                     ('d', 1),                     
                     ('d', 4);

CREATE TYPE VW AS (RV_values INT[], SW_values INT[]);

CREATE OR REPLACE VIEW coGroup AS
WITH Kvalues AS (SELECT r.K FROM R r UNION SELECT s.K FROM S s),
R_K AS (SELECT k.K, ARRAY(SELECT r.V FROM R r WHERE r.K = k.K) AS RV_values FROM Kvalues k),
S_K AS (SELECT k.K, ARRAY(SELECT s.W FROM S s WHERE s.K = k.K) AS SW_values FROM Kvalues k)
SELECT K, (RV_values, SW_values)::VW as vw FROM R_K NATURAL JOIN S_K;

select * from coGroup;

--Question 3-b)
\qecho 'Question 3-b'
select c.k,c.vw AS a from coGroup c
where (c.vw::VW).SW_values && (c.vw::VW).RV_values or (c.vw::VW).SW_values <@ (c.vw::VW).RV_values;

--Question 3-c)
\qecho 'Question 3-c'
select distinct c1.k as R_k, c2.k as S_K
from  coGroup c1,coGroup c2
where (c1.vw::VW).RV_values <@ (c2.vw::VW).SW_values 
and c1.k <> c2.k 
and not (c1.vw::VW).RV_values <@ '{}' ;

--Question 4a)
\qecho 'Question 4a'
create table A(value integer); 
create table B(value integer);

insert into A values (1),(2),(10),(11),(12),(16);
insert into B values (2),(10),(5);

WITH
F AS (SELECT ARRAY_AGG(a.value) AS r 
      FROM A a 
      GROUP BY (a.value)),
G AS (SELECT ARRAY_AGG(b.value) AS s 
      FROM B b 
      GROUP BY (b.value))		
select distinct a from F as f, G as g, unnest(r) a, unnest(s) b where a = b;

--Question 5:
\qecho 'Question 5'
--Creating Table course
create table course(cno text, cname text, dept text);
insert into course values('c200','PL','CS'),('c201','Calculus','Math'),('c202','Dbs','CS'),('c301','AI','CS'),('c302','Logic','Philosophy')

--Creating Table Student
create table student(sid text,sname text,major text, byear int)
insert into student values('s100','Eric','CS',1987),
                          ('s101','Nick','Math',1990),
                          ('s102','Chris','Biology',1976),
                          ('s103','Dinska','CS',1977),
                          ('s104','Zanna','Math',2000) 
                          
--Creatung table enroll                          
create table enroll(sid text, cno text, grade text);
insert into enroll values('s100','c200', 'A'),     
                         ('s100','c201', 'B'),     
                         ('s100','c202', 'A'),     
                         ('s101','c200', 'B'),     
                         ('s101','c201', 'A'),     
                         ('s102','c200', 'B'),     
                         ('s103','c201', 'A'),     
                         ('s101','c202', 'A'),     
                         ('s101','c301', 'C'),     
                         ('s101','c302', 'A'),     
                         ('s102','c202', 'A'),     
                         ('s102','c301', 'B'),     
                         ('s102','c302', 'A'),     
                         ('s104','c201', 'D');
                                                   

--(a)
\qecho '(a)'
CREATE TYPE studentType AS(sid text);
CREATE TYPE gradeStudentsType AS (grade text, student studentType[]);
CREATE TABLE courseGrades(cno text, gradeInfo gradeStudentsType[]);  

insert into courseGrades
with 
e as (select cno, grade, array_agg(row(sid)::studentType) as students           
      from enroll           
      group by (cno, grade)),     
f as (select cno, array_agg(row(grade, students)::gradeStudentsType) as gradeInfo           
      from e           
      group by (cno))
select * from f order by cno;

select * from coursegrades;


--(b)
\qecho '(b)'
CREATE TYPE courseType as(cno text);
CREATE TYPE gradeCoursesType AS (grade text, courses courseType[]);
CREATE TABLE studentGrades(sid text, gradeInfo gradeCoursesType[]);  

insert into studentGrades
With 
e as (select s.sid, g.grade, array_agg(row(sg.cno)::courseType) as courses   
      from coursegrades sg, unnest(sg.gradeinfo)g, unnest(g.student)s
      group by (s.sid,g.grade)),
f as (select sid, array_agg(row(grade, courses)::gradeCoursesType) as gradeInfo           
      from e           
      group by (sid))
select * from f order by sid;


--(c)
\qecho '(c)'
create table jcoursegrades(courseinfo jsonb);
insert into jcoursegrades
With 
E as (select e.cno, e.grade, array_to_json(array_agg(json_build_object('sid',sid))) as students
      from enroll e
      group by (e.cno,e.grade)),   
F as (select json_build_object('cno',cno,'gradeinfo',array_to_json(array_agg(json_build_object('grade',grade,'students',students)))) as courseInfo
      from E
      group by (cno))         
select * from F;

select * from jcoursegrades;


--(d)
\qecho '(d)'
--Creating Table jStudentGrades
create table jStudentgrades(studentinfo jsonb);
insert into jStudentgrades
With
E as (select s->'sid' as sid, g->'grade' as grade, array_to_json(array_agg(json_build_object('cno',cg.courseinfo->'cno'))) as courses
      from jcoursegrades cg, jsonb_array_elements(cg.courseinfo->'gradeinfo')g, jsonb_array_elements(g->'students')s
      group by (sid, grade)),
F as (select json_build_object('sid',sid,'gradeinfo',array_to_json(array_agg(json_build_object('grade',grade,'courses',courses)))) as studentinfo
      from E
      group by (sid))
select * from F;

select * from jStudentgrades;


--(e)
\qecho '(e)'
With
E as(select s.sid, s.sname, c.dept, array_to_json(array_agg(json_build_object('cno',cno))) as courses
      from student s natural join enroll e natural join course c 
      where s.major='CS'
      group by (s.sid, s.sname, c.dept)),
F as(select json_build_object('sid',sid,'sname',sname,'courseinfo',array_to_json(array_agg(json_build_object('dept',dept,'courses',courses)))) as courseInfo
     from E
     group by (sid, sname))         
select * from F;

--Connect to default database
\c postgres;

--Drop database which you created
drop database assignment7;




------------------------------------------------------------
