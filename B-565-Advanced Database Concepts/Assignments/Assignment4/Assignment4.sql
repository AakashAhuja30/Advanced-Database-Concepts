CREATE DATABASE assignment4;

\c assignment4;

--Creating Table Student
\qecho 'Creating Table Student'
Create table Student(
sid int,
sname text,
major text,
primary key (sid)
); 

--Creating Table Course
\qecho 'Creating Table Course'
Create table Course(
cno int,
cname text,
total int,
max int,
primary key (cno)
); 

--Creating Table Prerequisite
\qecho 'Creating Table Prerequisite'
Create table Prerequisite(
cno int,
prereq int,
foreign key(cno) references Course(cno)
); 

--Creating Table HasTaken
\qecho 'Creating Table HasTaken'
Create table HasTaken(
sid int,
cno int,
foreign key(sid) references Student(sid),
foreign key(cno) references Course(cno)
);

--Creating Table Enroll
\qecho 'Creating Table Enroll'
Create table Enroll(
sid int,
cno int,
foreign key(sid) references Student(sid),
foreign key(cno) references Course(cno)
);

--Creating Table Waitlist
\qecho 'Creating Table Waitlist'
Create table Waitlist(
sid int,
cno int,
positionn int,
foreign key(sid) references Student(sid),
foreign key(cno) references Course(cno)
);

\qecho 'Inserting values into tables'

INSERT INTO Course values(100,'EAI',0,9);
INSERT INTO Course values(101,'Stats',0,5);
INSERT INTO Course values(102,'ML',0,6);
INSERT INTO Course values(103,'AML',0,7);
INSERT INTO Course values(104,'ADC',0,5);
INSERT INTO Course values(105,'EDA',0,5);
INSERT INTO Course values(106,'Neural',0,8);
INSERT INTO Course values(107,'DataScience',0,9);
INSERT INTO Course values(108,'Networks',0,2);
INSERT INTO Course values(109,'Time Series',0,2);
INSERT INTO Course values(110,'AR',0,1);
INSERT INTO Course values(111,'VR',0,2);

INSERT INTO Prerequisite values(105,101);
INSERT INTO Prerequisite values(102,100);
INSERT INTO Prerequisite values(108,106);
INSERT INTO Prerequisite values(109,101);

INSERT INTO Student values(1,'Aakash','DS');
INSERT INTO Student values(2,'Rohan','CS');
INSERT INTO Student values(3,'John','DS');
INSERT INTO Student values(4,'Jim','CS');
INSERT INTO Student values(5,'jake','Engineering');
INSERT INTO Student values(6,'Boris','Informatics');
INSERT INTO Student values(7,'Lisa','Biology');

INSERT INTO Hastaken values(1,101);
INSERT INTO Hastaken values(1,100);
INSERT INTO Hastaken values(1,102);
INSERT INTO Hastaken values(2,107);
INSERT INTO Hastaken values(2,100);
INSERT INTO Hastaken values(3,101);


--Question 1a)
--Enforcing Primary key Constraint on Student Relation
\qecho 'Enforcing Primary key Constraint on Student Relation'
--Creating Trigger function 
\qecho 'Creating Trigger function'
CREATE OR REPLACE FUNCTION check_Student_key_constraint() 
RETURNS trigger AS
$$ 
BEGIN 
    IF NEW.sid IN (SELECT sid FROM Student) THEN    
      RAISE EXCEPTION 'sid already exist'; 
    END IF; 
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

--Creating Trigger definition 
\qecho 'Creating Trigger definition '
CREATE TRIGGER check_key_student
BEFORE INSERT ON student
FOR EACH ROW
EXECUTE PROCEDURE check_Student_key_constraint();

\qecho 'Checking to see if triggers work to enforce primary key constraints on student relation'
--Checking to see if triggers work to enforce primary key constraints on student relation
\qecho 'This will be rejected due to primary key constraints on student sid'
--This will be rejected due to primary key constraints on student sid
insert into student values(1,'Ricky','CS');


