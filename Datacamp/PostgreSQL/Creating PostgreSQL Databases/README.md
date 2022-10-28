# <mark>postgresql</mark>

> themore you do it, the better you get out of it

# Course content

1. Structure of postgreSQL Databases

2. Postresql Data Types 

3. Database Normalization

4. Access control 

PostreSQL is object-relational database mangement system

system components are considered objects

the top-level object is the database

```sql
CREATE DATABASE sba;
-- Define the business_type table below
CREATE TABLE business_type (
    id serial PRIMARY KEY,
      description TEXT NOT NULL
);

-- Define the applicant table below
CREATE TABLE applicant (
      id serial PRIMARY KEY,
      name text NOT NULL,
      zip_code CHAR(5) NOT NULL,
      business_type_id INTEGER references business_type(id)
);
ALTER TABLE account ADD column date_opened DATE;
ALTER TABLE account RENAME column short_name To nick_name;
ALTER TABLE account DROP Column date_opened;
```

- what fields should i use?

- how many tables should i add?

- which data types are best to use for the fields of my table

## Schema

## Three Schema Architecture

![](C:\Users\ncm\AppData\Roaming\marktext\images\2022-02-25-11-20-59-image.png)

![](C:\Users\ncm\AppData\Roaming\marktext\images\2022-02-25-11-21-29-image.png)

![](C:\Users\ncm\AppData\Roaming\marktext\images\2022-02-25-11-21-57-image.png)

> why we have three schemas?

to acheive data independece, that meaning if i do some changes to a certain schema, the higher ones still not affected 

for example 

if i add specific allocation to a physical schema, should the conceptual schema be affected?

no

If i add new table to the conceptual schema, should external schema affected?

it dependes, meaning that the external schema which allowed to see the table will be affected xD

#### Data model

[1] physical 

[2] logical

![](C:\Users\ncm\AppData\Roaming\marktext\images\2022-02-25-11-26-56-image.png)

### Mapping

the request goes from external schema to the physical back and forth 

the transferring of request between different schema is called "Mapping"

![](C:\Users\ncm\AppData\Roaming\marktext\images\2022-02-25-11-27-54-image.png)

 An important use-case for PostgreSQL schemas is the ability to provide database users with their own group of tables that are only accessible to each individual user, such that users' database access does not interfere with others. In the name of security, this can be taken one step further to separate any production tables from being manipulated by unauthorized users. Schemas allow these divisions to be created without the use of multiple databases which can reduce maintenance requirements for database administrators.

schema contains collection of tables, schema can also contain data types and functions

schema uses cases:

- provide database users with seperate enviroment, for example giving each user his own set of tables to use without intefering with other users

![](C:\Users\ncm\AppData\Roaming\marktext\images\2022-02-23-04-56-20-image.png)

![](C:\Users\ncm\AppData\Roaming\marktext\images\2022-02-23-04-56-58-image.png)

### The default schema

the `public` schema is the default schema in postreSQL

The `public` schema of a PostgreSQL database is created by default when a new database is created. All users by default have access to this schema unless this access is explicitly restricted. When a database is going to be used by a single user and does not have complex groupings of data objects beyond what can naturally be supported by an object-relational database, the `public` schema will usually suffice. No additional schemas need to be added to such a database.

```sql
CREATE TABLE business_type (
    id serial PRIMARY KEY,
      description TEXT NOT NULL
);
public.business_type
```

#### Create schema

```sql
CREATE SCHEMA schema_name;
CREATE TABLE schema_name.table1(

)
```

an exercise: creating 2 schemas each one has it's own table 

```sql
create schema load_7a;
create schema load_50;
create table load_7a.bank(
    id serial primary key,
    name varchar(100) not null
)
create table load_50.bank(
    id serial primary key,
    name varchar(100) not null,
    description boolean;
)
```

## Data types

using data types wisely is computer sciene man :D

**Text datatype**:

`TEXT`, `VARCHAR`, `CHAR(N)`

`TEXT`:

- strings of unlimited length

- strings of variable length

- Good for text-based values of unknown length

`VARCHAR`:

- strings of unlimited length

- strings of variable length

- Restrictions can be imposed on columns values
  
  - VARCHAR(N)

  - without specificying the N, it's equivalent to use `TEXT`

  - allow strings that are less than N characters to be stored in the column without any error

`CHAR`:

