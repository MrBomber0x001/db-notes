# Temporal EDA, Variables & Date Manipulation

EDA: Exploratory Data analysis
In this section, we will study date manipulation using different Date functions such as datepart, datename and datediff

```sql
-- Convert date time to date data type
select TOP(1) PickupDate, convert(Date, pickupDate) as DateOnly from YellowTripData

--here we use datepart to select the busiest hours for Taxi pickups
select top 3 count(Id) as BumverOfRides, Datepart(hour, pickupdate) as hour from ... group by datapart(hour, pickupdate) order by count(id) desc

--find the difference between the pickup date and dropoff date in seconds in sunday
select AVG(Datediff(second, pickupdate, dropoffdate) / 60)
as avgRideLenghtInmin
from ... where datename(weekday, pickupdate) = 'Sunday';
```

exercise:
ransactions per day
It's time for you to do some temporal EDA on the BikeShare dataset. Write a query to determine how many transactions exist per day.

```sql
SELECT
  -- Select the date portion of StartDate
  convert(date, StartDate) as StartDate,
  -- Measure how many records exist for each StartDate
  count(StartDate) as CountOfRows
FROM CapitalBikeShare
-- Group by the date portion of StartDate
group BY convert(date,  StartDate)
-- Sort the results by the date portion of StartDate
order BY convert(date, StartDate);
```

second exercise: seconds or no seconds?
is the second datapart on startDate is equal to zero or not

```sql
SELECT
	-- Count the number of IDs
	COUNT(ID) AS Count,
    -- Use DATEPART() to evaluate the SECOND part of StartDate
    "StartDate" = CASE WHEN datepart(second, StartDate) = 0 THEN 'SECONDS = 0'
					   WHEN datepart(second, StartDate) > 0 THEN 'SECONDS > 0' END
FROM CapitalBikeShare
GROUP BY
    -- Use DATEPART() to Group By the CASE statement
	CASE WHEN datepart(second, StartDate) = 0 THEN 'SECONDS = 0'
		 WHEN datepart(second, StartDate) > 0 THEN 'SECONDS > 0' END
```

third exercies: Which day of week is busiest?

```sql
SELECT
    -- Select the day of week value for StartDate
	datename(weekday, StartDate) as DayOfWeek,
    -- Calculate TotalTripHours
	sum(datediff(second, StartDate, EndDate))/ 3600 as TotalTripHours
FROM CapitalBikeShare
-- Group by the day of week
GROUP BY datename(weekday, StartDate)
-- Order TotalTripHours in descending order
ORDER BY TotalTripHours DESC
```

fourth exercise: find the outliers
what is outlier?
In statistics, an outlier is a data point that differs significantly from other observations. An outlier may be due to variability in the measurement or it may indicate experimental error; the latter are sometimes excluded from the data set. An outlier can cause serious problems in statistical analyses.
in the previous exercise 'Satureday' was the busiest day of the week, Do you wonder if there were any individual Saturday outliers that contributed to this

```sql
SELECT
	-- Calculate TotalRideHours using SUM() and DATEDIFF()
  	sum(datediff(second, StartDate, EndDate))/ 3600 AS TotalRideHours,
    -- Select the DATE portion of StartDate
  	convert(date, StartDate) AS DateOnly,
    -- Select the WEEKDAY
  	datename(weekday, convert(date, StartDate)) AS DayOfWeek
FROM CapitalBikeShare
-- Only include Saturday
WHERE datename(WEEKDAY, StartDate) = 'Saturday'
GROUP BY CONVERT(DATE, StartDate);
```

## Variable for datetime data

# User-defined Functions

# Stored Procedures

# NYC Taxi Ride Case Study

Variables for datetime date:
we can create single value variable or table variable

```sql
DECLARE @TaxiRideDate TABLE(StartDate date, EndDate datetime)
```

```sql
DECLARE @StartTime as time = '08:00 AM' --intial value
DECLARE @StartTime As time
SET @StartDate = '08:00 AM'

--declare and then set value depending on the result of select statement
DECLARE @BeginDate as date
SET
@BeginDate = (
  SELECT TOP 1 PickupDate
  FROM YellowTripDate
  Order by PickupDate Asc
)
```

CASTing: sql server use default rules when exeuting CAST() statements so you can cast a time to datetime, even whn there's no datetime present

```sql
declare @StartDateTime as datetime
set @StartDateTime = CAST(@BeginDate as datetime) + CAST(@StartTime as datetime)
```

Table Variables

```sql
Declare @TaxiRideDates Table(
  StartDate date,
  EndDate date
)
-- INSERT static values into table variable
insert into @TaxiRideDates (StartDate, EndDate)
SELECT '3/1/2018', '3/2/2018'

--insert a query result
insert into @TaxiRideDates(StartDate, EndDate)
Select Distinct CAST(pickupdate as date), CAST(DropOffDate as date)
FROM YellowTripDate
```

table variables are not recommended to store more than one hundered recored beuase of potential performance

