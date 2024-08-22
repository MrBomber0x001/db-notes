# Please write a DELETE statement and DO NOT write a SELECT statement.
# Write your MySQL query statement below

DELETE FROM Person 
WHERE id NOT IN (
    SELECT * FROM (SELECT MIN(id) FROM Person GROUP BY email) as p
)

# id         email
# 1          yousef@gmail.com
# 2          ahmed@gmail.com
# 3          yousef@gmail.com
# 4          ahmed@mail.com
# 5          omar@gmail.com

# inner subquery:
# yousef 1
# ahmed 2
# omar 5
# NOT IN
# 3 and 4 are found in the above table, so i'll delete them


