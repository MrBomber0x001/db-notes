# SQL Server Schema
Default Schema is `dbo` => Database Owner
### Creating schema
```sql
CREATE SCHEMA HR
CREATE SCHEMA Sales
```
### Adding tables to schema
```sql
ALTER SCHEMA HR TRANSFER Instructor

ALTER SCHEMA Sales TRANSFER Department
```

```sql
SELECT * FROM HR.Instructor
```
___
## Security
##### Steps to create a new user and give permissions 
1. Change authentication mode
2. restart server
3. create login
4. create user
5. create schema
6. assign objects to schema
7. Join schema with user
8. GRANT And DENY
9. Disconnect then connect with user
10. New Query
___
## Top
**The first two rows**
```sql
SELECT TOP(2) * 
FROM STUDENT
```

**Maximum Two Salaries**
```sql
SELECT TOP(2) salary
From Employee
ORDER BY Salary DESC
```
___
## NewId
**This generate GUID**
```sql 
SELECT NEWID()
```

**Give different questions every time (Random)**
```sql
SELECT TOP(10)
FROM Questions
Order by NEWID()
```

### Full bath Object
`[ServerName].[DataBase].[Schema].[Table]`

```sql
SELECT * FROM [.].[ITI].[dbo].[Student]
```

Union From different databases
Union departments from ITI Database and Company DataBase
```sql
SELECT dept_name From Department
Union
Select Dept From Company_SD.dbo.department
```
___
## Select Into

Create a new table `NewTable` and copy data from student to it
```sql
SELECT * into NewTable
From Students
```

Only creating structure of employee into new table
```sql
SELECT * INTO Table1
FROM Employee
Where 1 =2
```
#### insert based on select 
the result of select statement will be the new values in Table5
```sql
INSERT INTO table5
SELECT * FROM Student Where St_address ='cairo'
```
#### Bulk Insert
Insert Data from file (Delimited File)

```sql
BULK INSERT table5
FROM 'path to file'
WITH (Filedterminator=',')
```

___
# Ranking Functions
we Will use this table for the next examples

| eid | ename   | esal  | did |
| --- | ------- | ----- | --- |
| 15  | ahmed   | 10000 | 10  |
| 14  | ali     | 10000 | 10  |
| 12  | eman    | 9000  | 10  |
| 1   | nada    | 9000  | 10  |
| 3   | khalid  | 8000  | 10  |
| 7   | mohamde | 7000  | 20  |
| 8   | sayed   | 7000  | 20  |
| 6   | hassan  | 6000  | 20  |
| 5   | omar    | 6000  | 20  |
| 9   | sally   | 5000  | 30  |
| 10  | shimaa  | 4000  | 30  |
| 11  | hana    | 4000  | 30  |
| 12  | lama    | 3000  | 30  |
___
## Row Number

```sql
SELECT * ROW_NUMBER() OVER(ORDER BY esal DESC) as RN
FROM Employee
```

| eid | ename   | esal  | did | RN  |
| --- | ------- | ----- | --- | --- |
| 15  | ahmed   | 10000 | 10  | 1   |
| 14  | ali     | 10000 | 10  | 2   |
| 12  | eman    | 9000  | 10  | 3   |
| 1   | nada    | 9000  | 10  | 4   |
| 2   | reem    | 9000  | 10  | 5   |
| 3   | khalid  | 8000  | 10  | 6   |
| 7   | mohamde | 7000  | 20  | 7   |
| 8   | sayed   | 7000  | 20  | 8   |
| 6   | hassan  | 6000  | 20  | 9   |
| 5   | omar    | 6000  | 20  | 10  |
| 9   | sally   | 5000  | 30  | 11  |
| 10  | shimaa  | 4000  | 30  | 12  |
| 11  | hana    | 4000  | 30  | 13  |
| 12  | lama    | 3000  | 30  | 14  |
___
**This Query Will Select the third heights salary**
```sql
SELECT * 
	FROM 
	(SELECT * ROW_NUMBER() OVER(ORDER BY esal DESC) as RN
	FROM Employee) as NewTable
WHERE RN=3
```
___
## Dense Rank
```sql
SELECT * DENSE_RANK() OVER(ORDER BY esal DESC) as DR
FROM Employee
```

