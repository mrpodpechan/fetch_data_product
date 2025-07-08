# How does the ranking of the top 5 brands by receipts scanned for the recent month compare to the ranking for the previous month?
The following script produces the top 5 brands by by brand rankings of the current month and those from the previous month, so that
the result set can be analyzed to observe the change in brand rank month over month (MoM).

``` sql
WITH monthly_brand_rankings AS (
    SELECT 
        db.brand_name
        , dim_date.year
        , dim_date.month
        , dim_date.month_name
        , COUNT(DISTINCT fr.receipt_key) as receipts_scanned
        , ROW_NUMBER() OVER (
            PARTITION BY dim_date.year, dim_date.month 
            ORDER BY COUNT(DISTINCT fr.receipt_key) DESC
        ) as brand_rank_in_month
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
    AND 
        ((dim_date.year = 2021 AND dim_date.month = 1) OR 
        (dim_date.year = 2020 AND dim_date.month = 12))  -- Explicitly specify both months, would not use this approach in broader data
    GROUP BY 
        db.brand_name, dim_date.year, dim_date.month, dim_date.month_name
),
top_5_each_month AS (
    SELECT 
        *
    FROM 
        monthly_brand_rankings
    WHERE 
        brand_rank_in_month <= 5
),
current_month AS (
    SELECT * FROM top_5_each_month WHERE year = 2021 AND month = 1
),
previous_month AS (
    SELECT * FROM top_5_each_month WHERE year = 2020 AND month = 12
)
SELECT 
    COALESCE(curr.brand_name, prev.brand_name) as brand_name
    , curr.brand_rank_in_month as current_month_rank
    , curr.receipts_scanned as current_month_receipts
    , COALESCE(curr.month_name, 'Not in Top 5') as current_month
    , prev.brand_rank_in_month as previous_month_rank
    , prev.receipts_scanned as previous_month_receipts
    , COALESCE(prev.month_name, 'Not in Top 5') as previous_month
    , CASE 
        WHEN curr.brand_rank_in_month IS NULL THEN 'Dropped from Top 5'
        WHEN prev.brand_rank_in_month IS NULL THEN 'New to Top 5'
        WHEN curr.brand_rank_in_month < prev.brand_rank_in_month THEN 'Improved'
        WHEN curr.brand_rank_in_month > prev.brand_rank_in_month THEN 'Declined'
        ELSE 'Same'
        END as ranking_change
FROM 
    current_month curr
FULL OUTER JOIN 
    previous_month prev ON curr.brand_name = prev.brand_name
ORDER BY 
    CASE WHEN curr.brand_rank_in_month IS NULL THEN 999 ELSE curr.brand_rank_in_month END,
    CASE WHEN prev.brand_rank_in_month IS NULL THEN 999 ELSE prev.brand_rank_in_month END;
```