```sql
-- Create @ShiftStartTime
declare @ShiftStartTime AS time = '08:00 AM'

-- Create @StartDate
declare @StartDate AS date

-- Set StartDate to the first StartDate from CapitalBikeShare
set
@StartDate = (
SELECT TOP 1 StartDate
FROM CapitalBikeShare
ORDER BY StartDate ASC
)

-- Create ShiftStartDateTime
declare @ShiftStartDateTime AS datetime

-- Cast StartDate and ShiftStartTime to datetime data types
SET @ShiftStartDateTime = CAST(@StartDate AS datetime) + CAST(@ShiftStartTime AS datetime)

SELECT @ShiftStartDateTime

```

```sql
-- Declare @Shifts as a TABLE
declare @Shifts Table(
    -- Create StartDateTime column
	 StartDateTime datetime ,
    -- Create EndDateTime column
	EndDateTime datetime)
-- Populate @Shifts
insert into @Shifts (StartDateTime, EndDateTime)
	SELECT '3/1/2018 8:00 AM', '3/1/2018 4:00 PM'
SELECT *
FROM @Shifts
```

```sql
-- Declare @RideDates
DECLARE @RideDates TABLE(
    -- Create RideStart
	RideStart date,
    -- Create RideEnd
	RideEnd date)
-- Populate @RideDates
INSERT INTO @RideDates(RideStart, RideEnd)
-- Select the unique date values of StartDate and EndDate
SELECT DISTINCT
    -- Cast StartDate as date
	CAST(StartDate as date),
    -- Cast EndDate as date
	CAST(EndDate as date)
FROM CapitalBikeShare
SELECT *
FROM @RideDates
```

Date manipulation
GETDATE
DATEADD -> we don't have DATESUBTRACT because we can do the same functionality using negative number

```sql
-- Yersterday's Taxi Passenger Count
SELECT SUM(PassengerCount) FROM YellowTripDate WHERE CAST(PickupDate as date) = DATEADD(d, -1, GETDATE())
```

note very important:
the return value of DATEDIFF() depends on the datepart argument you pass

```sql
--First day of the current week
SELECT DATEADD(week, DATEDIFF(week, 0 , GETDATE()), 0)
```

what does this query actually about?
when starting to figure out complex query, start by the inner functions
GETDATE() returns the current Date
Second, we're calling DATEDIFF() to see how many weeks between today and 0 -> which is 1/1/1900
By adding zero weeks to the 6.217th week with the DATEADD(), sql server will return the date of the beginning of the week

Exercise
Parameters matter with DATEDIFF
How many times, in terms of days, weeks, and months, are the datepart boundaries crossed between the dates 2/26/2018 and 3/3/2018?

answer:
5 days, 0 weeks, 1 month. now you understand the assumption sql server take to evaluate datediff

find the fist day of the current month

```sql
select dateadd(month, datediff(month, 0, GETDATE()), 0)
```

# User defined functions

```sql
-- Scalar function with no input parameters
CREATE FUNCTION GetTomorrow()
  RETURNS date AS BEGIN
RETURN (SELECT DATEADD(day, 1, GETDATE()))
END

-- Scalar function with one Parameter
-- return numeric value, which is the sum of all trips equal to PickupDate
CREATE FUNCTION GetRideHrsOneDay(@DateParm date)
RETURNS numeric as begin
return (SELECT
  SUM(DATEDIFF(second, PickupDate, DropoffDate) / 360) from yellowTripData WHERE CONVERT(date, PickupDate) = @DatePam

) END;

```

```sql
-- Create GetYesterday()
CREATE function GetYesterday()
-- Specify return data type
returns date
AS
BEGIN
-- Calculate yesterday's date value
return( SELECT dateadd(day, -1, Getdate()))
END
```

```sql
-- Create SumRideHrsSingleDay
CREATE FUNCTION SumRideHrsSingleDay (@DateParm date)
-- Specify return data type
RETURNS numeric
AS
-- Begin
BEGIN
RETURN
-- Add the difference between StartDate and EndDate
(SELECT SUM(DATEDIFF(second, StartDate, EndDate))/3600
FROM CapitalBikeShare
 -- Only include transactions where StartDate = @DateParm
WHERE CAST(StartDate AS date) = @DateParm)
-- End
END
```

```sql
-- Create the function
CREATE FUNCTION SumRideHrsDateRange (@StartDateParm datetime, @EndDateParm datetime)
-- Specify return data type
RETURNS numeric
AS
BEGIN
RETURN
-- Sum the difference between StartDate and EndDate
(SELECT SUM(DATEDIFF(second, StartDate, EndDate))/3600
FROM CapitalBikeShare
-- Include only the relevant transactions
WHERE StartDate > @StartDateParm and StartDate < @EndDateParm)
END
```

## Table Valued UDF

there are two types:
1- Inline table valued functions (ITVF)

```sql
create function SumLoationStats(
  @StartDate As datetime = '1/1/2017'
) RETURNS Table as return
select PUlocaation as PickupLocation,
 Count(id) as RideCount,
 SUM(TRIPDistance) AS TotalTripDistance
 from YellowTriData
 WHERE PUlocationID;
```

2-Multi statement table function (MSTFV)

