## Working with Dates and Times

### Building dates

Execises 🧮

```sql
DECLARE
 @SomeTime DATETIME2(7) = SYSUTCDATETIME();

-- Retrieve the year, month, and day
SELECT
 Year(@SomeTime) AS TheYear,
 Month(@SomeTime) AS TheMonth,
 DAy(@SomeTime) AS TheDay;



DECLARE
 @BerlinWallFalls DATETIME2(7) = '1989-11-09 23:49:36.2294852';

-- Fill in each date part
SELECT
 DATEPART(year, @BerlinWallFalls) AS TheYear,
 DATEPART(month, @BerlinWallFalls) AS TheMonth,
 DATEPART(day, @BerlinWallFalls) AS TheDay,
 DATEPART(dayofyear, @BerlinWallFalls) AS TheDayOfYear,
    -- Day of week is WEEKDAY
 DATEPART(WEEKDAY, @BerlinWallFalls) AS TheDayOfWeek,
 DATEPART(week, @BerlinWallFalls) AS TheWeek,
 DATEPART(second, @BerlinWallFalls) AS TheSecond,
 DATEPART(nanosecond, @BerlinWallFalls) AS TheNanosecond;

DECLARE
 @BerlinWallFalls DATETIME2(7) = '1989-11-09 23:49:36.2294852';

-- Fill in the function to show the name of each date part
SELECT
 DATENAME(YEAR, @BerlinWallFalls) AS TheYear,
 DATENAME(MONTH, @BerlinWallFalls) AS TheMonth,
 DATENAME(DAY, @BerlinWallFalls) AS TheDay,
 DATENAME(DAYOFYEAR, @BerlinWallFalls) AS TheDayOfYear,
    -- Day of week is WEEKDAY
 DATENAME(WEEKDAY, @BerlinWallFalls) AS TheDayOfWeek,
 DATENAME(WEEK, @BerlinWallFalls) AS TheWeek,
 DATENAME(SECOND, @BerlinWallFalls) AS TheSecond,
 DATENAME(NANOSECOND, @BerlinWallFalls) AS TheNanosecond;

```

Dealing with leap years

```sql
DECLARE
 @LeapDay DATETIME2(7) = '2012-02-29 18:00:00';

-- Fill in the date parts and intervals as needed
SELECT
 DATEADD(DAY, -1, @LeapDay) AS PriorDay,
 DATEADD(DAY, 1, @LeapDay) AS NextDay,
    -- For leap years, we need to move 4 years, not just 1
 DATEADD(YEAR, -4, @LeapDay) AS PriorLeapYear,
 DATEADD(YEAR, 4, @LeapDay) AS NextLeapYear,
 DATEADD(Year, -1, @LeapDay) AS PriorYear;

 DECLARE
 @PostLeapDay DATETIME2(7) = '2012-03-01 18:00:00';

-- Fill in the date parts and intervals as needed
SELECT
 DATEADD(DAY, -1, @PostLeapDay) AS PriorDay,
 DATEADD(DAY, 1, @PostLeapDay) AS NextDay,
 DATEADD(YEAR, -4, @PostLeapDay) AS PriorLeapYear,
 DATEADD(YEAR, 4, @PostLeapDay) AS NextLeapYear,
 DATEADD(YEAR, -1, @PostLeapDay) AS PriorYear,
    -- Move 4 years forward and one day back
 DATEADD(day, -1, DATEADD(year, 4, @PostLeapDay)) AS NextLeapDay,
    DATEADD(day, -2, @PostLeapDay) AS TwoDaysAgo;


 DECLARE
 @PostLeapDay DATETIME2(7) = '2012-03-01 18:00:00',
    @TwoDaysAgo DATETIME2(7);

SELECT
 @TwoDaysAgo = DATEADD(DAY, -2, @PostLeapDay);

SELECT
 @TwoDaysAgo AS TwoDaysAgo,
 @PostLeapDay AS SomeTime,
    -- Fill in the appropriate function and date types
 Datediff(day, @TwoDaysAgo, @PostLeapDay) AS DaysDifference,
 Datediff(hour, @TwoDaysAgo, @PostLeapDay) AS HoursDifference,
 Datediff(minute, @TwoDaysAgo, @PostLeapDay) AS MinutesDifference;

```

Rounding dates
SQL Server does not have an intuitive way to round down to the month, hour, or minute. You can, however, combine the DATEADD() and DATEDIFF() functions to perform this rounding.
o round the date 1914-08-16 down to the year, we would call DATEADD(YEAR, DATEDIFF(YEAR, 0, '1914-08-16'), 0). To round that date down to the month, we would call DATEADD(MONTH, DATEDIFF(MONTH, 0, '1914-08-16'), 0). This works for several other date parts as well.

