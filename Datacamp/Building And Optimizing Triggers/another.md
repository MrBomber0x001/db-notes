# Table of contents

## Trigger Management and Optimization

### Trigger Modifications

Because triggers are objects we can deal with them as we deal with any DB object by deleting or creating and so on.

1. Deleting A trigger on a table or view
2. Disabling a trigger

#### Deleting triggers

**Deleting table and view triggers**

```sql
DROP TRIGGER PreventNewDiscounts;
```

**Deleting database level triggers**

```sql
DROP TRIGGER PreventViewsModifications
ON DATABASE;
```

**Deleting server triggers**

```sql
DROP TRIGGER DisallowLinkedServers
ON ALL SERVER;
```

#### Disabling triggers

There are some cases when you need just to stop trigger for specific period of time AKA **Disabling" a trigger.

A deleted trigger can never be used again, unless you recreate the trigger.

📘 **note**
> When you need to disable a trigger, you need to explicitly specify the object the trigger is attached to, even if it is a normal table.

```sql
DISABLE TRIGGER PreventNewDiscounts
ON Discount
```

```sql
DISABLE TRIGGER PreventViewsModifications
ON DATABASE
```

```sql
DISABLE TRIGGER DisallowLinkedServers
ON ALL SERVER
```

#### Re-enabling triggers

```sql
ENABLE TRIGGER PreventViewsModifications
ON DATABASE
```

#### Altering triggers

 there are two main approaches for changing
 triggers after they were created

1. Create and Drop workflow
2. using `ALTER`

In the first approach, you're going to create the trigger and if something happened and you wish to change it, you `DROP` the trigger and re-create it.
which is something frustrating during development, instead you can `ALTER` the trigger in time

```SQL
ALTER TRIGGER X
ON Y
INSTEAD OF DELETE
AS
    -- Your changes
```

### Trigger Management

To get information about the current triggers you've on your server, we'll explore the **sys.triggers** table which contains information about the system triggers

```sql
SELECT * FROM sys.triggers
```

<put here the table>
this table contains about 13 attributes, but we are going to explore the most important ones.

| name | role |
| --- | --- |
| `name` | trigger name |
| `object_id` | unique identifier of the trigger |
| `parent_class` | trigger type <br> - **1** for table trigger <br> - **0** for database trigger |
| `parent_class_desc` | textual describe of trigger type |
| `parent_id` | unique identifier of the parent object that trigger is attached to |
| `create_date` | date of creation |
| `modify_date` | date of last modifications |
| `is_disabled` | current state |
| `is_instead_of_trigger` | `INSTEAD OF` or `AFTER` trigger |

If you want to know the sever level triggers

```sql
SELECT * FROM sys.server_triggers
```

the table will have the same structure as the databsase triggers level with the same information

What if you need to identify the events that will fire a trigger ?

this information is stored in `sys.trigger_events`

<put here the table>

you don't need to memorize all of the events that will fire the triggers, they are contained in `sys.trigger_event_types`

<put the table>

the problem here is that the information is divided into many tables, if you want to form a good answer

"list the trigger along with their firing events and object they're attatched to"
 we need to join the tables together

```sql
SELECT t.name as TriggerName,
       t.parent_class_desc AS TriggerType,
       te.type_desc AS EventName,
       o.name As AttatchedTo,
       o.type_desc AS ObjectType
FROM sys.triggers AS t
INNER JOIN sys.trigger_events AS te
ON te.object_id = t.object_id
LEFT OUTER JOIN sys.objects AS o ON o.object_id = t.parent_id;
```

note:
the second join is chosedn to be a `LEFT` join beause database-level triggers do not appear as attached to an object
<put the query result>

In real-world you'll not use those views in isolation, they usually combined together to get a useful information

###### Practice Time

```sql
-- Get the disabled triggers
SELECT name,
    object_id,
  parent_class_desc
FROM sys.triggers
WHERE is_disabled = 1;
```

```sql
-- Check for unchanged server triggers
SELECT *
FROM sys.server_triggers
WHERE modify_date = create_date;
```

```sql
-- Get the database triggers
SELECT *
FROM sys.triggers
WHERE parent_class_desc = 'DATABASE';
```

```sql
-- counting AFTER triggers
SELECT COUNT(object_id) FROM
sys.triggers
WHERE is_instead_of_trigger = 'false'
```

### troubleshooting Triggers

- Keep a history of triggers runs
- how to search for triggeers causing issues

### Tracking Trigger Exectuins (system views)

one important thing to keep on mind when troubleshooting triggers is to have a history of their execution

note:
SQL Server provides information on the execution of the triggers that are currently stored in **memory**, so when the triggers are removed from memory they areremoved from the view as well
`sys.dm_exec_trigger_stats`

<put table here>

so how to get around this problem?
by creating our custom solution

```sql
ALTER TRIGGER PreventOrdersUpdate
ON Orders
INSTEAD OF UPDATE
AS
    INSERT INTO TriggerAudit (TriggerName, ExecutionDate)
    SELECT 'PreventOrdersUpdate', GETDATE();

    RAISERROR('Updates on "Orders" table are not permitted. Place a new order to add new products.', 16, 1)
```