| eid | ename   | esal  | did | RN  | DR  |
| --- | ------- | ----- | --- | --- | --- |
| 15  | ahmed   | 10000 | 10  | 1   | 1   |
| 14  | ali     | 10000 | 10  | 2   | 1   |
| 12  | eman    | 9000  | 10  | 3   | 2   |
| 1   | nada    | 9000  | 10  | 4   | 2   |
| 2   | reem    | 9000  | 10  | 5   | 2   |
| 3   | khalid  | 8000  | 10  | 6   | 3   |
| 7   | mohamde | 7000  | 20  | 7   | 4   |
| 8   | sayed   | 7000  | 20  | 8   | 4   |
| 6   | hassan  | 6000  | 20  | 9   | 5   |
| 5   | omar    | 6000  | 20  | 10  | 5   |
| 9   | sally   | 5000  | 30  | 11  | 6   |
| 10  | shimaa  | 4000  | 30  | 12  | 7   |
| 11  | hana    | 4000  | 30  | 13  | 7   |
| 12  | lama    | 3000  | 30  | 14  | 8   |
___
**This Query will select the heights salary with duplication**
```sql
SELECT * 
	FROM 
	(SELECT * DENSE_RANK() OVER(ORDER BY esal DESC) as DN
	FROM Employee) as NewTable
WHERE DN =1
```

| eid | ename | esal  | did | RN  | DR  |
| --- | ----- | ----- | --- | --- | --- |
| 15  | ahmed | 10000 | 10  | 1   | 1   |
| 14  | ali   | 10000 | 10  | 2   | 1   |
___
**This Query will get the two heights salaries Employees with duplication**
```sql
SELECT * 
	FROM 
	(SELECT * DENSE_RANK() OVER(ORDER BY esal DESC) as DN
	FROM Employee) as NewTable
WHERE DN <=1
```

| eid | ename | esal  | did | RN  | DR  |
| --- | ----- | ----- | --- | --- | --- |
| 15  | ahmed | 10000 | 10  | 1   | 1   |
| 14  | ali   | 10000 | 10  | 2   | 1   |
| 12  | eman  | 9000  | 10  | 3   | 2   |
| 1   | nada  | 9000  | 10  | 4   | 2   |
| 2   | reem  | 9000  | 10  | 5   | 2   |
___
## NTile
To divide rows into groups
```sql
SELECT * NTile(3) OVER(ORDER BY esal DESC) as G
FROM Employee
```

| eid | ename   | esal  | did | RN  | RN  | G   |
| --- | ------- | ----- | --- | --- | --- | --- |
| 15  | ahmed   | 10000 | 10  | 1   | 1   | 1   |
| 14  | ali     | 10000 | 10  | 2   | 2   | 1   |
| 12  | eman    | 9000  | 10  | 3   | 3   | 1   |
| 1   | nada    | 9000  | 10  | 4   | 4   | 1   |
| 2   | reem    | 9000  | 10  | 5   | 5   | 1   |
| 3   | khalid  | 8000  | 10  | 6   | 6   | 2   |
| 7   | mohamde | 7000  | 20  | 7   | 7   | 2   |
| 8   | sayed   | 7000  | 20  | 8   | 8   | 2   |
| 6   | hassan  | 6000  | 20  | 9   | 9   | 2   |
| 5   | omar    | 6000  | 20  | 10  | 10  | 2   |
| 9   | sally   | 5000  | 30  | 11  | 11  | 3   |
| 10  | shimaa  | 4000  | 30  | 12  | 12  | 3   |
| 11  | hana    | 4000  | 30  | 13  | 13  | 3   |
| 12  | lama    | 3000  | 30  | 14  | 14  | 3   |
___
**The First Group**
```sql
SELECT * 
	FROM 
	(SELECT * NTile(3) OVER(ORDER BY esal DESC) as G
	FROM Employee) as NewTable
WHERE G=1
```

| eid | ename | esal  | did | RN  | RN  | G   |
| --- | ----- | ----- | --- | --- | --- | --- |
| 15  | ahmed | 10000 | 10  | 1   | 1   | 1   |
| 14  | ali   | 10000 | 10  | 2   | 2   | 1   |
| 12  | eman  | 9000  | 10  | 3   | 3   | 1   |
| 1   | nada  | 9000  | 10  | 4   | 4   | 1   |
| 2   | reem  | 9000  | 10  | 5   | 5   | 1   |
___
## Rank

