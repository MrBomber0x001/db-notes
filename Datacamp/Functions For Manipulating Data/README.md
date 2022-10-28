# Choosing the appropriate data type

topics covered:
function for 🧮 data and time
character coveredfunctionas working with numberic data

data types:
exact numbers🧮

approximate numbers
float and real
note: you should use these tpees carefully and avoid using them on where clause with equality operator because you may get different results

Characters and unicode character data types🧮
ASCII and unicode character
ascii🧮 (English characters)
char
varchar
text
unicode (from any language)
nchar
nvarchar
ntext

## implict conversion🧮

keep in mind: for comparing two values, they need to have the same datatype
otherwise🧮
1-sql try to implicit conversion
2-explicit conversion

the value 0 conreesponcs to '1-1-1900' adding 1 add a new day

note about performance using implict conversion🧮
implict convertion is done row by row, so this may slow the performance alittle bit, having a good schema design is good

explict conversion🧮
CAST() and CONVERT()
CAST() is sql standard, CONVERT() is sql server
using convert() is slightly better more than CAST(), becuase when you type cast() is sql server, it converts it first to convert() so it execute addiotnal opertations

```sql
SELECT
 -- Transform the year part from the birthdate to a string
 first_name + ' ' + last_name + ' was born in ' + CAST(YEAR(birthdate) AS nvarchar) + '.'
FROM voters;


SELECT
 -- Transform to int the division of total_votes to 5.5
 CAST(total_votes / 5.5 AS int) AS DividedVotes
FROM voters;


SELECT
 first_name,
 last_name,
 total_votes
FROM voters
-- Transform the total_votes to char of length 10
WHERE CAST(total_votes AS int) LIKE '5%';
```

```sql
SELECT
 first_name,
    last_name,
 -- Convert birthdate to varchar(10) to show it as yy/mm/dd
 CONVERT(varchar(10), birthdate, 11) AS birthdate,
    gender,
    country,
    -- Convert the total_votes number to nvarchar
    'Voted ' + CAST(total_votes AS nvarchar) + ' times.' AS comments
FROM voters
WHERE country = 'Belgium'
    -- Select only the female voters
 AND gender = 'F'
    -- Select only people who voted more than 20 times
    AND total_votes > 20;
```

# Manipulating Time

```sql
SELECT
 CONVERT(VARCHAR(24), sysdatetime(), 107) AS HighPrecision,
 CONVERT(VARCHAR(24), getdate(), 102) AS LowPrecision;

 SELECT
 CAST(SYSUTCDATETIME() AS time) AS HighPrecision,
 CAST(getutcdate() AS time) AS LowPrecision;
```

```sql
SELECT
 first_name,
 last_name,
    -- Extract the year of the first vote
 YEAR(first_vote_date)  AS first_vote_year,
    -- Extract the month of the first vote
 MONTH(first_vote_date) AS first_vote_month,
    -- Extract the day of the first vote
 DAY(first_vote_date)   AS first_vote_day
FROM voters
-- The year of the first vote should be greater than 2015
WHERE YEAR(first_vote_date) > 2015
-- The day should not be the first day of the month
  AND day(first_vote_date) <> month(first_vote_date);

```

```sql
SELECT
 first_name,
 last_name,
    -- Extract the month number of the first vote
 datepart(MONTH,first_vote_date) AS first_vote_month1,
 -- Extract the month name of the first vote
    datename(MONTH,first_vote_date) AS first_vote_month2,
 -- Extract the weekday number of the first vote
 datepart(WEEKDAY,first_vote_date) AS first_vote_weekday1,
    -- Extract the weekday name of the first vote
 datename(WEEKDAY,first_vote_date) AS first_vote_weekday2
FROM voters;
```

```sql
SELECT
 first_name,
 last_name,
    -- Select the year of the first vote
    year(first_vote_date) AS first_vote_year,
    -- Select the month of the first vote
 month(first_vote_date) AS first_vote_month,
    -- Create a date as the start of the month of the first vote
 datefromparts(year(first_vote_date), month(first_vote_date), 1) AS first_vote_starting_month
FROM voters;
```

```sql
DECLARE @date1 datetime = '2018-12-01'
DECLARE @date2 datetime = '2030-03-03'

SELECT

DATEDIFF(year, @date2 - @date1, @date1 + @date2) as diff
```

```sql
SELECT
 -- Subtract 476 days from the current date
 dateadd(day, -476, sysdatetime()) AS date_476days_ago;
```

```sql
SELECT
 first_name,
 birthdate,
 first_vote_date,
    -- Select the diff between the 18th birthday and first vote
 datediff(year, DATEADD(YEAR, 18, birthdate), first_vote_date) AS adult_years_until_vote
FROM voters;

SELECT
 -- Get the difference in weeks from 2019-01-01 until now
 DATEDIFF(week, '2019-01-01', sysDAteTime()) AS weeks_passed;
```

