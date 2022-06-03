# Introduction to Trigger

## What's a trigger?

it's special type of stored procedure that being executed when an event (like data modifications occurs in the database server

Types of triggers?
DML triggers => INSERT, UPDATE OR DELETE statements
DDL

Atriiger can behave differently in relation to the statement that fires it, resulting in two types of triggers

- AFTER trigger

```sql
-- Create a new trigger that fires when deleting data
CREATE TRIGGER PreventDiscountsDelete
ON Discounts
-- The trigger should fire instead of DELETE
INSTEAD OF DELETE
AS
	PRINT 'You are not allowed to delete data from the Discounts table.';
```

```sql
CREATE TRIGGER OrderUpdateRows
ON Orders
AFTER UPDATE
AS
INSERT INTO OrdersUpdate(OrderId, OrderDate, ModifyDate)
SELECT OrderID, OrderDate, GETDATE()
FROM inserted
```

This trigger will be responsible for filling in a historical table (OrdersUpdate) where information about the updated rows is kept.
A historical table is often used in practice to store information that has been altered in the original table. In this example, changes to orders will be saved into OrdersUpdate to be used by the company for auditing purposes.

```sql
-- Create a new trigger
CREATE TRIGGER ProductsNewItems
ON Products
AFTER INSERT
AS
	-- Add details to the history table
	INSERT INTO ProductsHistory(Product, Price, Currency, FirstAdded)
	SELECT Product, Price, Currency, GETDATE()
	FROM inserted;
```

# Classification of Triggers

[1] AFTER Trigger
Practicing with AFTER triggers
Fresh Fruit Delivery company is happy with your services, and they've decided to keep working with you.

You have been given the task to create new triggers on some tables, with the following requirements:

[1] Keep track of canceled orders (rows deleted from the Orders table). Their details will be kept in the table CanceledOrders upon removal.

[2] Keep track of discount changes in the table Discounts. Both the old and the new values will be copied to the DiscountsHistory table.

[3] Send an email to the Sales team via the SendEmailtoSales stored procedure when a new order is placed.

```sql
CREATE TRIGGER KeepCanceledOrders
ON Orders
AFTER DELETE
AS
	INSERT INTO CanceledOrders ()



-- Create a new trigger to keep track of discounts
CREATE Trigger CustomerDiscountHistory
ON Discounts
AFTER UPDATE
AS
	-- Store old and new values into the `DiscountsHistory` table
	INSERT INTO DiscountsHistory (Customer, OldDiscount, NewDiscount, ChangeDate)
	SELECT i.Customer, d.Discount, i.Discount, GETDATE()
	FROM inserted AS i
	INNER JOIN deleted AS d ON i.Customer = d.Customer;

	-- Notify the Sales team of new orders
CREATE TRIGGER NewOrderAlert
ON Orders
AFTER insert
AS
	EXECUTE SendEmailtoSales;
```

[2] INSTEAD OF Trigger

```sql
-- Create the trigger
CREATE Trigger PreventOrdersUpdate
ON Orders
INSTEAD OF UPDATE
AS
	RAISERROR ('Updates on "Orders" table are not permitted.
                Place a new order to add new products.', 16, 1);
```

### DDL Triggers

Preventing table deletion
Fresh Fruit Delivery wants to prevent its regular employees from deleting tables from the database.

```sql
CREATE TRIGGER PreventTableDeletion
ON DATABASE
FOR DROP_TABLE
AS
	RAISERROR('You are not allowed to remove tables from this database.', 16, 1)
	-- Revert the statment that removes the table
	ROLLBACK;
```

## LOGON Triggers

Enhancing database security:
Recently, several inconsistencies have been discovered on the Fresh Fruit Delivery company's database server.

The IT Security team does not have an auditing process to find out when users are connecting to the database and track breaking changes back to the responsible user.

You are asked to help the Security team by implementing a new trigger based on their requirements.

Due to the complexity of this request, you should build the INSERT statement in the first step and use it to create the trigger in the second step.

```sql
-- Save user details in the audit table
INSERT INTO ServerLogonLog (LoginName, LoginDate, SessionID, SourceIPAddress)
SELECT ORIGINAL_LOGIN(), GETDATE(), @@SPID, client_net_address
-- The user details can be found in SYS.DM_EXEC_CONNECTIONS
FROM SYS.DM_EXEC_CONNECTIONS WHERE session_id = @@SPID;

-- Create a trigger firing when users log on to the server
CREATE TRIGGER LogonAudit
-- Use ALL SERVER to create a server-level trigger
ON ALL SERVER WITH EXECUTE AS 'sa'
-- The trigger should fire after a logon
for logon
AS
	-- Save user details in the audit table
	INSERT INTO ServerLogonLog (LoginName, LoginDate, SessionID, SourceIPAddress)
	SELECT ORIGINAL_LOGIN(), GETDATE(), @@SPID, client_net_address
	FROM SYS.DM_EXEC_CONNECTIONS WHERE session_id = @@SPID;
```

# Trigger Limitation and use cases

