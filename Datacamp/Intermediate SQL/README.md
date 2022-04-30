# Contents

1. Summarizing Data.
2. Date and Math functions
3. Processing Data with T-SQL (Loops, Derived Tables and CTE)
4. Windowing and it's common functions

## Chapter 1: Summarizing Data

We summarize date using Aggregate functions.

- Aggregate functions

#### Some exercises

```sql
SELECT Country, AVG(InternetUse) As MeanInternetUse,
MIN(GDP) As SmallestGDP,
MAX(InternetUse) As MaxInternetUSe
FROM EconomicIndicators
GROUP BY Country
HAVING MAX(InternetUse) > 1000
```

```sql
-- Calculate the aggregations by Shape
SELECT Shape,
       AVG(DurationSeconds) AS Average, 
       MIN(DurationSeconds) AS Minimum, 
       MAX(DurationSeconds) AS Maximum
FROM Incidents
GROUP BY Shape
-- Return records where minimum of DurationSeconds is greater than 1
having min(DurationSeconds) > 1
```

- Dealing with Missing Data

Blank is not NULL

- A blank is not the same as a NULL value
- May show up in columns containing texts
- An Empty string '' can be used to find blank values
- The best way is look for a column where the length or LEN > 0

```sql
SELECT country,GDP Year
FROM EconomicIndicators
WHERE LEN(GDP) > 0
```

- Replacing Null values
`ISNULL(column, 'replacedValue')` is there are any nulls it will be replaced with the `replacedValue`

```sql
SELECT GDP, Country
ISNULL(Country, 'Unknown') As NewCountry
FROM EconomicIndicators
```

we can replace with existing column

```sql
SELECT TradeGDPPercent, ImportantGoodPercent
ISNULL(TradeGDPPercent, ImportantGoodPercent) As NewCountry
FROM EconomicIndicators
```

we have also another method
`COALESCE(value_1, value_2, value_3, ... value_n)` returns the first non-missing value

```sql
SELECT TradeGDPPercent, ImportantGoodPercent
COALESCE(TradeGDPPercent, ImportantGoodPercent, 'N/A') As NewCountry
FROM EconomicIndicators
```

##### Binning Date with Case

The case statement allows us to evaluate records like an if statement

for example, we can check if a record contains a value and if it does exist we then replace it with a value from our choice, and if it doesn't we can replace it with another value

```sql
CASE
    WHEN Boolean_expression THEN result_expression [...n]
    [ELSE else_result_expression]
END
```

The ELSE is optional

```sql
SELECT Continent, 
CASE 
    WHEN Continent = 'Europe' or Continent = 'Asia' THEN 'Eurasia' 
    ELSE 'Other' 
END As NewContinet
FROM EconomicIndicators
```

we can use `CASE` to create `groups` which are often called `bins`

```sql
SELECT Country, LifeExp
CASE 
    WHEN LifeExp < 30 THEN 1
    WHEN LifeExp > 29 AND LifeExp < 40 THEN 2
    WHEN LifeExp > 39 AND LifeExp < 50 THEN 3
    WHEN LifeExp > 49 AND LifeExp < 60 THEN 4
    ELSE 5
    END AS LifeExpGroup
FROM EconomicIndicators
WHERE Year = 2007
```

another example

```sql
-- Complete the syntax for cutting the duration into different cases
SELECT DurationSeconds, 
-- Start with the 2 TSQL keywords, and after the condition a TSQL word and a value
      CASE WHEN (DurationSeconds <= 120) THEN 1
-- The pattern repeats with the same keyword and after the condition the same word and next value          
       when (DurationSeconds > 120 AND DurationSeconds <= 600) then 2
-- Use  same syntax here             
       when (DurationSeconds > 601 AND DurationSeconds <= 1200) then 3
-- Use same syntax here               
       when (DurationSeconds > 1201 AND DurationSeconds <= 5000) then 4
-- Specify a value      
       ELSE 5 
       END AS SecondGroup   
FROM Incidents
```

## Chapter 2: Math Functions

- Count and sum

```sql
-- Count the number of rows by MixDesc
SELECT MixDesc, count(*)
FROM Shipments
GROUP BY MixDesc
```

- Dates

`DATEPART` is used to determine what part of the date you want to Calculate, some of the common abbreviation are:

- `DD` for Day
- `MM` for Month
- `YY` for Year
- `HH` for Hour

`DATEADD(DATEPART, number, date)` Add or subtract datetime values
    - Always returns a date

what is the date is 30 days from Jun 12, 2020? and also 30 days before

```sql
SELECT DATEADD(DD, 30, '2020-06-21') as after_days, DATEADD(DD, -30, '2020-06-21') as before_days;
```

`DATEDIFF(datepart, startdate, enddate)` Obtain the difference between two datetime values
    - Always returns a number

```sql
SELECT DATEDIFF(DD, '2020-05-22', '2020-06-21') as diff1
 DATEDIFF(DD, '2020-07-21', '2020-06-21')as diff1
```

### Practical Example

- Write a query that returns the number of days between OrderDate and ShipDate.

```sql
SELECT OrderDate, ShipDate, DATEDIFF(DD, OrderDate, ShipDate) as Duration
FROM Shipments
```

- Write a query that returns the approximate delivery date as five days after the ShipDate.

```sql
SELECT OrderDate, DATEADD(DD, 5, ShipDate) As DeliveryDate FROM Shipments
```

- Rounding And Truncating numbers

`ROUND(number, length, [, function])`
-> length: the number of places the number should be rounded.

```js
if(length < 0)
    roundLeftNumber()
else
    roundRightNumber()
```

```sql
-- Round Cost to the nearest dollar
SELECT Cost, 
       round(Cost, 0) AS RoundedCost
FROM Shipments
```

