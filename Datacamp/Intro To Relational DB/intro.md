# module1 : Your first database

## Introduction

This is an introduction to relational databases with practical case we are going to investigate to get our hands dirty and not just rely on the theortical side.
In the resources section below I mentioned some of the cool resources to get started learning and working with sql and relational databases.

### our case:

Why to use relational database?

- **real life entites becomes table**: <br>
  A database models real-life entites like professors, students, universities by storying them on tables
- **reduces redundancy:** <br>
  each table contains data from a single entity type, this reduces redundnacy by storing entites only once

- **data integrity by relationships:** <br>
  the database can be used to model relationships between entities, for example: <br>
  a professor can work on a mutliple universities, a company can have mutiple workers <br>
  we can define how excatly data relates to each others

### what you're going to learn:

1. creating and manipulating with the data
2. creating a relational database from scratch
3. learning the following three concepts, which help preserve data quality on databases:
   1. constraints
   2. keys
   3. referential integrity

#### Query information_schema with SELECT

**Information_schema**: is a meta-database that holds information about your current database, it has multiple tables you can query with the select \* from syntax:

- tables: information about all tables in your current database
- columns: information about all columns in all of the tables in your current database
- and many more.

```sql
    -- Query the right table in information_schema
SELECT table_name
FROM information_schema.tables
-- Specify the correct table_schema value
WHERE table_schema = 'public';
```

public schema holds information about user-defined tables and databases

```sql
-- Query the right table in information_schema to get columns
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'university_professors' AND table_schema = 'public';
```

```sql
select count(table_name) from information_schema.columns where table_name = 'university_professors'
```

```sql
    SELECT * FROM table_name WHERE media='welcome';
```

## tables: the core of relational databases:

tables is the most important concept of relational database, In this section we are going to see how deal with redundancy in tables
let's see what's inside the first three records of 'university_professors' tables

```sql
SELECT * FROM university_professors LIMIT 3;
```

![Image](./screenshots/1.png)

Here we will begin to notice that professor 'karl' is repeated on the first three column and his university 'ETH Lausanne' also repeated couple of times because he only works for this university, However he has a affliations with at least three differenet organization as seen
So there is a certain redundancy in this table, and the reason for this redundancy is that table contains entites of at least different types
let's look at them

![image](./screenshots/2.png)

1. professors highlighted in green
2. universities highlighted in blue
3. organization highlighted in brown

let's look at the database once again, the graphic shown here is called **entity-relationship diagram**

![image](./screenshots/3.png)

squares denotes entity types, while circles denote attributes(columns)
as we said before that the table 'university_professor' contains at least three different entities, so we need to model them now, each one at it's own table

![image](./screenshots/5.png)

Now after we've created the entity-relationship diagram, the next step is to actually make those tables and connected them together
But before we actually do this, we need a refresher of the syntax to do so:

#### CREAT TABLE syntax

```sql
CREATE TABLE table_name(
  column_a data_type,
  column_b data_type,
  column_c data_types
);
```

##### Your first task:

1. create table professors table with two text column: firstname, lastname
2. create table university table with three text column: university_shortname, university, university_city

##### solving the task:

```sql
-- Create a table for the professors entity type
CREATE TABLE professors (
 firstname text,
 lastname text
);

-- Print the contents of this table
SELECT *
FROM professors

-- Create a table for the universities entity types
create table universities (
    university_shortname text,
    university text,
    university_city text
);

-- Print the contents of this table
SELECT *
FROM universities

  -- Create a table for organizations entity types
create table organizations (
  organization text,
  organization_sector text
)

SELECT * FROM organizations

  --Create a table for affliations entity types

CREATE TABLE affliations(
  firstname text,
  lastname text
  university_shortname text,
function text,
organisation text
)
```

oops we forget to add university_shortname to professor table!
don't worry to do so you need to alter the table then add the column
the syntax to do so:

