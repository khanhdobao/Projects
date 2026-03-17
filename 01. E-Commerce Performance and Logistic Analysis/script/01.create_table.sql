CREATE TABLE olist_translate_category_name 
(	
	product_category_name VARCHAR(50)
	,product_category_name_english VARCHAR(50)
)	
CREATE TABLE olist_customer_rating
(
	review_id VARCHAR(50)
	,order_id VARCHAR(50)
	,review_score INT
	,review_comment_title VARCHAR(50)
	,review_comment_message VARCHAR(500)
	,review_creation_date TIMESTAMP
	,review_answer_timestamp TIMESTAMP

)

CREATE TABLE olist_customer_info
(
	customer_id VARCHAR(50)
	,customer_unique_id VARCHAR(50)
	,customer_zip_code_prefix INT
	,customer_city VARCHAR(50)
	,customer_state VARCHAR(10)
)

CREATE TABLE olist_geolocation
(
	geolocation_zip_code_prefix INT
	,geolocation_lat FLOAT
	,geolocation_lng FLOAT
	,geolocation_city VARCHAR(50)
	,geolocation_state VARCHAR(10)

)