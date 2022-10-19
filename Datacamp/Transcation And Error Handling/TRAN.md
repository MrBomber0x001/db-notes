---
layout: post
title: Transcations & Concurrency control (Theory and Practice) in T-SQL - Part 1
subtitle: 
cover-img: /assets/img/cover.jfif
thumbnail-img: /assets/img/t-sql.jpg
share-img: /assets/img/path.jpg
tags: [sql, database]
---
## Table of Content

1. Humble Intro to Transcations.
2. Controlling Transactions
3. Handling Erros in Transactions

## Transactions in SQL Server

<put here the table of bank transcations database>

**Transaction**: _atomic_ unit of work that might include multiple activities that **query** and **modify** data, A one or more statements, all or none of the statment are executed.

Imagine we have a bank account database, we need to transfer $100 from account A to  account B
the procedure as came to your mind is

1. Subtract 100 from A
2. Add those 100 to B
so the operation here needs to be done as all statement , or not

**Genreal Statement**

```sql
BEGIN {TRAN | TRANSACTION }
   [ { transcation_name | @tran_name_variable}
      [ WITH MARK ['description'] ]
  ]
[;]
```

We can optionally add a transcation name and WITH MARK

```sql
 COMMIT [ {TRAN | TRANSACTION } [transcation_name | transc_name_variable ]]
[ WITH (DELAYED_DURABILITY = {OFF | ON } )][;]
```

once the commit is executed, the effect of transaction can't be reversed

`ROLLBACK` reverts the transaction to the beginning of it or a `savepoint` inside the transaction

```sql
ROLLBACK {TRAN | TRANSACTION }
[ {transcation_name | @tran_name_variable | savepoint_name | @savepoint_variable } [;]
```

we can define the boundaries (Beginning and end) of the transaction either:

1. Explicitly
The start of a transaction is defined by BEGIN and the end either to be
COMMIT (in case you of success) or ROLLBACK if you need to undo changes

```sql
BEGIN TRAN
         --your query
COMMIT TRAN;
```

2. Implicitly
MS SQL Server automatically commits the transaction at the end of each individual statement, in case you didn't specify this explicitly
we can change this behavior by changing the session option [IMPLICIT_TRANSACTION] to ON, by doing so, we don't need to specify the beginning of tran, but we need to specify the end of the train either committing it or rollbacking it.

### Transaction properties

Transactions have four props: ACID

- Atomicity
- Consistency
- Isolation
- Durability

an example

```sql
BEGIN TRAN;
UPDATE accounts SET current_balance = current_balance - 100 WHERE account_id = 1;
INSERT INTO transactions VALUES (1, -100, GETDATE());
UPDATE accounts SET current_balance = current_balance + 100 WHERE account_id = 5;
INSERT INTO transactions VALUES (5, 100, GETDATE());
COMMIT TRAN;
```

the second example uses rollback, which will revert the operation to the original state

```sql
BEGIN TRAN;
UPDATE accounts SET current_balance = current_balance - 100 WHERE account_id = 1;
INSERT INTO transactions VALUES (1, -100, GETDATE());
UPDATE accounts SET current_balance = current_balance + 100 WHERE account_id = 5;
INSERT INTO transactions VALUES (5, 100, GETDATE());
ROLLBACK TRAN;
```

third example with try... catch
we surrond transcation with try and catch

```sql
BEGIN TRY
   BEGIN TRAN;
      UPDATE accounts SET current_balance = current_balance - 100 WHERE account_id = 1;
      INSERT INTO transactions VALUES (1, -100, GETDATE());
      UPDATE accounts SET current_balance = current_balance + 100 WHERE account_id = 5;
      INSERT INTO transactions VALUES (5, 100, GETDATE());
   COMMIT TRAN;
END TRY
BEGIN CATCH
   ROLLBACK TRAN;
END CATCH
```

a fourth example of implicit transaction, which will cause only a three statement to be executed correctly.

```sql
UPDATE accounts SET current_balance = current_balance - 100 WHERE account_id = 1;
INSERT INTO transactions VALUES (1, -100, GETDATE());
UPDATE accounts SET current_balance = current_balance + 100 WHERE account_id = 5;
INSERT INTO transactions VALUES (500, 100, GETDATE()); -- ERROR!
```

