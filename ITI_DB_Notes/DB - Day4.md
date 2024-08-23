# Aggregate Functions
- count
- max 
- min 
- avg 
- sum
___
Examples will be provided on this employee Table

![Table](https://github.com/ahmedelmaadawy/DB-Notes/blob/main/Notes/Images/2.PNG)
#### The Aggregate Functions don't consider NULL values
**Sum Of Salaries in employee table**
```sql 
SELECT SUM(salary) 
FROM employes
```
`Result =>87000`
**Count of employees in your table**
```sql
SELECT COUNT(eid)
FROM employee
```
`Result =>15`
**Display maximum and minimum values in salary column**
```sql
SELECT MIN(salary),MAX(salary)
FROM employee
```
`Result=> 1000,9000`
**Average of salaries where salary don't equal null**  
```sql
SELECT AVG(salary)
FROM employee
```
`Result=>5800`
**Average of salaries where salary but replace null with 0**
```sql 
SELECT AVG(ISNULL(salary,0))
FROM employee
```
`Result=>5800`
___
# Group By
when using aggregate function and displaying a column we use group by

**This means display Every Minimum salary for each Department**
```sql
SELECT MIN(salary),did
FROM employee
GROUP BY did
```

| salary | did |
| ------ | --- |
| 1000   | 10  |
| 2000   | 20  |
| 1500   | 30  |

**Display count of employee in every address**
```sql 
SELECT COUNT(eid),address
FROM employee
GROUP BY address
```

| Count(eid) | address  |
| ---------- | -------- |
| 6          | cairo    |
| 5          | alex     |
| 4          | mansoura |
___
**Display minimum salary in each departments only including addresses with second letter _a_**
```sql
SELECT MIN(salary),did
FROM employee
WHERE address LIKE '_a%'
GROUP BY did
```

| Min(salary) | did |
| ----------- | --- |
| 2000        | 10  |
| 2000        | 20  |
| 1500        | 30  |
___
**Display Count of employees in each address only including departments 10 and 30
```sql
SELECT COUNT(eid),address
FROM employee
WHERE did IN(10,30)
GROUP BY address
```

| Count(eid) | address  |
| ---------- | -------- |
| 3          | cairo    |
| 3          | alex     |
| 4          | mansoura |
___
# Having
### Filtering based on Groups
**Having is condition based on aggregate function and is used to filter groups**
**display sum of every department in the department where sum of salary bigger than > 25000**
```sql
SELECT SUM(salary),did
FROM employee
GROUP BY did
HAVING SUM(salary) >25000
```

| sum(salary) | did |
| ----------- | --- |
| 28000       | 20  |
___
**Display number of employees in each address with number of employees more than 4**
```sql
SELECT COUNT(eid),address
FROM employee
GROUP BY address
HAVING COUNT(eid)> 4
```

| count(eid) | address |
| ---------- | ------- |
| 6          | cairo   |
| 5          | alex    |
___
**The query sums salaries by department for departments with more than 5 employees.**
```sql
SELECT SUM(salary),did
FROM employee
GROUP BY did
HAVING COUNT(eid)>5
```

| sum(salary) | did |
| ----------- | --- |
| 20000       | 10  |
___
**The query sums salaries by department where addresses have 'a' as the second character and the total salary exceeds 12,000.**
```sql
SELECT SUM(salary),did
FROM employee
WHERE address LIKE '_a%'
GROUP BY did
HAVING SUM(salary)>12000
```

| sum(salary) | did |
| ----------- | --- |
| 15000       | 20  |
| 14500       | 30  |
___
```sql
SELECT SUM(salary),address
FROM employee
WHERE address IN(20,30)
GROUP BY address
HAVING COUNT(eid)<4
```

| sum(salary) | address |
| ----------- | ------- |
| 13000       | alex    |
| 15000       | cairo   |
___
## Practice on Database

```sql
SELECT SUM(salary) as total
FROM Instructor
```

```sql
SELECT MAX(salary) as total
FROM Instructor
```

```sql
SELECT MIN(salary) as total
FROM Instructor
```

```sql
SELECT COUNT(*) ,COUNT(st_id),COUNT(st_fname),COUNT(st_age)
FROM Student
```

```sql
SELECT AVG(st_age)
FROM Student
```

```sql
SELECT SUM(salary),dept_id,dept_name
FROM Instructor i INNER JOIN Department d
	on d.dept_id = i.Dept_id
GROUP BY Dept_Id,dept_name
```
**works on combinations of address with departments**
```sql
SELECT COUNT(st_id),st_addres,Dept_Id
FROM student
GROUP BY st_address,Dept_Id
```

```sql
SELECT SUM(salary) ,dept_id
FROM Instructor
GROUP BY dept_id
HAVING SUM(salary)>25000
```

#### Special Case
**_Having_ here is considering the table a one group**
```sql
SELECT SUM(salary),AVG(salary)
FROM Instructor
Having COUNT(ins_id)>100
```

___
# Set Operators
- union
- union all
- intersect
- except
___
```sql
--batch
--Set of independent queries
SELECT st_fname
FROM Student

SELECT ins_name
FROM Instructor
```
### Union All
**These two tables have no relations**
**The Number of The columns in the two queries must match and data types must match**
```sql
SELECT st_fname as[names]
FROm Student
UNION ALL
SELECT ins_name
FROM Instructor
```
___
### Union
Union is distinct the result is without redundant
```sql
SELECT st_fname as[names]
FROm Student
UNION 
SELECT ins_name
FROM Instructor
```
___
### Intersect
The matched data in the two tables
```sql
SELECT st_fname as[names]
FROm Student
INTERSECT 
SELECT ins_name
FROM Instructor
```
___
### Except
The data in the first table but don't exist in the second table
```sql
SELECT st_fname as[names]
FROm Student
EXCEPT 
SELECT ins_name
FROM Instructor
```
___
## Subquery
taking output of queries as input in another queries
**The Inner query runs First Then outer query runs based on that outpu** 
```sql
SELECT *
FROM Student
WHERE st_avg < (SELECT AVG(st_age) FROM Student)
```

```sql
SELECT * ,(SELECT COUNT(st_id) FROM Student)
FROM Student
```
**Display departments with students in it**
```sql
SELECT dept_name
FROM Department
WHERE Dept_Id in (SELECT DISTINCT dept_id
				FROM Student
				WHERE Dept_Id IS NOT NULL)
```
___
## Subquery With DML

```sql
DELETE FROM Student_course
WHERE Crs_id =100
```

```sql
DELETE FROM Student_course
WHERE Crs_id =(SELECT crs_id FROM Course 
				WHERE Crs_name ='OOP')
```

```sql 
SELECT st_fname,dept_id,st_age
FROM Student 
WHERE St_address ='cairo'
```
**Order by first column**
```sql
SELECT st_fname,dept_id,st_age
FROM Student 
ORDER BY 1
```
**Order by department id ascending if there two matched order by age Descending**
```sql
SELECT st_fname,dept_id,st_age
FROM Student 
ORDER BY Dept_id ASC, st_age DESC
```

```sql
SELECT st_fname +' '+St_lname AS Fullname
FROM Student
ORDER BY Fullname
```

```sql
SELECT *
FROM (SELECT st_fname + ' '+st_lname as fullname
		FROM Student) as newtable
WHERE fullname='ahmed mohamed'
```
___
## Execution Order
1) from
2) join
3) on
4) where
5) group by
6) having
7) select
8) order by 
9) top
___
## Batch 
##### is set of independent queries 
##### DDL Queries cant run in the same batch you must use _go_ Keyword the right queries run and the wrong don't but they don't affect on each other
## Script 
##### is set of independent queries Separated by _go_ Keyword

