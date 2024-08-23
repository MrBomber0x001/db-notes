## Categories of Microsoft Transact-SQL

| DDl                      | DML                        | DCL                     | DQL                 | TCL                       |
| ------------------------ | -------------------------- | ----------------------- | ------------------- | ------------------------- |
| Data Definition Language | Data Manipulation Language | Data Query Language     | Data Query Language | Transact Control Language |
| Meta Data And structure  | Data                       | Sequrity and permisions | Display             | Execution                 |
|------------------------- | -------------------------- | ----------------------- | ------------------- | ------------------------- |
| Create Table             | Insert                     | grant                   | Select +            | begin transaction         |
| Create function          | update                     | deny                    | Join                | Commit                    |
| create view              | delete                     | revoke                  | subqueries          | rollback                  |
| alter drop               | Merge                      |                         | union               |                           |
| select into              |                            |                         | grouping            |                           |
___
## DDL - Create queries
**Create Database**
```sql
CREATE DATABASE ITItest
```
**Delete structure and data of database**
```sql
DROP DATABASE ITItest
```
**Backup database**
``` sql 
BACKUP DATABASE ITItest
FROM DISK ='D:\ITI.bak'
```
**restore a backup of database**
``` sql 
RESTORE DATABASE ITItest
FROM DISK ='D:\ITI.bak'
```
**Creating table**
```SQL 
USE ITItest
CREATE TABLE employee(
eid int  PRIMARY KEY,
ename VARCHAR(20) NOT NULL,
eadd VARCHAR(20) DEFAULT 'cairo',
hiredate DATE DEFAULT GETDATE(),--built in function
salary INT DEFAULT 5000,
age INT,
dnum INT
)
```
**Editing table to add column**
```sql 
ALTER TABLE employee ADD overtime INT
```
**Editing column datatype in table**
```sql
ALTER TABLE employee ALTER COLUMN overtime BIGINT
```
**Deleting column from table**
```sql
ALTER TABLE employee DROP COLUMN overtime
```
**Delete data and structure**
```sql 
DROP TABLE employee
```

**rename table**
```sql
sp_rename '',''
```
___
## DML Query
**Inserting data**
the values you don't enter must accept null or have default values otherwise it will give you Error
```sql
INSERT INTO employee 
values(1,'ahmed','alex','1/1/2022',8000,21,NULL)
```
**Inserting data to specific columns**
```sql
INSERT INTO employee(ename,eid)
VALUES('omar',2),('ali',3),('sally',10)
```
**Editing data based on condition**
```sql
UPDATE employee
	SET eadd ='alex'
WHERE eid =1
```

```sql
UPDATE employee
	SET eadd='aswan',salary =8000
WHERE eid=2
```
**Editing the salary column to add 500 to each value**
```sql
UPDATE employee
	SET salary +=500
```
**Delete only data but structure of table exists**
```sql
DELETE FROM employee
WHERE eid =1
```
___
## DQL
**Display all columns and rows from student table**
```sql
use ITI
SELECT * FROM student
```
**displaying all columns but specific rows based on where clause**
```sql
use ITI
SELECT * FROM student
WHERE st_Address ='cairo'
```
**Displaying Specific columns and specific rows**
```sql
use ITI
SELECT st_id,st_name FROM student
WHERE st_age >25
```
**Ordering data**
```sql
use ITI
SELECT * FROM student
ORDER BY st_age desc
```
**Distinct : Order and remove redundant values**
```sql
SELECT DISTINCT st_fname
FROM Student
```
**Displaying any student with a fname value**
```sql
SELECT * FROM student
WHERE st_fname IS NOT NULL
```
**Displaying any student with a NULL fname**
```sql
SELECT * FROM student
WHERE st_fname IS NULL
```

```sql
SELECT * FROM student
WHERE st_fname IS NOT NULL AND st_lname IS NOT NULL
```

```sql
SELECT st_fname+' '+st_lname AS [Full Name] --aliase Name
FROM student
```

```sql
SELECT fullName =st_fname+' '+st_lname 
FROM student
```
**Display any student from cairo or alex**
```sql 
SELECT * FROM student
WHERE st_address='cairo' OR st_address='alex' 
```
**Display any student from cairo or alex or aswan**
```sql 
SELECT * FROM student
WHERE st_address in ('alex','cairo','aswan')
```
**Display Any Student in department 10 or 30**
```sql 
SELECT * FROM student
WHERE Dept_Id in(10,30)
```
**Display any student with age in range 20 to 40**
```sql 
SELECT * FROM student
WHERE st_age BETWEEN 20 AND 40
```

```sql 
SELECT * FROM student
WHERE Dept_Id NOT IN(10,30)
```

```sql 
SELECT * FROM student
WHERE st_age NOT BETWEEN 20 AND 40
```

```sql
SELECT st_fname + ' '+ CONVERT(VARCHAR(20),st_age)
FROM student
```
___