```sql
DECLARE
 @SomeTime DATETIME2(7) = '2018-06-14 16:29:36.2248991';

-- Fill in the appropriate functions and date parts
SELECT
 DATEADD(day, DATEDIFF(day, 0, @SomeTime), 0) AS RoundedToDay,
 DATEADD(hour, datediff(hour, 0, @SomeTime), 0) AS RoundedToHour,
 DATEADD(minute, datediff(minute, 0, @SomeTime), 0) AS RoundedToMinute;
```

### formatting dates for reporting

sql server has three formatting functions:
CAST()
FORMAT()
CONVERT()

using the Convert(): it takes datatype, input, optional style
FORMAT() is single threaded: (input, format code, optional culture)

```sql
DECLARE
 @CubsWinWorldSeries DATETIME2(3) = '2016-11-03 00:30:29.245',
 @OlderDateType DATETIME = '2016-11-03 00:30:29.245';

SELECT
 -- Fill in the missing function calls
 CAST(@CubsWinWorldSeries AS DATE) AS CubsWinDateForm,
 CAST(@CubsWinWorldSeries AS NVARCHAR(30)) AS CubsWinStringForm,
 CAST(@OlderDateType AS DATE) AS OlderDateForm,
 CAST(@OlderDateType AS NVARCHAR(30)) AS OlderStringForm;


 --example of inner and outer function casting
 DECLARE
 @CubsWinWorldSeries DATETIME2(3) = '2016-11-03 00:30:29.245';

SELECT
 CAST(CAST(@CubsWinWorldSeries AS DATE) AS NVARCHAR(30)) AS DateStringForm;



 --convert function
 DECLARE
 @CubsWinWorldSeries DATETIME2(3) = '2016-11-03 00:30:29.245';

SELECT
 CONVERT(DATE, @CubsWinWorldSeries) AS CubsWinDateForm,
 CONVERT(NVARCHAR(30), @CubsWinWorldSeries) AS CubsWinStringForm;

 --using optional style
 DECLARE
 @CubsWinWorldSeries DATETIME2(3) = '2016-11-03 00:30:29.245';

SELECT
 convert(NVARCHAR(30), @CubsWinWorldSeries, 0) AS DefaultForm,
 convert(NVARCHAR(30), @CubsWinWorldSeries, 3) AS UK_dmy,
 convert(NVARCHAR(30), @CubsWinWorldSeries, 1) AS US_mdy,
 convert(NVARCHAR(30), @CubsWinWorldSeries, 103) AS UK_dmyyyy,
 convert(NVARCHAR(30), @CubsWinWorldSeries, 101) AS US_mdyyyy;

 --using format
 DECLARE
 @Python3ReleaseDate DATETIME2(3) = '2008-12-03 19:45:00.033';

SELECT
 -- Fill in the function call and format parameter
 format(@Python3ReleaseDate, 'd', 'en-US') AS US_d,
 format(@Python3ReleaseDate, 'd', 'de-DE') AS DE_d,
 -- Fill in the locale for Japan
 format(@Python3ReleaseDate, 'd', 'jp-JP') AS JP_d,
 format(@Python3ReleaseDate, 'd', 'zh-cn') AS CN_d;

 DECLARE
 @Python3ReleaseDate DATETIME2(3) = '2008-12-03 19:45:00.033';

SELECT
 -- Fill in the format parameter
 FORMAT(@Python3ReleaseDate, 'D', 'en-US') AS US_D,
 FORMAT(@Python3ReleaseDate, 'D', 'de-DE') AS DE_D,
 -- Fill in the locale for Indonesia
 FORMAT(@Python3ReleaseDate, 'D', 'id-ID') AS ID_D,
 FORMAT(@Python3ReleaseDate, 'D', 'zh-cn') AS CN_D;

```

### working with calender tables

also knows as data dimensions
calender table: is a table that stores dates for easy retrieval
this is a table you build once and never update (nearly)
Afte building the table, you can easily retrieve data from it

```sql
SELECT c.Date FROM dbo.Calender
where
 c.MonthName = 'April'
 AND c.DayName = 'Saturday'
 AND c.CalenderYear = '2020'
order by
c.Date

-- Find fiscal week 29 of fiscal year 2019
SELECT
 c.Date
FROM dbo.Calendar c
WHERE
    -- Instead of month, use the fiscal week
 c.FiscalWeekOfYear = 29
    -- Instead of calendar year, use fiscal year
 AND c.FiscalYear = 2019
ORDER BY
 c.Date ASC;
```

Apply() opertor: it excuete a function for each row on the result set, it simplifed calculations
look at the slides, very important

we can use Calendar table to join other tables 🏓 :

