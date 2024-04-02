use case3;
select * from product_details limit 10;
select * from product_prices limit 10;
select * from sales limit 10;
select * from product_hierarchy limit 10;

## 1 what was the total quantity sold for all products?
SELECT details.product_name,
SUM(sales.qty) AS sale_counts
FROM sales AS sales
INNER JOIN product_details AS details
ON sales.prod_id = details.product_id
GROUP BY details.product_name
ORDER BY sale_counts DESC;

## 2. what is the total generated revenue for all products before discounts?

SELECT SUM(price * qty) AS nodis_revenue
FROM sales AS sales;

## 3. what was the total discount amount for all products?
select sum(price * qty * discount)/100 as total_discount
from sales;

## 4.how many unique transations were there?

select count(distinct  txn_id) as unique_txn
from sales;

## 5. what are the avg unique products purchased in each transations?
with cte_transation_product as(select txn_id, count(distinct prod_id) as product_count
from sales
group by txn_id)
select round(avg(product_count)) as avg_unique_products
from cte_transation_product;

## 6. what is the average discount value per transation?
with cte_transation_discount as( select txn_id,sum(price * qty * discount)/100 as total_discount 
from sales
group by txn_id)
select round(avg(total_discount)) as avg_unique_products
from cte_transation_discount;

## 7. what is the avrage revenue for member transations and non_member transations?
with cte_member_revenue as(select txn_id,member,sum(price * qty) as revenue
from sales
group by member,txn_id )
select member,round(avg(revenue),2) as avg_revenue
from cte_member_revenue
group by member;

## 8. what are the top 3  products by total revenue before discounts?
select details.product_name,sum(sales.qty * sales.price) as nodis_revenue 
from sales as sales
inner join product_details as details
on sales.prod_id=details.product_id
group by product_name
order by nodis_revenue desc
limit 3;

## 9 waht are the total quantity, revenue and discount for each segment?
select details.segment_id,details.segment_name,sum(sales.qty) as total_qty,
sum(sales.qty * sales.price) as total_revenue, sum(sales.qty*sales.price*sales.discount)/100 as total_discount from sales as sales
inner join product_details as details
on sales.prod_id=details.product_id
group by details.segment_id,details.segment_name
order by total_revenue desc;

# 10. what is the top selling product for each segment?
select details.segment_id,details.segment_name,details.product_id,details.product_name,sum(sales.qty) as product_qty from sales as sales
inner join product_details as details
on sales.prod_id=details.product_id
group by details.segment_id,details.segment_name,details.product_id,details.product_name
order by product_qty desc limit 5;

## 11. what are the total quantity, revenue and discount for each category?
select details.category_id,details.category_name,sum(sales.qty) as total_qty, sum(sales.qty*sales.price) as total_revenue,
sum(sales.qty*sales.price*sales.discount)/100 as total_discount 
from sales as sales
inner join product_details as details
on sales.prod_id=details.product_id
group by details.category_id,details.category_name
order by total_revenue ;

## 12. what is the top selling product for each category?

select details.category_id,details.category_name,details.product_id,details.product_name,sum(sales.qty) as product_qty
from sales as sales
inner join product_details as details
on sales.prod_id=details.product_id
group by details.category_id,details.category_name,details.product_id,details.product_name
order by product_qty desc
limit 5;