```sql
ALTER TABLE table_name
ADD COLUMN column_name data_type;
```

Let's to it

```sql
ALTER TABLE professors
add COLUMN university_shortname text;
```

## updating the tables

only the university_professor holds data.
Now we've 5 different tables so far, it's time to migrate data from the university_professors table to the 4-other tables

If we have another look at the data on the university_professor table, we see:

```sql
select count(*) from university_professor
```

![image](./screenshots/6.png)

but if we see the unique organizations stored on the university_professor table:

```sql
SELECT count( DISTINCT organizations) FROM university_professors
```

![image](./screenshots/7.png)

So before coping the data from the original table, we need first to make sure we copy the distinct data to reduce redundancy, in order to this
we use the ""INSERT INTO SELECT DISTINCT" patterns
the syntax as follow:

```sql
--INSERT INTO General syntax
SELECT INTO table_name(column_a, column_b)
VALUES ('value_a', 'value_b')
```

```sql
INSERT INTO new_table
SELECT DISTINCT column_a, column_b FROM old_table
```

so out query will be like this:

```sql
INSERT INTO organizations
SELECT DISTINCT organization, organization_sector
FROM university_professors
```

In the last section when we create the tables, in the affliations table, instead of typing 'organization' we've typed 'organisation, so we need to fix this now, to do so
the syntax as follow:

```sql
-- General syntax
ALTER TABLE table_name
RENAME COLUMN old_name TO new_name

ALTER TABLE affliations
RENAME COLUMN organisation TO organization

```

also we don't need the university_shortname column, so are going to delete(drop) it from affliations table:

```sql
ALTER TABLE table_name
DROP COLUMN column_name

ALTER TABLE affloations
DROP COLUMN university_shortname
```

but why did we delete the university_shortname at the first place?
querying the university_professors table for uniquefirstname, lastname and university_shortname results of 551 unique records

```sql
SELECT DISTINCT firstname, lastname, university_short
FROM university_professor
```

![image](./screenshots/8.png)

and querying only the firstname and lastname results of 551 unique recordss
![image](./screenshots/9.png)

so the firstname and lastname uniquely identify a professor

Now after migrating the data from the university_professor table to other table, it is not needed anymore, so we are going to delete it.

```sql
DROP TABLE university_professor
```

# module2 : Enforce data consistency with attribute constraints

## Better data quality with constraints

You are going to learn:

1. what are constraints? and why to use them?
2. making our data consistent using those constrains

Althought we have setup a simple database, we haven't used most of the features database provides
the idea of database it push data into certain structure, a pre-defined model where you enforce data types, relationships, and other rules
these rules are called '**Integrity constrains**'

#### Integrity constrains: </br>

Integrity constraints can be divided into three types:<br>

1. Attribute constraints: e.g data type
2. key constraints: e.g primary data type
3. Referential integrity constraints: e.g foreign keys

In this section we are going to explore the first type, and in the next two sections, we will look at the other two

#### why constraints?

- Constrains enforce a certain data form: <br>
  things can get messy when people are in charge of entering data, so we need to make sure that data entered are consistent and have a rigid form!
- Help enforce data qualiy, and data quality is important for both users and developers

here are the common data types on postgreSQL that work as attributes constraints:
![image](./screenshots/10.png)

Data types also restrict possbile sql operations on stored data:
for example

```sql
CREATE TABLE weather(
  temperature integer,
  wind_speed text
)
SELECT temperature * wind_speed AS wind_chill
FROM weather
```

this will produce error, exactly as almost programming language will do <br>

```txt
operator does not exist: integer * text
HINT: No operator matches the given name and argument type(s).
You might need to add explicit type casts.
```

the solution for this is to use CASTing as follows:

```sql
SELECT temperature * CAST(wind_speed AS integer) wind_cill
FROM weather
```

This is on-the-fly type conversion

## working with data type:

- Enforced on columns (i.e. attributes)
- Define the so-called 'domain' values of a column:<br>
  meaning what form these values can take and what not