```sql
SELECT * RANK() OVER(ORDER BY esal DESC) as R
FROM Employee
```

| eid | ename   | esal  | did | RN  | RN  | G   | R   |
| --- | ------- | ----- | --- | --- | --- | --- | --- |
| 15  | ahmed   | 10000 | 10  | 1   | 1   | 1   | 1   |
| 14  | ali     | 10000 | 10  | 2   | 2   | 1   | 1   |
| 12  | eman    | 9000  | 10  | 3   | 3   | 1   | 3   |
| 1   | nada    | 9000  | 10  | 4   | 4   | 1   | 3   |
| 2   | reem    | 9000  | 10  | 5   | 5   | 1   | 3   |
| 3   | khalid  | 8000  | 10  | 6   | 6   | 2   | 6   |
| 7   | mohamde | 7000  | 20  | 7   | 7   | 2   | 7   |
| 8   | sayed   | 7000  | 20  | 8   | 8   | 2   | 7   |
| 6   | hassan  | 6000  | 20  | 9   | 9   | 2   | 9   |
| 5   | omar    | 6000  | 20  | 10  | 10  | 2   | 9   |
| 9   | sally   | 5000  | 30  | 11  | 11  | 3   | 11  |
| 10  | shimaa  | 4000  | 30  | 12  | 12  | 3   | 12  |
| 11  | hana    | 4000  | 30  | 13  | 13  | 3   | 12  |
| 12  | lama    | 3000  | 30  | 14  | 14  | 3   | 14  |
___
## Partition By
Rank Salary For each Partition and divide partitions with Departments and rank each department  on its own
```Sql
SELECT * , ROW_NUMBER() 
	OVER(PARTITION BY di ORDER BY esal DESC) as RN
FROM Employee
```

| eid | ename   | esal  | did | RN  |
| --- | ------- | ----- | --- | --- |
| 15  | ahmed   | 10000 | 10  | 1   |
| 14  | ali     | 10000 | 10  | 2   |
| 12  | eman    | 9000  | 10  | 3   |
| 1   | nada    | 9000  | 10  | 4   |
| 2   | reem    | 9000  | 10  | 5   |
| 3   | khalid  | 8000  | 10  | 6   |
| 7   | mohamde | 7000  | 20  | 1   |
| 8   | sayed   | 7000  | 20  | 2   |
| 6   | hassan  | 6000  | 20  | 3   |
| 5   | omar    | 6000  | 20  | 4   |
| 9   | sally   | 5000  | 30  | 1   |
| 10  | shimaa  | 4000  | 30  | 2   |
| 11  | hana    | 4000  | 30  | 3   |
| 12  | lama    | 3000  | 30  | 4   |
___
**Top Salary in each department**
```sql
SELECT *
FROM (
	SELECT * , ROW_NUMBER() 
		OVER(PARTITION BY di ORDER BY esal DESC) as RN
	FROM Employee
) as newTable
Where RN=1
```

| eid | ename   | esal  | did | RN  |
| --- | ------- | ----- | --- | --- |
| 15  | ahmed   | 10000 | 10  | 1   |
| 7   | mohamde | 7000  | 20  | 1   |
| 9   | sally   | 5000  | 30  | 1   |
___
### Partition by with dense rank

Assigns a dense rank to employees within each department
```sql
SELECT * , DENSE_RANK() 
	OVER(PARTITION BY di ORDER BY esal DESC) as DR
FROM Employee
```

| eid | ename   | esal  | did | RN  | DR  |
| --- | ------- | ----- | --- | --- | --- |
| 15  | ahmed   | 10000 | 10  | 1   | 1   |
| 14  | ali     | 10000 | 10  | 2   | 1   |
| 12  | eman    | 9000  | 10  | 3   | 2   |
| 1   | nada    | 9000  | 10  | 4   | 2   |
| 2   | reem    | 9000  | 10  | 5   | 2   |
| 3   | khalid  | 8000  | 10  | 6   | 3   |
| 7   | mohamde | 7000  | 20  | 1   | 1   |
| 8   | sayed   | 7000  | 20  | 2   | 1   |
| 6   | hassan  | 6000  | 20  | 3   | 2   |
| 5   | omar    | 6000  | 20  | 4   | 2   |
| 9   | sally   | 5000  | 30  | 1   | 1   |
| 10  | shimaa  | 4000  | 30  | 2   | 2   |
| 11  | hana    | 4000  | 30  | 3   | 2   |
| 12  | lama    | 3000  | 30  | 4   | 3   |
___
```sql
SELECT *
FROM (
	SELECT * , DENSE_RANK() 
	OVER(PARTITION BY di ORDER BY esal DESC) as DR
	FROM Employee) as newTable
WHERE DR =1
```

