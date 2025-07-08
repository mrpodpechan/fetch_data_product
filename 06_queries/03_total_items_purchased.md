# When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
Similar approach that we took with spend, there are technically two scripts here, one to help analyze the receipt statuses as there is not an 'Accepted' version (confirmed by reviewing the JSON data).
The second script is the counting of 'FINISHED' (assuming 'ACCEPTED') and then 'REJECTED'. The others are assumed to be WIP/In Progress unless 'ACCEPTED' is a broader definition.

## ACCEPTED appears to be greater than REJECTED.

## Script 1 - all rankings
```sql
SELECT 
    drs.status_code as receipt_status
    , COUNT(fr.receipt_key) as receipt_count
    , ROUND(AVG(COALESCE(fr.purchased_item_count,0)), 2) as avg_items_per_receipt
    , ROUND(SUM(COALESCE(fr.purchased_item_count,0)), 2) as total_items_purchased
FROM 
    "02_mart".fact_receipts fr
JOIN 
    "02_mart".dim_receipt_status drs ON fr.status_key = drs.status_key
GROUP BY 
    drs.status_code
ORDER BY 
    total_items_purchased DESC;
```

## Script 2 - FINISHED and REJECTED:
```sql
SELECT 
    drs.status_code as receipt_status
    , COUNT(fr.receipt_key) as receipt_count
    , ROUND(AVG(fr.purchased_item_count), 2) as avg_items_per_receipt
    , ROUND(SUM(fr.purchased_item_count), 2) as total_items_purchased
    , ROUND(MIN(fr.purchased_item_count), 2) as min_items_purchased
    , ROUND(MAX(fr.purchased_item_count), 2) as max_items_purchased
FROM 
    "02_mart".fact_receipts fr
JOIN 
    "02_mart".dim_receipt_status drs ON fr.status_key = drs.status_key
WHERE 
    drs.status_code IN ('FINISHED', 'REJECTED')
AND 
    fr.purchased_item_count IS NOT NULL
GROUP BY 
    drs.status_code
ORDER BY 
    total_items_purchased DESC;
```