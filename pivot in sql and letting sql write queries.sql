#first example of a pivot on a database
#taken from https://www.artfulsoftware.com/infotree/qrytip.php?id=78
#other links of interest
#https://stackoverflow.com/questions/1241178/mysql-rows-to-columns
#http://www.artfulsoftware.com/infotree/qrytip.php?id=78
#https://stackoverflow.com/questions/7674786/how-can-i-return-pivot-table-output-in-mysql

use mydatabase;

DROP TABLE IF EXISTS tbl;
CREATE TABLE tbl( id INT, colID INT, value CHAR(20) );
INSERT INTO tbl VALUES
  (1,1,'Sampo'),(1,2,'Kallinen'),(1,3,'Office Manager'),
  (2,1,'Jakko'),(2,2,'Salovaara'),(2,3,'Vice President');
  
select *
from tbl;

SELECT 
  id, 
  GROUP_CONCAT( if(colID=1,value,NULL) ) AS 'First Name',
  GROUP_CONCAT( if(colID=2,value,NULL) ) AS 'Last Name',
  GROUP_CONCAT( if(colID=3,value,NULL) ) AS 'Job Title'
FROM tbl
GROUP BY id;

############
#Trying out a leetcode example
############

CREATE TABLE occupations(name CHAR(20), occupation CHAR(20));
INSERT INTO occupations VALUES
('Ashley', 'Professor'),
('Samantha', 'Actor'),
('Julia', 'Doctor'),
('Britney', 'Professor'),
('Maria', 'Professor'),
('eera', 'Professor'),
('Priya', 'Doctor'),
('Priyanka', 'Professor'),
('Jennifer', 'Actor'),
('Ketty', 'Actor'),
('Belvet', 'Professor'),
('Naomi', 'Professor'),
('Jane', 'Singer'),
('Jenny', 'Singer'),
('Kristeen', 'Singer'),
('Christeen', 'Singer'),
('Eve', 'Actor'),
('Aamina', 'Doctor')

select * from occupations
order by occupation

With CTE as
(
SELECT 
  Occupation, 
  GROUP_CONCAT(Name) as Allnames
FROM Occupations
GROUP BY Occupation
)
Select allnames as Actor from CTE
WHERE Occupation =  'Actor'

######################
#Second try and successfull
######################

DROP view IF EXISTS occupations_extended;
create view occupations_extended as (
  select
    occupations.*,
    case when occupation = "Doctor" then name end as Professor,
    case when occupation = "Professor" then name end as Doctor,
    case when occupation = "Singer" then name end as Singer,
    case when occupation = "Actor" then name end as Actor
  from occupations
);

set @r1=0, @r2=0, @r3=0, @r4=0; #clever use of varables for iteration on rownumber, not used to seeing it in sql
Select MIN(Doctor), MIN(Professor), MIN(Singer), MIN(Actor) #takes in min or max in order to select a value that is non null, row in intermediary table has all null and only one value
from(
  select case when Occupation='Doctor' then (@r1:=@r1+1)
            when Occupation='Professor' then (@r2:=@r2+1)
            when Occupation='Singer' then (@r3:=@r3+1)
            when Occupation='Actor' then (@r4:=@r4+1) end as RowNumber,
    case when Occupation='Doctor' then Name end as Doctor,
    case when Occupation='Professor' then Name end as Professor,
    case when Occupation='Singer' then Name end as Singer,
    case when Occupation='Actor' then Name end as Actor
  from OCCUPATIONS
  order by Name
	) temp
group by RowNumber;

SELECT Occupation, GROUP_CONCAT(Name)
FROM Occupations
GROUP BY Occupation
order by name

DROP TABLE IF EXISTS history;
CREATE TABLE history
(hostid INT,
itemname VARCHAR(5),
itemvalue INT);

INSERT INTO history VALUES(1,'A',10),(1,'B',3),(2,'A',9),
(2,'C',40),(2,'D',5),
(3,'A',14),(3,'B',67),(3,'D',8);


########################
#Example that works without hardcoding column names from field values when doing pivot
#Reminds me of lisp
#You can let Sql create statemnts that will later be executed


select @sql

SELECT
  GROUP_CONCAT(DISTINCT
    CONCAT(
      'ifnull(SUM(case when itemname = ''',
      itemname,
      ''' then itemvalue end),0) AS `',
      itemname, '`'
    )
  ) INTO @sql
FROM
  history;
SET @sql = CONCAT('SELECT hostid, ', @sql, ' 
                  FROM history 
                   GROUP BY hostid');
                   
                   
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;



