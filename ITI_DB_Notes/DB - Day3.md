# Joins
Examples will be provided on this two tables<br>
Student Table<br>

| Sid | Sname  | did  |
| --- | ------ | ---- |
| 1   | ahmed  | 10   |
| 2   | khalid | 10   |
| 3   | eman   | 20   |
| 4   | omar   | NULL |

Department Table<br>

| Did | Dname |
| --- | ----- |
| 10  | SD    |
| 20  | HR    |
| 30  | IS    |
| 40  | Admin |

## Type Of Joins
### Cross Join
**Cartesian Product**
```sql 
SELECT Sname,Dname
FROM Student,Department
```

```sql 
SELECT Sname,Dname
FROM student CROSS JOIN Department
```

| Sname  | Dname |
| ------ | ----- |
| ahmed  | SD    |
| khalid | SD    |
| eman   | SD    |
| omar   | SD    |
| ahmed  | HR    |
| khalid | HR    |
| eman   | HR    |
| omar   | HR    |
| ahmed  | IS    |
| khalid | IS    |
| eman   | IS    |
| omar   | IS    |
| ahmed  | Admin |
| khalid | Admin |
| eman   | Admin |
| omar   | Admin |

### Inner Join
**Equi Join**
Only Matched Values No null Values from any table FK =PK
```sql
SELECT Sname,Dname
FROM Student,Department
WHERE Department.Did =Student.Sid
```
These two queries are the same
```sql
SELECT Sname,Dname
FROM Student S INNER JOIN Department D
ON D.Did =S.Sid
```

| Sname  | Dname |
| ------ | ----- |
| ahmed  | SD    |
| khalid | SD    |
| eman   | HR    |

### Outer Join
**Left Outer Join**
If You want every row from the left table even if there no matched values 
```sql
SELECT Sname,Dname
FROM Student S LEFT OUTER JOIN Department D
ON S.Did = D.Did
```

| Sname  | Dname |
| ------ | ----- |
| ahmed  | SD    |
| khalid | SD    |
| eman   | HR    |
| Omar   | NULL  |

**Right Outer Join**
If You want every row from the right table even if there no matched values 
```sql
SELECT Sname,Dname
FROM Student S RIGHT OUTER JOIN Department D
ON S.Did = D.Did
```

| Sname  | Dname |
| ------ | ----- |
| ahmed  | SD    |
| khalid | SD    |
| eman   | HR    |
| NULL   | IS    |
| NULL   | ADMIN |

**Full Outer Join**
If You want every row from the right and left tables even if there no matched values its combination of Left And Right Outer Join
```sql
SELECT Sname,Dname
FROM Student S FULL OUTER JOIN Department D
ON S.Did = D.Did
```

| Sname  | Dname |
| ------ | ----- |
| ahmed  | SD    |
| khalid | SD    |
| eman   | HR    |
| omar   | NULL  |
| NULL   | IS    |
| NULL   | ADMIN |

### Self Join
**Unary Relation**
Primary Key and foreign key is in the same table

| eid | ename  | superid |
| --- | ------ | ------- |
| 1   | ahmed  | NULL    |
| 2   | eman   | 1       |
| 3   | khalid | 1       |
| 4   | nada   | 2       |
| 5   | ali    | 2       |

we want a query to know the employee and his supervisor name

```sql
SELECT X.ename AS Empname ,Y.ename AS Supername
FROM Employee X ,Employee Y
WHERE Y.eid = X.superid
```

| Empname | Supername |
| ------- | --------- |
| eman    | ahmed     |
| khalid  | ahmed     |
| nada    | eman      |
| ali     | eman      |

