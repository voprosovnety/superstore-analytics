-- 04. Star schema creation
-- creates dimension tables and fact_sales table based on raw_superstore

-- 1) drop
drop table if exists fact_sales cascade;
drop table if exists dim_customer cascade;
drop table if exists dim_product cascade;
drop table if exists dim_geo cascade;


-- 2) create dims
create table dim_customer (
	customer_id text primary key not null,
	customer_name text,
	segment text
);

create table dim_product (
	product_key integer generated always as identity primary key,
	product_id text not null,
	category text not null,
	sub_category text not null,
	product_name text not null,
	constraint uq_dim_product_nk unique (product_id, category, sub_category, product_name)
);

create table dim_geo (
	geo_id integer generated always as identity primary key,
	postal_code text not null,
	city text not null,
	state text not null,
	region text not null,
	constraint uq_dim_geo_nk unique (postal_code, city, state, region)
);


-- 3) create fact
create table fact_sales (
	row_id integer primary key not null,
	order_id text not null,
	order_date date not null,
	ship_date date not null,
	customer_id text not null references dim_customer(customer_id),
	product_key integer not null references dim_product(product_key),
	geo_id integer not null references dim_geo(geo_id),
	sales numeric(10,2) not null,
	quantity integer not null,
	discount numeric(4,2) not null check (discount >= 0 and discount <= 1),
	profit numeric(10,2) not null
);


-- 4) load dims
insert into dim_customer (
	customer_id,
	customer_name,
	segment)
select distinct
	customer_id,
	customer_name,
	segment
from raw_superstore;

insert into dim_product (
	product_id,
	category,
	sub_category,
	product_name)
select distinct
	product_id,
	category,
	sub_category,
	product_name
from raw_superstore;

insert into dim_geo (
	postal_code,
	city,
	state,
	region
)
select distinct
	postal_code,
	city,
	state,
	region
from raw_superstore;


-- 5) load fact
insert into fact_sales (
	row_id,
	order_id,
	order_date,
	ship_date,
	customer_id,
	product_key,
	geo_id,
	sales,
	quantity,
	discount,
	profit
)
select
	r.row_id,
	r.order_id,
	r.order_date,
	r.ship_date,
	r.customer_id,
	p.product_key,
	g.geo_id,
	r.sales,
	r.quantity,
	r.discount,
	r.profit
from raw_superstore r 
	join dim_geo g on
	r.postal_code = g.postal_code and
	r.city = g.city and
	r.state = g.state and
	r.region = g.region
	join dim_product p on
	r.product_id = p.product_id and
	r.category = p.category and
	r.sub_category = p.sub_category and
	r.product_name = p.product_name;