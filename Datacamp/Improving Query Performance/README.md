## Introduction, Review and The Order of Things

the order of the syntax, as written in the query, is different from the processing order in the database

```sql
SELECT Country, Place, Magnitude
FROM Earthquakes
WHERE Magnitude >= 9
ORDER BY Magnitude DESC;
```

Syntax order:

1. SELECT
2. FROM
3. WHERE
4. ORDER BY
Processing Order:
1. FROM
2. WHERE
3. SELECT
4. ORDER BY

the table of processing order:

```
1. FROM
2. ON
3. JOIN
4. WHERE 
5. GROUP BY
6. HAVING

7. SELECT 
8. DISTINCT
9. ORDER BY
10. TOP
```

```sql
-- Second query

-- Add the new column to the select statement
SELECT PlayerName, 
       Team, 
       Position, 
      AvgRebounds -- Add the new column
FROM
     -- Sub-query starts here                             
 (SELECT 
      PlayerName, 
      Team, 
      Position,
      -- Calculate average total rebounds
     (ORebound+DRebound)/CAST(GamesPlayed AS numeric) AS AvgRebounds
  FROM PlayerStats) tr
WHERE AvgRebounds >= 12; -- Filter rows

```

thosw 2 queries will produce the same results, but it's not the correct way to use having

```sql
-- what's more effiecnt and why?
SELECT Team,
 SUM(TotalPoints) As TotalSGTeamPoints
FROM PlayerStats
WHERE Position = 'SG'
GROUP BY Team
```

```sql
SELECT Team,
 SUM(TotalPoints) As TotalSGTeamPoints
FROM PlayerStats
GROUP BY Team, Position
HAVING Position = 'SG'
```

in this case, where is more effient because rows are filtered first before grouping and summing

* tip: Don't use HAVING to filter individual or ungrouped rows

* tip: Use WHERE to filter individual rows and HAVING for a numeric filter on grouped rows

```sql
-- why this query will produce an error ?
-- what's the possible solution?
SELECT Team,
 SUM(DRebound+ORebound) As TotRebounds,
 SUM(DRebound) as TotDef,
 SUM(ORebound) AS TotOff
FROM PlayerStats
GROUP BY Team
HAVING ORebound >= 1000
```

because a numeric column that is using a HAVING filtering condition must be enclosed in an aggregate function?

* note: HAVING is always after GROUP BY

```sql
-- solution
-- why this query will produce an error ?
SELECT Team,
 SUM(DRebound+ORebound) As TotRebounds,
 SUM(DRebound) as TotDef,
 SUM(ORebound) AS TotOff
FROM PlayerStats
GROUP BY Team
HAVING SUM(ORebound) >= 1000
```

## Filtering and Data Interrogation

## Interrogation after SELECT

Here we're going to discuss the effect of Interrogation over performance
processing order after select

```sh
1. FROM
2. ON
3. JOIN
4. WHERE
5. GROUP BY
6. HAVING

7. SELECT

8. DISTINCT
9. ORDER BY
10. TOP
```

`SELECT *` is very bad for performance, always select the columns you need.

`SELECT *` in joins returns duplicates of `joining columns`

<put the query> and output
so you need to explicitly state the columns using aliases

_> actually there's no top of bottom, with ordering we can sort the data desc or asc then choose the top, so we could the choice the top bottoms or the top tops!

* tip: `ORDER BY` works well for interrogating data but slows performance in a query

## Managing duplicates

DISTINCT() and UNION() and their potential effects on performance

-> are there any differences between those 2 queries?

```sql
SELECT DISTINCT(PlayerName)
FROM PlayerName
```

```sql
SELECT PlayerName
FROM PlayerStats
GROUP BY PlayerName
```

-> the answer is 'No', they're pretty similar

_> if we now for sure there's on duplicates in the table, then use UNION ALL because It didn't use a sorting algorithms that slow the performance!

## Sub-queries and presence or absence

There are 3 places to use sub-query with
[1] FROM
the result of this query show seven customers had to wait 35 days or more for their order to be shipped
[2] WHERE
the result of this query show three customers having made orders with a freight weight of more than 800 kilograms
[3] SELECT

### Types of Sub-queries

[1] Uncorrleated

[2] Correlated

* tip: correlated sub-queries can be quite inefficent because the sub-query executes for each row in the outer query
* tip: correlated sub-queries can be replicated using inner join