- `CHAR(N) values consist of exactly N characters

- strings are right-padded with spaces if we insert less than N 

- `CHAR` only is equivalent to `CHAR(1)`

![](C:\Users\ncm\AppData\Roaming\marktext\images\2022-02-23-05-23-06-image.png)

```sql
-- Create the project table
create table project (
    -- Unique identifier for projects
    id SERIAL PRIMARY KEY,
    -- Whether or not project is franchise opportunity
    is_franchise boolean DEFAULT FALSE,
    -- Franchise name if project is franchise opportunity
    franchise_name text DEFAULT NULL,
    -- State where project will reside
    project_state text,
    -- County in state where project will reside
    project_county text,
    -- District number where project will reside
    congressional_district numeric,
    -- Amount of jobs projected to be created
    jobs_supported numeric
);
```

**Numeric types**

`SMALLINT` -> small-range integer (age)

`INTEGER` 

`BIGINT` -> visa or master card

 `SERIAL` (incremetal)

`BIGSERIAL`

`DECIMAL(precision, scale)`, and `NUMERIC` (user-specificed precision)

`REAL` -> 6 decimal of precision

`DOUBLE PRECISION` -. 15 decimal precision

```sql
-- Create the campaign table
CREATE TABLE campaign (
  -- Unique identifier column
  id SERIAL PRIMARY KEY,
  -- Campaign name column
  name VARCHAR(50),
  -- The campaign's budget
  budget NUMERIC(7, 2),
  -- The duration of campaign in days
  num_days SMALLINT DEFAULT 30,
  -- The number of new applications desired
  goal_amount INTEGER DEFAULT 100,
  -- The number of received applications
  num_applications INTEGER DEFAULT 0
);
```

**Boolean and temporal** 

`Boolean` or `bool`

Temporal: when representing a date and/or a time related to a table record

`TIMESTAMP` -> date and time

`DATE` -> date

`TIME` -->  time

```sql
CREATE TABLE appeal (
    id SERIAL PRIMARY KEY,
    content TEXT NOT NULL,
      -- Add received_on column
    received_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

      -- Add approved_on_appeal column
      approved_on_appeal BOOL DEFAULT NULL,

      -- Add reviewed column
    reviewed date
);
```

gluing everything together till now 

```sql
-- Create the loan table
create table loan (
    borrower_id INTEGER REFERENCES borrower(id),
    bank_id INTEGER REFERENCES bank(id),
      -- 'approval_date': the loan approval date
    approval_date date NOT NULL DEFAULT CURRENT_DATE,
    -- 'gross_approval': amounts up to $5,000,000.00
      gross_approval DECIMAL(9, 2) NOT NULL,
      -- 'term_in_months': total # of months for repayment
    term_in_months Smallint NOT NULL,
    -- 'revolver_status': TRUE for revolving line of credit
      revolver_status boolean NOT NULL DEFAULT FALSE,
      initial_interest_rate DECIMAL(4, 2) NOT NULL
);
```

### Datebase normalization

normalization is applied to tables to ensure:

- no anomalies

- the integrity of data.

## Access control

fdefault: `postgres` superuser role is used for adminstrations purposes:

- creating databases

- dropping databases

- inserting records

- deleting records

- dropping tables 

it should be used with care

### Creatig new Users

we create user for that specific database

```sql
CREATE USER olduser;
```

the olduser has no access to tables created by other users

olduser account does not have password by default 

```sql
CREATE USER newuser WITH PASSWORD 'secret';
```

```sql
ALTER USER olduser WITH PASSWORD 'new_password'
```

**Acess privileges**

- Users are a type of fole

- Group roles can aslo be defined

- Database objects access given to roles (database itself, tables as well as schemas);

> when creating a database object, the user that created the object owns it

other roles can access th object is granted privileges to access the object by it's owner

`GRANT`:

- `SELECT`

- `UPDATE`

- `DELETE`

```sql
GRANT p ON obj TO grantee;
--- let's demonstarate it by an example
```

```sql
create table account (
    id serial primary key,
    short_name varchar(25),
    provider_id integer references provider(id),
    balance decimal
)
```

when this table is created, it was created by superuser (postres), therefore when a new user account is created `yousef` for example will not have the privileges to access or modify the account table

```sql
create user yousef with password '4cex01bk';
```

we give privileges to users based on their scope of actions

```sql
GRANT INSERT ON account To yousef;
GRANT UPDATE ON account To yousef;
GRANT SELECT ON account TO yousef;
```

though we have some limitation of the `GRANT` command 

>  while many of the privileges on a table can be granted directly to a role the onwer, certain commands can only be executed by the table's owner

for example

- modifiying the table structure:       
  
  - renaming the table or columns
  
  - adding new column

only this can be done if we altered the table and give the ownership to `yousef`

```sql
ALTER TABLE account OWNER TO yousef;
```

### Hierarchical access control

Hierarchical privileges are  done using `groups` and `schemas`

1. **schema-based access**
- schema - names container for database objects such as tables and other things 

- schemas can be used for access control

granting privileges specicif to different schemas in a databas

 can be used to easily control access to multiple objects simulataneously

look for this scenario to understand better 

```sql
create schema me;
create schema spouse;