```sql
SELECT
 ir.IncidentDate,
 c.FiscalDayOfYear,
 c.FiscalWeekOfYear
FROM dbo.IncidentRollup ir
 INNER JOIN dbo.Calendar c
  ON ir.IncidentDate = c.Date
WHERE
    -- Incident type 4
 ir.IncidentTypeID = 4
    -- Fiscal year 2019
 AND c.FiscalYear = 2019
    -- Beyond fiscal week of year 30
 AND c.FiscalWeekOfYear > 30
    -- Only return weekends
 AND c.IsWeekend = 1;
```

## Converting to Dates and Times

I this chapter we will learn how to create dates

### Building Dates from parts

SQL Server has six function to build dates and times from component parts "the from parts series"
look at the slides

If any of your input is null, the result will be null

```sql
SELECT TOP(10)
 c.CalendarQuarterName,
 c.MonthName,
 c.CalendarDayOfYear
FROM dbo.Calendar c
WHERE
 -- Create dates from component parts
 DATEFROMPARTS(c.CalendarYear, c.CalendarMonth, c.Day) >= '2018-06-01'
 AND c.DayName = 'Tuesday'
ORDER BY
 c.FiscalYear,
 c.FiscalDayOfYear ASC;
```

exercise: Build data that Neil armstrong landed the moon at [date]

```sql
SELECT
 -- Mark the date and time the lunar module touched down
    -- Use 24-hour notation for hours, so e.g., 9 PM is 21
 DATETIME2FROMPARTS(1969, 07, 20, 20, 17, 00, 000, 0) AS TheEagleHasLanded,
 -- Mark the date and time the lunar module took back off
    -- Use 24-hour notation for hours, so e.g., 9 PM is 21
 DATETIMEFROMPARTS(1969, 07, 21, 18, 54, 00, 000) AS MoonDeparture;
```

```sql
SELECT
 -- Fill in the millisecond PRIOR TO chaos
 DATETIMEOFFSETFROMPARTS(2038, 01, 19, 03, 14, 07, 999, 0, 0, 3) AS LastMoment,
    -- Fill in the date and time when we will experience the Y2.038K problem
    -- Then convert to the Eastern Standard Time time zone
 DATETIMEOFFSETFROMPARTS(2038, 01, 19, 03, 14, 08, 0, 0, 0, 3) AT TIME ZONE 'Eastern Standard Time' AS TimeForChaos;
```

### Translating Date Strings

```sql

SELECT
 d.DateText AS String,
 -- Cast as DATE
 CAST(d.DateText AS DATE) AS StringAsDate,
 -- Cast as DATETIME2(7)
 CAST(d.DateText AS DATETIME2(7)) AS StringAsDateTime2
FROM dbo.Dates d;

```

```sql
SET LANGUAGE 'GERMAN'

SELECT
 d.DateText AS String,
 -- Convert to DATE
 CONVERT(DATE, d.DateText) AS StringAsDate,
 -- Convert to DATETIME2(7)
 CONVERT(DATETIME2(7), d.DateText) AS StringAsDateTime2
FROM dbo.Dates d;

```

```sql
SELECT
 d.DateText AS String,
 -- Parse as DATE using German
 PARSE(d.DateText AS DATE USING 'de-de') AS StringAsDate,
 -- Parse as DATETIME2(7) using German
 PARSE(d.DateText AS DATETIME2(7) USING 'de-de') AS StringAsDateTime2
FROM dbo.Dates d;
```

### working with offsets

```sql
DECLARE
 @OlympicsUTC NVARCHAR(50) = N'2016-08-08 23:00:00';

SELECT
 -- Fill in the time zone for Brasilia, Brazil
 SWITCHOFFSET(@OlympicsUTC, '-03:00') AS BrasiliaTime,
 -- Fill in the time zone for Chicago, Illinois
 SWITCHOFFSET(@OlympicsUTC, '-05:00') AS ChicagoTime,
 -- Fill in the time zone for New Delhi, India
 SWITCHOFFSET(@OlympicsUTC, '+05:30') AS NewDelhiTime;
```

```sql
DECLARE
 @OlympicsClosingUTC DATETIME2(0) = '2016-08-21 23:00:00';

SELECT
 -- Fill in 7 hours back and a '-07:00' offset
 TODATETIMEOFFSET(DATEADD(HOUR, -7, @OlympicsClosingUTC), '-07:00') AS PhoenixTime,
 -- Fill in 12 hours forward and a '+12:00' offset.  
 TODATETIMEOFFSET(DATEADD(HOUR, 12, @OlympicsClosingUTC), '+12:00') AS TuvaluTime;
```

### handling invalid Dates