| eid | ename   | esal  | did | RN  | DR  |
| --- | ------- | ----- | --- | --- | --- |
| 15  | ahmed   | 10000 | 10  | 1   | 1   |
| 14  | ali     | 10000 | 10  | 2   | 1   |
| 7   | mohamde | 7000  | 20  | 1   | 1   |
| 8   | sayed   | 7000  | 20  | 2   | 1   |
| 9   | sally   | 5000  | 30  | 1   | 1   |
___
## Practice on Database

```sql
SELECT * ,ROW_NUMBER() OVER(ORDER BY st_age DESC) As RN
FROM Student
```

```sql
SELECT * ,DENSE_RANK() OVER(ORDER BY st_age DESC) As DR
FROM Student
```

```sql
SELECT * ,NTile(3) OVER(ORDER BY st_age DESC) As G
FROM Student
```
___
```sql
SELECT *
FROM (
	SELECT * ,ROW_NUMBER() OVER(ORDER BY st_age DESC) As RN
	FROM Student ) As NewTable
WHERE RN =1

```


```sql
SELECT * 
FROM (
	SELECT * ,DENSE_RANK() OVER(ORDER BY st_age DESC) As DR
	FROM Student ) AS NewTable
WHERE DR =1
```

```sql
SELECT *
FROM (
	SELECT * ,NTile(3) OVER(ORDER BY st_age DESC) As G
	FROM Student) As NewTable
WHERE G=1
```
___
```sql
SELECT *
FROM (
	SELECT * ,ROW_NUMBER() 
	OVER(PARTITION BY dept_id ORDER BY st_age DESC) As RN
	FROM Student ) As NewTable
WHERE RN =1

```

```sql
SELECT * 
FROM (
	SELECT * ,DENSE_RANK() 
	OVER(PARTITION BY dept_id ORDER BY st_age DESC) As DR
	FROM Student ) AS NewTable
WHERE DR =1
```

```sql
SELECT *
FROM (
	SELECT * ,NTile(3) 
	OVER(PARTITION BY dept_id ORDER BY st_age DESC) As G
	FROM Student) As NewTable
WHERE G=1
```
___
# Merge

LastTransaction
*Target Table*

| Lid | Lname  | Lvalue |
| --- | ------ | ------ |
| 1   | ahmed  | 3000   |
| 2   | khalid | 4000   |
| 3   | ali    | 5000   |
| 4   | eman   | 6000   |

DailyTransaction
*Source Table*

| did | dname  | dval  |
| --- | ------ | ----- |
| 1   | ahmed  | 8000  |
| 2   | khalid | 9000  |
| 7   | nada   | 10000 |

**To Update Last Transaction Table at the End of day From Daily Transaction**

```sql
MERGE INTO Lasttransaction as T
Using DailyTransaction As S
ON T.Lid = S.did
WHEN MATCHED THEN 
	UPDATE 
	SET T.Lvalue = S.dval
WHEN NOT MATCHED THEN
	INSERT 
	VALUES (S.did,S.dname,S.Val);
```

| Lid | Lname  | Lvalue |
| --- | ------ | ------ |
| 1   | ahmed  | 8000   |
| 2   | khalid | 9000   |
| 3   | ali    | 5000   |
| 4   | eman   | 6000   |
| 7   | nada   | 10000  |
___

```sql
MERGE INTO Lasttransaction as T
Using DailyTransaction As S
ON T.Lid = S.did
WHEN MATCHED AND S.dval>T.Lval THEN 
	UPDATE 
	SET T.Lvalue = S.dval
WHEN NOT MATCHED THEN
	INSERT 
	VALUES (S.did,S.dname,S.Val);
```

| Lid | Lname  | Lvalue |
| --- | ------ | ------ |
| 1   | ahmed  | 8000   |
| 2   | khalid | 4000   |
| 3   | ali    | 5000   |
| 4   | eman   | 6000   |
| 7   | nada   | 10000  |
___
