# When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
There are technically two scripts here, one to help analyze the receipt statuses as there is not an 'Accepted' version (confirmed by reviewing the JSON data).
The second script is the counting of 'FINISHED' (assuming 'ACCEPTED') and then 'REJECTED'. The others are assumed to be WIP/In Progress unless 'ACCEPTED' is a broader definition.

## ACCEPTED appears to be greater than REJECTED.

## Script 1 - all rankings
'''sql
SELECT 
    drs.status_code as receipt_status
    , COUNT(fr.receipt_key) as receipt_count
    , ROUND(AVG(COALESCE(fr.total_spent,0)), 2) as average_spend
    , ROUND(SUM(COALESCE(fr.total_spent,0)), 2) as total_spend
FROM 
    "02_mart".fact_receipts fr
JOIN 
    "02_mart".dim_receipt_status drs ON fr.status_key = drs.status_key
GROUP BY 
    drs.status_code
ORDER BY 
    average_spend DESC;
'''

## Script 2 - FINISHED and REJECTED:
'''sql
SELECT 
    drs.status_code as receipt_status
    , COUNT(fr.receipt_key) as receipt_count
    , ROUND(AVG(fr.total_spent), 2) as average_spend
    , ROUND(SUM(fr.total_spent), 2) as total_spend
    , ROUND(MIN(fr.total_spent), 2) as min_spend
    , ROUND(MAX(fr.total_spent), 2) as max_spend
FROM 
    "02_mart".fact_receipts fr
JOIN 
    "02_mart".dim_receipt_status drs ON fr.status_key = drs.status_key
WHERE 
    drs.status_code IN ('FINISHED', 'REJECTED')
AND 
    fr.total_spent IS NOT NULL
GROUP BY 
    drs.status_code
ORDER BY 
    average_spend DESC;
'''