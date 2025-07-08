SELECT 
    'raw_receipts' as table_name 
    , 'json_data' as column_name
    , COUNT(*) - COUNT(json_data) as null_count
    , COUNT(*) as total_count
    , ROUND(((COUNT(*) - COUNT(json_data))::decimal / COUNT(*)) * 100, 2) as null_percentage
FROM 
    "00_raw_json".raw_receipts

UNION ALL

SELECT 
    'raw_users' 
    , 'json_data'
    , COUNT(*) - COUNT(json_data)
    , COUNT(*)
    , ROUND(((COUNT(*) - COUNT(json_data))::decimal / COUNT(*)) * 100, 2)
FROM 
    "00_raw_json".raw_users

UNION ALL

SELECT 
    'raw_brands'
    , 'json_data'
    , COUNT(*) - COUNT(json_data)
    , COUNT(*)
    , ROUND(((COUNT(*) - COUNT(json_data))::decimal / COUNT(*)) * 100, 2)
FROM 
    "00_raw_json".raw_brands

UNION ALL

SELECT 
    'users'
    , 'user_id'
    , COUNT(*) - COUNT(user_id)
    , COUNT(*)
    , ROUND(((COUNT(*) - COUNT(user_id))::decimal / COUNT(*)) * 100, 2)
FROM 
    "01_base".users

UNION ALL

SELECT 
    'users'
    , 'state'
    , COUNT(*) - COUNT(state)
    , COUNT(*)
    , ROUND(((COUNT(*) - COUNT(state))::decimal / COUNT(*)) * 100, 2)
FROM 
    "01_base".users

UNION ALL

SELECT 
    'brands'
    , 'brand_name'
    , COUNT(*) - COUNT(brand_name)
    , COUNT(*)
    , ROUND(((COUNT(*) - COUNT(brand_name))::decimal / COUNT(*)) * 100, 2)
FROM 
    "01_base".brands

UNION ALL

SELECT 
    'receipts'
    , 'total_spent'
    , COUNT(*) - COUNT(total_spent)
    , COUNT(*)
    , ROUND(((COUNT(*) - COUNT(total_spent))::decimal / COUNT(*)) * 100, 2)
FROM 
    "01_base".receipts

UNION ALL

SELECT 
    'receipt_items'
    , 'final_price'
    , COUNT(*) - COUNT(final_price)
    , COUNT(*)
    , ROUND(((COUNT(*) - COUNT(final_price))::decimal / COUNT(*)) * 100, 2)
FROM 
    "01_base".receipt_items

UNION ALL

SELECT 
    'fact_receipts'
    ,'user_key'
    , COUNT(*) - COUNT(user_key)
    , COUNT(*)
    , ROUND(((COUNT(*) - COUNT(user_key))::decimal / COUNT(*)) * 100, 2)
FROM 
    "02_mart".fact_receipts

UNION ALL

SELECT 
    'fact_receipts'
    , 'total_spent'
    , COUNT(*) - COUNT(total_spent)
    , COUNT(*)
    , ROUND(((COUNT(*) - COUNT(total_spent))::decimal / COUNT(*)) * 100, 2)
FROM 
    "02_mart".fact_receipts

UNION ALL

SELECT 
    'fact_receipt_items'
    , 'brand_key'
    , COUNT(*) - COUNT(brand_key)
    , COUNT(*)
    , ROUND(((COUNT(*) - COUNT(brand_key))::decimal / COUNT(*)) * 100, 2)
FROM 
    "02_mart".fact_receipt_items
ORDER BY 
    table_name, column_name;