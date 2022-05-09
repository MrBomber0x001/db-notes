# Working with Dates and Times

## Building dates

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

## formatting dates for reporting

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

## working with calender tables

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

# Converting to Dates and Times

I this chapter we will learn how to create dates

## Building Dates from parts

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

## Translating Date Strings

## working with offsets

## handling invalid Dates

# Aggregating Time Series Data

## Basic Aggregate function

## Statistical aggreate functionality

## Downsampling and upsampling date

## Grouping by Rollup, cube, grouping sets

# Answering Time Series Questions with Window Functions

## using aggregate functions over windows

## calculate running totals and moving averages

## Working with LAG() and LEAD()

## Finding maximum level of overlap

## Wrapping up