- Define what operations are possible
  -Enforece consistent storage of values

#### PostgreSQL datatypes(some):

- text : character strings of any length
- varchar [ (x) ] : a maximum of n characters
- char [ (x) ] : a
- fxed-length string of n characters
- boolean : can only take three states, e.g. TRUE , FALSE and NULL (unknown)

##### specifying types while creation:

```sql
CREATE TABLE student(
  ssn integer,
name varchar(64),
dob date,
average_grade numeric(3, 2), -- e.g. 5.54
tuition_paid boolean
)
```

##### specifying types after creation:

```sql
ALTER TABLE student
ALTER COLUMN name
TYPE varchar(128)



ALTER TABLE student
ALTER COLUMN integer
USING ROUND(average_grade)
```

Now let's get back to our database tables, we need to do some Constrains

#### Task:

1. in professor table specify a fixed-length character type with the correct length for university_shortname.
2. change the type of firstname to varchar(64)

#### solution

```sql
ALTER TABLE professors
ALTER column university_shortname
TYPE char(3)
ALTER COLUMN firstname
TYPE varchar(64)
```

#### Convert types USING a function

If you don't want to reserve too much space for a certain varchar column, you can truncate the values before converting its type.

```sql
ALTER TABLE table_name
ALTER COLUMN column_name
TYPE varchar(x)
USING SUBSTRING(column_name FROM 1 FOR x)
```

```sql
-- Convert the values in firstname to a max. of 16 characters
ALTER TABLE professors
ALTER COLUMN firstname
TYPE varchar(16)
using substring(firstname from 1 for 16)
```

## The not-null and unique constraints

those are the most important two attributes constraints

### Not-null constraints:

- Disallow any **NULL** values
- Must hold true for the current state and the future state
  so you can't insert null on that columns

#### what does null means?

Nothing xD, HAHAHAHA
actually it does represent 'non exising value':

- Does not exist or
- unknown

#### adding or removing not-null constraints

1. While creation <br>

```sql
CREATE TABLE students(
  ssn integer not null,
  lastname varchar(64) not null,
  home_phone integer
)
```

2. After creation:

```sql
ALTER TABLE students
ALTER COLUMN home_phone
SET NOT NULL
```

```sql
ALTER TABLE students
ALTER COLUMN home_phone
DROP NOT null
```

### Unique constraint:

- Disallow duplicate values on a column
- Must hold true for the current and future

what does 'holding true' means?
meaning that you couldn't apply unique constrains if the column does hold actually duplicates, because think of it, how the DBMS know now what to remove from what to persist?

#### Adding or removing unique constraints:

```sql
CREATE TABLE table_name(column_a UNIQUE)

ALTER TABLE table_name
ADD constraint some_name UNIQUEL(column_a)
```

### TASK:

1. add not-null constraints on professors' firstname and lastname
2. make universities' shortname unique
3. Make organizations.organization unique

### solution:

```sql
ALTER TABLE professors
ALTER COLUMN firstname
SET NOT NULL
ALTER COLUMN lastname
SET NOT NULL

ALTER TABLE universities
ADD CONSTRAINT university_shortname_unq UNIQUE(university_shortname)

ALTER TABLE organizations
ADD CONSTRAINT organization_unq UNIQUE(organization);
```

# module3: Uniquely identify records with key constraints

## keys and superkeys

let's take a look at our current database:
![image](./screenshots/11.png)

After completing this section, our database will look like this:
![image](./screenshots/12.png)

what is that underlyed id? where did it come from? and why?
we will examine all those question right now

### what is key:

- Attribute(s) that identify a record uniquely: <br>
  Normally, a table, as whole, only contain unique records, meaning that the combination of all attributes is a key in itself, However it's not called a key, but a **superkey** if attributes from that combination can be removed, and attributes still uniquely identify records
  If all possible attributes have been removed but the records are still uniquely identifed by the remaing attributes, we speak of **minimal superkey**