```sql
UPDATE Orders
SET Quanity = 400
WHERE ID = 600
```

This will raise an error, but also we got a **permenant record that we can use to track the history of triggers runs

```sql
SELECT * FROM TriggerAudit
```

<put the table>

How can we identify the triggers on a certain table or view?
using `sys.objects` table which contains information about the objects on the database.

```sql
SELECT name AS TableName,
       Object_id AS TableID
FROM sys.objects
WHERE name = 'Products';
```

| TableName | TableID |
| ----- | ---- |
| Products | 123 |

Then

```sql
SELECT o.name
    AS TableName, o.object_id
    AS TableID, t.name
    AS TriggerName, t.object_id
    AS TriggerID, t.is_disabled
    AS IsDisabled, t.is_instead_of_trigger AS IsInsteadOf
FROM sys.objects AS o
INNER JOIN sys.triggers AS t ON
t.parent_id = o.object_id
WHERE o.name ='Products'
```

```
TableName | TableID | TriggerName | TriggerID | IsDisabled | IsInsteadOf | | Products | 917578307 | TrackRetiredProducts | 1349579846 | 0 | 0 | | Products | 917578307 | ProductsNewItems | 1397580017 | 0 | 0 | | Products | 917578307 | PreventProductChanges | 1541580530 | 0 | 1 |
```

To identify the events capable of firing a trigger, we'lljoin to the `sys.trigger_events` also

```sql
SELECT o.name
    AS TableName, o.object_id
    AS TableID, t.name
    AS TriggerName, t.object_id
    AS TriggerID, t.is_disabled
    AS IsDisabled, t.is_instead_of_trigger AS IsInsteadOf
FROM sys.objects AS o
INNER JOIN sys.triggers AS t ON
t.parent_id = o.object_id
INNER JOIN sys.trigger_events AS te on t.object_id = te.object_id
WHERE o.name ='Products'
```

```
| TableName | TableID | TriggerName | TriggerID | IsDisabled | IsInsteadOf | FiringEvent | | Products | 917578307 | TrackRetiredProducts | 1349579846 | 0 | 0 | DELETE | | Products | 917578307 | ProductsNewItems | 1397580017 | 0 | 0 | INSERT | | Products | 917578307 | PreventProductChanges | 1541580530 | 0 | 1 | UPDATE |
```

if we want to further view also the trigger definiton, we'll use `OBJECT_DEFINITION()` method which return the definintion for an object Id passed as an argument

```sql
SELECT o.name
    AS TableName, o.object_id
    AS TableID, t.name
    AS TriggerName, t.object_id
    AS TriggerID, t.is_disabled
    AS IsDisabled, t.is_instead_of_trigger AS IsInsteadOf,
    OBJECT_DEFINITION(t.object_id) As TriggerDefinition
FROM sys.objects AS o
INNER JOIN sys.triggers AS t ON
t.parent_id = o.object_id
INNER JOIN sys.trigger_events AS te on t.object_id = te.object_id
WHERE o.name ='Products'
```

```
| TableName | TableID | TriggerName |...| FiringEvent | TriggerDefinition | | Products | 917578307 | TrackRetiredProducts |...| DELETE | CREATE TRIGGER TrackRetiredProducts ON Produc... | | Products | 917578307 | ProductsNewItems |...| INSERT | CREATE TRIGGER ProductsNewItems ON Products A... | | Products | 917578307 | PreventProductChanges |...| UPDATE | CREATE TRIGGER PreventProductChanges ON Produ... |
```

now you can inspect and modify the trigger definintion if needed

###### Practice Time

```sql
-- Get the table ID
SELECT object_id AS TableID
FROM sys.objects
WHERE name = 'Orders';
```

```sql
-- Get the trigger name
SELECT t.name AS TriggerName
FROM sys.objects AS o
-- Join with the triggers table
INNER JOIN sys.triggers AS t ON t.parent_id = o.object_id
WHERE o.name = 'Orders';
```

```sql
SELECT t.name AS TriggerName
FROM sys.objects AS o
INNER JOIN sys.triggers AS t ON t.parent_id = o.object_id
-- Get the trigger events
INNER JOIN sys.trigger_events AS te ON te.object_id = t.object_id
WHERE o.name = 'Orders'
-- Filter for triggers reacting to new rows
AND te.type_desc = 'UPDATE';
```

```sql
SELECT t.name AS TriggerName
FROM sys.objects AS o
INNER JOIN sys.triggers AS t ON t.parent_id = o.object_id
-- Get the trigger events
INNER JOIN sys.trigger_events AS te ON te.object_id = t.object_id
WHERE o.name = 'Orders'
-- Filter for triggers reacting to new rows
AND te.type_desc = 'UPDATE';
```

## Resources

- <a href="https://app.datacamp.com/learn/courses/transactions-and-error-handling-in-sql-server">Datacamp: Building and Optimizing Triggers</a>
