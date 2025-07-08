# Which brand has the most spend among users who were created within the past 6 months?
This script is designed to represent the top 10 brands driven by a window function of users created in the last 6 months via an interval approach.

## Cracker Barrel Cheese is the clear winner (and it's really, really good cheese).

'''sql
WITH recent_users AS (
    SELECT 
        user_key
        , created_date
        , MAX(created_date) OVER () as max_date_in_data
    FROM 
        "02_mart".dim_users
    WHERE 
        created_date IS NOT NULL
),
users_past_6_months AS (
    SELECT 
        user_key
    FROM 
        recent_users
    WHERE 
        created_date >= max_date_in_data - INTERVAL '6 months'
)
SELECT 
    db.brand_name
    , db.brand_code
    , ROUND(SUM(fri.final_price * fri.quantity_purchased), 2) as total_brand_spend
    , COUNT(DISTINCT fr.receipt_key) as receipt_count
    , COUNT(DISTINCT fr.user_key) as unique_customers
    , ROUND(SUM(fri.final_price * fri.quantity_purchased) / COUNT(DISTINCT fr.user_key), 2) as spend_per_customer
FROM 
    "02_mart".fact_receipts fr
JOIN 
    users_past_6_months ru ON fr.user_key = ru.user_key
JOIN 
    "02_mart".fact_receipt_items fri ON fr.receipt_key = fri.receipt_key
JOIN 
    "02_mart".dim_brands db ON fri.brand_key = db.brand_key
WHERE 
    db.brand_name IS NOT NULL
GROUP BY 
    db.brand_name, db.brand_code
ORDER BY 
    total_brand_spend DESC
LIMIT 10; -- Showing the top 10 to observe the data and produce the topmost answer
'''