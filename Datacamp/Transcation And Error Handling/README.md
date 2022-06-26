---
layout: post
title: How to Handle T-SQL Errors Properly [Extensive guide]
subtitle: 
cover-img: /assets/img/cover.jfif
thumbnail-img: /assets/img/Inkedk0QFwX.jpg
share-img: /assets/img/Inkedk0QFwX.jpg
tags: [sql]
---


## Introduction

![giphy.gif](<https://cdn.hashnode.com/res/hashnode/image/upload/v1656254959441/Hz9dG9JiL.gif>)

As a Backend Software Engineer, you will be working with databases a lot on a regular basis, so you should get comfortable reading SQL errors to properly fix them, so it's an essential skill for you as a developer and troubleshooter as well. <br>

Errors in T-SQL are of many types, based on the error you get, you can decide the optimal solution for it.
So In this article, I will show you how to **read**, **handle** and even **customize** your errors.

## Table of Contents

1. Starting with error handling.
2. Raising, throwing, and customizing your errors.
3. Resources.

## Error Handling

let's begin with an example to demonstrate the concept of errors on SQL server
Imagine you have a database consisting of Products, Buyers, Staff, and Orders
and you have a unique constraint on the product table (on product_name)

```sql
CONSTRAINT unique_product_name UNIQUE (product_name);
```

And you tried to insert a product with a name that already exits

```sql
INSERT INTO products (product_name, stock, price)
    VALUES ('Trek Powerfly 5 - 2018', 10, 3499.99);
```

🤔 what do you think you will get? <br>
Of course an error

```
Violation of UNIQUE KEY constraint 'unique_product_name'.
Cannot insert duplicate key in object 'dbo.products'.
The duplicate key value is (Trek Powerfly 5 - 2018).
```

we can handle this kind of Error using the `Try catch` block. <br>
The syntax of try-catch on SQL is nearly similar to the ones on programming languages,
you begin with try and end with catch, you see it's that simple 😄. <br>

The General syntax

```sql
BEGIN TRY
    { sql_statement | statement_block }
END TRY
BEGIN CATCH
    [ { sql_statement | statement_block } ]
END CATCH
[ ; ]
```

In case of your query inside Try throw an error, then you place your error handling statements with the catch block. <br>
If there is no error, the catch block is skipped

**An example of a statement that fails**

```sql
BEGIN TRY
    INSERT INTO products (product_name, stock, price)
        VALUES ('Trek Powerfly 5 - 2018', 10, 3499.99);
    SELECT 'Product inserted correctly!' AS message;
END TRY
BEGIN CATCH
    SELECT 'An error occurred! You are in the CATCH block' AS message;
END CATCH
```

| message |
|-----------------------------------------------|
| An error occurred! You are in the CATCH block |

**An example of successful Insertion**

```sql

BEGIN TRY
    INSERT INTO products (product_name, stock, price)
    VALUES ('Super new Trek Powerfly', 5, 1499.99);
    SELECT 'Product inserted correctly!' AS message;
END TRY
BEGIN CATCH
    SELECT 'An error occurred! You are in the CATCH block' AS message;
END CATCH
```

| message |
|-----------------------------|
| Product inserted correctly! |

### Nested try..catch

A try block or a catch block can `nest` another try-catch block. <br>
**an example of nested try-catch**

```sql
BEGIN try
    INSERT INTO products (product_name, stock, price)
    VALUES ('Trek Powerfly 5 - 2018', 10, 3499.99);
    SELECT 'Product inserted correctly!' AS message
END TRY

BEGIN catch
    SELECT 'An error occurred inserting the product!
            You are in the first CATCH block' AS message;
    BEGIN TRY
        INSERT INTO myErrors
            VALUES ('ERROR!');
        SELECT 'Error inserted correctly!' AS message;
    END TRY
    BEGIN CATCH
        SELECT 'An error occurred inserting the error!
        You are in the second CATCH block' AS message;
    END CATCH
END CATCH
```

| message |
|--|
| An error occurred inserting the product! You are in the first CATCH block |

| message |
|---|
| An error occurred inserting the error! You are in the second CATCH block |

#### Exercise

You have a stock attribute on `products` table and you can't have negative values on this attribute.

```sql
-- Set up the TRY block
BEGIN TRY
    -- Add the constraint
    ALTER TABLE products
        ADD CONSTRAINT CHK_Stock CHECK (stock >= 0);
END TRY
-- Setcatc up the CATCH block
BEGIN CATCH
    SELECT 'An error occurred!';
END CATCH
```

| query result |
| --- |
| An error occurred!|

```sql
-- Set up the first TRY block
BEGIN TRY
    INSERT INTO buyers (first_name, last_name, email, phone)
        VALUES ('Peter', 'Thompson', 'peterthomson@mail.com', '555000100');
END TRY
-- Set up the first CATCH block
BEGIN CATCH
    SELECT 'An error occurred inserting the buyer! You are in the first CATCH block';
    -- Set up the nested TRY block
    BEGIN TRY
        INSERT INTO errors
            VALUES ('Error inserting a buyer');
        SELECT 'Error inserted correctly!';
    END  TRY
    -- Set up the nested CATCH block
    BEGIN CATCH
        SELECT 'An error occurred inserting the error! You are in the nested CATCH block';
    END CATCH
END CATCH

```

### Error Anatomy and uncatchable error

📓**note**: </br>
> Not all errors are catchable

```sql
INSERT INTO products (product_name, stock, price)
VALUES ('Trek Powerfly 5 - 2018', 10, 3499.99);
```

```
Msg 2627, Level 14, State 1, Line 1
Violation of UNIQUE KEY constraint 'unique_name'.
Cannot insert duplicate key in object 'dbo.products'.
The duplicate key value is (Trek Powerfly 5 - 2018).
```

Let's break down the error message, to compose a useful information and know exactly how to handle error based on it's Anatomy <br>

* The first line is `error number` -> sql errors  from `1 to 49999`

You can also create your own starting from `50001`

`select * from sys.message` -> to know the complete log of error numbers

| message_id | language_id | severity | ... | text |
| --- | --- | --- | --- | --- |
| 2627 | 1033| 14 | .. | Violation of %ls constraint '%.*ls'. Cannot insert duplcate... |

* The second value is `severity level`

* from `0 - 10`: informational messages (warnings)
* from `11 - 16`: errors that can be corrected by the user (constraint violation, etc.)
* from `17 - 26`: other errors (software problems, fatal errors)

you can see the whole list through the docuemntation

* the third value is the state: it gives you more information about the error
1: if SQL server display an error
0-255: own errors -> to raise your own error

* The fourth value is `Line`  -> give you the line number.

Finally, if the error happens within a stored procedure` or a `trigger`, you will receive extra data giving you the name of the stored procedure or the name of the trigger

### Uncatchable Errors

the try cath we've learned can't catch every kind of error.

* Severity lower than 11 (Uncatchable)
* Severity 11 -> 19 (catchable)
* Compilation errors: objects and columns that don't exist

the severity of 20 or higher that stopped the connection will not be caught but if it didn't cut the connection, it will be caught

compilation error: object and column that doesn't exist

**An example**

```sql
BEGIN TRY
    select non-existent_column from products;
END TRy
BEGIN CATCH
    select 'you are in the CATCH Block' as message;
end catch
```

notice the output?

```
Msg 207, Level 16, State 1, Line 2
Invalid column name 'non_existent_column'.
```

It doesn't give you the actual error which is `you are in the CATCH Block` As this is a compilation error, the `CATCH` block can
t handle the error

### Giving information about the error

```
Msg 2627, Level 14, State 1, Line 1
Violation of UNIQUE KEY constraint 'unique_name'.
Cannot insert duplicate key in object 'dbo.products'.
The duplicate key value is (Trek Powerfly 5 - 2018).
this is the original error
```

and this is the error returned from the catch block

```sql
BEGIN TRY
    INSERT INTO products (product_name, stock, price)
    VALUES ('Trek Powerfly 5 - 2018', 10, 3499.99);
    SELECT 'Product inserted correctly!' AS message;
END TRY
BEGIN CATCH
    SELECT 'An error occurred! You are in the CATCH block' AS message;
END CATCH
```

| message |
|-----------------------------------------------|
| An error occurred! You are in the CATCH block |

sometimes the default error the query throws is very useful, and by overriding it using CATCH with an error statement we lose the default, however, can still retrieve it using

### Error functions

`ERROR_NUMBER()` returns the number of the error.
`ERROR_SEVERITY()` returns te error severity (11-19)
`ERROR_STATE()`  returns the state of the error
`ERROR_LINE()` returns the number of the line error
`ERROR_PROCEDURE()` returns the name of the stored proc/trigger, Null if there is no stored pro/trig
`Error_message()`

**An Example**

```sql
BEGIN TRY
    INSERT INTO products (product_name, stock, price)
        VALUES ('Trek Powerfly 5 - 2018', 10, 3499.99);
END TRY
BEGIN CATCH
    SELECT
    ERROR_NUMBER() AS Error_number,
    ERROR_SEVERITY() AS Error_severity,
    ERROR_STATE() AS Error_state,
    ERROR_PROCEDURE() AS Error_procedure,
    ERROR_LINE() AS Error_line,
    ERROR_MESSAGE() AS Error_message;
END CATCH
```

| Error_number| Error_severity| Error_state| Error_procedure| Error_line| Error_message|
|-------------|---------------|------------|----------------|-----------|--------------|
| 2627 | 14 | 1 | NULL | 2 | Violation of UNIQUE KEY constraint 'unique_name'... |

⛔**Warning**: <br>
> We can't use error functions outside the catch block

```sql
SELECT
ERROR_NUMBER() AS Error_number,
ERROR_SEVERITY() AS Error_severity,
ERROR_STATE() AS Error_state,
ERROR_PROCEDURE() AS Error_procedure,
ERROR_LINE() AS Error_line,
ERROR_MESSAGE() AS Error_message;
```

you will get `nulls`

we can use it inside nested try and catch,
But in this case, you will get the last error that occurred

```sql
BEGIN TRY
    INSERT INTO products (product_name, stock, price)
    VALUES ('Trek Powerfly 5 - 2018', 10, 3499.99);
END TRY
BEGIN CATCH
    BEGIN TRY
    INSERT INTO myErrors
        VALUES ('ERROR!')
END TRY
BEGIN CATCH
    SELECT 'Outer CATCH block' AS 'Error_from',
        ERROR_NUMBER() AS Error_number,
        ERROR_MESSAGE() AS Error_message;
    END CATCH
END CATCH
```

```sql
BEGIN TRY
    INSERT INTO products (product_name, stock, price) 
    VALUES  ('Trek Powerfly 5 - 2018', 2, 3499.99),         
            ('New Power K- 2018', 3, 1999.99)       
END TRY
-- Set up the outer CATCH block
BEGIN CATCH
    SELECT 'An error occurred inserting the product!';
    -- Set up the inner TRY block
    BEGIN TRY
        -- Insert the error
        INSERT INTO errors 
            VALUES ('Error inserting a product');
    END Try    
    -- Set up the inner CATCH block
    BEGIN CATCH
        -- Show number and message error
        SELECT 
            ERROR_LINE() AS line,      
            ERROR_MESSAGE() AS message; 
    END CATCH    
END CATCH

```

## Raising, throwing and customizing your errors

In this section, we will learn

* How to raise errors.
* Re-throw original errors.
* Create your own defined errors.

### Raise errors statements

SQL Server provides two statements to raise errors

* `RAISEERROR`
* `THROW` (Microsoft recommend using it on new application)

**RAISERROR syntax**

```sql
RAISEERROR ( {msg_str | msg_id | @local_variable_message}, severity, state, [ argument [, ...n]])
[WITH option [,...n]]
```

* the first parameter can be a message string, a message-id, or a variable that contains the message string.
* the second Parameter -> severity
* the third -> state

you can optionally add arguments, like strings or numbers

if the message string has some parameter placeholders such as %s or %d, these arguments will replace them

#### RAISERROR with message string

```sql
if not exits( select * from staff where staff_id = 15)
    RAISERROR('No staff member with such id', 16, 1);
```

```
Msg. 50000, Level 16, State 1, Line 3
No staff member with such an id
```

If we don't specify an error number, the error number will always be `50000`

Let's change the message text with `placeholders`

```sql
RAISERROR('No %s member with such id %d. ', 16, 1, 'staff member', 15);
```

```
Msg. 50000, Level 16, State 1, Line 3
No staff member with id 15
```

It's recommended to look at Microsoft documentation for more information

#### RAISERROR with error number

```sql
RAISERROR(60000, 16, 1);
```

```
Msg. 60000, Level 16, State 1, Line 1
This is a test message
```

This error number comes from `sys.messages`

**RIASERROR - Example with Try .. Catch**

```sql
BEGIN TRY
    IF NOT EXISTS (SELECT * FROM staff WHERE staff_id = 15)
        RAISERROR("No Staff member with such id.", 9, 1)
END TRY
BEGIN CATCH 
    SELECT "You are in the CATCH block" AS message
END CATCH
```

```
No staff member with such id
Msg. 50000, Level 9, State 1
```

As you might've guessed, errors below `11` are not catchable.

if we changed the severity level from 9 to 11, the error will be caught by the catch

| message |
| --- |
You are in the CATCH Block |

#### Exercise

```sql
BEGIN TRY
    -- Change the value
    DECLARE @product_id INT = 5;
    IF NOT EXISTS (SELECT *FROM products WHERE product_id = @product_id)
        RAISERROR('No product with id %d.', 11, 1, @product_id);
    ELSE
SELECT* FROM products WHERE product_id = @product_id;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE();
END CATCH
```

### Throw statment

> Recommended by Microsoft over RAISERROR statement

**General syntax**

```sql
THROW [error_number, message, state][;]
```

📓**note**:<br>
unlike the RAISERROR statement, the THROW statement allows re-throwing an original error caught by a CATCH block

#### Throw - Without parameters

```sql
BEGIN TRY
    SELECT price/0 from orders;
END TRY
BEGIN CATCH
    THROW;
    SELECT 'This line is executed!' as message;
END CATCH
```

The original error caused from the try block is dividing by 0, so the output mesasge is the thrown original error

```
(0 rows affected)
Msg. 8134, Level 16, State 1, Line 2
Divide by zero error encountered.
```

and `SELECT` statement inside catch has not been executed;

be careful when writing THROW at the end, you should put a semi-colon before the line

```sql
BEGIN TRY
    SELECT price / 0 from orders
END TRY
BEGIN CATCH 
    SELECT 'This line is executed!'
    THROW;
END CATCH
```

| THROW |
| --- |
| This line is executed! |
SQL Server thinks that the word THROW is an alias for the select statement

#### Throw - with parameters

This syntax can be included within a CATCH block or outside of it.

```sql
THROW 52000, 'This is an example, 1;
```

**An example**

```sql
BEGIN TRY
    IF NOT EXISTS (SELECT * FROM staff FROM staff_id = 15)
        THROW 51000, 'This is an example', 1;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() as message;
END CATCH
```

But only statements with no parameter should be put on the `catch` block

| message |
| --- |
| This is an example |

**Another example**

```sql
CREATE PROCEDURE insert_product
    @product_name VARCHAR(5),
    @stock INT,
    @price DECIMAL
AS
BEGIN TRY
    INSERT INTO products (product_name, stock, price)
        VALUES (@product_name, @stock, @price)
END TRY
BEGIN CATCH
    INSERT INTO errors VALUES ('Error inserting a product');
        THROW;
END CATCH
```

```sql
BEGIN TRY
    EXEC insert_product
    @product_name = 'Trek Conduit+'
    @stock = 3,
    @price = 499.99
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE();
END CATCH
```

### customizing error messages in THROW statements

⚠️**Warning**: <br>

throw statement doesn't allow the inclusion of parameters placeholders such as %d or %s but we have a hack around this by

1. Variable by concatenating strings
2. `FORMATEMESSAGE()` function

#### Using a variable and the CONCAT function

```sql
DECLARE @staff AS INT = 500;
DECLARE @my_message NVARCHAR(500) = CONCAT('There is no staff member for id', @staff_id, '. Try with another one)

IF NOT EXISTS (SELECT * FROM staff WHERE staff_id = @staff_id)
    THROW 50000, @my_message, 1;
```

```
Msg. 50000, Level 16, State 1, Line 5
There is no staff member for id 500. Try With another one.
```

#### Using FORMATEMESSAGE function

```sql
FORMATEMESSAGE( { ' msg_string' | msg_number }, [param_value [,...n]])
```

we can include wild cards

```sql
DECLARE @staff AS INT = 500;
DECLARE @my_message NVARCHAR(500) = FORMATEMESSAGE('There is no staff member for id %d. %s ', @staff_id, 'Try with another one');
```

notice that the throw statement doesn't allow the specification of the severity, SQL server always sets it to 16

#### FORMATEMESSAGE() with message number

In SQL server we have a view `sys.messages` which contains messages with according `message_id`

```sql
SELECT * FROM sys.messages
```

You'll get a view

| message_id | language_id | severity | is_event_logged | text |
| --- | --- | --- | --- | --- |
| 101 | 1033 | 15 | 0 | Query not allowed in Waitfor |
| ... | ... | ... | ... | ... |

we can *choose* any message_id or *add* a new message to this view to customize our errors. <br>
To add a new message to `sys.messages`, we can execute the `sp_addmessage` stored procedure with the following parameters

```sql
sp_addmessage
      msg_id, severity, msgtext,
      [ language ],
      [ with_log {'TRUE' | 'FALSE' } ],
      [ replace]
```

* msg_id must be greater than 500000

* language is optional, if you don't specify it, it would be the default language of the session.

```sql
EXEC sp_addmessage @msgnum = 55000, @severity = 16, @msgtext = 'There is no staff member for id %d. %s', @lang = 'us_english'
```

we can now use this new message_id on th `FORMATEMESSAGE()`

```sql
DECLARE @staff_id AS INT = 500;
DECLARE @my_message NVARCHAR(500) = FORMATEMESSAGE(55000, @staff_id, 'Try with another one');

IF NOT EXISTS (SELECT * FROM staff WHERE staff_id = @staff_id)
        THROW 50000, @my_messaeg, 1
```

notice that the throw statement doesn't allow the specification of the severity, SQL server always sets it to 16

**A Detailed Example**

```sql
EXEC sp_addmessage @msgnum = 50002, @severity = 16, @msgtext = 'There are not enough %s bikes. You only have %d in stock.', @lang = N'us_english';

DECLARE @product_name AS NVARCHAR(50) = 'Trek CrossRip+ - 2018';
--Change the value
DECLARE @sold_bikes AS INT = 10;
DECLARE @current_stock INT;

SELECT @current_stock = stock FROM products WHERE product_name = @product_name;

DECLARE @my_message NVARCHAR(500) =
 FORMATMESSAGE(50002, @product_name, @current_stock);

IF (@current_stock - @sold_bikes < 0)
 THROW 50000, @my_message, 1;
```

## Resources

* <a href="https://campus.datacamp.com/courses/transactions-and-error-handling-in-sql-server/raising-throwing-and-customizing-your-errors">Datacamp - Transaction and Error Handling</a>