```sql
DECLARE
 @GoodDateINTL NVARCHAR(30) = '2019-03-01 18:23:27.920',
 @GoodDateDE NVARCHAR(30) = '13.4.2019',
 @GoodDateUS NVARCHAR(30) = '4/13/2019',
 @BadDate NVARCHAR(30) = N'SOME BAD DATE';

SELECT
 -- Fill in the correct data type based on our input
 TRY_CONVERT(DATETIME2(3), @GoodDateINTL) AS GoodDateINTL,
 -- Fill in the correct function
 TRY_CONVERT(DATE, @GoodDateDE) AS GoodDateDE,
 TRY_CONVERT(DATE, @GoodDateUS) AS GoodDateUS,
 -- Fill in the correct input parameter for BadDate
 TRY_CONVERT(DATETIME2(3), @BadDate) AS BadDate;
```

```sql
DECLARE
 @GoodDateINTL NVARCHAR(30) = '2019-03-01 18:23:27.920',
 @GoodDateDE NVARCHAR(30) = '13.4.2019',
 @GoodDateUS NVARCHAR(30) = '4/13/2019',
 @BadDate NVARCHAR(30) = N'SOME BAD DATE';

-- The prior solution using TRY_CONVERT
SELECT
 TRY_CONVERT(DATETIME2(3), @GoodDateINTL) AS GoodDateINTL,
 TRY_CONVERT(DATE, @GoodDateDE) AS GoodDateDE,
 TRY_CONVERT(DATE, @GoodDateUS) AS GoodDateUS,
 TRY_CONVERT(DATETIME2(3), @BadDate) AS BadDate;

SELECT
 -- Fill in the correct data type based on our input
 TRY_CAST(@GoodDateINTL AS DATETIME2(3)) AS GoodDateINTL,
    -- Be sure to match these data types with the
    -- TRY_CONVERT() examples above!
 TRY_CAST(@GoodDateDE AS DATE) AS GoodDateDE,
 TRY_CAST(@GoodDateUS AS DATE) AS GoodDateUS,
 TRY_CAST(@BadDate AS DATETIME2(3)) AS BadDate;
```

```sql
DECLARE
 @GoodDateINTL NVARCHAR(30) = '2019-03-01 18:23:27.920',
 @GoodDateDE NVARCHAR(30) = '13.4.2019',
 @GoodDateUS NVARCHAR(30) = '4/13/2019',
 @BadDate NVARCHAR(30) = N'SOME BAD DATE';

-- The prior solution using TRY_CAST
SELECT
 TRY_CAST(@GoodDateINTL AS DATETIME2(3)) AS GoodDateINTL,
 TRY_CAST(@GoodDateDE AS DATE) AS GoodDateDE,
 TRY_CAST(@GoodDateUS AS DATE) AS GoodDateUS,
 TRY_CAST(@BadDate AS DATETIME2(3)) AS BadDate;

SELECT
 TRY_PARSE(@GoodDateINTL AS DATETIME2(3)) AS GoodDateINTL,
    -- Fill in the correct region based on our input
    -- Be sure to match these data types with the
    -- TRY_CAST() examples above!
 TRY_PARSE(@GoodDateDE AS DATE USING 'de-de') AS GoodDateDE,
 TRY_PARSE(@GoodDateUS AS DATE USING 'en-us') AS GoodDateUS,
    -- TRY_PARSE can't fix completely invalid dates
 TRY_PARSE(@BadDate AS DATETIME2(3) USING 'sk-sk') AS BadDate;
```

```sql
WITH EventDates AS
(
    SELECT
        -- Fill in the missing try-conversion function
        TRY_CONVERT(DATETIME2(3), it.EventDate) AT TIME ZONE it.TimeZone AS EventDateOffset,
        it.TimeZone
    FROM dbo.ImportedTime it
        INNER JOIN sys.time_zone_info tzi
   ON it.TimeZone = tzi.name
)
SELECT
    -- Fill in the approppriate event date to convert
 CONVERT(NVARCHAR(50), ed.EventDateOffset) AS EventDateOffsetString,
 CONVERT(DATETIME2(0), ed.EventDateOffset) AS EventDateLocal,
 ed.TimeZone,
    -- Convert from a DATETIMEOFFSET to DATETIME at UTC
 CAST(ed.EventDateOffset AT TIME ZONE 'UTC' AS DATETIME2(0)) AS EventDateUTC,
    -- Convert from a DATETIMEOFFSET to DATETIME with time zone
 CAST(ed.EventDateOffset AT TIME ZONE 'US Eastern Standard Time'  AS DATETIME2(0)) AS EventDateUSEast
FROM EventDates ed;
```

```sql
-- Try out how fast the TRY_CAST() function is
-- by try-casting each DateText value to DATE
DECLARE @StartTimeCast DATETIME2(7) = SYSUTCDATETIME();
SELECT TRY_CAST(DateText AS DATE) AS TestDate FROM #DateText;
DECLARE @EndTimeCast DATETIME2(7) = SYSUTCDATETIME();

-- Determine how much time the conversion took by
-- calculating the date difference from @StartTimeCast to @EndTimeCast
SELECT
    DATEDIFF(MILLISECOND, @StartTimeCast, @EndTimeCast) AS ExecutionTimeCast;
```