```sql
create function CountTripAvgFareDay(
  @Month char(2),
  @Year char(4)
) RETURNS @TripCountAvgFare Table(
  DropOffDate date, TripCount int, AvgFare numeric
) AS BEGIN INSRT INTO @TripCountAVGFare
SELECT
  CAST(DropOffDate as date),
  COUNT(ID),
  AVG(FareAmount) as AVGFAreAmt
FROM YellowTripDate
WHERE
 DATEPART(month, DropOffDate) = @Month
 AND DatePART(year, DropOffDate) = @Year
 Group by CAST(DropOffDate as data)
 returns END
;
```

exercises

```sql
-- Create the function
CREATE FUNCTION SumStationStats(@StartDate AS datetime)
-- Specify return data type
RETURNS TABLE
AS
RETURN
SELECT
	StartStation,
    -- Use COUNT() to select RideCount
	COUNT(ID) as RideCount,
    -- Use SUM() to calculate TotalDuration
    SUM(DURATION) as TotalDuration
FROM CapitalBikeShare
WHERE CAST(StartDate as Date) = @StartDate
-- Group by StartStation
GROUP BY StartStation;
```

```sql
-- Create the function
CREATE FUNCTION CountTripAvgDuration (@Month CHAR(2), @Year CHAR(4))
-- Specify return variable
RETURNS @DailyTripStats TABLE(
	TripDate	date,
	TripCount	int,
	AvgDuration	numeric)
AS
BEGIN
-- Insert query results into @DailyTripStats
INSERT @DailyTripStats
SELECT
    -- Cast StartDate as a date
	CAST(StartDate AS date),
    COUNT(ID),
    AVG(Duration)
FROM CapitalBikeShare
WHERE
	DATEPART(month, StartDate) = @Month AND
    DATEPART(year, StartDate) = @Year
-- Group by StartDate as a date
GROUP BY CAST(StartDate AS date)
-- Return
RETURN
END
```

UDF in action: executing the UDF

```sql
SELECT dbo.GetTomorrow()
```

the schema must be specified when creating and executing the function
if we don't specifiy the schema upon creation, the sql server will by default assign to to the user defulat scehama

```sql
DECLARE @TotalRideHrs as numberic
EXEC @TotalRideHrs = dbo.GetRideHrsOneDay @DateParm = '1/15/2017'
SELECT
  'Toal Ride Hours for 1/15/2017:',
  @TotalRideHrs
```

exec is used to execute the function and assign the function to the local variable called @TotalRideHrs

EXecuting scalar UDF

```sql
-- Declare parameter variable
-- set to oldest date in YellowTripData
-- Pass to function with select
Declare @DateParm as date = (SELECT TOP 1 CONVERT(date, PickupDate) FROM YellowTripDate ORDER BY PickupDate DESC)
SELECT @DateParm, dbo.GetRideHrsOneDay (@DateParm)
```

it's possibly to execute the function in the where clause, but this affect the query performance

since table valued function returns a table, we can execute it using the select from keywords

```sql
SELECT TOP 10 * FROM dbo.SumLocationStats('2017')
ORDER BY RideCount DESC
```

you can sepcify order by clause when executing the function, but it's not allowed n thr funciton itsslef

```sql
DECLARE @CountTripAvgFareDay TAble(
  DropOffDate date,
  TripCount int,
  AvgFare  numeric
)
INSERT INTO @CountTripAvgFareDay
SELECT TOP 10 *
FROM dbo.CountTripAvgFareDay
ORDER BY DropOFFDATE



SELECT * FROM @CountTripAvgFareDay
```

here we created a local table variable with the same structure as the function table result structure

exercises

```sql
-- Create @BeginDate
declare @BeginDate AS date = '3/1/2018'
-- Create @EndDate
declare @EndDate as date = '3/10/2018'
SELECT
  -- Select @BeginDate
   @BeginDate AS BeginDate,
  -- Select @EndDate
  @EndDate AS EndDate,
  -- Execute SumRideHrsDateRange()
  dbo.SumRideHrsDateRange(@BeginDate, @EndDate) AS TotalRideHrs
```

```sql
-- Create @RideHrs
declare @RideHrs AS numeric
-- Execute SumRideHrsSingleDay function and store the result in @RideHrs
exec @RideHrs = dbo.SumRideHrsSingleDay @DateParm = '3/5/2018'
SELECT
  'Total Ride Hours for 3/5/2018:',
  @RideHrs
```

```sql
-- Create @StationStats
DECLARE @StationStats TABLE(
	StartStation nvarchar(100),
	RideCount int,
	TotalDuration numeric)
-- Populate @StationStats with the results of the function
INSERT INTO @StationStats
SELECT TOP 10 *
-- Execute SumStationStats with 3/15/2018
FROM dbo.SumStationStats ('3/15/2018')
ORDER BY RideCount DESC
-- Select all the records from @StationStats
SELECT *
FROM @StationStats
```

## Maintaing user defined Functions

change the function or modify using ALTER Function

```sql
alter function SumStationStats (@EndDate as datetime = '1/01/2017')
...
..
```