- As long as attributes can be removed: **superkey**
- if no more attributes can be removed: **minimal superkey** or **key**: <br>
  this is a actual key, so the key is always minimal

Let's look at an example:
a database from the textbook: Fundementals of Database Systems

![image](./screenshots/13.png)

the table shows 6 different cars, so the combination of all attributes is attributes

```txt
SK1 = {license_no, serial_no, make, model, year}
```

if we remove the year from the the superkey, the six records are still unique, so it's still a super key

```txt
SK2 = {license_no, serial_no, make, model}
```

Actually there are alot of superkeys in this example

```txt
SK3 = {make, model, year}, SK4 = {license_no, serial_no}, SKi, ..., SKn
```

However there are only 4 minimal superkeys

```txt
K1 = {license_no}; K2 = {serial_no}; K3 = {model}; K4 = {make, year}
```

remember that superkeys are minimal when no attributes can be removed without losing the uniqueness property, this is trivival for k1 to k3 because they only consist of single attribute

also if we remove year from k4, 'make' would contain duplicates, and would, therefore be no longer suited as key.

there four minimal superkeys are also called **candidate keys**
why candidate keys?
In the end, there can only be one key for the table, which has to be chosen from the candidate keys

### Identify keys with SELECT COUNT DISTINCT:

How to know if a given column could be qualified to be a key?
There are some steps you can follow to know:

1. Count the distinct records for all possible combinations of columns. If the resulting number x equals the number of all rows in the table for a combination, you have discovered a superkey.

2. Then remove one column after another until you can no longer remove columns without seeing the number x decrease. If that is the case, you have discovered a (candidate) key.

The table professors has 551 rows. It has only one possible candidate key, which is a combination of two attributes, so let's try to find that candidate key

```sql
-- Try out different combinations
select COUNT(DISTINCT(firstname, lastname, university_shortname))
FROM professors;
```

output: 551, let's try to remove firstname

```sql
-- Try out different combinations
select COUNT(DISTINCT( lastname, university_shortname))
FROM professors;
```

output: 546, so let's try to remove lastname and use firstname instead

```sql
-- Try out different combinations
select COUNT(DISTINCT(firstname, university_shortname))
FROM professors;
```

output: 479, so let's try again removing the university_shortname

```sql
-- Try out different combinations
select COUNT(DISTINCT(firstname, lastname))
FROM professors;
```

output: 551 , that's it
Indeed, the only combination that uniquely identifies professors is {firstname, lastname}. {firstname, lastname, university_shortname} is a superkey, and all other combinations give duplicate values. Hopefully, the concept of superkeys and keys is
let's move to primary key!

## primar key:

primary key is one of the most important concepts in database design, almost every database shoud have primary key chosen by you from the set of candidate keys.
the main purpose as already explained, is uniquely identifying records in a table
this makes it easier to reference these records from other tables.
you may have seen that primary keys need to be defined on columns that don't accept duplicat or null values

### the syntax of specifying primary key:

1. upon creation

```sql
CREATE TABLE products(
  product_no integer PRIMARY KEY,
  name text,
  price numeric
)
CREATE TABLE example(
  a integer,
  b integer,
  c integer,
  PRIMARY KEY(a, c) --this notation is important when definining primary key consisting of two columns, but beware that this is just one primary key formed by the combination of two columns.
)
```

2. to exising table:

```sql
ALTER TABLE table_name
ADD CONSTRAINT some_name PRIMARY KEY(column_name)
```

so back to your database tables, we now need to make a primary key for every table we have, so let's do it:

```sql
-- Rename the organization column to id
ALTER TABLE organizations
RENAME column organization TO id;

-- Make id a primary key
ALTER TABLE organizations
ADD CONSTRAINT organization_pk primary KEY (id);


-- Rename the university_shortname column to id
ALTER TABLE universities
RENAME column university_shortname to id;

-- Make id a primary key
ALTER TABLE universities
ADD CONSTRAINT university_pk primary KEY (id);


```