## Examples on Database
**TRY IT YOURSELF**
**Cross Join**
```sql
use ITI 
SELECT st_name ,dept_name
FROM Student,Department
```
### Inner Join
```sql
use ITI 
SELECT st_name ,dept_name
FROM Student S ,Department D
WHERE D.Deopt_Id = S.Dept_Id
```
**Display student name and department for students from alex**
```sql
use ITI 
SELECT st_name ,dept_name
FROM Student S ,Department D
WHERE D.Deopt_Id = S.Dept_Id
AND St_Address ='alex'
```
**Display student name and all department data for the student**
```sql
use ITI 
SELECT st_name ,D.*
FROM Student S ,Department D
WHERE D.Deopt_Id = S.Dept_Id
```
**Display student name and department for student for students ages between 20 and 25 then order the result by  Department name**
```sql
use ITI 
SELECT st_name ,dept_name
FROM Student S ,Department D
WHERE D.Deopt_Id = S.Dept_Id 
AND St_age BETWEEN 20 AND 25
ORDER BY Dept_Name
```
___
## Outer Join
**Display all Student even it no department match**
```sql
use ITI 
SELECT st_name ,dept_name
FROM Student S LEFT OUTER JOIN Department D
WHERE D.Deopt_Id = S.Dept_Id
```

```sql
use ITI 
SELECT st_name ,dept_name
FROM Student S Right OUTER JOIN Department D
WHERE D.Deopt_Id = S.Dept_Id
```

```sql
use ITI 
SELECT st_name ,dept_name
FROM Student S FULL OUTER JOIN Department D
WHERE D.Deopt_Id = S.Dept_Id
```
___
## Self Join
**Student Name and his Supervisor**
```sql 
SELECT B.St_name AS StudName, A.st_name AS SuperName
FROM Student A, Student B
--(A,PK,Parent,Supervisor) -- (B,FK,Child,Student)
WHERE A.St_Id = B.St_Super
```
**Display Supervisors Name**
```sql 
SELECT DISTINCT A.st_name AS SuperName
FROM Student A, Student B
WHERE A.St_Id = B.St_Super
```
**Display all students even if they have no super**
```sql 
SELECT DISTINCT A.st_name AS SuperName
FROM Student A LEFT OUTER JOIN Student B
WHERE A.St_Id = B.St_Super
```
___
## Joins With More than Two Tables
**Display Student name and his courses and grades**
```sql
SELECT st_fname,crs_name,grade
FROM Student S,Stud_Course SC , Course C
WHERE S.St_Id =SC.St_Id 
AND C.Crs_Id = SC.Crs_Id
```
**The same output as the last query**
```sql
SELECT st_fname,crs_name,grade
FROM Student S INNER JOIN Stud_Course SC 
ON S.St_Id =SC.St_Id 
INNER JOIN 
	Course C
ON C.Crs_Id = SC.Crs_Id
```
**Joining four Tables**
```sql
SELECT st_fname,crs_name,grade
FROM Student S INNER JOIN Stud_Course SC 
ON S.St_Id =SC.St_Id 
INNER JOIN 
	Course C
ON C.Crs_Id = SC.Crs_Id
INNER JOIN 
	Department D
ON D.Dept_Id = S.Dept_Id
```
___
## Join With DML
**Joining two table and update grades based on condition in another table**
```sql
UPDATE Stud_Course
	SET grade +=10
FROM Student s ,Stud_Course SC
WHERE S.St_Id = sc.ST_Id AND St_address ='alex'
```

___
# Built In Functions
## ISNull
**Replace null values with other value**
```sql
SELECT isnull(St_fname,'student has no name')
FROM Student
```

## Coalesce
**Replace null values with any of multiple replacement values**
if first name is null display last name and if its null display address and if null display "Student has no name"
```sql
SELECT coalesce(St_fname,st_lname,st_address,
				'student has no name')
FROM Student
```
___
## Autoincrement ID
**Auto increment For Id**
```sql
CREATE TABLE Test2(
id INT PRIMARY KEY IDENTITY (1,1),
ename VARCHAR(20)
)

INSERT INTO Test2 VALUES ('ahmed')
```
**reset identity**
```sql
dbcc check_ident('test',reseed,0)
```

