WITH a 
AS ( -- CTE table a to filter and refine missing rows
	SELECT 
	SELECT 
	COALESCE (t.product_category_name_english,'unclassified') AS category
	,i.price
	,i.freight_value
	, CASE WHEN o.order_status = 'delivered' THEN o.order_delivered_customer_date ELSE NULL END AS delivery_date
	,o.order_id
	,i.product_id
	FROM olist_orders o
	LEFT JOIN olist_item i ON i.order_id = o.order_id
	LEFT JOIN olist_product p ON p.product_id = i.product_id
	LEFT JOIN olist_translate_category_name t ON p.product_category_name = t.product_category_name
	WHERE 2=2
	AND  o.order_status = 'delivered'
) 

SELECT 
	--TO_CHAR(a.delivery_date,'YYYYMM') AS year_month
	category
	,COUNT (DISTINCT a.order_id) AS number_of_order
	,COUNT ( a.product_id) AS product_quantity
	,SUM(a.price) AS product_price
	,SUM(a.freight_value) AS freight_value
	FROM a
	WHERE 2=2
	AND a.delivery_date IS NOT NULL
	AND DATE_PART('year',a.delivery_date) = '2017' --only 2017 full 12 month
	GROUP BY 1
	ORDER BY 4 DESC

--> Q4 is the most busiest time
------window function to answer the question, 20% of product generate 80% revenue (analyse all data)
-- refine missing data
WITH base_data
AS ( -- CTE table a to filter and refine missing rows
	SELECT 
	COALESCE (p.product_category_name,'unclassified') AS category
	,i.price
	,i.freight_value
	, CASE WHEN o.order_status = 'delivered' THEN o.order_delivered_customer_date ELSE NULL END AS delivery_date
	,o.order_id
	,i.product_id
	FROM olist_orders o
	LEFT JOIN olist_item i ON i.order_id = o.order_id
	LEFT JOIN olist_product p ON p.product_id = i.product_id
	WHERE 2=2
	AND  o.order_status = 'delivered'
) ,

category_summary AS (
	SELECT
	category
	,COUNT (DISTINCT order_id) AS number_of_order
	,COUNT ( product_id) AS product_quantity
	,SUM(price)*0.3 AS commission_revenue
	FROM base_data
	WHERE 2=2
	AND delivery_date IS NOT NULL
	GROUP BY 1
)

	SELECT 
	--TO_CHAR(a.delivery_date,'YYYYMM') AS year_month
	category
	,number_of_order
	,product_quantity
	,commission_revenue
	,(commission_revenue*100/ SUM(commission_revenue) OVER ()) AS pct_total_price
	,SUM(commission_revenue) OVER (ORDER BY commission_revenue DESC) *100 / SUM(commission_revenue) OVER () AS cumulative_pct_rev
	FROM category_summary
	ORDER BY 4 DESC
	
--> RESULT: RANKING LIST CATEGORY


