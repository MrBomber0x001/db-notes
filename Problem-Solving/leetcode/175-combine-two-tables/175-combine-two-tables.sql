# Write your MySQL query statement below
select firstName,
       lastName,
       A.city,
       A.state
from Person P
left join Address A on A.personId = P.personId