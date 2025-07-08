SELECT 
    'Orphaned Receipts (Missing Users)' as test_name
    , COUNT(*) as failed_records
FROM 
    "02_mart".fact_receipts fr
LEFT JOIN 
    "02_mart".dim_users du ON fr.user_key = du.user_key
WHERE 
    du.user_key IS NULL;

SELECT 
    'Orphaned Receipt Items (Missing Receipts)' as test_name
    , COUNT(*) as failed_records
FROM 
    "02_mart".fact_receipt_items fri
LEFT JOIN 
    "02_mart".fact_receipts fr ON fri.receipt_key = fr.receipt_key
WHERE 
    fr.receipt_key IS NULL

UNION ALL

SELECT 
    'Orphaned Receipt Items (Missing Brands)'
    , COUNT(*)
FROM 
    "02_mart".fact_receipt_items fri
LEFT JOIN 
    "02_mart".dim_brands db ON fri.brand_key = db.brand_key
WHERE 
    fri.brand_key IS NOT NULL AND db.brand_key IS NULL

UNION ALL

SELECT 
    'Invalid Date Keys in fact_receipts'
    , COUNT(*)
FROM 
    "02_mart".fact_receipts fr
LEFT JOIN 
    "02_mart".dim_date dd ON fr.date_scanned_key = dd.date_key
WHERE 
    fr.date_scanned_key IS NOT NULL AND dd.date_key IS NULL

UNION ALL

SELECT 
    'Missing Receipts in Mart Layer'
    , COUNT(*)
FROM 
    "01_base".receipts r
LEFT JOIN 
    "02_mart".fact_receipts fr ON r.receipt_id = fr.receipt_id
WHERE 
    fr.receipt_id IS NULL

UNION ALL

SELECT 
    'Duplicate User IDs in dim_users'
    , COUNT(*) - COUNT(DISTINCT user_id)
FROM 
    "02_mart".dim_users

UNION ALL

SELECT 
    'Duplicate Brand IDs in dim_brands'
    , COUNT(*) - COUNT(DISTINCT brand_id)
FROM 
    "02_mart".dim_brands
WHERE 
    brand_id IS NOT NULL;