--Enforcing Primary key Constraint on Course Relation
\qecho 'Enforcing Primary key Constraint on Course Relation'
--Creating Trigger function 
\qecho 'Creating Trigger function '
CREATE OR REPLACE FUNCTION check_course_key_constraint() 
RETURNS trigger AS
$$ BEGIN 
    IF NEW.cno IN (SELECT cno FROM course) THEN    
      RAISE EXCEPTION 'course already exists'; 
    END IF; 
    RETURN NEW;
   END;
$$ LANGUAGE 'plpgsql';

--Creating Trigger definition 
\qecho 'Creating Trigger definition '
CREATE TRIGGER check_key_course
BEFORE INSERT ON course
FOR EACH ROW
EXECUTE PROCEDURE check_course_key_constraint();


--Checking to see if triggers work to enforce primary key constraints on course relation
--This will be rejected due to primary key constraints on course cno
INSERT INTO course VALUES (100,'EDA',45,50);


--Question 1 b)
--Enforcing constraints for enroll table
\qecho 'Enforcing constraints for enroll table'
CREATE OR REPLACE FUNCTION check_foreign_key_constraints() 
RETURNS trigger AS
$$ 
BEGIN 
    IF NEW.cno NOT IN (SELECT cno FROM course) THEN    
      RAISE EXCEPTION 'course not available in the list of courses '; 
    ELSIF NEW.sid NOT IN (SELECT sid FROM student) THEN    
      RAISE EXCEPTION 'student not present in the list of students at university'; 
    END IF;
    Return New;
END;
$$ LANGUAGE 'plpgsql';

--Creating Trigger definition 
\qecho 'Creating Trigger definition '
CREATE TRIGGER check_key_enroll
BEFORE INSERT ON enroll
FOR EACH ROW
EXECUTE PROCEDURE check_foreign_key_constraints();

--Checking to see if triggers work to enforce foreign key constraints on enroll relation
\qecho 'Checking to see if triggers work to enforce foreign key constraints on enroll relation'
insert into enroll values(4,100);

--This will be rejected due to foreign key constraints on enroll sid
\qecho 'This will be rejected due to foreign key constraints on enroll sid'
insert into enroll values(56,100);

--This will be rejected due to foreign key constraints on enroll cno
\qecho 'This will be rejected due to foreign key constraints on enroll cno'
insert into enroll values(01,1001);


--Enforcing constraints for hastaken table
\qecho 'Enforcing constraints for hastaken table'
--Creating Trigger definition 
CREATE TRIGGER check_key_hastaken
BEFORE INSERT ON hastaken
FOR EACH ROW
EXECUTE PROCEDURE check_foreign_key_constraints();

--Checking to see if triggers work to enforce foreign key constraints on hastaken relation
\qecho 'Checking to see if triggers work to enforce foreign key constraints on hastaken relation'

--This will be rejected due to foreign key constraints on hastaken sid
\qecho 'This will be rejected due to foreign key constraints on hastaken sid'
insert into hastaken values(56,101);

--This will be rejected due to foreign key constraints on hastaken cno
\qecho 'This will be rejected due to foreign key constraints on hastaken cno'
insert into hastaken values(01,1001);

--Enforcing constraints for Waitlist table
\qecho 'Enforcing constraints for Waitlist table'
CREATE TRIGGER check_key_Waitlist
BEFORE INSERT ON waitlist
FOR EACH ROW
EXECUTE PROCEDURE check_foreign_key_constraints();

--Checking to see if triggers work to enforce foreign key constraints on waitlist relation
\qecho 'Checking to see if triggers work to enforce foreign key constraints on waitlist relation'
--This will be rejected due to foreign key constraints on waitlist sid
\qecho 'This will be rejected due to foreign key constraints on waitlist sid'
insert into waitlist values(56,104,2);

--This will be rejected due to foreign key constraints on waitlist cno
\qecho 'This will be rejected due to foreign key constraints on waitlist cno'
insert into waitlist values(1,1001,2);


--Enforcing constraints for Prerequisite table
\qecho 'Enforcing constraints for Prerequisite table'
CREATE OR REPLACE FUNCTION check_Prerequisite_key_constraint() 
RETURNS trigger AS
$$ 
BEGIN 
    IF NEW.cno NOT IN (SELECT cno FROM course) THEN    
      RAISE EXCEPTION 'course not available in the list of courses '; 
    ELSIF NEW.prereq NOT IN (SELECT cno FROM course) THEN    
      RAISE EXCEPTION 'Prerequisite not available in the list of courses '; 
    END IF;
    Return New;
