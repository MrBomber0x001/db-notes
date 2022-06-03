# Write your MySQL query statement below
update Salary 
SET sex = (
    CASE 
        when sex = 'f' then 'm'
        ELSE 'f'
    END
)