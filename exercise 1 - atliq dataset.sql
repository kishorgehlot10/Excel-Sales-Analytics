# Exercise - 1 
-- month
-- product_name
-- variant
-- sold qty
-- gross price per item
-- gross price total

select s.date,s.product_code,s.sold_quantity,
	   p.product,p.variant, 
       g.gross_price,
       round((s.sold_quantity*g.gross_price),2) as gross_price_total
from fact_sales_monthly s

join dim_product p
on s.product_code = p.product_code

join fact_gross_price g
on s.product_code = g.product_code and get_fiscal_year(s.date) = g.fiscal_year 

where 
      customer_code = 90002002 and
      get_fiscal_year(date) = 2021
	
order by date asc ;

# Exercise - 2

select s.date,
       sum(gross_price*sold_quantity) as gross_price_total
from fact_sales_monthly s
join fact_gross_price g
on s.product_code = g.product_code and g.fiscal_year = get_fiscal_year(s.date)
where customer_code = 90002002
group by s.date ;

# Exercise - 3

select get_fiscal_year(s.date) as fiscal_year,
	 sum(round(gross_price*sold_quantity,2)) as gross_price_total
     
from fact_sales_monthly s
join fact_gross_price g
on s.product_code = g.product_code and g.fiscal_year = get_fiscal_year(s.date)
where customer_code = 90002002
group by get_fiscal_year(s.date);


# Exercise - 4

select 
       sum(s.sold_quantity) as total_sold_qty
from fact_sales_monthly s
join dim_customer c 
on c.customer_code = s.customer_code
where market = "india" and get_fiscal_year(s.date) = 2021
group by c.market ;

# Exercise-5

select s.date,s.fiscal_year,
       s.customer_code,s.product_code,
	   p.product,p.variant,
       c.customer,c.market,
       s.sold_quantity,
       g.gross_price as gross_price_per_item,
       round(g.gross_price*sold_quantity,2) as total_gross_price,
       pre.pre_invoice_discount_pct
       
from 
     fact_sales_monthly s

join dim_product p
on s.product_code = p.product_code

join fact_gross_price g
on g.product_code = s.product_code and
g.fiscal_year = s.fiscal_year

join dim_customer c
on s.customer_code = c.customer_code

join fact_pre_invoice_deductions pre
on pre.customer_code = s.customer_code and
   pre.fiscal_year = s.fiscal_year

where 
     s.fiscal_year = 2021

limit 1000000 ;