END;
$$ LANGUAGE 'plpgsql';

--Creating Trigger definition 
CREATE TRIGGER check_key_prerequisite
BEFORE INSERT ON prerequisite
FOR EACH ROW
EXECUTE PROCEDURE check_Prerequisite_key_constraint();

--Checking to see if triggers work to enforce foreign key constraints on prerequisite relation
\qecho 'Checking to see if triggers work to enforce foreign key constraints on prerequisite relation'
--This will be rejected due to foreign key constraints on prerequisite cno
\qecho 'This will be rejected due to foreign key constraints on prerequisite cno'
INSERT INTO prerequisite VALUES (105,1000);

--This will be rejected due to foreign key constraints on prerequisite prereq
\qecho 'This will be rejected due to foreign key constraints on prerequisite prereq'
INSERT INTO prerequisite VALUES (1000,105);

--Enforcing Foreign key Constraint on Student Relation: Cascading
\qecho 'Enforcing Foreign key Constraint on Student Relation: Cascading'
--Creating Trigger function 

CREATE OR REPLACE FUNCTION delete_from_student_related_relations() 
   RETURNS TRIGGER AS
  $$
    BEGIN
    DELETE FROM hastaken WHERE sid = OLD.sid;
    DELETE FROM Enroll WHERE sid = OLD.sid;
    DELETE FROM Waitlist WHERE sid = OLD.sid;
    RETURN OLD;
    END;
  $$ LANGUAGE 'plpgsql';

CREATE TRIGGER delete_from_Student_Relation
BEFORE DELETE ON Student
FOR EACH ROW
EXECUTE PROCEDURE delete_from_student_related_relations();

--Checking to see if triggers work to enforce foreign key constraints on student relation
\qecho 'Checking to see if triggers work to enforce foreign key constraints on student relation'
insert into student values(8, 'RohanTemp', 'Math');
INSERT INTO Enroll VALUES (8,110);
INSERT INTO HasTaken VALUES (8,100);
INSERT INTO Waitlist VALUES (8,104,2);

--Producing cascading effect when we delete from student relation on enroll and waitlist relation. It won't delete from hastaken relation
\qecho ''
DELETE FROM student WHERE sid = 8;


--Enforcing Foreign key Constraint on Course Relation
--Creating Trigger function 

CREATE OR REPLACE FUNCTION delete_from_course_related_relations() 
   RETURNS TRIGGER AS
  $$
    BEGIN
    DELETE FROM Prerequisite WHERE cno = OLD.cno;
    DELETE FROM HasTaken WHERE cno = OLD.cno;
    DELETE FROM Enroll WHERE cno = OLD.cno;
    DELETE FROM Waitlist WHERE cno = OLD.cno;
    RETURN OLD;
    END;
  $$ LANGUAGE 'plpgsql';


CREATE TRIGGER delete_from_course_Relation
BEFORE DELETE ON course
FOR EACH ROW
EXECUTE PROCEDURE delete_from_course_related_relations();

--Checking to see if triggers work to enforce foreign key constraints on course relation
INSERT INTO Prerequisite VALUES (110,109);
INSERT INTO Enroll VALUES (7,110);
INSERT INTO HasTaken VALUES (6,110);
INSERT INTO Waitlist VALUES (4,110,1);

--Producing cascading effect when we delete from course relation on hastaken, enroll, prerequisite and waitlist relation
DELETE FROM course WHERE cno = 110;


--Question 1 c)

CREATE OR REPLACE FUNCTION check_delete_fromtable_constraint() 
RETURNS TRIGGER AS
$$
BEGIN
   RAISE EXCEPTION 'Cannot Delete from this table';  
END;
$$ LANGUAGE 'plpgsql';

--Ensuring that no deletes are permitted on hastaken
CREATE TRIGGER check_delete_hastaken
BEFORE DELETE ON hastaken
FOR EACH ROW
EXECUTE PROCEDURE check_delete_fromtable_constraint();

