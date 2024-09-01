# 01 - ACID
ACID is an acronym that stands for Atomicity, Consistency, Isolation, and Durability. These are four key properties that guarantee reliable processing of database transactions. Let's explore each of these properties in detail:

## Atomicity

Atomicity ensures that a transaction is treated as a single, indivisible unit of work. This means that either all operations within a transaction are completed successfully, or none of them are. If any part of the transaction fails, the entire transaction is rolled back, leaving the database in its previous consistent state.

Example:
Consider a bank transfer where money is deducted from one account and added to another. If the deduction succeeds but the addition fails, atomicity ensures that the deduction is also rolled back, maintaining the integrity of both accounts.

## Consistency

Consistency guarantees that a transaction brings the database from one valid state to another. It ensures that all data written to the database must be valid according to all defined rules, including constraints, cascades, triggers, and any combination thereof.

Example:
If a database has a rule that all accounts must have a positive balance, a transaction that would result in a negative balance would be rolled back to maintain consistency.

## Isolation

Isolation ensures that concurrent execution of transactions leaves the database in the same state that would have been obtained if the transactions were executed sequentially. It prevents interference between concurrent transactions.

Example:
If two users are trying to book the last seat on a flight simultaneously, isolation ensures that only one booking succeeds while the other fails, maintaining the consistency of the seat inventory.

## Durability

Durability guarantees that once a transaction has been committed, it will remain committed even in the case of a system failure (e.g., power outage or crash). This is usually achieved by storing the transactions in non-volatile memory.

Example:
When a customer makes an online purchase and receives a confirmation, durability ensures that the order details are safely stored and won't be lost, even if the system crashes immediately after.

Understanding and implementing ACID properties is crucial for maintaining data integrity and reliability in database systems, especially in scenarios involving critical data such as financial transactions or medical records.