```sql
-- which is more efficent?
SELECT CustomerID,
CompanyNAme,
(SELET AVG(Frieght)
 FROM Orders o
 WHERE c.CustomerID = o.CustomerID) AS AvgFreight
FROM Customers c;


SELECT c.CustomerID,
c.CompanyNAme,
AVG(o.Frieght)
FROM Customers c
INNER JOIN Orders o
ON c.CustomerID = o.CustomerID

GROUP BY o.CustomerID,
c.CompanyName;

```

consider using `inner join`, which only makes one pass through the data!

### Practice

You want a query that returns the region and countries that have experienced earthquakes centered at a depth of 400km or deeper. Your query will use the Earthquakes table in the sub-query, and Nations table in the outer query.

```sql
SELECT UNStatisticalRegion,
       CountryName 
FROM Nations
WHERE Code2 -- Country code for outer query 
         IN (SELECT Country -- Country code for sub-query
             FROM Earthquakes
             WHERE depth >= 400 ) -- Depth filter
ORDER BY UNStatisticalRegion;
```

A friend is working on a project looking at earthquake hazards around the world. She requires a table that lists all countries, their continent and the average magnitude earthquake by country. This query will need to access data from the Nations and Earthquakes tables

```sql
SELECT UNContinentRegion,
       CountryName, 
        (SELECT AVG(magnitude) -- Add average magnitude
        FROM Earthquakes e 
            -- Add country code reference
        WHERE n.Code2 = e.Country) AS AverageMagnitude 
FROM Nations n
ORDER BY UNContinentRegion DESC, 
         AverageMagnitude DESC;
```

You want to find out the 2017 population of the biggest city for every country in the world. You can get this information from the Earthquakes database with the Nations table as the outer query and Cities table in the sub-query.

create this using:
[1] correlated sub-query

```sql
SELECT
 n.CountryName,
  (SELECT MAX(c.Pop2017) -- Add 2017 population column
  FROM Cities AS c 
                       -- Outer query country code column
  WHERE c.CountryCode = n.Code2) AS BiggestCity
FROM Nations AS n; -- Outer query table
```

[2] inner join

```sql
SELECT n.CountryName, 
       c.BiggestCity 
FROM Nations AS n
INNer join  -- Join the Nations table and sub-query
    (SELECT CountryCode, 
     MAX(Pop2017) AS BiggestCity 
     FROM Cities
     GROUP BY CountryCode) AS c
ON n.Code2 = c.CountryCode; -- Add the joining columns
```

## Presence and Absence

Checking the presence or absence of data is common task of a data scientist.

`INTERSECT` and `EXCEPT`

INTERSECT is one of the easier and more intuitive methods used to check if data in one table is present in another

EXCEPT does the opposite of INTERSECT. It is used to check if data, present in one table, is absent in another.

### Practice

You want to know which, if any, country capitals are listed as the nearest city to recorded earthquakes. You can get this information by comparing the Nations table with the Earthquakes table.

```sql
SELECT Capital
FROM Nations -- Table with capital cities

INTERSECT -- Add the operator to compare the two queries

SELECT NearestPop -- Add the city name column
FROM Earthquakes;
```

You want to know which countries have no recorded earthquakes. You can get this information by comparing the Nations table with the Earthquakes table.

```sql
SELECT Code2 -- Add the country code column
FROM Nations

EXCEPT -- Add the operator to compare the two queries

SELECT Country 
FROM Earthquakes; -- Table with country codes
```

## Query performance tuning

### indexes

Indexes are structures added to the table to improve speed of accessing data from a table.

used to locate data quickly without having to scan the entire table.
this makes them particulary useful for improving performance of Queries with filter conditions
they are applied to a table columns and can be addd at any time.

the two most common table indexes are Clustered and Nonclustered

#### Clusterd and Nonclustered Indexes

1. Clusterd Index:
A good analogy for a clustered index is a dictionary where words are stored "alphabetically".

Clustered indexes reducee the number of data page reads by a query which helps speed up search operations.

A table can only contain one Clustered index.

2. Non Clustered Index:
A good analogy is a text book with an index at the back

Data in the book is unordered and the index at the back indicated the page number containing a search condition.

Another layer in the index structure contains ordered pointers to the data pages.

A table can contain more than one Nonclustered index.

It's common used to improve table insert and update operations.

##### Clustered Index: B-tree structure

A clustred index creates what is called a B-tree structure on a table.

* Root node

* branches the nodes

* leaves

[-] The root node:
the root node contains ordered pointers to branch nodes which in turn contains orderd pointers to page nodes.

the page node level contains all the 8 kilobyte data pages from the table with the data physically ordered by the columns(s) with the clustred index.
