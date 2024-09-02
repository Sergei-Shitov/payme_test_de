-- Write a SQL query to perform the following analysis:

-- • Calculate the total sales amount and the total number of transactions for each month.

-- • Calculate the 3-month moving average of sales amount for each month. The moving 
-- average should be calculated based on the sales data from the previous 3 months 
-- (including the current month).

-------------------------------------------------

select
	date_trunc('month', purchase_date)::date as month,
	count(sales_transaction_id) as transuctions_num,
	sum(st.purchase_quantity * p.price)::numeric(10,2) as total_amount
from
	dds.sales_transactions st
join dds.products p using (product_id)
group by 
	month
order by 
	month
;


-- in this case we need to discuss what we will do with first two month (I set it as 0)


with month_average as (
	select
		date_trunc('month', st.purchase_date)::date as month,
		avg(st.purchase_quantity * p.price) as average_amount
	from
		dds.sales_transactions st
	join dds.products p using (product_id)
	group by 
		month
)
select 
	month,
	((	
		average_amount +
		lag(average_amount, 1, 0) over(order by month) +
		lag(average_amount, 2, 0) over(order by month)
	) / 3 )::numeric(10,2) as moving_average
from month_average
order by month
;
