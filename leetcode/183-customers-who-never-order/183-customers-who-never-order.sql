# Write your MySQL query statement below



SELECT name as Customers
FROM Customers C
WHERE C.id not in 
(
    select customerId from Orders
)