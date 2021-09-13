/*

CTEs
- common table expression
- named temprorary result set	
- used to manipulate complex subquery data
- only exists within the scope of the statement that we write
- only in memory, unlike temp.db file
- acts very much as a subquery

- a remark on where, it gets applied before the aggregate functions

*/

With CTE_Employee as 
(Select FirstName, LastName, Gender, Salary
, Count(Gender) Over (Partition by Gender) as TotalGender
, Avg(Salary) over (Partition by Gender) as AvgSalaryPerGender
From SQLTutorialAlexCovid.dbo.EmployeeDemographics as emp
Join SQLTutorialAlexCovid.dbo.EmployeeSalary as sal
	on emp.EmployeeID = sal.EmployeeID
Where Salary > 45000
)
Select *
From CTE_Employee


-- First CTE
;WITH fnames (name) AS
(SELECT 'John' UNION SELECT 'Mary' UNION SELECT 'Bill'),
 
-- Second CTE
minitials (initial) AS
(SELECT 'A' UNION SELECT 'B' UNION SELECT 'C'),
 
-- Third CTE
lnames (name) AS
(SELECT 'Anderson' UNION SELECT 'Hanson' UNION SELECT 'Jones')
 
-- Using all three
SELECT f.name, m.initial, l.name
FROM fnames f
CROSS JOIN lnames AS l
CROSS JOIN minitials m;

/*

Temp Tables

- remark on temp vs view 
Although subsequent runs of the view may be more efficient (say because the pages used by the view query are in cache), a temporary table actually stores the results.

*/

--Create table #temp_Employee (
--EmployeeID int,
--JobTitle varchar(255),
--Salary int
--)

Select *
from #temp_Employee

Insert into #temp_Employee Values (
'1001', 'HR', '45000')

--Insert into #temp_Employee
--Select *
--From SQLTutorialAlexCovid.dbo.EmployeeSalary


--Drop table if exists #Temp_Employee2
--Create Table #Temp_Employee2 (
--JobTitle varchar(50),
--EmployeesPerJob int,
--AvgAge int,
--AvgSalary int)

--Insert into #Temp_Employee2
--Select JobTitle, Count(Jobtitle), Avg(Age), Avg(Salary)
--From SQLTutorialAlexCovid.dbo.EmployeeDemographics
--Join SQLTutorialAlexCovid.dbo.EmployeeSalary
--	on EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
--Group by JobTitle



Select * 
From #Temp_Employee2


/*

String functions: trim, ltrim, rtrim, replace, substring, upper, lower

*/

--CREATE TABLE EmployeeErrors (
--EmployeeID varchar(50)
--,FirstName varchar(50)
--,LastName varchar(50)
--)

--Insert into EmployeeErrors Values 
--('1001  ', 'Jimbo', 'Halbert')
--,('  1002', 'Pamela', 'Beasely')
--,('1005', 'TOby', 'Flenderson - Fired')

Select *
From EmployeeErrors

-- Using Trim, LTRIM, RTRIM

Select EmployeeID, Trim(EmployeeID) as IDTRIM
From EmployeeErrors

Select EmployeeID, LTrim(EmployeeID) as IDTRIM
From EmployeeErrors

Select EmployeeID, RTrim(EmployeeID) as IDTRIM
From EmployeeErrors

-- Using replace

Select Lastname, replace(LastName, '- Fired', '')
From EmployeeErrors

-- using substring

Select SUBSTRING(Firstname, 1, 3)
From EmployeeErrors

Select Substring(err.FirstName, 1, 3), Substring(dem.FirstName, 1, 3)
From EmployeeErrors err
Join EmployeeDemographics dem
	on Substring(err.FirstName, 1, 3) = Substring(dem.FirstName, 1, 3)

-- using upper and lower

Select Firstname, LOWER(FirstName)
From EmployeeErrors

Select Firstname, Upper(FirstName)
From EmployeeErrors


/*
************
Stored Procedures
************
*/

--CREATE PROCEDURE TEST 
--AS
--Select *
--From EmployeeDemographics

EXEC TEST

Create procedure Temp_Employee
as
Create Table #Temp_Employee (
JobTitle varchar(100),
EmployeesPerJob int,
AvgAge int,
AvgSalary int
)
Insert into #Temp_Employee
Select JobTitle, Count(Jobtitle), Avg(Age), Avg(Salary)
From SQLTutorialAlexCovid.dbo.EmployeeDemographics
Join SQLTutorialAlexCovid.dbo.EmployeeSalary
	on EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
Group by JobTitle

Select *
From #Temp_Employee

Exec Temp_Employee @JobTitle = 'Salesman'

-- we also altered the stored procedure after it was saved adding a parameter to it (Programmability/Stored Procedures/dbo.test_employee)



/*
********************
Subqueries (in the select, from and where statement)
********************
*/

Select *
From EmployeeSalary

-- Subquery in select

Select EmployeeID, Salary, (Select Avg(Salary) from EmployeeSalary) as AllAvgSalary
From EmployeeSalary

-- How to do it with partition by

Select EmployeeID, Salary, Avg(Salary) over () as AllAvgSalary
From EmployeeSalary

-- Group By doesn't work because you cannot flatten it

-- Subquery in From

Select a.EmployeeID, a.AllAvgSalary
From (Select EmployeeID, Salary, Avg(Salary) over () as AllAvgSalary
From EmployeeSalary) a

-- Subquery in Where

Select EmployeeID, JobTitle, Salary
From EmployeeSalary
Where EmployeeID in (
		Select EmployeeID
		From EmployeeDemographics
		Where Age > 30)

/*
********************
Variable data
********************
*/

--SHOW VARIABLES LIKE "secure_file_priv";


/*
********************
Loading from csv
********************
*/
use googlemerchstore;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/googlemerchstore2.csv' INTO TABLE userexplorer
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;


/*
*************
Partition by
*************
*/

Select *
From SQLTutorialAlexCovid.dbo.EmployeeDemographics

Select *
From SQLTutorialAlexCovid.dbo.EmployeeSalary

Select FirstName, LastName, Gender, Salary, 
Count(Gender) Over (Partition by Gender) as TotalGender
From SQLTutorialAlexCovid.dbo.EmployeeDemographics as Demo
Join SQLTutorialAlexCovid.dbo.EmployeeSalary as Sal
	on Demo.EmployeeID = Sal.EmployeeID


Select Gender, Count(Gender)
From SQLTutorialAlexCovid.dbo.EmployeeDemographics as Demo
Join SQLTutorialAlexCovid.dbo.EmployeeSalary as Sal
	on Demo.EmployeeID = Sal.EmployeeID
Group by Gender