--This will be rejected as we have written a trigger that forbids deletes from hastaken table
delete from hastaken where sid=1 and cno=101;


--Writing a trigger to forbid delete in hastaken while there are students enrolled
CREATE OR REPLACE FUNCTION check_insert_table_constraint() 
RETURNS TRIGGER AS
$$
BEGIN
   if exists(select 1 from enroll) then
   RAISE EXCEPTION 'Cannot insert into this table while students are enrolled'; 
   RETURN Null;
   END if;
END;
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER check_insert_hastaken
BEFORE INSERT ON hastaken
FOR EACH ROW
EXECUTE PROCEDURE check_insert_table_constraint();

--This will be rejected as we have written a trigger that forbids inserts into hastaken table
insert into hastaken values(4,100);

--Question 1 d): Creating triggers to forbid delete on course and prerequisite relations
--drop trigger check_delete_course on course;

CREATE TRIGGER check_delete_course
BEFORE DELETE ON course
FOR EACH ROW
EXECUTE PROCEDURE check_delete_fromtable_constraint();

CREATE TRIGGER check_delete_prerequisite
BEFORE DELETE ON prerequisite
FOR EACH ROW
EXECUTE PROCEDURE check_delete_fromtable_constraint();

--This wont be permitted due to the trigger functions defined above
delete from course where cno=105;
delete from prerequisite where prereq=101;

--Writing triggers to prevent insertions on course and prerequisites
--drop trigger check_insert_course on course;

CREATE TRIGGER check_insert_course
BEFORE INSERT ON course
FOR EACH ROW
EXECUTE PROCEDURE check_insert_table_constraint();

CREATE TRIGGER check_insert_prerequisite
BEFORE INSERT ON prerequisite
FOR EACH ROW
EXECUTE PROCEDURE check_insert_table_constraint();

--This wont be permitted due to the trigger functions defined above
insert into course values(110,'SQL',23,23);
insert into prerequisite values(108,105);


--Question 2 a)
create or replace function enroll_conditions_preqs()
returns trigger as
$$
begin
 if exists(select p.prereq from prerequisite p where p.cno=new.cno
           EXCEPT
           select h.cno from hastaken h where h.sid=new.sid) then
    raise exception 'Does not meet Prerequirments for the given course';
 return null;
 else update course set total=total+1
      where cno=new.cno;
 return new; 
 end if;
end;
$$ language plpgsql;

create trigger enroll_trigger_prereq 
before insert on enroll 
for each row 
execute procedure enroll_conditions_preqs();

--Will reject this enrollment as it doesn't fulfill prerequisites
insert into enroll values(4,105);

--Will accept this enrollment as sid 1 meets the prerequisites to take course no 109
insert into enroll values(1,105);



--Question 2 b)
--Creating a trigger to put a student to waitlist if enrollment for a course is full
create or replace function waitlist_number(cno int) 
returns integer as 
$$ 
begin 
  if exists(select 1 from waitlist w where w.cno = waitlist_number.cno) then 
  return (select max(w.positionn)+1 from waitlist w where w.cno = waitlist_number.cno); 
  else return 1; 
  end if; 
end; 
$$ language plpgsql;

create or replace function enroll_conditions_maxcoursesenrolled()
returns trigger as
$$
begin
 if not exists(select 1 from course c 
               where c.cno=new.cno
               and c.total<c.max) then
    insert into waitlist values(new.sid, new.cno, waitlist_number(new.cno));
 return null;
 else update course set total=total+1-1
      where cno=new.cno;
 return new;
 end if;
end;
$$ language plpgsql;

--Trigger Definition
create trigger enroll_trigger_maxcoursesenrolled 
before insert on enroll 
for each row 
execute procedure enroll_conditions_maxcoursesenrolled();

--This will be permitted and will increase the course count by 1
insert into enroll values(5,111);

--This will be permitted and will increase the course count by 1 again and now the limit for number of people will be reached
insert into enroll values(6,111);

--Now since the enrollment is full, another addition to enroll won't be allowed for a given course and the student will be waitlisted for the course
insert into enroll values(7,111);
insert into enroll values(1,111);
insert into enroll values(3,111);