```sql
CREATE TABLE Test3(
id INT IDENTITY ,
ssn INT PRIMARY KEY,
ename VARCHAR(20)
)

INSERT INTO Test3 VALUES (1234,'ahmed')
INSERT INTO Test3 VALUES (4564,'mohamed')
INSERT INTO Test3 VALUES (1234,'salem')
```

___
## Like Statement
```sql 
SELECT * 
FROM Student
WHERE St_fname ='ahmed'
```
___
- *_* is one character
- **%** is Zero or more character
**Names Of student there name starts with "a"**
```sql 
SELECT * 
FROM Student
WHERE St_fname LIKE 'a%'
```
**Names Of student there name ends with "a"**
```sql 
SELECT * 
FROM Student
WHERE St_fname LIKE '%a'
```

### Some Patterns
- `a%h` starts with a and ends with h
- `%d_` the second last char is d
- `___` three chars word
- `_m__` four chars word the second char is m
- `___%` at least four char word
- `ahm%` word starts with ahm
- `[ahm]%` word starts with a or h or m
- `[a-h]%` word starts with range from a to h
- `[(am)(gh)]%` word starts with "am" or "gh"
- `%[%]` string that ends with %
- `%[_]%` words contains __
___
## Database Integrity

|                | Domain Integrity                           | Entity Integrity                                                                  | refrential Integrity                          |
| -------------- | ------------------------------------------ | --------------------------------------------------------------------------------- | --------------------------------------------- |
|                | Range of values                            | Uniqueness                                                                        | Relationship                                  |
| DB Constraints | Data Types                                 | **Primary Key constraint**                                                        |                                               |
|                | (tiny int => 1byte)                        | **unique constraint** => multi columns with unique constraints and allow one NULL | **Foreign Key Constraints**                   |
|                | Default values 'cairo'                     |                                                                                   | **Custom Constraints like Stored Procedures** |
|                | allow NULL or NOT NULL                     |                                                                                   |                                               |
|                | **Check(Constraint)** when Creating tables |                                                                                   |                                               |
| -----------    | ---------------------                      | ----------------------                                                            | -----------------                             |
| DB Objects     |                                            |                                                                                   |                                               |
|                | **Rule**                                   | **Index**                                                                         | **Trigger**                                   |
|                | **Trigger**                                | **Trigger**                                                                       |                                               |

## Types of constraints
- **Primary Key constraint**
- **unique constraint** 
- **Check(Constraint)** 
- **Foreign Key Constraints**
- **Custom Constraints like Stored Procedures**
___
## Constraints

```sql
CREATE TABLE Employee(
eid INT PRIMARY KEY IDENTITY,
ename VARCHAR(20),
eadd VARCHAR(20) DEFAULT 'cairo',
hiredate DATE DEFAULT getdate(),
sal INT ,
overtime INT,
--computed and saved
netsal AS(isnull(sal,0)+isnull(overtime,0)) PRESISTED, 
bd DATE,
--computed
age  AS (YEAR(getdate())-Year(bd)),
gender VARCHAR(1),
hour_rate INT NOT NULL,
dnum INT,
)
```


```sql
CREATE TABLE Employee(
eid INT IDENTITY,
ename VARCHAR(20),
eadd VARCHAR(20) DEFAULT 'cairo',
hiredate DATE DEFAULT getdate(),
sal INT ,
overtime INT,
--computed and saved
netsal AS(isnull(sal,0)+isnull(overtime,0)) PRESISTED, 
bd DATE,
--computed
age AS (YEAR(getdate())-Year(bd)),
gender VARCHAR(1),
hour_rate INT NOT NULL,
dnum INT,
--FOR composite primary key
CONSTRAINT C1 PRIMARY KEY(eid,ename),
CONSTRAINT C2 UNIQUE(sal),
CONSTRAINT C3 CHECK(sal>1000)
CONSTRAINT C4 CHECK(overtime BETWEEN 100 AND 500)
CONSTRAINT C5 CHECK (gender IN('M','F'))
CONSTRAINT C6 FOREIGN KEY(dnum) REFERENCES depts(did)
	ON DELETE SET NULL ON UPDATE CASCADE
)
```
___
