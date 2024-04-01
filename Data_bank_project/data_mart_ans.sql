use case2;
select * from customer_transactions limit 10;
select * from customer_nodes limit 10;
select * from regions limit 10;

## 1. How many different nodes make up the data bank network ?
SELECT count(DISTINCT node_id) AS unique_nodes
FROM customer_nodes;

## 2. how many nodes are there in each region?
select region_name region_id,
count(node_id) as nodes_count
from customer_nodes
inner join regions using(region_id)
group by region_id;

## 3. how many customers are divided among the regions?
SELECT region_id, 
count(DISTINCT  customer_id) as customer_count
from customer_nodes
inner join regions using(region_id)
group by region_id;

## 4. determine the total amount of transaction for each region name?
select region_name,
sum(txn_amount) as total_amount_of_transaction
from regions,customer_nodes,customer_transactions 
where regions.region_id=customer_nodes.region_id and customer_nodes.customer_id=customer_transactions.customer_id 
group by region_name;



select * from customer_transactions limit 10;
select * from customer_nodes limit 10;
select * from regions limit 10;

## 5. how long does it take on an average to move client to a new node?
SELECT round(avg(datediff(end_date, start_date)), 2) AS avg_days
FROM customer_nodes
WHERE end_date!='9999-12-31';

## 6. what is the unique count and total amount for each transaction type?
select txn_type,
count(*) as unique_count,
sum(txn_amount) as total_amount
from customer_transactions
group by txn_type;


## 7. what is the average number and size of past deposite across all customers?
SELECT round(count(customer_id)/(SELECT count(DISTINCT customer_id)
FROM customer_transactions)) AS average_deposit_count,
concat('$', round(avg(txn_amount), 2)) AS average_deposit_amount
FROM customer_transactions
WHERE txn_type = "deposit";

## 8. For each month how many data bank customers make more than 1 deposit and at least either 1 purchase or 1 withdrawal in a single month?
WITH transaction_count_per_month_cte AS
(SELECT customer_id,
month(txn_date) AS txn_month,
SUM(IF(txn_type="deposit", 1, 0)) AS deposit_count,
SUM(IF(txn_type="withdrawal", 1, 0)) AS withdrawal_count,
SUM(IF(txn_type="purchase", 1, 0)) AS purchase_count
FROM customer_transactions
GROUP BY customer_id,
month(txn_date))
SELECT txn_month,
count(DISTINCT customer_id) as customer_count
FROM transaction_count_per_month_cte
WHERE deposit_count>1
  AND (purchase_count = 1
       OR withdrawal_count = 1)
GROUP BY txn_month;