create table me.account (

);
create table spouse.account (

)

-- a new user account is created for your spouse 
create user better_half with password 'changeme';
GRANT USAGE ON SCHEMA spouse TO better_half;
GRANT USAGE ON SCHEMA public TO better_half
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA spouse;
To better_half
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public;
TO better_half;
-- but no privileges are given to better_half on `me` schema
```

2. **group-based**
- Group - a type of role that indentifies one or more users

- Access control can be applied at group level

```sql
CREATE GROUP family;
GRANT USAGE ON SCHEMA public to family;
GRANT SELECT,UPDATE, INSERT, DELETE ON ALL TABLES IN SCHEMA public to family;
```

```sql
ALTER GROUP family add user ahmed;
ALTER GROUP family add user better_half; -- those users will inherit then the privlges fro mthe group 
```

with such a setup, the family group can be given access to all tables in the public schema, each family member could have then a schema of a their own for maintaing their individua financial date.

another case study:

3 developer are hired into a new company, before starting to work, each one is given a new account

```sql
-- Create a user account for Ronald Jones
CREATE USER rjones WITH PASSWORD 'changeme';

-- Create a user account for Kim Lopez
CREATE USER klopez WITH PASSWORD 'changeme';

-- Create a user account for Jessica Chen
CREATE USER jchen WITH PASSWORD 'changeme';

-- Create the dev_team group
CREATE GROUP dev_team;

-- Grant privileges to dev_team group on loan table
GRANT INSERT, UPDATE, DELETE, SELECT ON loan TO dev_team;

-- Add the new user accounts to the dev_team group
ALTER GROUP dev_team ADD USER rjones, klopez, jchen;
```

in this case, the software development team will make a development enviroment seperated from the production enviroment so the team lead decided to make a development schema seperated from production (public) one 

```sql
-- Create the development schema
Create schema development;

-- Grant usage privilege on new schema to dev_team
grant usage ON SCHEMA development TO dev_team;

-- Create a loan table in the development schema
create table development.loan (
    borrower_id INTEGER,
    bank_id INTEGER,
    approval_date DATE,
    program text NOT NULL,
    max_amount DECIMAL(9,2) NOT NULL,
    gross_approval DECIMAL(9, 2) NOT NULL,
    term_in_months SMALLINT NOT NULL,
    revolver_status BOOLEAN NOT NULL,
    bank_zip VARCHAR(10) NOT NULL,
    initial_interest_rate DECIMAL(4, 2) NOT NULL
);

-- Grant privileges on development schema
grant SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA development TO dev_team;
```

#### Removing access

using `REVOKE`

suppose you have this scenairo where you give your cousin all the privileges on the database schema and after then you found he mistakenly deleted it, so you decided to revoke the delete or truncate statement from here

```sql
CREATE USER cousin;   
ALTER GROUP family ADD USER cousin;
GRANT ALL PRIVILEGES ON finances.* TO cousin;
```

```sql
REVOKE DELETE, TRUNCATE ON finances.* FROM cousin; -- or 
REVOKE ALL PRIVILEGES ON finances.* FROM cousin;
```

`REVOKE` can remove users from groups

```sql
REVOKE family FROM cousin;
```

use case 

```sql
-- Create the project_management group
create group project_management;

-- Grant project_management SELECT privilege
GRANT select ON  loan TO project_management;

-- Add Kim's user to project_management group
alter group project_management ADD USER klopez;

-- Remove Kim's user from dev_team group
REVOKE dev_team FROM klopez;
```

Summing all up to this moment

```sql
-- Create the new analysis schema
CREATE SCHEMA analysis;

-- Create a table unapproved loan under the analysis schema
CREATE TABLE analysis.unapproved_loan (
    id serial PRIMARY KEY,
    loan_id INTEGER REFERENCES loan(id),
    description TEXT NOT NULL
);

-- Create 'data_scientist' user with password 'changeme'
CREATE USER data_scientist WITH password 'changeme';

-- Give 'data_scientist' ability to use 'analysis' schema
GRANT usage ON schema analysis TO data_scientist;

-- Grant read-only access to table for 'data_scientist' user
grant SELECT ON analysis.unapproved_loan TO data_scientist;
```

## Next Steps

- Database objects (e.g views and functions)

- Data types (e.g geometric and array-based)

- Normalization (e.g 4NF)

- Access control (further)
