---
title: The SQL Server Query Optimizer
Source: https://www.youtube.com/watch?v=iAxFGRbAh8s&list=PLE8kQVoC67PzGwMMsSk3C8MvfAqcYjusF&index=13
Articles: https://www.red-gate.com/simple-talk/databases/sql-server/performance-sql-server/the-sql-server-query-optimizer/
---
## Overview
- The **Query Optimizer** is a critical component in any DBMS (Database Management System).
-  The generation of candidate execution plans is performed inside the Query Optimizer using transformation rules, and the use of `heuristics limits the number of choices` considered in order to keep the optimization time reasonable. Candidate plans are stored in memory during the optimization, in a component called the Memo 'Plan Cache' in order that it might be reused if the same query is executed again.

![[Screenshot 2025-04-27 145712.png]]

# 📚 Query Optimizer

- **Plan enumeration** → _relevant plans_.
     -  **search space** for a given query as the set of all the possible execution plans for that query, and any possible plan in this search space returns the same results but may differ in performance.
 `--> Enumeration is the process of generating valid plans from this search space.`
- **Plan selection** → _Compares plans to choose the one with the lowest estimated cost._
	`RBO/CBO`

## 🔀 Operations

- **Logical Plan
    - Cannot be executed.
    - _Join_ / _Aggregation_.
    - Conceptual level (logical concepts).
- **Physical Plan
    - Implementation of logical operations.
    - Can be executed.
    - Has a cost function.
    - Examples: _Nested Join_, _Hash Join_, _Index Scan_, _Hash-based aggregation_.
    - Based on algorithms.
![[Pasted image 20250428012845.png]]

- **Rule-based (RBO)**
    > Uses predefined rules.
- **Cost-based (CBO)**
    > Defines how plan enumeration will occur based on cost estimates.
--------------------------------------------- 
# 📜 Rule-based Optimization
- **Improving the plan** by transforming / reshaping it following predefined rules (Plan Refactoring).
- Transformations happen until reaching a **Fixed Point** (no more transformations).

- Use indexes if available.
- If possible, use Nested Loop Joins first.
- Perform selection (filtering) operations as early as possible.
### Example 1: Filter Pushdown
- Move filters closer to the data source:
- Example transformation:
    - `σA<5 (A ⨝ B)` ➔ `σA<5 (A) ⨝ B`
    ![[Pasted image 20250428014942.png]]
    - Garbage unnecessary plans.
### Example 2: Expression simplification
- Simplify complex expressions wherever possible.
![[Pasted image 20250428015046.png]]

📌Challenges: It may pick a bad plan because it ignores real-world factors like data size, memory, or disk I/O , may be suboptimal

---------------------------------------------
## ⚙️Cost-based Optimization:
`Plans are selected based on **cost estimation**:`
- Join order
- Access Path Selection (Table scan / Index scan, etc.)
- Join Algorithms (Nested / Hash / Merge)
- Aggregations (Sort / Hash)
- Sorting, etc.

**Cost Factors:**
- Cost of each physical node operation 'used algorithm'
- Cost of I/O , CPU , memory
- Estimated number of rows to be fetched 'Cardinality estimation'

📌the set of plans which a query optimizer considers contains plans with low costs. 

📌SQL Server uses and maintains optimizer statistics `"stored in table catalog"` , which contain statistical information describing the distribution of values in one or more columns of a table. Once the cost for each operator is estimated using estimations of cardinality and resource demands, the Query Optimizer will add up all of these costs to estimate the cost for the entire plan.

- Table Catalog --> contains metadata about database objects "Schema" , implemented as a set of system tables , used in Query analyzer for validation & cost estimator in Query optimizer.

📌Challenges: table statistics may be outdated , slower than RBO

-------------------------------------------- 
 
  ## Optimization Could be done using the following approaches:
# ↘️Top-down Approach:

- **Starts from** logical plan (after applying heuristics).
- **Apply more rules** to generate more alternatives.
- **Estimate cost** and choose the cheapest plan.

- **Sort** ✅
- better for complex queries✅
- More Plan alternatives means more complexity❌
- may be suboptimal❌
 📌SQL Server uses this method.
 
# ↗️Bottom-up Approach:
- Builds solutions step-by-step , starting from small parts  and combining them gradually into larger parts.
- Suppose you have a query** joining 3 tables and you want to  know the best exec plan;
    - 1 table
    - 2 tables
    - 3 tables (subexpressions at each level)
`at each level , we find best sub plan and use it in a higher level`        
- Simple to implement.✅
- Optimal.✅
- Adding constraints.❌
- expensive with complex queries.❌
`suppose you need to add a sort constraint , you will estimate based on sorted and unsorted options to choose the best plan , and that's expensive.`
- Usually supports left-deep plans.❌
    ![[Pasted image 20250428152419.png]]
- **Used by**:
    - IBM R2
    - PostgreSQL
    - MySQL
--------------------------------------
# Side Notes:
 ->Some execution plans may be `suboptimal` , as an example suppose you are using an index in an execution plan and this index could be used to generate more efficient plan , ==it's about the inefficient usage of physical operations in the exec plan==

- suboptimal:
->outdated statistics
->inefficient usage of statistics.

 ->Some execution plans may be `invalid` , as an example suppose you have used an execution plan and then you made some significant changes in the schema like removing index , in this case the reusability of this execution plan will be invalid for your next queries.

📌In some cases , Query optimizers may not perform as expected , either if the reason was lack of given inputted information or query optimizer limitations , therefore `HINTS` were introduced to solve this problem , as they let you override the operations of the Query optimizer ,  ==Hints are instructions that you can send to the Query Optimizer to influence a particular area of an execution plan.== 
‼️يستخدم بحذر لو ده اخر الاختيارات 

**Hint examples:**
- Force join types (e.g., `LOOP JOIN`, `HASH JOIN`).
- Force index usage (`FORCESEEK`, `FORCESCAN`).
## Challenges:
- combinatorial explosion انفجار تركيبي `solved using heuristics`
- accurate cost and cardinality estimation.
- Data Skewness `- - Unusual data distributions can mislead estimations.`

📌SQL Server implemented its own cost-based Query Optimizer based on the `Cascades Framework .`  It's extensible architecture has made it much easier for new functionality, such as new transformation rules or physical operators, to be implemented in the Query Optimizer. This allows the performance of the Query Optimizer to constant be tuned and improved.