## Surrogate keys: (\_id)

surrogate keys are sort of an artificial primry key.
they are not based on a native column on your data, but on a column that just exists for the sake of having a primary key.

- Primary keys should be build from as few columns as possible
- Primary keys should never change over time.

let's look at this table:
![image](./screenshots/13.png)
in this table, the 'license_no' column would be suited as the primary key - the license_no is unlikely to change over time, not like the color column, for example, which might change if the car is repainted.
so there's no need for surrogate key here
but if we have this table:
![image](./screenshots/14.png)
the only sensible primary key here for this table is the combination of {make, model} but this are two column for a primary key
we can add a surrogate key column, called "id" to solve this problem

### Adding a surrogate key with serial data type

using serial data type in PostgreSQL which allow us to add auto incrementing number column

```sql
ALTER  TABLE car
ADD COLUMN id serial primary key;
```

### Another type of surrogate key

```sql
ALTER TABLE table_name
ADD COLUMN column_c varchar(256);
UPDATE table_name
SET column_c  = CONCAT(column_a, column_b);
--concat function glue together the values of two or more existing columns

ALTER TABLE table_name
ADD CONSTRAINT pk primary key(column_c)
```

back to our database tables, we need to add surrogate key to professors table, because it's attributes can't make a suitable primary key, we could have two professor with the name working for different universites which does make duplicates

```sql
-- Add the new column to the table
ALTER TABLE professors
ADD COLUMN id serial;

-- Make id a primary key
ALTER TABLE professors
ADD CONSTRAINT professors_pkey PRIMARY KEY (id);

-- Have a look at the first 10 rows of professors
select *  from professors LIMIT 10;
```

an example of combining two table together:

```sql
-- Count the number of distinct rows with columns make, model
SELECT COUNT(DISTINCT(make, model))
FROM cars;

-- Add the id column
ALTER TABLE cars
ADD COLUMN id varchar(128);

-- Update id with make + model
UPDATE cars
SET id = CONCAT(make, model);

-- Make id a primary key
ALTER TABLE cars
ADD Constraint id_pk primary key(id);

-- Have a look at the table
SELECT * FROM cars;
```

# module4: Glue together tables with foreign keys

## Model 1:N relationships with foreign keys

- a foreign key(FK) points to the primary key(PK) of another table
- Domain of FK must be equal to domain of PK: <br>
  there are some resitrictions to the foreign keys:
  first the domain and the datatyp must be the same as one of the primary key.
  seconldy
- Each value of FK must exist in PK pf the other table(FK constraint or 'referential integrity'): <br>
  only foreign keys values are allowed that exist as values un the primary key of the referenced table
- FKs are not actual keys:<br>
  because duplicates are allowe

our database model will be like this:
![image](./screenshots/15.png)

A more than just one professor can work into one univeristy not multiple universities at the same times

example of the syntax used to make foriegn keys:

1. upon creation

```sql
CREATE TABLE manufacturees (
  name varchar(255) primary KEY;
)

INSERT INTO manufacturees
VALUES ('Ford'), ('VW'),('GM')

CREATE TABLE cars(
  model varchar(255) primary key;
  manufacturere_name varchar(255) References manufacturees (name)
)

INSERT INTO cars
VALUES ('Ranger', 'Ford'), ('Beetle', 'VW');
```

2. after creation

```sql
ALTER table a
ADD CONSTRAINT a_fkey foreign KEY (b_id) References b (id);
```

now let's implement this on our database tables

```sql
-- Rename the university_shortname column
ALTER TABLE professors
RENAME COLUMN university_shortname TO university_id;

-- Add a foreign key on professors referencing universities
ALTER  TABLE professors
ADD Constraint professors_fkey FOREIGN KEY (university_id) REFERENCES universities (id);
```

