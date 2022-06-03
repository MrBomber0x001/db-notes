```sql
BEGIN TRY
    INSERT INTO products   (product_name, stock, price)
        values('duplicated values');
    SELECT 'product inserted correctly!' as message
End try
BEGIN CATCH
    SELECT 'An error occurred! you are in the catch block' as message
END CATCH
--- we can use the print function instead of select statement
```

we could have nestin try..catch

```sql
-- Set up the first TRY block
begin try
	INSERT INTO buyers (first_name, last_name, email, phone)
		VALUES ('Peter', 'Thompson', 'peterthomson@mail.com', '555000100');
end try
-- Set up the first CATCH block
begin CATCH
	SELECT 'An error occurred inserting the buyer! You are in the first CATCH block';
    -- Set up the nested TRY block
    begin try
    	INSERT INTO errors
        	VALUES ('Error inserting a buyer');
        SELECT 'Error inserted correctly!';
	end try
    -- Set up the nested CATCH block
    begin CATCH
    	SELECT 'An error occurred inserting the error! You are in the nested CATCH block';
    end CATCH
end CATCH
```

```sql
-- Set up the TRY block
BEGIN try
	-- Add the constraint
	ALTER TABLE products
		ADD CONSTRAINT CHK_Stock CHECK (stock >= 0);
ENd TRY
-- Set up the CATCH block
BEGIN CATCH
	SELECT 'An error occurred!';
END CATcH
```

```sql
-- Set up the TRY block
begin try
	SELECT 'Total: ' + SUM(price * quantity) AS total
	FROM orders
end try
-- Set up the CATCH block
begin catch
	-- Show error information.
	SELECT  error_number() AS number,
        	error_severity() AS severity_level,
        	error_state() AS state,
        	error_line() AS line,
        	error_message() AS message;
end catch
```

```sql
BEGIN TRY
    INSERT INTO products (product_name, stock, price)
    VALUES	('Trek Powerfly 5 - 2018', 2, 3499.99),
    		('New Power K- 2018', 3, 1999.99)
END TRY
-- Set up the outer CATCH block
begin catch
	SELECT 'An error occurred inserting the product!';
    -- Set up the inner TRY block
    begin try
    	-- Insert the error
    	INSERT INTO erorrs
        	VALUES ('Error inserting a product');
    end try
    -- Set up the inner CATCH block
    begin catch
    	-- Show number and message error
    	SELECT
        	error_line() AS line,
			error_message() AS message;
    END catch
end catch
```

```sql
if not exits(select * from staffs where staff_id = 16)
    raiserror('No staff member with such id', 16, 1)
    --or
    raiserror('No %s with id %d.', 16, 1, 'staff memeber', 16);
```

```sql
BEGIN TRY
	-- Change the value
    DECLARE @product_id INT = 50;
    IF NOT EXISTS (SELECT * FROM products WHERE product_id = @product_id)
        RAISERROR('No product with id %d.', 11, 1, @product_id);
    ELSE
        SELECT * FROM products WHERE product_id = @product_id;
END TRY
BEGIN CATCH
	SELECT ERROR_MESSAGE();
END CATCH
```

THROW

```sql
begin try
    select product_price / 0 from orders
end TRY
begin catch
    throw;
    select 'this line will not be exceuted' as message
end catch;
```

note about throw:

```sql
begin TRY
    select price / 0 from orders
end TRY
    select 'This line is exceuted'
    throw;
end catch;
```

this query willhave a different behaviour that throw here will be column, because sql server will think that 'throw' is an alias for the select statement, to solve this behaviour, we should insert ';' after select

stored procedure

```sql
CREATE PROCEDURE insert_product
  @product_name VARCHAR(50),
  @stock INT,
  @price DECIMAL

AS

BEGIN TRY
    INSERT INTO products (product_name, stock, price)
        VALUES (@product_name, @stock, @price);
END TRY
BEGIN CATCH
    INSERT INTO errors VALUES ('Error inserting a product');
    THROW;
END CATCH

BEGIN TRY
	-- Execute the stored procedure
	EXEC insert_product
    	-- Set the values for the parameters
    	@product_name = 'Trek Conduit+',
        @stock = 3,
        @price = 499.99;
END TRY
-- Set up the CATCH block
Begin catch
	-- Select the error message
	SELECT error_message();
end catch

```

customizing error messages using throw :
we can't use %d or %s inside throw, but fortuantely, there are two ways to handle this situation;
1-variable by concatenating strings
2-formatMessage() function

1-using variable

```sql
Declare @staff_id as int = 500;
declare @my_messag NVARCHAR(500) = CONCAT('there is no staff memeber for id', @staff_id, '.try with another one');

if not exists (SELECT * FROM Staff where staff_id = @staff_id)
    throw 50000, @my_message, 1;
```

