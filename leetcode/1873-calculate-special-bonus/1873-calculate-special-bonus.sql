# Write your MySQL query statement below
SELECT employee_id,
CASE 
    WHEN employee_id % 2 != 0 and name not like 'M%' THEN salary
    ELSE 0
END AS bonus 
FROM Employees
ORDER BY employee_id