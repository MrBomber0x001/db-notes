# Index
Indexes are used to speed-up query process in SQL Server, resulting in high performance. They are similar to textbook indexes. In textbooks, if you need to go to a particular chapter, you go to the index, find the page number of the chapter and go directly to that page. Without indexes, the process of finding your desired chapter would have been very slow.

The same applies to indexes in databases. Without indexes, a DBMS has to go through all the records in the table in order to retrieve the desired results. This process is called table-scanning and is extremely slow. On the other hand, if you create indexes, the database goes to that index first and then retrieves the corresponding table records directly.
## Clustered Index

A clustered index defines the order in which data is physically stored in a table. Table data can be sorted in only way, therefore, there can be only one clustered index per table. In SQL Server, **the primary key constraint automatically creates a clustered index on that particular column**.

```sql
CREATE CLUSTERED INDEX i2 
ON Student(st_name)
```
___
## Non Clustered Index
A non-clustered index doesn’t sort the physical data inside the table. In fact, a non-clustered index is stored at one place and table data is stored in another place. This is similar to a textbook where the book content is located in one place and the index is located in another. This allows for more than one non-clustered index per table.

It is important to mention here that inside the table the data will be sorted by a clustered index. However, inside the non-clustered index data is stored in the specified order. The index contains column values on which the index is created and the address of the record that the column value belongs to.

When a query is issued against a column on which the index is created, the database will first go to the index and look for the address of the corresponding row in the table. It will then go to that row address and fetch other column values. It is due to this additional step that non-clustered indexes are slower than clustered indexes.

**Unique Constraint Creates a NON Clustered index by default**
#### Create non clustered Index
```sql
CREATE NONCLUSTERED INDEX i2 
ON Student(st_name)
```

This will create a unique constraint and a non clustered index
```sql
CREATE UNIQUE INDEX i5
ON Student(st_name)
```
___
# Cursor

1. Declare Cursor `=> Assign Select`
2. Declare Variables `=> assign values for each row`
3. Open Cursor `Declare pointer at first row`
4. Fetch Row `Data into memory => Next Row`
5. Check on `@@fetch_status =0`
6. Close Cursor
7. Deallocate Cursor

**FOR update is the default of cursor**

```sql
DECLARE c1 CURSOR
FOR SELECT st_id ,St_fname 
FROM Student 
WHERE St_address ='Cairo'
FOR READ ONLY  -- OR FOR UPDATE

DECLARE @id int,@name VARCHAR(20)
OPEN c1
FETCH c1 INTO @id,@name
WHILE @@FETCH_STATUS =0
	BEGIN
	SELECT @id,@name
	FETCH c1 INTO @id,@name 
	END
CLOSE c1
DEALLOCATE c1
```

**Concatenation for all names in one string**
```sql
DECLARE c1 CURSOR

FOR SELECT DISTINCT(st_fname) 
FROM Student 
WHERE St_fname IS NOT NULL
FOR READ ONLY

DECLARE @name VARCHAR(10),@all_names VARCHAR(200) =''

OPEN c1
FETCH c1 INTO @name
WHILE @@FETCH_STATUS =0
	BEGIN 
	SET @all_name=CONCAT(@all_names,',',@name)
	FETCH c1 INTO @name
	END
SELECT @al_names
CLOSE c1
DEALLOCATE c1
```

**Update Salaries in instructor**
```sql
DECLARE C1 CURSOR

FOR SELECT Salary FROM Instructor
FOR UPDATE

DECLARE @sal INT
OPEN c1
FETCH c1 INTO @sal
WHILE @@FETCH_STATUS=0
	BEGIN
	IF @sal >=3000
	UPDATE Instructor
		SET salary = salary*1.2
	WHERE CURRENT OF c1
	ELSE IF @salary<3000
		UPDATE Instructor
			SET Salary =salary*1.1
	WHERE CURRENT OF c1
		
	ELSE 
		DELETE FROM Instructor
		WHERE CURRENT OF c1
	FETCH c1 INTO @sal
	END
CLOSE c1
DEALLOCATE c1
```
___
# View
**Views in SQL** are a kind of virtual table. A view also has rows and columns like tables, but a view doesn’t store data on the disk like a table. View defines a customized query that retrieves data from one or more tables, and represents the data as if it was coming from a single source.

We can create a view by selecting fields from one or more tables present in the database. A View can either have all the rows of a table or specific rows based on certain conditions.

- Is a select statement
- Specify user view of data
- Hide DB Object
- Limit Access of data
- Simplify Construction of complex queries
- Has No parameter
- Has No DML Queries inside its body
- standard view can be considered as virtual table
#### Types Of Views
1. Standard View
2. Partitioned View
3. materialized View

### Standard View

```sql
CREATE VIEW VCairo 
AS
	SELECT id,name
	FROM Student
	WHERE address ='cairo'
```

Access View
```sql
SELECT * 
FROM VCairo
```

```sql
CREATE VIEW VCairo(stID,stName)  --alias names
AS
	SELECT id,name
	FROM Student
	WHERE address ='cairo'
```

```sql
ALTER SCHEMA hr TRANSFER Vcairo
```

**This prevent insert values in address other than Cairo**
```sql
CREATE VIEW VCairo(stID,stName,sadd)  --alias names
AS
	SELECT id,name,address
	FROM Student
	WHERE address ='cairo'
WITH CHECK OPTION
```
### Partitioned View

