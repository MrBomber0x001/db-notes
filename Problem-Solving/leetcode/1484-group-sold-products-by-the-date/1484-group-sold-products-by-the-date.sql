# Write your MySQL query statement below
SELECT sell_date, COUNT(distinct(product)) as num_sold, group_concat(distinct product) as products FROM Activities
group by sell_date
order by sell_date