```sql
-- Select all professors working for universities in the city of Zurich
SELECT professors.lastname, universities.id, universities.university_city
from professors
join universities
ON professors.university_id = universities.id
where universities.university_city = 'Zurich';
```

the result is
![image](./screenshots/16.png)

### Model more complex relationships

how to implement many to many relationship?

- create ordinary table that contain two foriegn keys that points to both connected entites

in our tables: we have this relationship now
![image](./screenshots/18.png)
as professor can work for multiple organizations and an organization could have mutliple professors working for it

in this case we need to add additional attributes such as function

```sql
CREATE TABLE affliations (
  professor_id integer references professors (id),
  organization_id varchar(255) references organizations(id),
  function varchar(255)
)
```

notice that: no primary keyis defined here, because theoritcaly a professor can have mutliple functions in one organization

```sql
-- Add a professor_id column
ALTER TABLE affiliations
ADD COLUMN professor_id integer REFERENCES professors (id);

-- Rename the organization column to organization_id
ALTER TABLE affiliations
RENAME organization TO organization_id;

-- Add a foreign key on organization_id
ALTER TABLE affiliations
ADD CONSTRAINT affiliations_organization_fkey foreign key (organization_id) REFERENCES organizations (id);
```

now we will be populating the professor id column on affliations from professors.id column directly
here is the syntax:

```sql
UPDATE table_a
SET column_to_update = table_b.column_to_update_from
FROM table_b
WHERE condition1 AND condition2 AND ...;
```

now let's implement this:

```sql
-- Update professor_id to professors.id where firstname, lastname correspond to rows in professors
UPDATE affiliations
SET professor_id = professors.id
FROM professors
WHERE affiliations.firstname = professors.firstname AND affiliations.lastname = professors.lastname;

-- Have a look at the 10 first rows of affiliations again
select * from affiliations limit 10;
```

let's drop firstname and lastname from affliations, we don't need it anymore

```sql
-- Drop the firstname column
Alter table affiliations
DROP column firstname;

-- Drop the lastname column
Alter table affiliations
DROP column lastname;
```

## Referntial integrity

```sql
-- Identify the correct constraint name
SELECT constraint_name, table_name, constraint_type
FROM information_schema.table_constraints
WHERE constraint_type = 'FOREIGN KEY';

-- Drop the right foreign key constraint
ALTER TABLE affiliations
DROP CONSTRAINT affiliations_organization_id_fkey;

-- Add a new foreign key constraint from affiliations to organizations which cascades deletion
ALTER TABLE affiliations
ADD CONSTRAINT affiliations_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES organizations (id) ON DELETE CASCADE;

-- Delete an organization
DELETE FROM organizations
WHERE id = 'CUREM';

-- Check that no more affiliations with this organization exist
SELECT * FROM affiliations
WHERE organization_id = 'CUREM';
```

## round up

count afflitions per university

```sql
-- Count the total number of affiliations per university
SELECT COUNT(*), professors.university_id
FROM affiliations
JOIN professors
ON affiliations.professor_id = professors.id
-- Group by the university ids of professors
GROUP BY professors.university_id
ORDER BY count DESC;
```

### Join all the tables together

In this last exercise, your task is to find the university city of the professor with the most affiliations in the sector "Media & communication".

For this,

you need to join all the tables,
group by some column,
and then use selection criteria to get only the rows in the correct sector.
Let's do this in three steps!

```sql
-- Filter the table and sort it
SELECT COUNT(*), organizations.organization_sector,
professors.id, universities.university_city
FROM affiliations
JOIN professors
ON affiliations.professor_id = professors.id
JOIN organizations
ON affiliations.organization_id = organizations.id
JOIN universities
ON professors.university_id = universities.id
Where organizations.organization_sector = 'Media & communication'
GROUP BY organizations.organization_sector,
professors.id, universities.university_city
ORDER BY count DESC;
```
