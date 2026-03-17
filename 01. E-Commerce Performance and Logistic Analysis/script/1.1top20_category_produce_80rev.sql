WITH base_data
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
),

category_revenue_ranked AS (

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
)
--> RESULT: WE HAVE RANKING 80% REVENUE 

SELECT 

	SUM(CASE WHEN cumulative_pct_rev < 82 THEN 1 ELSE 0 END ) AS top20_category
	,COUNT(*) AS total_category
	,SUM(CASE WHEN cumulative_pct_rev < 82 THEN 1 ELSE 0 END )*100 / count(*) AS pct_of_total
	FROM category_revenue_ranked;

--> RESULT: TOP 24% CATEGORY GENERATE 82% REVENUE

