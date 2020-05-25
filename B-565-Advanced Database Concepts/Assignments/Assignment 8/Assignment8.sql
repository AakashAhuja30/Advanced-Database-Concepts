--Creating Database
create database assignment8;

--------- connecting to database
\c assignment8;

\qecho 'Question 1:'
--Question 1:

-- Creating Relation Tree
CREATE TABLE Tree(parent int, child int);

--Inserting values into Tree
INSERT INTO Tree VALUES (1,2), (1,3), (1,4), (2,5), (2,6), (3,7), (5,8), (7,9), (9,10);

select * from Tree;

--Creating table V which has all the vertices in Tree
create table V(vertex integer);

--Inserting values into V
insert into V (select distinct parent from Tree union select distinct child from Tree);


--Creating a table that will store the distance from parent to child
create table TC (V1 integer, V2 integer, distance integer);

\qecho 'Creating a function that calculates the distance for each of the nodes'
create or replace function distance_calculate()
returns table(V1 integer, V2 integer, distance integer) as
$$
declare	
count integer;

BEGIN

drop table if exists TC;
create table TC (V1 integer, V2 integer, distance integer);

--Phase1:
insert into TC select *,1 from Tree;

drop table if exists V;
create table V(vertex integer);
insert into V (select distinct parent from Tree union select distinct child from Tree);
count := (select count(*) from V);
		  
while count != 0
loop
insert into TC SELECT TC.V1, tree.child , TC.distance + 1
FROM TC INNER JOIN tree ON (TC.V2 = tree.parent);
count:= count - 1;
end loop;

insert into TC select v1.*, v2.*, 0 
from V v1, V v2  
where v1.vertex = v2.vertex;

END;
$$ language plpgsql;

select distance_calculate();

\qecho 'Creating a function that returns the distance for a specific node pair'
create or replace function cal_dist(m int,n int)
returns table(distance int) as
$$
select distinct distance from tc
where v1=m
and v2=n;
$$language sql;

\qecho 'This gives us the ancestor descendent distance for each of our nodes in the tree'
SELECT v1.vertex AS v1, v2.vertex as v2, cal_dist(v1.vertex, v2.vertex) as distance 
FROM   V v1, V v2
WHERE  v1.vertex != v2.vertex 
ORDER BY 3,1,2;


\qecho 'Question 2'
--Question 2:
create table graph(source integer,target integer);
INSERT INTO graph VALUES(1,2),(1,3),(1,4),(3,4),(2,5),(3,5),(5,4),(3,6),(4,6);

\qecho 'Creating the main topological sort function'
create or replace function topological_sort() 
returns table(index integer,vertex integer) as
$$
declare
n int :=1;
i record;
j record;

BEGIN

DROP TABLE IF EXISTS degree;

DROP TABLE IF EXISTS top_sort;

CREATE TABLE degree(target integer,indeg integer);

CREATE TABLE top_sort(index integer,vertex integer);

INSERT INTO degree(select g.target,count(g.target) from graph g group by g.target);
for i in (select * from graph)
loop
if(i.source not in (select t.target from degree t))
then
insert into degree values(i.source,0);
end if;
end loop;
while(select count(*) from degree)!=0
loop
for j in (select * from degree where indeg=0)
loop

insert into top_sort(select n,j.target);
n:=n+1;
update degree set indeg=indeg-1 where target in(select g.target from graph g,
												   degree d where g.source=d.target and d.indeg=0);
delete from degree where target=j.target;

end loop;

end loop;

END;
$$language plpgsql;

select * from topological_sort();

select * from top_sort;


\qecho 'Question 3'
--Question 3

CREATE TABLE IF NOT EXISTS partSubPart(pid INTEGER, sid INTEGER, quantity INTEGER);
DELETE FROM partSubPart;
INSERT INTO partSubPart VALUES(1,2,4),(1,3,1),(3,4,1),(3,5,2),(3,6,3),(6,7,2),(6,8,3);
CREATE TABLE IF NOT EXISTS basicPart(pid INTEGER, weight INTEGER);
DELETE FROM basicPart;
INSERT INTO basicPart VALUES(2,5),(4,50),(5,3),(7,6),(8,10);
select * from partsubpart;

