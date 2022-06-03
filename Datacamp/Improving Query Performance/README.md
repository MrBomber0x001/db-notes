## Query performance tuning

### indexes

Indexes are structures added to the table to improve speed of accessing data from a table.

used to locate data quickly without having to scan the entire table.
this makes them particulary useful for improving performance of Queries with filter conditions
they are applied to a table columns and can be addd at any time.

the two most common table indexes are Clustered and Nonclustered

#### Clusterd and Nonclustered Indexes

1. Clusterd Index:
A good analogy for a clustered index is a dictionary where words are stored "alphabetically".

Clustered indexes reducee the number of data page reads by a query which helps speed up search operations.

A table can only contain one Clustered index.

2. Non Clustered Index:
A good analogy is a text book with an index at the back

Data in the book is unordered and the index at the back indicated the page number containing a search condition.

Another layer in the index structure contains ordered pointers to the data pages.

A table can contain more than one Nonclustered index.

It's common used to improve table insert and update operations.

##### Clustered Index: B-tree structure

A clustred index creates what is called a B-tree structure on a table.

- Root node

- branches the nodes

- leaves

[-] The root node:
the root node contains ordered pointers to branch nodes which in turn contains orderd pointers to page nodes.

the page node level contains all the 8 kilobyte data pages from the table with the data physically ordered by the columns(s) with the clustred index.
