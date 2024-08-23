# Variables
## 1. Local Variables
It's Considered Local on the scope of `batch` or `function` or `SP`
```sql
DECLARE @x int
```

To Assign Value 
```sql
SET @x =10
```

```sql
SELECT @x = 9
```

```sql
SELECT @X = age 
	FROM student
	WHERE id = 7
```

```sql
UPDATE student  
	SET name = 'Ali' ,@x=age
WHERE id = 8
```

Display
```sql
SELECT @x
```
___
## 2. Global Variables 
We Can't define global variable and can't assign values to it.
Only Can Get Values from it it's built in variables

Examples:
```sql
@@Servername 
@@version
@@rowcount
@@error
@@identity
```
___
## Examples
Local Variables

```sql
DECLARE @x int
SELECT @x
```

```sql
DECLARE @x int =100
SELECT @x
```

```sql
DECLARE @x int = (SELECT AVG(st_age) FROM Student)
SELECT @x
```

```sql
DECLARE @Y int
	SELECT @Y=st_age FROM student
	WHERE st_id =4
SELECT @y
```

When query return more than one value the variable will only keep the last value 
```sql
DECLARE @Y int
	SELECT st_age FROM student
	WHERE st_address ='alex'
SELECT @y
```
___
### Table Variable

Array of Integer or 1D Array
```sql
DECLARE @t TABLE(col1 int) --1D Array of integer
INSERT INTO @t 
VALUES(4),(9),(15)
```

```sql
DECLARE @t TABLE(col1 int) 
	INSERT INTO @t
	SELECT st_age FROM student st_address ='alex'
SELECT * FROM @t
SELECT Count(*) FROM @t
```

Table Variable or 2D Array
```sql
DECLARE @t TABLE(col1 int,col2 VARCHAR(20)) --2D Array of integer
	INSERT INTO @t
	SELECT st_age,name FROM student st_address ='alex'
SELECT * FROM @t
SELECT Count(*) FROM @t
```

```sql
DECLARE @did int
UPDATE Instructor
	SET Salary=6000,@did=dept_id
	WHERE ins_id =4
SELECT @did
```
___
### Dynamic Queries
```sql
DECLARE @par=9
SELECT * FROM Student
WHERE st_id=@par
```

```sql
DECLARE @par=9
SELECT TOP(@par)
FROM Student
```

```sql
EXECUTE('SELECT * FROM student')
```

```sql
DECLARE @col VARCHAR(10)='8',@table VARCHAR(20)='Student'
EXECUTE (SELECT @col FROM @table)
```
___
# Control Of Flow Statements
## IF
#### BEGIN END 
Used to define scope of if and else
```sql
DECLARE @x int
UPDATE student
	SET st_age +=1
SELECT @x == @@ROWCOUNT

IF @x>0
	BEGIN
		SELECT 'Multi Rows Affected'
	END
ELSE 
	BEGIN
		SELECT 'Zero Rows Affected'
	END
```
___
## IF EXISTS & IF NOT EXISTS
IF any result it executes query if not execute some other query
```sql
IF EXISTS(
	SELECT name 
		FROM SYS.Tables
		WHERE name='Student')
	SELECT 'Table is existed'
ELSE
	CREATE TABLE Student
	(
	id INT ,
	name VARCHAR(100)
	)
```

Like If Exists but reversed
```sql
IF NOT EXISTS (SELECT top_id 
				  FROM Course 
				  WHERE top_id=1)
DELETE FROM topic WHERE top_id=1
ElSE 
	SELECT 'Table Has Relation'
```
___
## Begin Try & Begin Catch

If any error happened Execute the catch
```sql
BEGIN TRY 
	DELETE FROM topic WHERE top_id=1
END TRY 
BEGIN CATCH
	SELECT ERROR_LINE(),ERROR_MESSAGE(),ERROR_Number()
END CATCH
```
___
## WHILE
##### CONTINUE BREAK
```sql
--11 12 13 15
DECLARE @x int=10
WHILE @x=<20
	BEGIN 
	SET @x+=1
	IF @x=14
		CONTINUE
	IF @x=1b
		BREAK
	SELECT @x
	END
```
___
## CASE IIF

