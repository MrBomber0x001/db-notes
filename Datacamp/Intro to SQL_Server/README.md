# Intro

This is T-SQL (Microsoft implementation of SQL);

## SELECTION

The most important thing you need to know about `SELECT` is it doesn't affect the query.
- `TOP` 
```sql
-- Returns 5 rows 
select TOP(5) name from people

-- Returns 5% of rows 
select TOP(5) PERCENT name from people
```

- `DISTINCT`
if you use DISTINCT with two or more columns, it will return each unique combination of values

- `*`
Return everything, but not suitable for production or large tables, it's recommended to specifiy columns names
```sql
select * from people;
```


- Ordering
Queries return setws, or subsets, 
sets have no inherent order.
so running

```sql
select * from people
```

will return different order for each time we run it.

we can order by any column, even if it does not appear on the select part of the query.

```sql
-- Select the top 20 rows from description, nerc_region and event_date
SELECT 
  TOP (20) description,
  nerc_region,
  event_date
FROM 
  grid 
  -- Order by nerc_region, affected_customers & event_date
  -- Event_date should be in descending order
ORDER BY
  nerc_region,
  affected_customers,
   event_date desc;
```

-- Select all artists beginning with B who released tracks in 1986, but also retrieve any records where the release_year is greater than 1990

```sql
SELECT 
  artist, 
  release_year, 
  song 
FROM 
  songlist 
  -- Choose the correct artist and specify the release year
WHERE 
  (
    artist LIKE 'B%' 
    And release_year = 1986
  ) 
  -- Or return all songs released after 1990
  or release_year > 1990  
  -- Order the results
ORDER BY 
  release_year, 
  artist, 
  song;
```

## GROUPS, SORTING, COUNTING, STRINGS

- GROUPS

when using aggregate functions, every column you use in the select needs to be in an aggregate function, or will be used as grouping column.

e.g the following query will return an error
```sql
select sum(affected_customers) as total_affected,
(demand_loss_nw) as total_loss
from grid;
```
so be careful when using aggregate functions.

- STRINGS
working with strings in T-SQL is common, so take your time to master it, because you will need it alot.

- `LEN(column)`
returns the length of a string
```sql
select name,
LEN(name) as name_length
from people 
```

| name | name_length | 
|--|--|
| yousef | 6 |
| bassant | 7 |

It's useful to know the total length of a string, as a starting point for use in other string calculations.
T-SQL provide many methods for manipulating strings in very easy manner

- `LEFT(column, number_of_char)` 
extract number of characters from beginning of a string

```sql
SELECT description,
LEFT(description, 20)
from grid
```

| description | first_20_left |
|-------------------------------|-----------------------|
| Severe Weather Thunderstorms | Severe Weather Thun |
| Severe Weather Thunderstorms | Severe Weather Thun |
| Severe Weather Thunderstorms | Severe Weather Thun |
| Fuel Supply Emergency Coal | Fuel Supply Emergenc |
| Physical Attack Vandalism | Physical Attack Van |
Severe Weather Thunderstorms | Severe Weather Thun


- RIGHT (extract number of characters from beginning of a string)

- `CHARINDEX(char or pattern, column)`
help us find specific character index within a string
or to be more precised, it returns the first index occurance of the given char or pattern


```sql
SELECT CHARINDEX('_', url) as char)location,
url
FROM courses;
```

| char_location | url |
|---------------|-------------------------------------|
| 34 | datacamp.com/courses/introduction_ |
| 34 | datacamp.com/courses/intermediate_ |
| 29 | datacamp.com/courses/writing_ |
| 29 | datacamp.com/courses/joining_ |
| 27 | datacamp.com/courses/intro_ |

- SUBSTRING(column, start, end)
sometimes we need to extract from middle of string as opposed to right or left.
substring method comes to rescue!

```sql
SELECT substring(url, 12, 12) as target_section,
urls
from courses;
```

| target_section | url |
|------------------|----------------------------------|
| datacamp.com |https//www.datacamp.com/courses |

- `REPLACE(column, charToBeReplaced, charToReplaceWith)`

```sql
SELECT TOP(5) REPLACE(url, '_', '-') as replace_with_hyphen
FROM courses;
```

| replace_with_hyphen |
|-------------------------------------|
| datacamp.com/courses/introduction- |
| datacamp.com/courses/intermediate- |
| datacamp.com/courses/writing- |
| datacamp.com/courses/joining- |
| datacamp.com/courses/intro- |

##### some exercises

-- select `Weather` from a description column
Before writing any sql query, wether it seems complex of simple.
Divide the query into smaller steps you can take first. then conquer the rest one after the other.

for this query, we need to get slice the string, from the first character to the length of word `Weather`

1. find the first index of Weather
2. calculate the length of the word
3. use substring to extract the word