create or replace function aggregatedWeight(p integer) 
returns integer as
$$
declare
n int :=0;
m int :=0;
i record;
BEGIN
if(select not exists(select weight from basicPart where pid=p))then
for i in(select sid from partsubpart where pid=p)
loop
if(not exists(select bp.pid from basicPart bp where bp.pid=i.sid ))then
n:= n+(select ps.quantity from partsubpart ps where ps.sid=i.sid) * aggregatedweight(i.sid);
else
m:=(select ps.quantity*bp.weight from partsubpart ps ,basicPart bp where ps.sid=i.sid and bp.pid=i.sid);
n:=n+m;
end if;
end loop;
else
n:=(select weight from basicPart where pid=p);
end if;
return n;
END;
$$language plpgsql;

\qecho 'Calling our function aggregated weight for the given pids'
select distinct pid, aggregatedWeight(pid)
from(select pid from partSubPart union select pid from basicPart) q 
order by 1;


\qecho 'Question 4'
--Question 4
create table if not exists document (doc text,  words text[]);
delete from document;
insert into document values('d7', '{C,B,A}'),
                           ('d1', '{A,B,C}'),
                           ('d8', '{B,A}'),
                           ('d4', '{B,B,A,D}'),
                           ('d2', '{B,C,D}'),
                           ('d6', '{A,D,G}'),
                           ('d3', '{A,E}'),
                           ('d5','{E,F}');

create or replace function powerset(arr anyarray) 
returns table(pwrst text[]) as
$$
DECLARE
temp text[];
i text;
j record;
BEGIN
drop table if exists powerset1;
create table powerset1(pwrst text[]);
insert into powerset1 values('{}');
FOREACH i IN ARRAY arr
loop

for j in (select * from powerset1)

loop

temp:=array_append(j.pwrst,i);

insert into powerset1 values(temp);

end loop;

end loop;

return query(select * from powerset1);

END;
$$language plpgsql;


create or replace function sortarray (anyarray)
returns anyarray AS 
$$
select array(select distinct unnest($1) 
             order by 1);
$$ language sql;

create or replace function frequentSets(threshold int) 
returns table(frequentsets text[]) AS
$$ 
BEGIN
DROP TABLE IF EXISTS frequent_table;
CREATE TABLE frequent_table(powerset text[],cnt integer);
INSERT INTO frequent_table (SELECT powerset(sortarray(d.words)),count(d.words) from document d
                            group by powerset(sortarray(d.words))
                            );
return query (select ft.powerset 
              from frequent_table ft where ft.cnt>=threshold);
END;
$$ language plpgsql;

select frequentsets(1);
select frequentsets(2);
select frequentsets(3);
select frequentsets(4);

\qecho 'Question 5'
--Question 5:

CREATE TABLE Points (PId INTEGER, X FLOAT, Y FLOAT);
INSERT INTO Points VALUES(1 , 0 , 0),(   2 , 2 , 0),(   3 , 4 , 0),(   4 , 6 , 0),(   5 , 0 , 2),(   6 , 2 , 2),(   7 , 4 , 2),(   8 , 6 , 2),(   9 , 0 , 4),(  10 , 2 , 4),(  11 , 4 , 4),(  12 , 6 , 4),(  13 , 0 , 6),(  14 , 2 , 6),(  15 , 4 , 6),(  16 , 6 , 6),(  17 , 1 , 1),(  18 , 5 , 1),(  19 , 1 , 5),(  20 , 5 , 5);
select * from points order by 1;

\qecho 'Creating KMeans function & running it for 1000 iterations' 
create or replace function k_means(k integer) 
returns table(PId int, x float,y float) AS
$$
declare
i integer;
BEGIN
drop table if exists kmean;
create table kmean(Pid integer,x float,y float);
insert into kmean(select * from Points order by random() limit k);
i:=1000;
while (i!=0)
loop	
i:=i-1;
drop table if exists centroids;
create table centroids(Pid integer,x float,y float,label integer);
insert into centroids (select distinct d.pid, d.x, d.y, km.Pid
					   from kmean km, Points d
					   where sqrt((d.x-km.x)^2+(d.y-km.y)^2) = (select min(sqrt((d.x-kmc.x)^2+(d.y-kmc.y)^2))
															    from kmean kmc));

update kmean km 
set x=q.x,y=q.y 
from(select avg(c.x) as x,avg(c.y) as y,c.label
     from centroids c group by c.label)q
     where km.pid=q.label;
			

end loop;
return query(select km.PId, km.x,km.y from kmean km);
END;
$$ language plpgsql;

\qecho 'Running k means for 1000 iterations'
select * from k_means(3);

--connection to postgres
\c postgres;

--dropping database

drop database assignment8;			
