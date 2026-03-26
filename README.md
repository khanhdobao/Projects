# Project Overview

## Objective

Olist is dealing with slow delivery performance and uneven revenue distribution across sellers and product categories. These issues affect customer satisfaction and make it harder to scale.

This project looks at what drives revenue, delivery performance, and seller efficiency. The goal is to support better decisions and improve both operations and customer experience.

---

## Context & Business Questions

Olist runs on a commission-based marketplace model, so revenue depends heavily on seller performance and order volume. When delivery slows down or revenue is concentrated in a few areas, growth becomes harder to sustain.

This analysis focuses on two key questions:

- **Logistics and customer satisfaction**  
  How do delivery times across Brazilian states relate to customer review scores?

- **Revenue concentration**  
  Which 20% of product categories generate 80% of total revenue?

---

## Data Schema
<img width="1400" height="842" alt="image" src="https://github.com/user-attachments/assets/c2f28530-0c88-4f29-b8bb-4fbed48fd678" />

**Source:** https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

---

## Business Logic Modeling

To keep the analysis reliable and meaningful, I followed a few key steps:

- **Data cleaning and validation**  
  I identified missing values, including 1,603 missing product categories, and filtered the dataset to include only delivered orders.

- **Revenue estimation**  
  Since actual profit data wasn’t available, I assumed a 30% commission fee to estimate revenue.

- **SQL modeling**  
  I used CTEs and `COALESCE` to handle missing values and structure the data for analysis.

---

## Approach and Process

To answer the two main questions, I split the analysis into two views:

### View A (Sales and Products)
- Combines Orders, Items, Products, and Translations  
- Focus: What sells and which categories drive revenue?

### View B (Customer and Feedback)
- Combines Orders, Reviews, Customers, and Geolocation  
- Focus: Where customers are and how satisfied they are

---

## Data Collection

Before joining the datasets, I ran an initial EDA on each table using Python. This step helped catch data quality issues early.

I focused on:

- Investigating cases where price existed but category data was missing  
- Identifying missing values  
- Understanding inconsistencies  

---

## Initial EDA

The data audit showed:

- `price` and `freight_value` had no missing values  
- 1,603 missing values in `product_category_name`  
- 2,454 missing values in `delivery_customer_date`  

The price distribution was right-skewed:

- Mean = 120.7  
- Median = 75.0  

This suggests a small number of high-value orders pulling the average up.

```python
# 1. Check for missing category data
print("--- Missing Values Per Column ---")
print(df.isnull().sum())

# 2. Check for statistical column
print("\n--- Numerical Summary ---")
print(df.describe().T)```
<img width="1540" height="1225" alt="image" src="https://github.com/user-attachments/assets/aa65d90b-d7ee-4884-8713-26ce380f9de2" />


## 📊 Visualizations and Insights

### 1. Revenue Concentration

Since profit data wasn’t available, I built a revenue model using a **30% commission assumption** and applied the **Pareto principle**.
<img width="1226" height="851" alt="image" src="https://github.com/user-attachments/assets/79b0ab77-de88-4af3-9fa5-253a84186bb9" />
<img width="1229" height="870" alt="image" src="https://github.com/user-attachments/assets/0d9d7649-354d-4619-a0cf-2c451c7851cd" />
**Result:**
- Only **18 product categories generate 80% of total revenue**

This shows a strong concentration of value in a small set of categories.

---

### 2. Logistics and Customer Satisfaction

To measure the impact of delivery delays, I created a **satisfaction gap** by comparing review scores for on-time vs late deliveries.

Some smaller cities showed sharp drops in satisfaction but had low order volumes, which distorted the results. To correct this, I weighted late delivery rates by order volume.

This helped focus on areas where improvements matter most.
<img width="1244" height="884" alt="image" src="https://github.com/user-attachments/assets/2354e0c3-eeac-40a4-95e4-18153bfcf7e7" />

---

### 🔍 Key Findings

- Major cities like **São Paulo, Rio de Janeiro, and Belo Horizonte** have the highest number of late deliveries  
- These cities also handle the largest order volumes  

**Rio de Janeiro stands out:**
- 6% of total orders  
- 10% of all late deliveries  

This gap highlights a clear logistics issue that needs attention.

---

## 💡 Strategic Recommendations

### Focus on the "Top 18"
- 80% of revenue comes from 18 categories  
- Includes categories like **Health & Beauty** and **Watches**  
- Prioritize marketing and inventory in these areas  

---

### Fix the "Crisis Cities"
- Improve logistics in:
  - São Paulo  
  - Rio de Janeiro  
  - Belo Horizonte  
- Fixing these hubs addresses **~25% of delivery failures**

---

### Target the Rio Gap
- Rio’s late delivery share (10%) exceeds its order share (6%)  
- Indicates a specific logistics inefficiency that needs to be resolved
