select customer_id, 
       count(*) as count_no_trans
from Visits
where visit_id not in (select Distinct visit_id from Transactions)
group by 1