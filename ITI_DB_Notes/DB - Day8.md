# Stored Procedure
A stored procedure in SQL is a group of SQL queries that can be saved and reused multiple times. It is very useful as it reduces the need for rewriting SQL queries. It enhances efficiency, reusability, and security in database management.

Users can also pass parameters to stored procedures so that the stored procedure can act on the passed parameter values.

Stored Procedures are created to perform one or more DML operations on the Database. It is nothing but a group of ****SQL statements**** that accepts some input in the form of parameters, performs some task, and may or may not return a value.
##### Features
- Custom Constraints
- Hide business Logic
- execute Dynamic Query
- prevent SQL Injection

```sql
CREATE PROCEDURE GetStudent
AS
SELECT  * FROM Student
```

**Calling**
```sql
getstudent
EXECUTE getstudent
EXEC getstudent
```

```sql
CREATE PROC getstdbyadd @add VARCHAR(10)
AS
	SELECT st_id,st_fname
	FROM Student
	WHERE St_address =@add
```

**Calling**
```sql
getstdbyadd 'cairo'
getstdbyadd 'alex'
```

**Delete stored procedure**
```sql
DROP PROC getstdbtadd
```
##### DML With SP
check for foreign key before deleting 
```sql
CREATE PROC deltopic @tid int
AS 
	IF NOT EXISTS (SELECT top_id FROM Course WHERE top_id=@tid)
		DELETE FROM topic WHERE Top_id =@tid
	ELSE 
		SELECT 'table has relationship'
```
## Dynamic Stored Procedure

```sql
CREATE PROC getmydata @col VARCHAR(10),@t VARCHAR(20)
AS 
	EXECUTE @col FROM @t
```

**Calling**
```sql 
getmydata '*','Student'
getmydata '*','instructor'
```
## Output parameter
**You can define parameter in sp as Output to update it's value inside stored procedure**
```sql
CREATE PROC GetData
	@id int ,@age int output ,@name varchar(20) output
as
		select @age=st_age,@name=st_fname
		from student
		where st_id=@id
```

**Using Output parameters**
```sql
DECLARE @x INT,@y VARCHAR(20)
execute getData 2,@x output,@y output
select @x,@y
```
## Built in Stored Procedure
`sp_helptext`
`sp_bindrule`
`sp_unbind`
`sp_addtype`

### Functions and SP

| **Function**                                                                           | **Stored Procedure**                                                                                                            |
| -------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| Returns a single value, either as a table or as a scalar, always.                      | Can return zero, a single value, or several values.                                                                             |
| Run-time compilation and execution occur for functions.                                | The database contains stored procedures that have been parsed and compiled.                                                     |
| Only Select statements are allowed. Updating and inserting DML statements are allowed. | Capable of carrying out any action on database objects, such as DML and select statements.                                      |
| Only input parameters are permitted. Output parameters are not supported.              | Both input and output parameters are supported.                                                                                 |
| Does not permit the usage of Try...Catch blocks are used to handle exceptions.         | Allows the use of Try...Catch blocks are used to handle exceptions.                                                             |
| Transactions are not permitted within a function.                                      | A stored procedure can contain transactions.                                                                                    |
| A function cannot call a stored procedure.                                             | A stored procedure can be called a function.                                                                                    |
| A Select statement can invoke functions.                                               | Stored procedures can't be accessed by Select/Where or Having statements. To run a stored procedure, use the Execute statement. |
| In JOIN clauses, functions can be used.                                                | JOIN clauses can't use stored procedures.                                                                                       |
___
# Trigger
Its a Special Type of SP
- Automatic call
- Can't Call
- Can't Send Parameters
- Fire According Action (insert , update , Delete)
Two Types of Triggers 
1. Instead Of
2. After
Instead of prevent the query and fires the trigger instead but after the query executes as normal but trigger fire after the query

```sql
CREATE TRIGGER tr_1
ON Course
AFTER UPDATE
AS
	SELECT 'Welcome TO Course'
```

**Only Trigger if you update course name**
```sql
CREATE TRIGGER tr_1
ON Course
AFTER UPDATE
AS
	IF UPDATE(crs_name)
	SELECT 'Welcome TO Course'

```

**Display the server user and date after updating student**
```sql
CREATE trigger t11
ON student
after UPDATE
AS
	SELECT suser_name(),getdate()
```

**Prevent from updating course Table**
```sql
CREATE trigger t12
ON course
INSTEAD OF UPDATE
AS
	SELECT 'not allowed'
```

**Enable and Disable Trigger**
```sql
ALTER TABLE department DISABLE TRIGGER t13
ALTER TABLE department ENABLE TRIGGER t13
```
___
#### Built In Tables
There are two built in tables in Microsoft SQL that only can be used inside triggers

**This will display the updated row and the row before update
```sql
CREATE TRIGGER tr100
ON Course
AFTER UPDATE
AS 
	SELECT * FROM inserted
	SELECT * FROM deleter
```

**Prevent From deleting in a certain condition**
```sql
CREATE TRIGGER t20
ON student
INSTEAD OF DELETE
AS
	IF format(GETDATE(),'dddd')='Friday'
		SELECT 'NOT ALLOWED'
	ELSE
		DELETE FROM student WHERE S_is =(SELECT st_id FROM deleted)
```
___
## SP , Triggers
|Sr. No.|Key|Triggers|Stored procedures|
|---|---|---|---|
|1|Basic|trigger is a stored procedure that runs automatically when various events happen (eg update, insert, delete)|Stored procedures are a pieces of the code in written in PL/SQL to do some specific task|
|2|Running Methodology|It can execute automatically based on the events|It can be invoked explicitly by the user|
|3|Parameter|It can not take input as parameter|It can take input as a parameter|
|4|Transaction statements|we can't use transaction statements inside a trigger|We can use transaction statements like begin transaction, commit transaction, and rollback inside a stored procedure|
|5|Return|Triggers can not return values|Stored procedures can return values|