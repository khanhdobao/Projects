WITH base_delivery_data
AS ( -- CTE table a to filter and refine missing rows
	SELECT
	ci.customer_city AS city
	,r.review_score AS score
	,o.order_id
	,EXTRACT(DAY FROM (o.order_delivered_customer_date - o.order_purchase_timestamp)) AS num_delivery_days
	,CASE WHEN o.order_estimated_delivery_date < o.order_delivered_customer_date THEN 1 ELSE 0 END AS flag_late_delivery
	FROM olist_orders o
	INNER JOIN olist_customer_rating r ON o.order_id = r.order_id
	INNER JOIN olist_customer_info ci ON o.customer_id = ci.customer_id
	WHERE 2=2 
	AND o.order_status = 'delivered'
	AND o.order_status IS NOT NULL
) 
-- delivery days
	SELECT
    city,
    COUNT(order_id) AS total_orders,
    ROUND(AVG(num_delivery_days), 2) AS avg_delivery_days,
    ROUND(COUNT(order_id) * 100.0 / SUM(COUNT(order_id)) OVER(), 2) AS pct_order_of_total
	FROM base_delivery_data
	GROUP BY 1
	ORDER BY total_orders DESC;
/* comment:The top three cities are : Sao Paulo, Rio de Janeiro, and Salvador, represent a significant 25.2% of Olist's total order volume. 
The current average delivery of top 3 cities ranges between 7 to 14 days, we will further investigate which city show the highest late delivery to have a wider view