```sql
-- Try out how fast the TRY_PARSE() function is
-- by try-parsing each DateText value to DATE
DECLARE @StartTimeParse DATETIME2(7) = SYSUTCDATETIME();
SELECT TRY_PARSE(DateText AS DATE) AS TestDate FROM #DateText;
DECLARE @EndTimeParse DATETIME2(7) = SYSUTCDATETIME();

-- Determine how much time the conversion took by
-- calculating the difference from start time to end time
SELECT
    DATEDIFF(MILLISECOND, @StartTimeParse, @EndTimeParse) AS ExecutionTimeParse;
```

## Aggregating Time Series Data

### Basic Aggregate function

#### Exercise

```sql
-- Fill in the appropriate aggregate functions
SELECT
 it.IncidentType,
 COUNT(1) AS NumberOfRows,
 SUM(ir.NumberOfIncidents) AS TotalNumberOfIncidents,
 MIN(ir.NumberOfIncidents) AS MinNumberOfIncidents,
 MAX(ir.NumberOfIncidents) AS MaxNumberOfIncidents,
 MIN(ir.IncidentDate) As MinIncidentDate,
 MAX(ir.IncidentDate) AS MaxIncidentDate
FROM dbo.IncidentRollup ir
 INNER JOIN dbo.IncidentType it
  ON ir.IncidentTypeID = it.IncidentTypeID
WHERE
 ir.IncidentDate BETWEEN '2019-08-01' AND '2019-10-31'
GROUP BY
 it.IncidentType;

```

```sql
-- Fill in the functions and columns
SELECT
 COUNT(DISTINCT ir.IncidentTypeID) AS NumberOfIncidentTypes,
 COUNT(DISTINCT ir.IncidentDate) AS NumberOfDaysWithIncidents
FROM dbo.IncidentRollup ir
WHERE
ir.IncidentDate BETWEEN '2019-08-01' AND '2019-10-31';
```

```sql
SELECT
 it.IncidentType,
    -- Fill in the appropriate expression
 SUM(CASE WHEN ir.NumberOfIncidents > 5 THEN 1 ELSE 0 END) AS NumberOfBigIncidentDays,
    -- Number of incidents will always be at least 1, so
    -- no need to check the minimum value, just that it's
    -- less than or equal to 5
    SUM(CASE WHEN ir.NumberOfIncidents <= 5 THEN 1 ELSE 0 END) AS NumberOfSmallIncidentDays
FROM dbo.IncidentRollup ir
 INNER JOIN dbo.IncidentType it
  ON ir.IncidentTypeID = it.IncidentTypeID
WHERE
 ir.IncidentDate BETWEEN '2019-08-01' AND '2019-10-31'
GROUP BY
it.IncidentType;
```

### Statistical aggreate functionality

#### Exercise

```sql
-- Fill in the missing function names
SELECT
 it.IncidentType,
 AVG(ir.NumberOfIncidents) AS MeanNumberOfIncidents,
 AVG(CAST(ir.NumberOfIncidents AS DECIMAL(4,2))) AS MeanNumberOfIncidents,
 STDEV(ir.NumberOfIncidents) AS NumberOfIncidentsStandardDeviation,
 VAR(ir.NumberOfIncidents) AS NumberOfIncidentsVariance,
 COUNT(1) AS NumberOfRows
FROM dbo.IncidentRollup ir
 INNER JOIN dbo.IncidentType it
  ON ir.IncidentTypeID = it.IncidentTypeID
 INNER JOIN dbo.Calendar c
  ON ir.IncidentDate = c.Date
WHERE
 c.CalendarQuarter = 2
 AND c.CalendarYear = 2020
GROUP BY
it.IncidentType;
```

```sql
SELECT DISTINCT
 it.IncidentType,
 AVG(CAST(ir.NumberOfIncidents AS DECIMAL(4,2)))
     OVER(PARTITION BY it.IncidentType) AS MeanNumberOfIncidents,
    --- Fill in the missing value
 PERCENTILE_CONT(0.5)
     -- Inside our group, order by number of incidents DESC
     WITHIN GROUP (ORDER BY ir.NumberOfIncidents DESC)
        -- Do this for each IncidentType value
        OVER (PARTITION BY it.IncidentType) AS MedianNumberOfIncidents,
 COUNT(1) OVER (PARTITION BY it.IncidentType) AS NumberOfRows
FROM dbo.IncidentRollup ir
 INNER JOIN dbo.IncidentType it
  ON ir.IncidentTypeID = it.IncidentTypeID
 INNER JOIN dbo.Calendar c
  ON ir.IncidentDate = c.Date
WHERE
 c.CalendarQuarter = 2
 AND c.CalendarYear = 2020;
```

### Downsampling and upsampling date