resulting in an **inconsistent** state

### Exercises

```sql

BEGIN TRY  
 Begin TRAN;
  UPDATE accounts SET current_balance = current_balance - 100 WHERE account_id = 1;
  INSERT INTO transactions VALUES (1, -100, GETDATE());
        
  UPDATE accounts SET current_balance = current_balance + 100 WHERE account_id = 5;
  INSERT INTO transactions VALUES (5, 100, GETDATE());
 Commit TRAN;
END TRY
BEGIN CATCH  
 rollback TRAN;
END CATCH
```

```sql
BEGIN TRY  
 -- Begin the transaction
 BEGIN tran;
  UPDATE accounts SET current_balance = current_balance - 100 WHERE account_id = 1;
  INSERT INTO transactions VALUES (1, -100, GETDATE());
        
  UPDATE accounts SET current_balance = current_balance + 100 WHERE account_id = 5;
        -- Correct it
  INSERT INTO transactions VALUES (500, 100, GETDATE());
    -- Commit the transaction
 Commit TRAN;    
END TRY
BEGIN CATCH  
 SELECT 'Rolling back the transaction';
    -- Rollback the transaction
 Rollback tran;
END CATCH
```

using `@@ROWCOUNT` to control when to rollback the transcation

```sql
-- Begin the transaction
begin tran; 
 UPDATE accounts set current_balance = current_balance + 100
  WHERE current_balance < 5000;
 -- Check number of affected rows
 IF @@ROWCOUNT > 200 
  BEGIN 
         -- Rollback the transaction
    Rollback tran; 
   SELECT 'More accounts than expected. Rolling back'; 
  END
 ELSE
  BEGIN 
         -- Commit the transaction
   commit tran
   ; 
   SELECT 'Updates commited'; 
  END
```

### @TRANCOUNT and savepoints

savepoints:
@@TRANCOUNT returns the **number of BEGIN TRAN** statements that are active in your current connection
Returns:

- 0 -> no open transactions
- greater than 0 -> open transaction

It's modified by:

- BEGIN TRAN -> (which increases @@TRANCOUNT by 1) @@TRANCOUNT + 1
- COMMIT TRAN -> @@TRANCOUNT - 1
- ROLLBACK TRAN -> @@TRANCOUNT = 0 (except with savepoint_name)

an example of @@TRANCOUNT in nested transaction

```sql
SELECT @@TRANCOUNT AS '@@TRANCOUNT value'; -- 0
BEGIN TRAN;
    SELECT @@TRANCOUNT AS '@@TRANCOUNT value'; -- 1
    DELETE  transcations;
    BEGIN TRAN;
          SELECT @@TRANSCOUNT AS '@@TRANCOUNT value'; -- 2
          DELTE accounts;
    COMMIT TRAN; -- (2-1 = 1)
    SELECT @@TRANSCOUNT AS '@@TRANSCOUNT value'; -- 1
ROLLBACk TRAN; -- (0)
SELECT @@TRANCOUNT AS '@@TRANCOUNT value'; -- 0
```

| @@TRASCOUNT value |
| -- |
| 0|

@@TRANCOUNT in a TRY..CATCH construct

```sql
BEGIN TRY
   BEGIN TRANS;
      UPDATE account SET current_balance = current_balance - 100 WHERE account_id = 1;
      INSERT INTO transactions VALUES (1, -100, GETDATE())

      UPDATE accounts SET current_balance = current_balance + 100 WHERE account_id = 5;
      INSERT INTO transcations VALUES (5, 100, GETDATE());

   IF (@@TRANCOUNT > 0)
      COMMIT TRAN;
END TRY
BEGIN CATCH
   IF (@@TRANCOUNT > 0)
      ROLLBACK TRAN;
END CATCH
```

Savepoints are:

- Markers within a transcations
- Allow to rollback to the savepoints

```sql
SAVE {TRAN | TRANSACTION} {savepoint_name | @savepoint_variable}
[;]
```

let's see an example

