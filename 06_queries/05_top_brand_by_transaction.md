# Which brand has the most transactions among users who were created within the past 6 months?
Using the same approach from the spend analytics, this script is designed to represent the top 10 brands driven by a window function of users created in the last 6 months via an interval approach.

## Pepsi seems to be the top brand by transaction count. Sadly, no cheese.

'''sql
SELECT 
    db.brand_name
    , db.brand_code
    , COUNT(fri.item_key) as total_transactions
    , COUNT(DISTINCT fr.receipt_key) as unique_receipts
    , COUNT(DISTINCT fr.user_key) as unique_customers
    , SUM(fri.quantity_purchased) as total_items_sold
    , ROUND(COUNT(fri.item_key)::decimal / COUNT(DISTINCT fr.user_key), 2) as transactions_per_customer
FROM 
    "02_mart".fact_receipts fr
JOIN 
    "02_mart".dim_users du ON fr.user_key = du.user_key
JOIN 
    "02_mart".fact_receipt_items fri ON fr.receipt_key = fri.receipt_key
JOIN 
    "02_mart".dim_brands db ON fri.brand_key = db.brand_key
WHERE 
    db.brand_name IS NOT NULL
AND 
    du.created_date >= (
    SELECT MAX(created_date) - INTERVAL '6 months'
    FROM "02_mart".dim_users
    WHERE created_date IS NOT NULL
    )
GROUP BY 
    db.brand_name, db.brand_code
ORDER BY 
    total_transactions DESC
LIMIT 10;
'''