#### Exercise

```sql
SELECT
 -- Downsample to a daily grain
    -- Cast CustomerVisitStart as a date
 CAST(dsv.CustomerVisitStart AS DATE) AS Day,
 SUM(dsv.AmenityUseInMinutes) AS AmenityUseInMinutes,
 COUNT(1) AS NumberOfAttendees
FROM dbo.DaySpaVisit dsv
WHERE
 dsv.CustomerVisitStart >= '2020-06-11'
 AND dsv.CustomerVisitStart < '2020-06-23'
GROUP BY
 -- When we use aggregation functions like SUM or COUNT,
    -- we need to GROUP BY the non-aggregated columns
 CAST(dsv.CustomerVisitStart AS DATE)
ORDER BY
 Day;
```

```sql
SELECT
 -- Downsample to a weekly grain
 DATEPART(WEEK, dsv.CustomerVisitStart) AS Week,
 SUM(dsv.AmenityUseInMinutes) AS AmenityUseInMinutes,
 -- Find the customer with the largest customer ID for that week
 MAX(dsv.CustomerID) AS HighestCustomerID,
 COUNT(1) AS NumberOfAttendees
FROM dbo.DaySpaVisit dsv
WHERE
 dsv.CustomerVisitStart >= '2020-01-01'
 AND dsv.CustomerVisitStart < '2021-01-01'
GROUP BY
 -- When we use aggregation functions like SUM or COUNT,
    -- we need to GROUP BY the non-aggregated columns
 DATEPART(WEEK, dsv.CustomerVisitStart)
ORDER BY
 Week;
```

```sql
SELECT
 -- Determine the week of the calendar year
 c.CalendarWeekOfYear,
 -- Determine the earliest DATE in this group
    -- This is NOT the DayOfWeek column
 MIN(c.Date) AS FirstDateOfWeek,
 ISNULL(SUM(dsv.AmenityUseInMinutes), 0) AS AmenityUseInMinutes,
 ISNULL(MAX(dsv.CustomerID), 0) AS HighestCustomerID,
 COUNT(dsv.CustomerID) AS NumberOfAttendees
FROM dbo.Calendar c
 LEFT OUTER JOIN dbo.DaySpaVisit dsv
  -- Connect dbo.Calendar with dbo.DaySpaVisit
  -- To join on CustomerVisitStart, we need to turn 
        -- it into a DATE type
  ON c.Date = CAST(dsv.CustomerVisitStart AS DATE)
WHERE
 c.CalendarYear = 2020
GROUP BY
 -- When we use aggregation functions like SUM or COUNT,
    -- we need to GROUP BY the non-aggregated columns
 c.CalendarWeekOfYear
ORDER BY
 c.CalendarWeekOfYear;
```

### Grouping by Rollup, cube, grouping sets

#### Exercise

```sql
SELECT
 c.CalendarYear,
 c.CalendarQuarterName,
 c.CalendarMonth,
    -- Include the sum of incidents by day over each range
 SUM(ir.NumberOfIncidents) AS NumberOfIncidents
FROM dbo.IncidentRollup ir
 INNER JOIN dbo.Calendar c
  ON ir.IncidentDate = c.Date
WHERE
 ir.IncidentTypeID = 2
GROUP BY
 -- GROUP BY needs to include all non-aggregated columns
 c.CalendarYear,
 c.CalendarQuarterName,
 c.CalendarMonth
-- Fill in your grouping operator
WITH ROLLUP
ORDER BY
 c.CalendarYear,
 c.CalendarQuarterName,
 c.CalendarMonth;
```

```sql
SELECT
 -- Use the ORDER BY clause as a guide for these columns
    -- Don't forget that comma after the third column if you
    -- copy from the ORDER BY clause!
 ir.IncidentTypeID,
 c.CalendarQuarterName,
 c.WeekOfMonth,
 SUM(ir.NumberOfIncidents) AS NumberOfIncidents
FROM dbo.IncidentRollup ir
 INNER JOIN dbo.Calendar c
  ON ir.IncidentDate = c.Date
WHERE
 ir.IncidentTypeID IN (3, 4)
GROUP BY
 -- GROUP BY should include all non-aggregated columns
 ir.IncidentTypeID,
 c.CalendarQuarterName,
 c.WeekOfMonth
-- Fill in your grouping operator
WITH CUBE
ORDER BY
 ir.IncidentTypeID,
 c.CalendarQuarterName,
 c.WeekOfMonth;
```