```sql
CREATE VIEW Vstuds
AS 
	SELECT *
	FROM Cairoserver.iti.dbo.Students
	UNION ALL
	SELECT *
	FROM Alexserver.DB.hr.Studs
```
___
#### Securing View
**This will return The script that created view**
```sql
SP_HELPTEXT 'vcairo'
```
So you Should encrypt the view when creating it

```sql
CREATE VIEW VCairo(stID,stName) 
WITH ENCRIPTION
AS
	SELECT id,name
	FROM Student
	WHERE address ='cairo'
```
___
#### Inserting into View
You Can Insert data into view if the view access one table this will reflect into your table because view is not a table
You cant insert or update if one of the values the view can't access is mandatory it must be allowing `null or default or identity or driven`

```sql
INSERT INTO VCairo
VALUES(800,'ali','cairo')
```


___
# Pivot and Group

Sales Table

| ProductID | SalesmanName | Quantity |
| --------- | ------------ | -------- |
| 1         | ahmed        | 10       |
| 1         | Khalid       | 20       |
| 1         | ali          | 45       |
| 2         | ahmed        | 15       |
| 2         | khalid       | 30       |
| 2         | ali          | 20       |
| 3         | ahmed        | 30       |
| 4         | ali          | 80       |
| 1         | ahmed        | 25       |
| 1         | khalid       | 10       |
| 1         | ali          | 100      |
| 2         | ahmed        | 55       |
| 2         | khalid       | 40       |
| 2         | ali          | 70       |
| 3         | ahmed        | 30       |
| 4         | ali          | 90       |
| 3         | khalid       | 30       |
| 4         | khalid       | 90       |


**After selecting it will display another row with the sum of all quantities**
```sql
SELECT SalesmanName ,SUM(Quantity) AS Qty
FROM Sales
GROUP BY ROLLUP(quantity)
```

| Name   | Qty |
| ------ | --- |
| ahmed  | 165 |
| ali    | 405 |
| khalid | 220 |
| NULL   | 790 |
___
This will add rows for sum of quantities for each product and sum of all quantities
```sql
SELECT ProductID,SalesmanName,sum(quantity) AS "Quantities"
FROM sales
GROUP BY ROLLUP(ProductID,SalesmanName)
```

| ProductID | ahmed  | Quantities |
| --------- | ------ | ---------- |
| 1         | ahmed  | 35         |
| 1         | ali    | 145        |
| 1         | khalid | 30         |
| 1         | NULL   | 210        |
| 2         | ahmed  | 70         |
| 2         | ali    | 90         |
| 2         | khalid | 70         |
| 2         | NULL   | 230        |
| 3         | ahmed  | 60         |
| 3         | khalid | 30         |
| 3         | NULL   | 90         |
| 4         | ahmed  | 170        |
| 4         | ali    | 90         |
| 4         | NULL   | 260        |
| NULL      | NULL   | 790        |
___
## Cube
Groups sales data by all combinations of product and salesman including subtotal for each salesman with each product and total sale for each product
```sql
SELECT ProductID,SalesmanName,sum(quantity) AS "Quantities"
FROM sales
GROUP BY cube(ProductID,SalesmanName)
```

| ProductID | ahmed  | Quantities |
| --------- | ------ | ---------- |
| 1         | ahmed  | 35         |
| 2         | ahmed  | 70         |
| 3         | ahmed  | 60         |
| NULL      | ahmed  | 165        |
| 1         | ali    | 145        |
| 2         | ali    | 90         |
| 4         | ali    | 170        |
| NULL      | ali    | 405        |
| 1         | khalid | 30         |
| 2         | khalid | 70         |
| 3         | khalid | 30         |
| 4         | khalid | 90         |
| NULL      | khalid | 220        |
| NULL      | NULL   | 790        |
| 1         | NULL   | 210        |
| 2         | NULL   | 230        |
| 3         | NULL   | 90         |
| 4         | NULL   | 260        |
___
## Grouping Sets
Calculates sales quantities grouped separately by Product and by SalesmanName.
```sql
SELECT ProductID,SalesmanName,sum(quantity) AS "Quantities"
FROM sales
GROUP BY grouping sets(ProductID,SalesmanName)
```

| ProductID | SalesmanName | Quantities |
| --------- | ------------ | ---------- |
| NULL      | ahmed        | 165        |
| NULL      | ali          | 405        |
| NULL      | khalid       | 220        |
| 1         | NULL         | 210        |
| 2         | NULL         | 230        |
| 3         | NULL         | 90         |
| 4         | NULL         | 260        |
___
## Pivot
Transforms `sales` data by pivoting `SalesmanName` into columns (`ahmed`, `ali`, `khalid`) with their respective total `Quantity` values.
```sql
SELECT * 
FROM sales 
PIVOT (sum(Quantity) FOR SalesmanName IN ([ahmed],[ali],[khalid])) as Pvt
```

| ProductId | ahmed | ali  | khalid |
| --------- | ----- | ---- | ------ |
| 1         | 35    | 145  | 30     |
| 2         | 70    | 90   | 70     |
| 3         | 60    | NULL | 30     |
| 4         | NULL  | 170  | 90     |
___
