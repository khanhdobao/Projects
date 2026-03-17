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
	city
	,COUNT(order_id) AS number_of_orders
	,SUM(flag_late_delivery) AS number_late_order
	,SUM(flag_late_delivery)*100/COUNT(order_id) AS pct_late_order_each_city
	,ROUND(SUM(flag_late_delivery)*100/SUM(SUM(flag_late_delivery)) OVER(),2) AS pct_late_grand_total
	,ROUND(COUNT(order_id)*100/SUM(COUNT(order_id)) OVER(),2) AS pct_order_grand_total
	,ROUND(SUM(flag_late_delivery)*100/SUM(SUM(flag_late_delivery)) OVER() * COUNT(order_id)*100/SUM(COUNT(order_id)) OVER(),2) AS weighted_late_vs_volume
	FROM base_delivery_data
	GROUP BY 1
	ORDER BY 7 DESC;
/*comment: Smaller cities show high sensitivity to delays, but São Paulo, Rio de Janeiro, and Belo horizonte
are the real drivers of customer dissatisfaction. Since these three hubs have the most orders and the most delivery failures,
fixing logistics there would have the biggest positive impact on Olist’s brand.