```sql
DECLARE @date1 NVARCHAR(20) = '2018-30-12';

-- Set the date format and check if the variable is a date
SET DATEFORMAT ydm;
SELECT ISDATE(@date1) AS result;
```

```sql
DECLARE @date1 NVARCHAR(20) = '30.03.2019';

-- Set the correct language
SET LANGUAGE Dutch;
SELECT
 @date1 AS initial_date,
    -- Check that the date is valid
 ISDATE(@date1) AS is_valid,
    -- Select the name of the month
 DATEName(month, @date1) AS month_name;
```

```sql
SELECT
 first_name,
    last_name,
    birthdate,
 first_vote_date,
 -- Find out on which day of the week each participant voted
 DATENAME(weekday, first_vote_date) AS first_vote_weekday,
 -- Find out the year of the first vote
 YEAR(first_vote_date) AS first_vote_year,
 -- Discover the participants' age when they joined the contest
 DATEDIFF(YEAR, birthdate, first_vote_date) AS age_at_first_vote,
 -- Calculate the current age of each voter
 DATEDIFF(YEAR, birthdate, GETDATE()) AS current_age
FROM voters;
```

# Working with strings

## Functions for positions

LEN(): number of characters in a string
CHARINDEX(): looks for a character expression in a given string and returns its starting positions.
CHARINDEX(expression_to_find, expression_to_search [, start_location])

PATINDEX(): returning the starting position of a string. just like charindex but more powerful. using searching using pattern.

printing the lenght of a string

```sql
SELECT TOP 10
 company,
 broad_bean_origin,
 -- Calculate the length of the broad_bean_origin column
 LEN(broad_bean_origin) AS length
FROM ratings
--Order the results based on the new column, descending
ORDER BY Len(broad_bean_origin) desc;
```

searching a string for a string

```sql
SELECT
 first_name,
 last_name,
 email
FROM voters
-- Look for the "dan" expression in the first_name
WHERE CHARINDEX('dan', first_name) > 0
    -- Look for last_names that do not contain the letter "z"
 AND CHARINDEX('z', last_name) = 0;
```

searching using a pattern

```sql
SELECT
 first_name,
 last_name,
 email
FROM voters
-- Look for first names that contain "rr" in the middle
WHERE patindex('%rr%', first_name) > 0;
```

```sql
SELECT
 first_name,
 last_name,
 email
FROM voters
-- Look for first names that start with C and the 3rd letter is r
WHERE patindex('%C_r%', first_name) > 0;
```

```sql
SELECT
 first_name,
 last_name,
 email
FROM voters
-- Look for first names that have an "a" followed by 0 or more letters and then have a "w"
WHERE patindex('%a%w%', first_name) > 0;
```

```sql
SELECT
 first_name,
 last_name,
 email
FROM voters
-- Look for first names that contain one of the letters: "x", "w", "q"
WHERE patindex('%[xwq]%', first_name) > 0;
```

## Functions for string transformations

LOWER() -> convert to lower case and UPPER() -> convert to upper case.
LEFT(character_expression, number_of_characters)
returns the specified number of characters from the beginning of the string.
RIGHT(character_expression, number_of_characters)
v=returns the specified number of characters from the end of the string.

```sql
select country, left(country, 3 )as country_prefix,
email,
right(email, 4) as email_domain
from voters
```

LTRIM(chararcter_expression) -> returns a string after removing the leading blanks.
RTRIM(character_expression) -> returns a string after removing the trainling blanks;TRIM([character FROM] character_Expression) -> returns a string after removing the blanks or other specified characters

REPLACE(character_expression, searched_expression, replacment_expression) -> returns a string where all occurrences of an expression are replaced with another one

```sql
SELECT REPLACE('I like apples, apples are good.', 'apple', 'organge') As result;
```

SUBSTRING(character_expression, start, number_of_characters) -> returns part of a string.

```sql
SELECT SUNSTRING('12345678', 5, 3) as result
```

exerices
Most of the time, you can't make changes directly to the data from the database to make it look more user-friendly. However, when you query the data, you can control the aspect of the results, and you can make them easier to read.

```sql
SELECT
 company,
 bean_type,
 broad_bean_origin,
    -- 'company' and 'broad_bean_origin' should be in uppercase
 'The company ' +  upper(company) + ' uses beans of type "' + bean_type + '", originating from ' + upper(broad_bean_origin) + '.'
FROM ratings
WHERE
    -- The 'broad_bean_origin' should not be unknown
 LOWER(broad_bean_origin) NOT LIKE '%unknown%'
     -- The 'bean_type' should not be unknown
    AND LOWER(bean_type) NOT LIKE '%unknown%';
```