--Question 2 c)
--handling Waitlist Relation first: if a person is deleted from waitlist relation for a course then the position of all students below that person need to be decremented by 1 and nothing needs to happen to the waitlist position of those people who are above the deleted person
--Updates waitlist upon deletion from waitlist

CREATE or replace FUNCTION compact()
RETURNS trigger AS 
$$
BEGIN
   UPDATE waitlist SET positionn = positionn-1
   WHERE cno = OLD.cno 
   AND positionn > OLD.positionn;
   RETURN OLD;
   END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER waiting_deleted
AFTER DELETE ON waitlist
FOR EACH ROW
EXECUTE PROCEDURE compact();

--This will delete the person in the waitlist for a course and update waitlist position of all people below that person in the waitlist.
delete from waitlist where sid=1 AND cno=111;

-- Handling Enroll Relation now: if a person is deleted from enroll relation for a course then person from waitlist relation with 1st position needs to get enrolled in the enroll relation and deleted from the waitlist relation. Then the rest of the positions in the waitlist need to decremented by 1 for that course. If there's no person in waitlist then update course total count by decrementing it by 1. 

create or replace function enroll_delete_conditions_one()
returns trigger as
$$
BEGIN
 update course set total = total -1
        where cno=old.cno;
 return old;
END;
$$language plpgsql;


--drop trigger handle_enroll_delete on enroll;

create trigger handle_enroll_delete
before delete on enroll
for each row
execute procedure enroll_delete_conditions_one();


create or replace function enroll_delete_conditions_two()
returns trigger as
$$
BEGIN
 if EXISTS ( SELECT 1 from waitlist where cno=old.cno) then
   insert into enroll values((select w.sid from waitlist w where w.cno=old.cno and w.positionn=1),(select w1.cno from waitlist w1 where w1.cno=old.cno and w1.positionn=1));
   delete from waitlist w2 where w2.cno=old.cno and w2.positionn=1;
 return old;
 else return null;
 end if;   
END;
$$language plpgsql;

--drop trigger handle_enroll_delete_two on enroll;

create trigger handle_enroll_delete_two
after delete on enroll
for each row
execute procedure enroll_delete_conditions_two();
--Checking if deleting a student for a course on enroll pushes people from waitlist to enroll for that course
delete from enroll where sid=6 and cno=111;
--Yes it does
delete from enroll where sid=7 and cno=111;
--Yes it does

--Now when waitlist for a course is empty, deleting a person for a course from enroll will delete him from enroll and reduce total people enrolled in that course by 1
delete from enroll where sid=3 and cno=111;


-- Question 3
drop table sample;
create table sample(
xsum int
);

drop table expectation_variance_calculated;
create table expectation_variance_calculated(
Expectation float,
Variance float
);

create or replace function expectation_variance_function() 
returns trigger as
$$
begin
update expectation_variance_calculated 
       SET Expectation = Expectation + (new.xsum),
       Variance = Variance + power((new.xsum),2);
return new;
end;
$$ language 'plpgsql';

--drop trigger expectation_variance_trigger on sample;
create Trigger expectation_variance_trigger
after insert ON sample
For each row
Execute procedure expectation_variance_function();

--drop function runExperiment(n int, out Expectation float, out Variance float);
create or replace function runExperiment(n int, out Expectation float, out Variance float)
returns setof record as
$$
declare i int;
begin
delete from sample;
delete from expectation_variance_calculated;
insert into expectation_variance_calculated values(0,0);
for i in 1..n loop
insert into sample values (floor(random()*6)+1 + floor(random()*6)+1 + floor(random()*6)+1);
end loop;
RETURN QUERY select e.Expectation/n as Expectation,sqrt(e.Variance/n - power(e.Expectation/n,2)) AS Variance from expectation_variance_calculated e;
end;
$$ language 'plpgsql';

SELECT * from runExperiment(10);
SELECT * from runExperiment(100);
SELECT * from runExperiment(1000);
SELECT * from runExperiment(10000);

--Connect to default database
\c postgres;

--Drop database which you created
drop database assignment4;