```sql
SELECT
 c.CalendarYear,
 c.CalendarQuarterName,
 c.CalendarMonth,
 SUM(ir.NumberOfIncidents) AS NumberOfIncidents
FROM dbo.IncidentRollup ir
 INNER JOIN dbo.Calendar c
  ON ir.IncidentDate = c.Date
WHERE
 ir.IncidentTypeID = 2
-- Fill in your grouping operator here
GROUP BY GROUPING SETS
(
   -- Group in hierarchical order:  calendar year,
    -- calendar quarter name, calendar month
 (c.CalendarYear, c.CalendarQuarterName, c.CalendarMonth),
   -- Group by calendar year
 (c.CalendarYear),
    -- This remains blank; it gives us the grand total
 ()
)
ORDER BY
 c.CalendarYear,
 c.CalendarQuarterName,
 c.CalendarMonth;
```

```sql
SELECT
 c.CalendarYear,
 c.CalendarMonth,
 c.DayOfWeek,
 c.IsWeekend,
 SUM(ir.NumberOfIncidents) AS NumberOfIncidents
FROM dbo.IncidentRollup ir
 INNER JOIN dbo.Calendar c
  ON ir.IncidentDate = c.Date
GROUP BY GROUPING SETS
(
    -- Each non-aggregated column from above should appear once
   -- Calendar year and month
 (c.CalendarYear, c.CalendarMonth),
   -- Day of week
 (c.DayOfWeek),
   -- Is weekend or not
 (c.IsWeekend),
    -- This remains empty; it gives us the grand total
 ()
)
ORDER BY
 c.CalendarYear,
 c.CalendarMonth,
 c.DayOfWeek,
 c.IsWeekend;
```

## Answering Time Series Questions with Window Functions

### using aggregate functions over windows

#### Exercise

```sql
SELECT
 ir.IncidentDate,
 ir.NumberOfIncidents,
    -- Fill in each window function and ordering
 -- Note that all of these are in descending order!
 ROW_NUMBER() OVER (ORDER BY ir.NumberOfIncidents DESC) AS rownum,
 RANK() OVER (ORDER BY ir.NumberOfIncidents DESC) AS rk,
 DENSE_RANK() OVER (ORDER BY ir.NumberOfIncidents DESC) AS dr
FROM dbo.IncidentRollup ir
WHERE
 ir.IncidentTypeID = 3
 AND ir.NumberOfIncidents >= 8
ORDER BY
 ir.NumberOfIncidents DESC;
```

```sql
SELECT
 ir.IncidentDate,
 ir.NumberOfIncidents,
    -- Fill in the correct aggregate functions
    -- You do not need to fill in the OVER clause
 SUM(ir.NumberOfIncidents) OVER () AS SumOfIncidents,
 MIN(ir.NumberOfIncidents) OVER () AS LowestNumberOfIncidents,
 MAX(ir.NumberOfIncidents) OVER () AS HighestNumberOfIncidents,
 COUNT(ir.NumberOfIncidents) OVER () AS CountOfIncidents
FROM dbo.IncidentRollup ir
WHERE
 ir.IncidentDate BETWEEN '2019-07-01' AND '2019-07-31'
AND ir.IncidentTypeID = 3;
```

### calculate running totals and moving averages

#### Exercise

```sql
SELECT
 ir.IncidentDate,
 ir.IncidentTypeID,
 ir.NumberOfIncidents,
    -- Get the total number of incidents
 SUM(ir.NumberOfIncidents) OVER (
       -- Do this for each incident type ID
  PARTITION BY ir.IncidentTypeID
       -- Sort by the incident date
  ORDER BY ir.IncidentDate
 ) AS NumberOfIncidents
FROM dbo.IncidentRollup ir
 INNER JOIN dbo.Calendar c
  ON ir.IncidentDate = c.Date
WHERE
 c.CalendarYear = 2019
 AND c.CalendarMonth = 7
 AND ir.IncidentTypeID IN (1, 2)
ORDER BY
 ir.IncidentTypeID,
 ir.IncidentDate; 
```

```sql
SELECT
 ir.IncidentDate,
 ir.IncidentTypeID,
 ir.NumberOfIncidents,
    -- Fill in the correct window function
 AVG(ir.NumberOfIncidents) OVER (
  PARTITION BY ir.IncidentTypeID
  ORDER BY ir.IncidentDate
       -- Fill in the three parts of the window frame
  ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
 ) AS MeanNumberOfIncidents
FROM dbo.IncidentRollup ir
 INNER JOIN dbo.Calendar c
  ON ir.IncidentDate = c.Date
WHERE
 c.CalendarYear = 2019
 AND c.CalendarMonth IN (7, 8)
 AND ir.IncidentTypeID = 1
ORDER BY
 ir.IncidentTypeID,
 ir.IncidentDate;
```

### Working with LAG() and LEAD()

#### Exercise