```sql
SELECT top(10)description, 
CHARINDEX(
  'Weather', description
) as start_of_string,
LEN('Weather') as length_of_string,
SUBSTRING(description, CHARINDEX('Weather', description), LEN('Weather')) as word,
SUBSTRING(description, 15, LEN(description)) as additional_description
from grid
where description like '%Weather%';
```

- Gouping
When we write a `WHERE` Clause, the filtering takes place on the row level - that is, within the data.

Where is used to filter rows before any grouping occurs

but what if we need to sum values based on groups?

`GROUP BY` and `Having` come to rescue.

#### simple exercise

notice the order of statements
`ORDER BY` always comes last
`Having` after `GROUP BY`

```sql
SELECT 
  country, 
  COUNT (country) AS country_count, 
  AVG (place) AS avg_place, 
  AVG (points) AS avg_points, 
  MIN (points) AS min_points, 
  MAX (points) AS max_points 
FROM 
  eurovision 
GROUP BY 
  country 
  -- The country column should only contain those with a count greater than 5
having 
  count(country) > 5 
  -- Arrange columns in the correct order
ORDER BY 
  avg_place, 
  avg_points desc;
```

## JOINS

I have dedicated notes for joins, you can refer to better than this.



## DDL and DML statements

- DDL

- `CREATE` 
You have to consider some points when creating a table

- table and column names
- Type of data each column will store
- Size or amount of data stored in the column

```sql
-- Create the table
CREATE TABLE results (
	-- Create track column
	track VARCHAR(200),
    -- Create artist column
	artist VARCHAR(120),
    -- Create album column
	album VARCHAR(160),
	-- Create track_length_mins
	track_length_mins INT,
);
-- Select all columns from the table
SELECT 
  track, 
  artist, 
  album, 
  track_length_mins 
FROM 
  results;
```

- `INSERT` 
used to add or append data.
```sql
insert into person (name, email, password) values ('yousef', 'yousefmeska123@gmail.com', 'password1233232323')
```
`INSERT SELECT` statement
Inserting from table into another table.

```sql
INSERT INTO TABLE_NAME (COL1, COL2, COL3)
SELECT 
column1, 
column2, 
column3
FROM other_TABLE
WHERE
    -- condition apply
```
- Don't use `SELECT *`
- Be specific in case table structure changes

- `UPDATE`
```sql
UPDATE table_name
SET column = value
WHERE
    -- please, please don't forget the condition(s);
```

- `DELETE`
Deleting happend immediately, so there is no confirmation message when deleting, be careful

```sql
DELETE
FROM table_name
WHERE 
    -- condition(s)
```

-`TRUNCATE`
Clears the entire table at once

```sql
TRUNCATE TABLE table_name
```

there are some differences between truncate and delete, I will come to it later.

##### Declaring Variables And temporary tables

to avoid repetition, create a variable

`DECLARE`

```sql
DECLARE @test_int INT
DECLARE @my_artist VARCHAR(100)
SET @test_int = 4;
SET @my_artist = 'Yousef'

SELECT ___ FROM __ 
WHERE artist = @my_artist
```

- Temporary Table:
Sometimes you might want to 'save' the results of a query so you can do some more work with the data
A table we can create for 'our session' only, to do some querying on it further, we can manually drop it.

```sql 
SELECT col1,
col2, 
col3 INTO #my_temp_table
FROM my_existing_table

WHERE 
    -- conditions 
```

```sql
DROP TABLE #my_temp_table
```


###### some exerices
```sql
-- Declare your variables
DECLARE @start DATE
DECLARE @stop DATE
DECLARE @affected INT;
-- SET the relevant values for each variable
SET @start = '2014-01-24'
SET @stop  = '2014-07-02'
SET @affected =  5000 ;

SELECT 
  description,
  nerc_region,
  demand_loss_mw,
  affected_customers
FROM 
  grid
-- Specify the date range of the event_date and the value for @affected
where event_date Between @start AND @stop
AND affected_customers >= @affected;
```

-- get the longest track from every album and add that to a temporary table
```sql
SELECT album.title AS album_title,
artist.name as artist,
MAX(track.milliseconds / (1000 * 60) % 60 ) AS max_track_length_mins
-- Name the temp table #maxtracks
INTO #maxtracks
FROM album
-- Join album to artist using artist_id
INNER JOIN artist ON album.artist_id = artist.artist_id
-- Join track to album using album_id
Inner join track on album.album_id = track.album_id
GROUP BY artist.artist_id, album.title, artist.name,album.album_id
-- Run the final SELECT query to retrieve the results from the temporary table
SELECT album_title, artist, max_track_length_mins
FROM  #maxtracks
ORDER BY max_track_length_mins DESC, artist;
```