```sql
BEGIN TRAN
   SAVE TRAN savepoint1
   INSERT INTO customers VALUES ('Yousef', 'Meska', 'yousefmeska123@gmail.com', '01211212797')

   SAVE TRAN savepoint2
   INSERT INTO customers VALUES ('Omar', 'Meska', 'omarmeska123@gmail.com', '01011010676')

   ROLLBACK TRAN savepoint1
   ROLLBACK TRAN savepoint2

   SAVE TRAN savepoint3
   INSERT INTO customers VALUES ('ahmed', 'meska', 'ahmedmeska123@gmail.com', '01212')
COMMIT TRAN
```

only the last insert will took place

:notebook: note:
savepoints don't affect the value of @@TRANSCOUNT

### Examples

```sql
BEGIN TRY
 -- Begin the transaction
 begin tran;
     -- Correct the mistake
  UPDATE accounts SET current_balance = current_balance + 200
   WHERE account_id = 10;
     -- Check if there is a transaction
  IF @@trancount > 0     
      -- Commit the transaction
   commit tran;
     
 SELECT * FROM accounts
     WHERE account_id = 10;      
END TRY
BEGIN CATCH  
    SELECT 'Rolling back the transaction'; 
    -- Check if there is a transaction
    IF @@trancount > 0    
     -- Rollback the transaction
        rollback tran;
END CATCH
```

```sql
BEGIN TRAN;
 -- Mark savepoint1
  SAVE TRAN savepoint1;
 INSERT INTO customers VALUES ('Mark', 'Davis', 'markdavis@mail.com', '555909090');

 -- Mark savepoint2
    SAVE TRAN savepoint2;
 INSERT INTO customers VALUES ('Zack', 'Roberts', 'zackroberts@mail.com', '555919191');

 -- Rollback savepoint2
 Rollback tran savepoint2    -- Rollback savepoint1
rollback tran savepoint2
 -- Mark savepoint3
 save tran savepoint3
 INSERT INTO customers VALUES ('Jeremy', 'Johnsson', 'jeremyjohnsson@mail.com', '555929292');
-- Commit the transaction
COMMIT TRAN;
```

## Controlling Errors of Transcations (XACT_ABORT & XACT_STATE)

`XACT_ABORT` specified whthere the currenct transction will be automatically rolled back when an error occrus

It can be set to on or off.

```sql
SET XACT_ABORT { ON | OFF}
```

If an error occurs under the default setting which is by default `OFF`, the transcation can automatically be rolled back or not, depending on the error, if the transcations is not rolled back, **it remains open**

Setting it to ON, will ensure the transcation will be rolled bacek when an error occures and abort the transaction

```sql
SET XACT_ABORT ON
```

Let's see an examples

```sql
SET XACT_ABORT OFF
BEGIN TRAN
   INSERT INTO customers VALUES ('yousef', 'meska', 'yousefmeska123@gmail.com', '1545')
   INSERT INTO customers VALUES ('omar', 'meska', 'omarmeska.com', '1546') -- ERROR!
COMMIT TRAN
```

The last statement generate an error of violating the uniqe key 'unique_email'

```
Violation of UNIQUE KEY 'unique_email'
```

If we checked the customers table we'll see the first statement has been executed despite an error found on the transaction

| customer_id | first_name | last_name | email | phone |
| --- | ---- | --- | --- | --- |
| 14 | yousef | meska | yousefmeska123.com | 1545 |

Now If we turned XACT_ABORT to ON, the transaction will be rolled back an aborted

| customer_id | first_name | last_name | email | phone |
| --- | ---- | --- | --- | --- |

### XACT_ABORT with RAISEERROR and THROW statement