2-using formatMEssage() function

```sql
Declare @staff_id as int = 500;
declare @my_messag NVARCHAR(500) = FORMATMESSAGE('there is no staff memeber for id %d. %s', @staff_id, '.try with another one');

if not exists (SELECT * FROM Staff where staff_id = @staff_id)
    throw 50000, @my_message, 1;

```

using formatmessage() msg_number

```sql
exec sp_addmessage
    @msgnum = 55000, @serverity = 16, ....
```

```sql
DECLARE @product_name AS NVARCHAR(50) = 'Trek CrossRip+ - 2018';
-- Set the number of sold bikes
DECLARE @sold_bikes AS INT = 10;
DECLARE @current_stock INT;

SELECT @current_stock = stock FROM products WHERE product_name = @product_name;

DECLARE @my_message NVARCHAR(500) =
	-- Customize the error message
	FORMATMESSAGE('There are not enough %s bikes. You have %d in stock.', @product_name, @current_stock);

IF (@current_stock - @sold_bikes < 0)
	-- Throw the error
	THROW 50000, @my_message, 1;
```

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

# Transcation

example
account 1 = $24, 400;
account 5 = $35, 300;

```sql
begin TRY
    begin transaction
        update accounts set current_balance = current_balance - 100 where account_id = 1;
        insert into transactions values(1, -100, getdate())

        update accounts set current_balance = current_balance + 100 where account_id = 5;
        insert INTO transactions values(5, 100, getDate());
    Commit tran
End TRY
begin CATCH
    select 'Rolling back transcation';
    rollback transaction
end catch
```

choosing when to commit or when to rollback

```sql
Begin transaction
    update accounts set current_balance = current_balance + 100 where current_balance > 50000
    If @@rowcount > 200
        Begin
            rollback tran;
            select 'more accounts than expected. Rolling back';
        EnD
    ELSE
        BEGIN
            commit tran
            select 'updated successfully'
        End
```

@@TRANCOUNT and savepoints

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

USING SAVEPOINTS

```SQL
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

XACT_ABORT

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

using XACT_ABORT and XACT_STATE()

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

Transcation Isolation Levels

```sql
-- Set the appropriate isolation level
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	-- Select first_name, last_name, email and phone
	SELECT
    	first_name,
        last_name,
        email,
        phone
    FROM customers;
```

```SQL
-- Set the appropriate isolation level
SET transaction isolation LEVEL REPEATABLE READ

-- Begin a transaction
bEGIN TRAN

SELECT * FROM customers;

-- some mathematical operations, don't care about them...

SELECT * FROM customers;

-- Commit the transaction
COMMIT TRAN
```

- Serializable locks rows under some range
  out of that range you can do concurrent transcations

serilazable - query bases on index range

```sql
set transaction isolation level serializable

Begin TRANSACTION
	SELECT * FROM customers
	Where customer_id BETWEEN 1 AND 3
```

serializable - Query not based on index range

```sql
-- Transcation 1
SET Transaction isolation level serializable
	select * FROM customers

-- Transcation 2
INSERT INTO customerts VALUEs(
	100, 'Phantom', 'Ph', 'phantom@gmail.com', 22222
)

--transcation 2 will have to wait until transaction 1 finished and commit the transcation
	--transcation 1
	select * from customers
	--will give the same result as the previous example

--commiting from transcation 1
commit TRAN
--transcation 2 will insert now successfully
```

```sql
-- Set the appropriate isolation level
set transaction isolation level serializable
-- Begin a transaction
begin transaction
-- Select customer_id between 1 and 10
SELECT *
FROM customers
where customer_id between 1 AND 10;

-- After completing some mathematical operation, select customer_id between 1 and 10
SELECT *
FROM customers
where customer_id between 1 AND 10;

-- Commit the transaction
commit transaction
```

- Snapshot Example

```sql
-- Transcation 1
SET Transaction isolation level Snapshot

Begin Tran
	SELECT * from accounts

-- Transcation 2
begin transaction
	insert into accounts
	values (11111111111111, 1, 25000)

	update accounts set current_balance = 30000 where account_id = 1;

	select * from accounts;
Commit tran
-- tran 2 will get the same output as in the previous select statement
-- we don't see the data changed by tran 2 because these changes occurred after the start of transcation1. and with snapshot wwe an only see the committed changes that occured before the start of snapshot transaction
```

WITH (LOCK) applies to secific table, unlike READ UNCOMMITED which applies to the whole connection

```sql
SELECT *
	-- Avoid being blocked
	FROM transactions WITH (NOLOCK)
WHERE account_id = 1
```

The End.