```sql
SELECT ins_name,
	CASE 
		 WHEN Salary >8000 THEN 'High salary'
		 WHEN Salary <8000 THEN 'Low Salary'
		 ELSE 'No Data'
	END AS  sal
FROM instructor
```

IIF is like the ternary Operator takes a condition and two options
```sql
SELECT ins_name ,IIF(Salary>8000,'High','low')
FROM instructor
```

```sql
UPDATE Instructor
SET Salary = 
		CASE
		 WHEN Salary >=8000 then Salary*1.20
		 ELSE Salary*1.10
		 END
```
___
# Windowing Function

Get values from one row before and one row after
```sql
SELECT sname,grade,
	LAG(grade) OVER(ORDER BY grade),
	LEAD (grade) OVER(ORDER BY grade)
FROM grades
```

Group by the course Name
```sql
SELECT sname,grade,
	LAG(grade) OVER(PARTITION BY Cname ORDER BY grade),
	LEAD (grade) OVER(PARTITION BY Cname ORDER BY grade)
FROM grades
```

Display the first and last values from the row
```sql
SELECT Sname,Grade,
	First = FIRST_VALUE(grade) OVER(ORDER BY grade),
	last= LAST_VALUE(grade) OVER(ORDER BY grade)
FROM grades
```
___
# Functions
## Built-In Functions
##### Null
`ISNULL()`
`COLEASE()`
##### Conversion
`CONVERT()`
`CAST()`
`FORMAT()`
##### System
`db_name()`
##### Aggregate 
`MIN()`
`MAX()`
`AVG()`
`COUNT()`
##### String
`CONCAT()`
`UPPER()`
`LOWWER()`
`SUBSTRING()`
##### Date
`GETDATE()`
`YEAR()`
`MONTH()`
`DAY()`
`DATEDIFF()`
##### Logical
`ISDATE()`
`ISNUMERIC()`
##### Ranking
`ROW_NUMBER()`
___
## User Defined Functions
All Functions Must Return
### Scalar Function
Scalar Functions Return One Value
```sql
CREATE FUNCTION getstudentname(@id int)
RETURNS VARCHAR(20)
	BEGIN
		DECLARE @name VARCHAR(20)
		SELECT @name=st_fname FROM student
		WHERE St_id =@id
		RETURN @name
	END
```
##### Call
you must call scalar function with the schema name
```sql 
SELECT dbo.getstudentname(1)
SELECT dbo.getstudentname(10)
```
___
### Inline Table Value Function
Return Table
If only select statement 
If you make calculation on any column you must give it alias name
```sql
CREATE FUNCTION getinst(@did int)
RETURNS TABLE
AS 
	RETURN(
		SELECT ins_name ,salary*12 as Annual sal
		FROM Instructor
		WHERE dept_id = @did
	)
```
##### Call
```sql
SELECT * 
FROM getinst(10)
```

```sql
SELECT ins_name 
FROM getinst(5)
```
___
### Multi-statement Table valued function
Return Table
Select or if or while or declaring variable
insert based on select
```sql
CREATE FUNCTION getstudent (@format varchar(20))
RETURNS @t TABLE (
		id INT,
		sname VARCHAR(20)
		) 
AS
	BEGIN
		IF @format ='first'
		INSERT INTO @t
		SELECT st_id,st_fname FROM student
		ELSE IF @format ='last'
		INSERT INTO @t
		SELECT st_id,st_lname FROM student
		ELSE IF @format ='fullname'
		INSERT INTO @t
		SELECT st_id,concat(st_fname,' ',st_lname) FROM student
		RETURN
	END
```
##### Call
```sql
SELECT * FROM getstuds('first')
SELECT * FROM getstuds('last')
SELECT * FROM getstuds('fullname')
```
___
