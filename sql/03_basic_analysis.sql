-- A. Overall data summary
-- total rows, distinct orders, date range
select 
	count(*) as total_rows,
	count(distinct order_id) as distinct_orders, 
	min(order_date) as min_order_date, 
	max(order_date) as max_order_date
from raw_superstore;

-- B1. Check duplicate row_id
select row_id
from raw_superstore
group by row_id
having count(*) > 1;

-- B2. Orders summary by order_id
select
	order_id,
	count(*) as item_count,
	sum(sales) as total_sales,
	sum(profit) as total_profit
from raw_superstore
group by order_id;

-- C. Sales & profit by category
select
	category,
	sum(sales) as total_sales,
	sum(profit) as total_profit,
	sum(profit)/sum(sales) as profit_margin
from raw_superstore
group by category
order by total_profit desc;

-- D. Sales & profit by region
select
	region,
	sum(sales) as total_sales,
	sum(profit) as total_profit,
	round(100 * sum(profit)/sum(sales), 2) as profit_margin
from raw_superstore
group by region
order by total_profit desc;

-- E. Sales & profit by customer segment
-- consumer vs corporate vs home office preformance comparison
select
	segment,
	sum(sales) as total_sales,
	sum(profit) as total_profit,
	round(100 * sum(profit)/sum(sales), 2) as profit_margin
from raw_superstore
group by segment
order by total_profit desc;

-- F1. Profit distribution by exact discount values
-- checking whether higher discounts correlate with lower profit
select
	discount,
	sum(sales) as total_sales,
	sum(profit) as total_profit,
	round(100 * sum(profit)/sum(sales), 2) as profit_margin
from raw_superstore
group by discount
order by discount asc;

-- F2. Profit by discount buckets
-- bucketed analysis to reveal harmful discount ranges
select
	case
		when discount = 0 then '0%'
		when discount <= 0.1 then '0-10%'
		when discount <= 0.2 then '10-20%'
		else '>20%'
	end as bucket,
	sum(sales) as total_sales,
	sum(profit) as total_profit,
	round(100 * sum(profit)/sum(sales), 2) as profit_margin
from raw_superstore
group by bucket
order by
	case bucket
		when '0%' then 1
		when '0-10%' then 2
		when '10-20%' then 3
		else 4
	end;

-- G. Top 10 most profitable products
-- identifies key items driving positive profit
select
	product_name,
	sum(sales) as total_sales,
	sum(profit) as total_profit
from raw_superstore
group by product_name
order by total_profit desc
limit 10;

-- H. Bottom 10 least profitable or loss-making products
-- highlights products with pricing/discount issues
select
	product_name,
	sum(sales) as total_sales,
	sum(profit) as total_profit
from raw_superstore
group by product_name
order by total_profit asc
limit 10;

-- I. Monthly sales & profit trend
-- shows business seasonality and long-term growth
select
	to_char(date_trunc('month', order_date),'YYYY-MM') as month,
	sum(sales) as total_sales,
	sum(profit) as total_profit
from raw_superstore
group by month
order by month asc;