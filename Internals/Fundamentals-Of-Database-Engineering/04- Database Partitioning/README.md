# 04- Database Partitioning
Partitioning is a database design technique used to divide a large database into smaller, more manageable pieces. This can improve performance, manageability, and availability by allowing operations to be performed on smaller subsets of data. Partitioning can be done in various ways, such as by range, list, or hash, depending on the specific requirements and characteristics of the data.

## table of content

- [Partitioning](#partitioning)
- [table of content](#table-of-content)
- [partitioning types](#partitioning-types)
- [partitioning benefits](#partitioning-benefits)
- [partitioning drawbacks](#partitioning-drawbacks)
- [partitioning strategies](#partitioning-strategies)
- [partitioning implementation](#partitioning-implementation)
- [partitioning challenges](#partitioning-challenges)


## partitioning types
Partitioning can be categorized into different types based on the method used to divide the data. The main types of partitioning are range partitioning, list partitioning, and hash partitioning.

### Range Partitioning
Range partitioning involves dividing the data into ranges based on a specific column, such as date or numeric value. Each partition holds a range of values, making it easy to manage and query specific subsets of data.

**Example:**
Consider a sales database where transactions are recorded with a `transaction_date` column. We can partition the data by year:

- Partition 1: Transactions from 2020
- Partition 2: Transactions from 2021
- Partition 3: Transactions from 2022

This allows for efficient querying of transactions within a specific year.

![Range Partitioning](https://example.com/range_partitioning_image.png)

### List Partitioning
List partitioning involves dividing the data based on a predefined list of values. Each partition contains rows that match one of the values in the list.

**Example:**
Consider a customer database with a `region` column. We can partition the data by region:

- Partition 1: Customers from North America
- Partition 2: Customers from Europe
- Partition 3: Customers from Asia

This allows for efficient querying of customers within a specific region.

![List Partitioning](https://example.com/list_partitioning_image.png)

### Hash Partitioning
Hash partitioning involves dividing the data based on a hash function applied to a specific column. The hash function distributes the rows evenly across the partitions, ensuring balanced data distribution.

**Example:**
Consider an orders database with an `order_id` column. We can partition the data using a hash function on the `order_id`:

- Partition 1: Orders with hash value 0
- Partition 2: Orders with hash value 1
- Partition 3: Orders with hash value 2

This ensures that the orders are evenly distributed across the partitions.

![Hash Partitioning](https://example.com/hash_partitioning_image.png)


## partitioning benefits, drawbacks, and strategies
Partitioning offers several benefits, including improved performance, easier management, and increased availability. By working with smaller subsets of data, operations can be more efficient and less resource-intensive.

## partitioning implementation
Implementing partitioning involves several steps, including defining the partitioning scheme, creating the partitions, and managing the data within each partition. Proper implementation is crucial for achieving the desired benefits.

### Practical Examples of Partitioning

Partitioning can be applied in various real-world scenarios to improve database performance and manageability. Here are some practical examples:

1. **E-commerce Website:**
   - **Range Partitioning:** Partition the order data by month or year to quickly retrieve orders within a specific time frame.
   - **List Partitioning:** Partition the product catalog by category (e.g., electronics, clothing, home goods) to efficiently query products within a specific category.
   - **Hash Partitioning:** Partition user data by user ID to evenly distribute the load and ensure balanced access patterns.

2. **Financial Services:**
   - **Range Partitioning:** Partition transaction data by date to facilitate efficient querying and reporting of transactions within a specific period.
   - **List Partitioning:** Partition account data by account type (e.g., savings, checking, credit) to streamline account management and queries.
   - **Hash Partitioning:** Partition trade data by trade ID to ensure even distribution and load balancing across the database.

3. **Healthcare System:**
   - **Range Partitioning:** Partition patient records by admission date to quickly access records for a specific time period.
   - **List Partitioning:** Partition patient data by department (e.g., cardiology, neurology, orthopedics) to efficiently manage and query patient records within each department.
   - **Hash Partitioning:** Partition appointment data by appointment ID to distribute the load evenly and ensure balanced access.

### Difference Between Sharding and Partitioning

While both sharding and partitioning involve dividing data into smaller, more manageable pieces, they serve different purposes and are implemented differently:

- **Partitioning:**
  - Partitioning is typically applied within a single database instance.
  - It involves dividing a table into smaller, more manageable pieces called partitions.
  - Each partition is stored within the same database and managed by the same database server.
  - Partitioning improves query performance, manageability, and availability within a single database.
  - **Table Names:** The table name remains the same when querying partitioned data. The database management system handles the partitioning logic transparently.

- **Sharding:**
  - Sharding involves distributing data across multiple database instances or servers.
  - Each shard is a separate database that contains a subset of the data.
  - Sharding is used to horizontally scale a database by distributing the load across multiple servers.
  - It improves performance and availability by allowing the database to handle more traffic and larger datasets.
  - **Table Names:** The table name may change when querying sharded data, as each shard can be considered a separate database with its own schema. Queries need to be directed to the appropriate shard based on the sharding key.


## partitioning challenges
Partitioning can present several challenges, such as ensuring data consistency, managing partitioned data, and handling partitioning changes over time. Addressing these challenges is essential for maintaining a well-functioning partitioned database.


When you use partitioning in a database, the physical storage of data is divided into smaller, more manageable pieces, but from the perspective of your backend application, the table names generally remain the same. Partitioning is an implementation detail that is abstracted away from the application layer. This means that your SQL queries do not need to change to account for the partitioning scheme.

Here’s a more detailed explanation:

### Partitioning Overview

Partitioning involves dividing a large table into smaller, more manageable pieces called partitions. Each partition can be stored and managed independently, which can improve performance, simplify maintenance, and enhance the manageability of large datasets.

### Types of Partitioning

1. **Range Partitioning:** Divides the table based on ranges of a column value.
2. **List Partitioning:** Divides the table based on a list of discrete values.
3. **Hash Partitioning:** Divides the table based on a hash function applied to a column value.
4. **Composite Partitioning:** Combines two or more partitioning methods.

### Impact on Backend Queries

- **No Change in Table Names:** From the backend perspective, the table name remains the same. The database engine internally routes the query to the appropriate partition(s) based on the partitioning key.
- **Query Optimization:** The database optimizer takes into account the partitioning scheme when generating query execution plans. This can lead to more efficient query execution, especially if the query can be restricted to a specific partition.
- **Partition Pruning:** A key benefit of partitioning is partition pruning, where the database engine can exclude irrelevant partitions from the query execution plan, thereby reducing the amount of data scanned and improving performance.

### Example

Suppose you have a large table `orders` partitioned by the `order_date` column using range partitioning. The table might be partitioned into monthly partitions:

```sql
CREATE TABLE orders (
    order_id INT,
    order_date DATE,
    customer_id INT,
    amount DECIMAL(10, 2)
)
PARTITION BY RANGE (order_date) (
    PARTITION p2022_01 VALUES LESS THAN ('2022-02-01'),
    PARTITION p2022_02 VALUES LESS THAN ('2022-03-01'),
    PARTITION p2022_03 VALUES LESS THAN ('2022-04-01'),
    ...
);
```

From your backend application, you would still query the `orders` table as usual:

```sql
SELECT * FROM orders WHERE order_date BETWEEN '2022-01-01' AND '2022-01-31';
```

The database engine will automatically route this query to the appropriate partition(s) (`p2022_01` in this case) without you needing to specify the partition name in the query.

### Conclusion

Partitioning is a transparent feature from the application’s perspective. Your backend queries do not need to change to account for the partitioning scheme. The database engine handles the partitioning details internally, allowing you to continue querying the table using the same table name and SQL syntax. This abstraction ensures that partitioning is a seamless enhancement to your database architecture, improving performance and manageability without requiring changes to your application code.


----

Sharding is a database architecture pattern where data is horizontally partitioned across multiple databases, known as shards. Each shard is a separate database instance, often running on different servers. This approach is used to improve scalability, performance, and availability by distributing the data and query load across multiple servers.

### Sharding Overview

Sharding involves dividing a large database into smaller, more manageable pieces called shards. Each shard contains a subset of the data, and the shards are typically distributed across multiple servers. Sharding can be done based on various strategies, such as:

1. **Range-Based Sharding:** Data is partitioned based on a range of values (e.g., date ranges, numerical ranges).
2. **Hash-Based Sharding:** Data is partitioned based on a hash function applied to a column value.
3. **Directory-Based Sharding:** A lookup service or directory is used to determine the shard for a given key.

### Impact on Backend Queries

Unlike partitioning, which is transparent to the application, sharding requires more involvement from the application layer. Here are some key considerations:

- **Routing Logic:** The application must include logic to route queries to the appropriate shard. This often involves determining the shard key and using it to direct the query to the correct database instance.
- **Query Composition:** Queries may need to be composed differently to handle sharding. For example, if a query spans multiple shards, the application may need to execute the query on each shard and then combine the results.
- **Joins and Transactions:** Joins across shards and distributed transactions can be complex and may require additional logic or middleware to manage.
- **Data Consistency:** Ensuring data consistency across shards can be challenging. Techniques like two-phase commits or eventual consistency models may be used.

### Example

Suppose you have a large table `users` sharded based on the `user_id` column using hash-based sharding. The table is divided into three shards:

1. `users_shard1`
2. `users_shard2`
3. `users_shard3`

The application must determine which shard to query based on the `user_id`. Here’s a simplified example in pseudo-code:

```python
def get_user_shard(user_id):
    shard_number = hash(user_id) % 3 + 1
    return f"users_shard{shard_number}"

def get_user_by_id(user_id):
    shard = get_user_shard(user_id)
    query = f"SELECT * FROM {shard} WHERE user_id = {user_id}"
    result = execute_query(query)
    return result
```

In this example, the application calculates the shard number based on the `user_id` and constructs the query to target the appropriate shard.

### Conclusion

Sharding introduces more complexity compared to partitioning because it requires the application to be aware of the sharding scheme and include logic to route queries to the correct shard. This means that backend queries and application code need to be designed with sharding in mind, potentially requiring changes to handle routing, query composition, and data consistency across shards.

While sharding can significantly improve scalability and performance, it also adds complexity to the application and database architecture. Careful planning and design are necessary to ensure that sharding is implemented effectively and does not introduce new challenges in terms of data management and application logic.


## notes
> everything you should partition against should be not null
```sh
docker run --name pgmain -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres

## then execute the following command to connect to the database

docker exec -it pgmain psql -U postgres

## then create a new database

CREATE DATABASE grades;

## then connect to the new database

\c grades;

## then create a new table

CREATE TABLE grades_org (
    id SERIAL not null,
    g int not null
);

## then insert a 10 million records into grades_org

INSERT INTO grades_org (g) SELECT float(random() * 100) FROM generate_series(1, 10000000);

## then create a new table
CREATE TABLE grades_part (
    id SERIAL not null,
    g int not null
) PARTITION BY RANGE (g); -- you have to use partition by clause

## then create a new table
CREATE TABLE grades_part_0 PARTITION OF grades_part FOR VALUES IN (0);
CREATE TABLE grades_part_1 PARTITION OF grades_part FOR VALUES IN (1);
CREATE TABLE grades_part_2 PARTITION OF grades_part FOR VALUES IN (2);

```