```sql
SET XACT_ABORT ON

BEGIN TRAN
 INSERT INTO Users ('yousef', 'meska', 'yousefmeska123@gmail.com', '011000000')
    RAISERROR('An Error occured', 16 ,1);
    INSERT INTO Users ('omar', 'meska', 'omarmeska123@gmail.com', '012000000')
 COMMIT TRAN
 
SELECT * FROM Users WHERE first_name IN ('yousef', 'omar')

-- What's the output ?


SET XACT_ABORT ON

BEGIN TRAN
 INSERT INTO Users ('yousef', 'meska', 'yousefmeska123@gmail.com', '011000000')
 THROW 55000, 'An Error occured', 1;
 INSERT INTO Users ('omar', 'meska', 'omarmeska123@gmail.com', '012000000')
COMMIT TRAN
 
SELECT * FROM Users WHERE first_name IN ('yousef', 'omar')


-- What's the output ? and why ?

# Answer

1. Setting XACT_ABORT to ON, will rollback the transaction if an error occured and abort the execution
However, using `RAISERROR()` will not affect `XACT_ABORT`.
So the output will be an error which will be shown to the user and the transcation will take place.

2. So microsoft recommend using `THROW` instead because it will affect XAACT_ABORT and the transaction will be rolledback in addition to the error message that will be shown to the user
```

### XACT_STATE

```sql
XACT_STATE()
```

It doesn't take any parameter.
It returns

- `0` -> no open transaction
- `1` -> Open and committable transaction
- `-1` -> Open and uncommitable transactions (Doomed transaction)

When a transaction is **Doomed** that's means

- You can't commit
- You can't rollback ot a savepoint
- You can only rollback the full transaction
- You can't make any changes but you can read data

Let's see an examples
In this example, the transcation will will commited if there's no error between TRY block, if there's an error, the catch will handle it by determing the state of the transcation
And the state of the transaction will remains opem and commitable because we set `XACT_ABORT` to OFF
if the transaction is commitable then the transcation will be commited
if not it will be rolled backs

```sql
SET XACT_ABORT OFF -- if there's an error the transaction will be open if not rolled back
BEGIN TRY
   BEGIN TRAN
      INSERT INTO customers VALUES ('x', 'y', 'x@gmail.com')
      INSERT INTO customers VALUES ('z', 'u', 'z@gmail.com') -- ERROR!
   COMMIT TRAN
END TRY
BEGIN CATCH
   IF XACT_STATE() = -1
      ROLLBACK
   IF XACT_STATE = 1
      COMMIT
   SELECT ERROR_MESSAGE() As error_messag
END CATCH
```

Only the first statement will be committed
| customer_id | first_name | last_name | email |
| --- | ---- | --- | --- |
| 15 | x | y | x@gmail.com |

Let's see what happens when we need to make the transaction uncommitable?

```sql
SET XACT_ABORT ON -- the transaction will remains open but uncommitable
BEGIN TRY
   BEGIN TRAN
      INSERT INTO customers VALUES ('x', 'y', 'x@gmail.com')
      INSERT INTO customers VALUES ('z', 'u', 'z@gmail.com') -- ERROR!
   COMMIT TRAN
END TRY
BEGIN CATCH
   IF XACT_STATE() = -1
      ROLLBACK
   IF XACT_STATE = 1
      COMMIT
   SELECT ERROR_MESSAGE() As error_messag
END CATCH
```

| customer_id | first_name | last_name | email |
| --- | ---- | --- | --- |

The transaction has beed rolled back

### Exercises

```sql
-- Use the appropriate setting
SET XACT_ABORT off;
-- Begin the transaction
Begin transaction; 
 UPDATE accounts set current_balance = current_balance - current_balance * 0.01 / 100
  WHERE current_balance > 5000000;
 IF @@ROWCOUNT <= 10 
     -- Throw the error
  Throw 55000, 'Not enough wealthy customers!', 1;
 ELSE  
     -- Commit the transaction
  Commit transaction; 
```

```sql
-- Use the appropriate setting
SET XACT_ABORT on;
BEGIN TRY
 BEGIN TRAN;
  INSERT INTO customers VALUES ('Mark', 'Davis', 'markdavis@mail.com', '555909090');
  INSERT INTO customers VALUES ('Dylan', 'Smith', 'dylansmith@mail.com', '555888999');
 COMMIT TRAN;
END TRY
BEGIN CATCH
 -- Check if there is an open transaction
 IF XACT_STATE() <> 0
     -- Rollback the transaction
  Rollback tran;
    -- Select the message of the error
    SELECT error_message() AS Error_message;
END CATCH
```
