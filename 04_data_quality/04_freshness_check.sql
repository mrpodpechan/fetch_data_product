SELECT 
    'Latest Receipt Date' as metric_type
    , 'date_scanned' as detail
    , MAX(dd.full_date)::text as value
FROM 
    "02_mart".fact_receipts fr
JOIN 
    "02_mart".dim_date dd ON fr.date_scanned_key = dd.date_key

UNION ALL

SELECT 
    'Earliest Receipt Date'
    , 'date_scanned'
    , MIN(dd.full_date)::text
FROM 
    "02_mart".fact_receipts fr
JOIN 
    "02_mart".dim_date dd ON fr.date_scanned_key = dd.date_key

UNION ALL

SELECT 
    'Days Since Latest Receipt'
    , 'date_scanned'
    , (CURRENT_DATE - MAX(dd.full_date))::text || ' days'
FROM 
    "02_mart".fact_receipts fr
JOIN 
    "02_mart".dim_date dd ON fr.date_scanned_key = dd.date_key

UNION ALL


SELECT 
    'Latest User Registration'
    , 'created_date'
    , MAX(created_date)::text
FROM 
    "02_mart".dim_users
WHERE 
    created_date IS NOT NULL

UNION ALL

SELECT 
    'Days Since Latest User'
    , 'created_date'
    , (CURRENT_DATE - MAX(created_date::date))::text || ' days'
FROM 
    "02_mart".dim_users
WHERE 
    created_date IS NOT NULL;


SELECT 
    'Monthly Receipt Volume' as metric_type
    , dd.year::text || '-' || LPAD(dd.month::text, 2, '0') || ' (' || dd.month_name || ')' as detail
    , COUNT(DISTINCT fr.receipt_key)::text as value
FROM 
    "02_mart".fact_receipts fr
JOIN 
    "02_mart".dim_date dd ON fr.date_scanned_key = dd.date_key
WHERE 
    dd.full_date >= (
    SELECT MAX(dd2.full_date) - INTERVAL '6 months'
    FROM "02_mart".dim_date dd2
    WHERE dd2.date_key IN (SELECT DISTINCT date_scanned_key FROM "02_mart".fact_receipts)
)
GROUP BY 
    dd.year, dd.month, dd.month_name
ORDER BY 
    dd.year DESC, dd.month DESC;