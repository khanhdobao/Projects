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
SELECT
    city,
	COUNT(order_id) AS total_orders
	,SUM(flag_late_delivery) AS number_late_order
    ,ROUND(AVG(CASE WHEN flag_late_delivery = 1 THEN score END), 2) AS avg_score_late
    ,ROUND(AVG(CASE WHEN flag_late_delivery = 0 THEN score END), 2) AS avg_score_ontime
    ,ROUND(AVG(CASE WHEN flag_late_delivery = 0 THEN score END) - 
          AVG(CASE WHEN flag_late_delivery = 1 THEN score END), 2) AS satisfaction_drop
FROM base_delivery_data
GROUP BY 1
HAVING COUNT(order_id) > 50 -- Focus on statistically significant cities
ORDER BY  satisfaction_drop DESC;

/* comment:
the output show that cities like petrolina, timoteo and sertaozinho show the biggest drop in ratings when deliveries are late, 
but they have too few orders to be the main concern. To understand the real threat to Olist’s reputation, we should focus on major hubs. 
In these larger cities, a consistent 2-star drop proves that late deliveries are a widespread problem, not just a one-off.

