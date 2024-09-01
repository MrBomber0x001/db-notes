# 02 - Understanding Database Internals


## Row-Oriented vs Column-Oriented Databases

### Row-Oriented Databases
Row-oriented databases store data in rows, with each row containing all the information about a particular record. This structure is efficient for:
- Inserting, updating, and deleting individual records
- Retrieving all data for a specific record

Examples: MySQL, PostgreSQL, Oracle

### Column-Oriented Databases
Column-oriented databases store data by column rather than by row. This structure is advantageous for:
- Analytical queries that involve aggregations over large datasets
- Compression of data, as similar data types are stored together

Examples: Apache Cassandra, Google BigQuery, Amazon Redshift

## Primary and Secondary Columns

### Primary Columns
- Also known as the primary key
- Uniquely identifies each record in a table
- Cannot contain null values
- Typically used for indexing and establishing relationships between tables

### Secondary Columns
- All columns that are not part of the primary key
- Can contain duplicate or null values
- Used to store additional information about the record
- Can be indexed to improve query performance, creating secondary indexes

Understanding these concepts is crucial for database design and optimization, as the choice between row and column orientation, as well as the selection of primary and secondary columns, can significantly impact database performance and functionality.