## Transactions 
##### Set of Independent queries run as a single unit of work all queries run together or no query run at all

##### Every Query is Implicit Transaction
### Explicit Transaction

```sql
BEGIN TRANSACTION
INSERT 
UPDATE
DELETE 
COMMIT OR ROLLBACK
```

##### Examples
```sql
BEGIN TRY
	BEGIN TRANSACTION
	
	COMMIT
END TRY
BEGIN CATCH
	ROLLBACK
	SELECT ERROR_LINE(),ERROR_MESSAGE(),ERROR_NUMBER()
END CATCH

```
___
### Every Transaction have four Properties ACID

- **Atomicity** - each statement in a transaction (to read, write, update or delete data) is treated as a single unit. Either the entire statement is executed, or none of it is executed. This property prevents data loss and corruption from occurring if, for example, if your streaming data source fails mid-stream.

- **Consistency** - ensures that transactions only make changes to tables in predefined, predictable ways. Transactional consistency ensures that corruption or errors in your data do not create unintended consequences for the integrity of your table.

- **Isolation** - when multiple users are reading and writing from the same table all at once, isolation of their transactions ensures that the concurrent transactions don't interfere with or affect one another. Each request can occur as though they were occurring one by one, even though they're actually occurring simultaneously.

- **Durability** - ensures that changes to your data made by successfully executed transactions will be saved, even in the event of system failure.
___
### Drop ,Delete, truncate

| DROP                      | DELETE                | TRUNCATE                              |
| ------------------------- | --------------------- | ------------------------------------- |
| DDL                       | DML                   | DDL                                   |
| Delete data and meta data | Delete data           | delete data                           |
|                           | Can  use where clause | can't Use where delete all table data |
|                           | Slower                | Faster                                |
|                           | Can Rollback          | Can't Rollback                        |
|                           | Don't reset identity  | reset identity                        |
|                           | always Log            | sometimes log                         |
___
## Identity
**use this query when you want to manually insert values in identity**
```sql
SET IDENTITY INSERT Table_1 ON;
```
**Can't insert identity manually**
```sql
SET IDENTITY INSERT Table_1 OFF;
```
**Check the last identity value in the last query**
```sql
SELECT SCOPE_IDENTY()
SELECT @@IDENTITY
```
**Check Identity in specific table**
```sql
SELECT IDENT_CURRENT('t1')
```
**The current database you are using**
```sql
SELECT db_name()
```
**The name of the user that is currenty login in server**
```sql
SELECT suser_name()
```
**The name of the host server**
```sql
SELECT host_name()
```
___
## Some Build in Functions
1) Upper
2) lowe
3) len
4) substring
5) concat
6) concat_ws

**Display first name in upper case and last name in lower case**
```sql
SELECT upper(st_fname) ,lower(st_name)
FROM Student
```
**Display the length of first name**
```sql
SELECT len(st_fname),st_fname
FROM Student
```
**sub string start from first char and select 3 chars**
```sql
SElECT substring(st_fname,1,3)
FROM Student
```
**Concatenation some strings and concatenation with separator**
```sql
SELECT Concat('ahmed','ali','omar')--ahmedaliomar
SELECT Concat_ws(',','ahmed','ali','omar')ahmed,ali,omar
```
___
