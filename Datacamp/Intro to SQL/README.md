## Tips

1. Use Aliasing.

2. Be Consisten when writing sql queries.

## Selecting


we can peform arithmetic operations with select as printing simple statements.

```sql
select "Welcome TO SQL! <3" as result;

select (1 + 2) as result;

select (4.0 / 3.0) as result;
```

- SELECTING Single, or Multiple columns

```sql
SELECT title, release_year, country
FROM films;

-- or

SELECT * from films;
```

- SELECTING Distinct values 

`DISTINCT` is used to returns DISTINCT (Not repeated values)

```sql
SELECT DISTINCT role from roles 
```

- SELECTING With Counting

```sql
select count(*) from people;
select count(birthdate) from people;
select count(distinct name) from poeple;
```


## Filtering

1. Filtering Numerical Values
2. Filtering Textual Values

- = equal
- <> not equal
- < less than
- \> greater than
- <= less than or equal to
- \>= greater than or equal to


-- Get The number of films before 2000

```sql 
select count(*) from films where release_year < 2000
```

-- Get the number of spanish films or english films before 2000 and after 1990 with the gross greater than 2000

```sql
select count(*) from films 
where (language = 'Spanish' or language = 'English')
and (release_year <= 2000 and release_year >= 1990 )
and gross > 2000
```

- `BETWEEN` 

t's important to remember that BETWEEN is inclusive, meaning the beginning and end values are included in the results!

-- GET title and release of spanish or french filmes released between 1990 and 2000 inclusively with budget more than 20000 

```sql
select title, release_year from films 
where release_year BETWEEN 1990 AND 2000 
and budget > 20000
and (language = 'Spanish' OR language = 'French')
```

- `IN`
The IN operator allows you to specify multiple values in a WHERE clause, making it easier and quicker to specify multiple OR conditions!

-- Get the title and release year of all films released in 1990 or 2000 that were longer than two hours. Remember, duration is in minutes
```sql
select title, release_year from films
where release_year IN (1990, 2000) and duration > 120
```


- `IS NULL` and `IS NOT NULL`
Filtering based on `null` values, `null` represents a **missing values**

--GET the number of films which don't have a language associated with them.

```sql
select count(*) from films where language IS NULL
```

- `LIKE` and `NOT LIKE`

Filter using regular expression, this is the most powerful filtering methods, as it gives you many options and more control of filteration process


-- Get the names of all people whose names begin with 'B'.

```sql
select name from people where name is like 'B%'
```

-- Get the names of people whose names have 'r' as the second letter.

```sql
select name from people where name is like '_r%'
```

--Get the names of people whose names don't start with A

```sql
select name from people where name is not like 'A%'
```


## Aggregate functions

- SUM(column)
- AVG(column)
- MIN(column)
- MAX(column)


-- GET average, longest, shortest, total duration of films 

```sql
select sum(duration) as total, AVG(duration) as average, MIN(duration) as shortest, MAX(duration) as longest from films 
```

Commonly aggregate functions are combined with ~`HERE` Clause

-- Get the total amount grossed by all films made in the year 2000 or later.

```sql 
select sum(gross) from filmes where release_year >= 2000
```

-- get the title and duration in hours and average duration for all films.

```sql
select title, duration / 60.0 as duration_hours, avg(duration) as average_duration from films 
```

-- GET the percentage of people who are no longer alive

```sql
select (deathdate) * 100.0 / count(*) as percentage_dead from people
```

-- GET the number of years between the newest films and oldest films

```sql
select MAX(release_year) - MIN(release_year) as difference from films
```

-- GET the number of decades the films table covers

```sql
select (MAX(release_year) - MIN(release_year)) / 10.0 as number_of_decades from films
```


## Sorting And Grouping

we can sort by single, or multiple columns descending or ascending 
for the case of multiple columns, it will sort by the first one then the next one and so far.

**The order of columns** Is important
- `ORDER BY` (DESC or ASC)


-- Get the birth date and name for every person, in order of when they were born.

```sql 
select birthdate, name from people order by birthdate
```

-- Get all details for all films except those released in 2015 and order them by duration on descending order

```sql
select * from films where release_year <> 2015 order by duration desc
```

- `GROUP BY`
When sometimes to `aggregate results` 
Suppose you want to count the number of males and females of your company

```sql
select count(*) from employees
GROUP BY sex;
```


| sex|	count|
|--|--|
|male|	15|
|female| 	19|


**NOTES** 

- Commonly, GROUP BY is used with aggregate functions like COUNT() or MAX(). Note that GROUP BY always goes after the FROM clause and before WHERE!.

- SQL will return an error if you try to SELECT a field that is not in your GROUP BY clause without using it to calculate some kind of value about the entire group

Get the release year and average duration of all films, grouped by release year.
```sql
select release_year, avg(duration) from films group by release_year
```


Get the IMDB score and count of film reviews grouped by IMDB score in the reviews table.

```sql
select imdb_score, count(*) from films group by imdb_score
```

|imdb_score|	count|
|--|--|
|5.7|	117|
|8.7	|11|
|9|	2|