```sql
SELECT
 first_name,
 last_name,
 country,
    -- Select only the first 3 characters from the first name
 LEFT(first_name, 3) AS part1,
    -- Select only the last 3 characters from the last name
    RIGHT(last_name, 3) AS part2,
    -- Select only the last 2 digits from the birth date
    RIGHT(birthdate, 2) AS part3,
    -- Create the alias for each voter
    LEFT(first_name, 3) + RIGHT(last_name, 3)
 + '_' +  RIGHT(birthdate, 2)

FROM voters;
```

```sql
DECLARE @sentence NVARCHAR(200) = 'Apples are neither oranges nor potatoes.'
SELECT
 -- Extract the word "Apples"
 substring(@sentence, 1, 6) AS fruit1,
    -- Extract the word "oranges"
 substring(@sentence, 20, 7) AS fruit2;

```

```sql
SELECT
 first_name,
 last_name,
 email,
 -- Replace "yahoo.com" with "live.com"
 replace(email, 'yahoo.com', 'live.com') AS new_email
FROM voters;

SELECT
 company AS initial_name,
    -- Replace '&' with 'and'
 replace(company, '&', 'and') AS new_name
FROM ratings
WHERE CHARINDEX('&', company) > 0;


SELECT
 company AS old_company,
    -- Remove the text '(Valrhona)' from the name
 replace(company, '(Valrhona)', '') AS new_company,
 bean_type,
 broad_bean_origin
FROM ratings
WHERE company = 'La Maison du Chocolat (Valrhona)';
```

## Functions manipulting groups of string

these functions are newly introducted in sql server

CONCAT(string1 , string2, [. stringN])
CONCAT_WS(separator, string1, string2, [,stringN])

keep in mind: concatenating data with functions is better than usign the + operato; because the "+" may do addition if thr values are not strings
and you can concatentate from all data types, nit just strings

STRING_AGG(expression, seperator) [<order_clause>] or string aggreagate;
the sperator is added between the strings, but not in the end.
an example

```sql
select string_agg(first_name, ',') as list_names;
from voters;
```

```sql
select
string_agg(first_name, ' ', last_name, '(', first_vote_data, ')'), Char(13)) as list_names
from voters;
```

char(13) is the carriage return character, and a list seperated by this character will show values one below the other.

another effective way for using this function is with GROUP BY
concatenating values in groups;

```sql
select YEAR(first_vote_date) as voting_year;
 string_agg(first_name, ',') as voters;
 from voters;
 group by YEAR(first_vote_date);
```

each year will have list of voters;

STRING_AGG() with optional <order_clause>

```sql
select
 YEAR(first_vote_date) as voting_year;
 string_agg(first_name, ',') WITHIN GROUP (ORDER BY first_name ASC) AS voters;
 from voters;
 group by year(first_vote_date);
```

the voters will apear in alphabetical order in this table

STRING_SPLIT(string, seperator) - divide a string into smaller pieces, based on a seperator. - returns a <b>single column table</b>

```sql
select * from string_split('1,2,3,4', ',');
```

we cannot use it as column in the select statement, but we can use it in the <b>FROM</b> clause just like a normal table;

exercises

```sql
DECLARE @string1 NVARCHAR(100) = 'Chocolate with beans from';
DECLARE @string2 NVARCHAR(100) = 'has a cocoa percentage of';

SELECT
 bean_type,
 bean_origin,
 cocoa_percent,
 -- Create a message by concatenating values with "+"
 @string1 + ' ' + bean_origin + ' ' + @string2 + ' ' + CAST(cocoa_percent AS nvarchar) AS message1,
 -- Create a message by concatenating values with "CONCAT()"
 CONCAT(@string1, ' ', bean_origin, ' ', @string2, ' ', cocoa_percent) AS message2,
 -- Create a message by concatenating values with "CONCAT_WS()"
 CONCAT_WS(' ', @string1, bean_origin, @string2, cocoa_percent) AS message3
FROM ratings
WHERE
 company = 'Ambrosia'
 AND bean_type <> 'Unknown';
```

```sql
SELECT
 company,
    -- Create a list with all bean origins
 string_agg(bean_origin, ',') AS bean_origins
FROM ratings
WHERE company IN ('Bar Au Chocolat', 'Chocolate Con Amor', 'East Van Roasters')
-- Specify the columns used for grouping your data
GROUP BY company;
```

```sql
SELECT
 company,
    -- Create a list with all bean origins ordered alplabetically
 STRING_AGG(bean_origin, ',') WITHIN GROUP (ORDER BY bean_origin) AS bean_origins
FROM ratings
WHERE company IN ('Bar Au Chocolat', 'Chocolate Con Amor', 'East Van Roasters')
-- Specify the columns used for grouping your data
GROUP BY company;
```

