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
print(df.describe().T)