```sql
-- Get the column that contains the trigger name
SELECT  name AS TriggerName,
	   parent_class_desc AS TriggerType,
	   create_date AS CreateDate,
	   modify_date AS LastModifiedDate,
	   is_disabled AS Disabled,
       -- Get the column that tells if it's an INSTEAD OF trigger
	   is_instead_of_trigger AS InsteadOfTrigger
FROM sys.triggers;
```

using OBJECT_DEINITON

```sql
-- Gather information about database triggers
SELECT name AS TriggerName,
	   parent_class_desc AS TriggerType,
	   create_date AS CreateDate,
	   modify_date AS LastModifiedDate,
	   is_disabled AS Disabled,
	   is_instead_of_trigger AS InsteadOfTrigger,
       -- Get the trigger definition by using a function
	   OBJECT_DEFINITION (object_id)
FROM sys.triggers
UNION ALL
-- Gather information about server triggers
SELECT name AS TriggerName,
	   parent_class_desc AS TriggerType,
	   create_date AS CreateDate,
	   modify_date AS LastModifiedDate,
	   is_disabled AS Disabled,
	   0 AS InsteadOfTrigger,
       -- Get the trigger definition by using a function
	   OBJECT_DEFINITION (object_id)
FROM sys.server_triggers
ORDER BY TriggerName;
```

## use cases for AFTER trigger

```sql
CRETE TRIGGER CopyCusomtersToHistory
ON Customers
AFTER INSERT, UPDATE
AS
           INSERT INTO CustomersHistroy(Customer, ContractId, Address, PhoneNo)
          SELECT Customer, ContractID, Address, PhoneNo, GETDATE()
          FROM inserted;
```

## Table auditing

```sql
CREATE TRIGGER OrdersAudit
ON Orders
AFTER UPDATE, INSERT, DELETE
AS
      DECLARE @Insert BIT = 0, @Delete BIT = 0;
      IF EXISTS (SELECT * FROM inserted) SET @Insert = 1;
      IF EXISTS (SELECT * FROM deleted( SET @Deleted = 1;

      INSERT INTO [TablesAudit] ([TableName], [EventType], [UserAccount], [EventDate])
      SELECT 'Orders' As [TableName]
      , CASE WHEN @Insert = 1 AND @Delete = 0 THEN 'INSERT'
                  WHEN @Insert = 1 AND @Delete = 1 THEN 'UPDATE'
                  WHEN @Insert = 0 AND @Delete = 1 THEN 'DELETE'
                  END AS [Event]
     , ORIGINAL_LOGIN()
     , GETDATE();
```

```sql
CREATE TRIGGER NewOrderNotification
ON Orders
AFTER INSERT
AS
               EXECUTE SendNotifications @RecipientEmail = 'sales@freshfruit.com',
                                @EmailSubject = 'New Order Placed'
                                @EmailBody = 'A new Order was just placed'

```

```sql
CREATE TRIGGER CopyCustomersToHistory
ON Customers
AFTER INSERT, UPDATE
AS
             INSERT INTO CustomersHistory (CustomerID, Customer, ContractID, Address, PhoneNo, Email, ChangeDate)
            SELECT CustomerID, Customer, ContractID, ContractDate, Address, PhoneNo, Email, GETDATE()
          FROM inserted
```

```sql
-- Add a trigger that tracks table changes
create trigger OrdersAudit
ON Orders
after INSERT, delete, update
AS
	DECLARE @Insert BIT = 0;
	DECLARE @Delete BIT = 0;
	IF EXISTS (SELECT * FROM inserted) SET @Insert = 1;
	IF EXISTS (SELECT * FROM deleted) SET @Delete = 1;
	INSERT INTO [TablesAudit] (TableName, EventType, UserAccount, EventDate)
	SELECT 'Orders' AS TableName
	       ,CASE WHEN @Insert = 1 AND @Delete = 0 THEN 'INSERT'
				 WHEN @Insert = 1 AND @Delete = 1 THEN 'UPDATE'
				 WHEN @Insert = 0 AND @Delete = 1 THEN 'DELETE'
				 END AS Event
		   ,ORIGINAL_LOGIN() AS UserAccount
		   ,GETDATE() AS EventDate;
```

### instead of

```sql
-- Prevent any product changes
CREATE TRIGGER PreventProductChanges
ON Products
instead of UPDATE
AS
	RAISERROR ('Updates of products are not permitted. Contact the database administrator if a change is needed.', 16, 1);
```

```sql
-- Create a new trigger to confirm stock before ordering
CREATE TRIGGER ConfirmStock
ON Orders
INSTEAD OF INSERT
AS
	IF EXISTS (SELECT *
			   FROM Products AS p
			   INNER JOIN inserted AS i ON i.Product = p.Product
			   WHERE p.Quantity < i.Quantity)
	BEGIN
		RAISERROR('You cannot place orders when there is no stock for the order''s product.', 16, 1);
	END
	ELSE
	BEGIN
		INSERT INTO Orders (OrderID, Customer, Product, Price, Currency, Quantity, WithDiscount, Discount, OrderDate, TotalAmount, Dispatched)
		SELECT OrderID, Customer, Product, Price, Currency, Quantity, WithDiscount, Discount, OrderDate, TotalAmount, Dispatched FROM inserted;
	END;
```

# Trigger Optimization and Management