```sql
SELECT
 ir.IncidentDate,
 ir.IncidentTypeID,
    -- Get the prior day's number of incidents
 LAG(ir.NumberOfIncidents, 1) OVER (
       -- Partition by incident type ID
  PARTITION BY ir.IncidentTypeID
       -- Order by incident date
  ORDER BY ir.IncidentDate
 ) AS PriorDayIncidents,
 ir.NumberOfIncidents AS CurrentDayIncidents,
    -- Get the next day's number of incidents
 LEAD(ir.NumberOfIncidents, 1) OVER (
       -- Partition by incident type ID
  PARTITION BY ir.IncidentTypeID
       -- Order by incident date
  ORDER BY ir.IncidentDate
 ) AS NextDayIncidents
FROM dbo.IncidentRollup ir
WHERE
 ir.IncidentDate >= '2019-07-02'
 AND ir.IncidentDate <= '2019-07-31'
 AND ir.IncidentTypeID IN (1, 2)
ORDER BY
 ir.IncidentTypeID,
 ir.IncidentDate;
```

```sql
SELECT
 ir.IncidentDate,
 ir.IncidentTypeID,
    -- Fill in two periods ago
 LAG(ir.NumberOfIncidents, 2) OVER (
  PARTITION BY ir.IncidentTypeID
  ORDER BY ir.IncidentDate
 ) AS Trailing2Day,
    -- Fill in one period ago
 LAG(ir.NumberOfIncidents, 1) OVER (
  PARTITION BY ir.IncidentTypeID
  ORDER BY ir.IncidentDate
 ) AS Trailing1Day,
 ir.NumberOfIncidents AS CurrentDayIncidents,
    -- Fill in next period
 LEAD(ir.NumberOfIncidents, 1) OVER (
  PARTITION BY ir.IncidentTypeID
  ORDER BY ir.IncidentDate
 ) AS NextDay
FROM dbo.IncidentRollup ir
WHERE
 ir.IncidentDate >= '2019-07-01'
 AND ir.IncidentDate <= '2019-07-31'
 AND ir.IncidentTypeID IN (1, 2)
ORDER BY
 ir.IncidentTypeID,
 ir.IncidentDate;
```

```sql
SELECT
 ir.IncidentDate,
 ir.IncidentTypeID,
    -- Fill in the days since last incident
 DATEDIFF(DAY, LAG(ir.IncidentDate, 1) OVER (
  PARTITION BY ir.IncidentTypeID
  ORDER BY ir.IncidentDate
 ), ir.IncidentDate) AS DaysSinceLastIncident,
    -- Fill in the days until next incident
 DATEDIFF(DAY, ir.IncidentDate, LEAD(ir.IncidentDate, 1) OVER (
  PARTITION BY ir.IncidentTypeID
  ORDER BY ir.IncidentDate
 )) AS DaysUntilNextIncident
FROM dbo.IncidentRollup ir
WHERE
 ir.IncidentDate >= '2019-07-02'
 AND ir.IncidentDate <= '2019-07-31'
 AND ir.IncidentTypeID IN (1, 2)
ORDER BY
 ir.IncidentTypeID,
 ir.IncidentDate;
```

### Finding maximum level of overlap

#### Exercise

```sql
-- This section focuses on entrances:  CustomerVisitStart
SELECT
 dsv.CustomerID,
 dsv.CustomerVisitStart AS TimeUTC,
 1 AS EntryCount,
    -- We want to know each customer's entrance stream
    -- Get a unique, ascending row number
 ROW_NUMBER() OVER (
      -- Break this out by customer ID
      PARTITION BY dsv.CustomerID
      -- Ordered by the customer visit start date
      ORDER BY dsv.CustomerVisitStart
    ) AS StartOrdinal
FROM dbo.DaySpaVisit dsv
UNION ALL
-- This section focuses on departures:  CustomerVisitEnd
SELECT
 dsv.CustomerID,
 dsv.CustomerVisitEnd AS TimeUTC,
 -1 AS EntryCount,
 NULL AS StartOrdinal
FROM dbo.DaySpaVisit dsv
```

```sql
SELECT s.*,
    -- Build a stream of all check-in and check-out events
 ROW_NUMBER() OVER (
      -- Break this out by customer ID
      PARTITION BY s.CustomerID
      -- Order by event time and then the start ordinal
      -- value (in case of exact time matches)
      ORDER BY s.TimeUTC, s.StartOrdinal
    ) AS StartOrEndOrdinal
FROM #StartStopPoints s;
```

```sql
SELECT
 s.CustomerID,
 MAX(2 * s.StartOrdinal - s.StartOrEndOrdinal) AS MaxConcurrentCustomerVisits
FROM #StartStopOrder s
WHERE s.EntryCount = 1
GROUP BY s.CustomerID
-- The difference between 2 * start ordinal and the start/end
-- ordinal represents the number of concurrent visits
HAVING MAX(2 * s.StartOrdinal - s.StartOrEndOrdinal) > 2
-- Sort by the largest number of max concurrent customer visits
ORDER BY MaxConcurrentCustomerVisits DESC;
```

## Wrapping up