```sql
-- Truncate cost to whole number
SELECT Cost, 
       round(Cost, 0, 1) AS TruncateCost
FROM Shipment
```

- Absolute, square root, square, logarithm
- `ABS()`
- `SQUARE()`
- `SQRT()`
- `LOG()`

```sql
-- Return the absolute value of DeliveryWeight
SELECT DeliveryWeight,
       abs(DeliveryWeight) AS AbsoluteValue
FROM Shipments

-- Return the square and square root of WeightValue
SELECT WeightValue, 
       square(WeightValue) AS WeightSquare, 
       sqrt(WeightValue) AS WeightSqrt
FROM Shipments
```

## Chapter 3: Processing Data

- While Loops
While loops here are just as in programming languages exactly

```sql
DECLARE @CTR INT
SET @CTR = 1
WHILE @CTR < 10
    BEGIN
        SET @CTR = @CTR + 1
        IF @CTR = 4
            BREAK
    ENd
SELECT @CTR
```

- Derived Tables
Derived Tables are another name for a query acting as a table and are commonly used to do aggregations in T-SQL

we used derived table when we need to break down a complex query into smaller steps
it's a great solution, if we want to create intermediate Calculations that need to ne used in a larger query

They are specified in the `FROM` clause

```sql
SELECT a.* FROM Kidney a
-- this derived table computes the average age joined to the actual table
JOIN(SELECT AVG(Age) As AverageAge FROM Kidney b) 
On a.Age = b.AverageAge
```

```sql
SELECT a.RecordId, a.Age, a.BloodGlucoseRandom, 
-- Select maximum glucose value (use colname from derived table)    
       b.MaxGlucose
FROM Kidney a
-- Join to derived table
JOIN (SELECT Age, MAX(BloodGlucoseRandom) AS MaxGlucose FROM Kidney GROUP BY Age) b
-- Join on Age
on a.Age = b.Age
```

-- you will create a derived table to return all patient records with the highest BloodPressure at their Age level

```sql
SELECT * FROM Kidney a
JOIN (SELECT Age, MAX(BloodPressure) AS MaxBloodPressure FROM Kidney GROUP BY Age) b
ON a.BloodPressure = b.MaxBloodPressure
AND a.Age = b.Age
```

- CTES (Common Table Expression)
are another type of derived table, they are little different as they can be used multiple times in a query and are defined like a table. [Defined before you use it]

```sql
WITH CTEName(Col1, Col2)
AS
(
    SELECT Col1, Col2,
    FROM TableName
)
```

the columns names need to maatch coluns in the query

#### Some Exercises

```sql
-- create a CTE to get the maximum BloodPressure by age
WITH BloodPressureAge(Age, MaxBloodPressure)
AS
(
    SELECT Age, Max(BloodPressure) As MaxBloodPressure
    FROM Kidney
    GROUP BY Age
)

-- create a query to use CTE as a table
SELECT a.Age, MIN(a.BloodPressure), b.MaxBloodPressure
FROM Kideny a
JOIN BloodPressureAge b 
ON a.Age = b.Age
GROUP BY a.Age, b.MaxBloodPressure
```

```sql
-- Specify the keyowrds to create the CTE
WITH BloodGlucoseRandom (MaxGlucose) 
AS(SELECT MAX(BloodGlucoseRandom) AS MaxGlucose FROM Kidney)

SELECT a.Age, b.MaxGlucose
FROM Kidney a
-- Join the CTE on blood glucose equal to max blood glucose
JOIN BloodGlucoseRandom b
on a.BloodGlucoseRandom = b.MaxGlucose
```

```sql
-- Create the CTE
WITH BloodPressure (MaxBloodPressure)
AS (
    SELECT MAX(BloodPressure) as MaxBloodPressure
    FROM Kidney
)

SELECT *
FROM Kidney a
-- Join the CTE  
Join BloodPressure b
on a.BloodPressure = b.MaxBloodPressure
```

## Chapter 4: Window functions

Window functions provides the ability to create and analyze groups of data.
With window functions, we can look at the current row, next row and previous row
all at the same time very efficiently

Data here are processed as a group, allowing each group to be evaluated seperately

![](./imgs/window.PNG)

here the data are seperated onto groups based on `SalesYear`

using windowing function, you can create a query to return values by year, without knowing the value of year is!

- Window function is create by OVER() clause
- PARTITION BY creates the frame.
- if you do not include the PARTITION BY the frame is entire table
- to arrange the results, use ORDER BY.
- Allows aggregations to be created at the same time as the window.

```sql
OVER(PARTITION BY SalesPerson Order By SalesYear)
```

```sql
SELECT SalesPerson, SalesYear, CurrentQuota,
       SUM(CurrentQuota)
       OVER(PARTITION BY SalesYear) As YearlyTotal,
       ModifiedDate AS ModDate
FROM SalesGoal
```

- Write a T-SQL query that returns the sum of OrderPrice by creating partitions for each TerritoryName

```sql
SELECT OrderID, TerritoryName, 
       -- Total price for each partition
       sum(OrderPrice) 
       -- Create the window and partitions
       OVER(partition BY TerritoryName) AS TotalPrice
FROM Orders
```

|OrderID| TerritoryName| TotalPrice|
|--|--|--|
|43706| Australia |1469|
|43722 |Australia |1469|

--  calculate the number of orders in each territory.

```sql
SELECT OrderID, TerritoryName,
       COUNT(TerritoryName)
       OVER(PARTITION BY TerritoryName) AS TotalOrders
FROM Orders
```

|OrderID| TerritoryName| TotalOrders|
|--|--|--|
|43706| Australia |13|
|43722 |Australia |16|
