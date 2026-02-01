-- schema definition for raw superstore dataset
-- base table used for all further transformations and analysis
drop table if exists raw_superstore;

create table raw_superstore (
	row_id integer primary key,
	order_id text,
	order_date date,
	ship_date date,
	ship_mode text,
	customer_id text,
	customer_name text,
	segment text,
	country text,
	city text,
	state text,
	postal_code text,
	region text,
	product_id text,
	category text,
	sub_category text,
	product_name text,
	sales numeric(10,2),
	quantity integer,
	discount numeric(4,2),
	profit numeric(10,2)
);