```sql
DECLARE @phrase NVARCHAR(MAX) = 'In the morning I brush my teeth. In the afternoon I take a nap. In the evening I watch TV.'

SELECT value
FROM string_split(@phrase, '.');
```

```sql
DECLARE @phrase NVARCHAR(MAX) = 'In the morning I brush my teeth. In the afternoon I take a nap. In the evening I watch TV.'

SELECT value
FROM string_split(@phrase, ' ');
```

Simple application

```sql
SELECT
    -- Concatenate the first and last name
 CONCAT('***' , first_name, ' ', UPPER(last_name), '***') AS name,
    -- Mask the last two digits of the year
    REPLACE(birthdate, SUBSTRING(CAST(birthdate AS varchar), 3, 2), 'XX') AS birthdate,
 email,
 country
FROM voters
   -- Select only voters with a first name less than 5 characters
WHERE LEN(first_name) < 5
   -- Look for this pattern in the email address: "j%[0-9]@yahoo.com"
 AND PATINDEX('j_a%@yahoo.com', email) > 0;
```

## Recognizing Numeric Data Properties

### Aggregate arithmetic functions

### Analytic function

#### Exercise

```sql
SELECT 
 first_name,
 last_name,
 total_votes AS votes,
    -- Select the number of votes of the next voter
 LEAD(total_votes) OVER (ORDER BY total_votes) AS votes_next_voter,
    -- Calculate the difference between the number of votes
 LEAD(total_votes) OVER (ORDER BY total_votes) - total_votes AS votes_diff
FROM voters
WHERE country = 'France'
ORDER BY total_votes;
```

```sql
SELECT 
 broad_bean_origin AS bean_origin,
 rating,
 cocoa_percent,
    -- Retrieve the cocoa % of the bar with the previous rating
 LAG(cocoa_percent) 
  OVER(PARTITION  BY broad_bean_origin ORDER BY rating) AS percent_lower_rating
FROM ratings
WHERE company = 'Fruition'
ORDER BY broad_bean_origin, rating ASC;
```

```sql
SELECT 
 first_name + ' ' + last_name AS name,
 country,
 birthdate,
 -- Retrieve the birthdate of the oldest voter per country
 FIRST_VALUE(birthdate) 
 OVER (PARTITION BY country ORDER BY birthdate) AS oldest_voter,
 -- Retrieve the birthdate of the youngest voter per country
 LAST_VALUE(birthdate) 
  OVER (PARTITION BY country ORDER BY birthdate ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS youngest_voter
FROM voters
WHERE country IN ('Spain', 'USA');
```

### Mathematical functions

#### Exercise

```sql
DECLARE @number1 DECIMAL(18,2) = -5.4;
DECLARE @number2 DECIMAL(18,2) = 7.89;
DECLARE @number3 DECIMAL(18,2) = 13.2;
DECLARE @number4 DECIMAL(18,2) = 0.003;

DECLARE @result DECIMAL(18,2) = @number1 * @number2 - @number3 - @number4;
SELECT 
 @result AS result,
 -- Show the absolute value of the result
 ABS(@result) AS abs_result,
 -- Find the sign of the result
 sign(@result) AS sign_result;
```

```sql
SELECT
 rating,
 -- Round-up the rating to an integer value
 CEILING(rating) AS round_up,
 -- Round-down the rating to an integer value
 FLOOR(rating) AS round_down,
 -- Round the rating value to one decimal
 ROUND(rating, 1) AS round_onedec,
 -- Round the rating value to two decimals
 ROUND(rating, 2) AS round_twodec
FROM ratings;
```

```sql
DECLARE @number DECIMAL(4, 2) = 4.5;
DECLARE @power INT = 4;

SELECT
 @number AS number,
 @power AS power,
 -- Raise the @number to the @power
 power(@number, @power) AS number_to_power,
 -- Calculate the square of the @number
 square(@number) num_squared,
 -- Calculate the square root of the @number
 sqrt(@number) num_square_root;
```

```SQL
SELECT 
 company, 
    -- Select the number of cocoa flavors for each company
 COUNT(*) AS flavors,
    -- Select the minimum, maximum and average rating
 MIN(rating) AS lowest_score,   
 MAX(rating) AS highest_score,   
 AVG(rating) AS avg_score,
    -- Round the average rating to 1 decimal
    ROUND(AVG(rating), 1) AS round_avg_score,
    -- Round up and then down the aveg. rating to the next integer 
    CEILING(AVG(rating)) AS round_up_avg_score,   
 FLOOR(AVG(rating)) AS round_down_avg_score
FROM ratings
GROUP BY company
ORDER BY flavors DESC;
```
