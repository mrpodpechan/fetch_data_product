# What are the top 5 brands by receipts scanned for most recent month?
The following script produces the top 5 brands by receipt counts using a window function 
(RANK) to order the months in the receipts result set and orders them by 1 so the 
most recent month ended is present.

```sql
WITH monthly_brand_data AS (
    SELECT 
        db.brand_name
        , db.brand_code
        , COUNT(DISTINCT fr.receipt_key) as receipts_scanned
        , dim_date.year
        , dim_date.month
        , dim_date.month_name
        , RANK() OVER (ORDER BY dim_date.year DESC, dim_date.month DESC) as month_rank
    FROM 
		"02_mart".fact_receipts fr
    JOIN 
		"02_mart".fact_receipt_items fri ON fr.receipt_key = fri.receipt_key
    JOIN 
		"02_mart".dim_brands db ON fri.brand_key = db.brand_key
    JOIN 
		"02_mart".dim_date ON dim_date.date_key = fr.purchase_date_key
    WHERE 
		db.brand_name IS NOT NULL
    GROUP BY 
		db.brand_name, db.brand_code, dim_date.year, dim_date.month, dim_date.month_name
)
SELECT 
    brand_name
    , brand_code
    , month_name
    , receipts_scanned
FROM 
	monthly_brand_data
WHERE 
	month_rank = 1
ORDER BY 
	receipts_scanned DESC
LIMIT 5;
```