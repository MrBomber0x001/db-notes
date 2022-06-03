
WITH CTE AS 
(
    SELECT Salary,
    dense_rank() over (ORDER BY Salary Desc) as Dr
    FROM Employee
)

SELECT 
CASE 
    WHEN MAX(CTE.dr) < 2 THEN null ELSE Salary
END AS SecondHighestSalary
FROM CTE WHERE Dr = 2
