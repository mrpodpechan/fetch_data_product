# Entity Relationship Diagram (ERD)
This document describes the relational data model designed for the Fetch Rewards data mart.

## Overview
The ERD implements a **star schema** design optimized for analytical queries and business intelligence reporting. 
The model transforms unstructured JSON data into a structured, performant relational database following dimensional modeling best practices.

## Schema Design Philosophy
**Three-Layer Architecture:**
This setup follows closely to Medallion Architecture without the formal names.
1. **Raw Layer** - Preserves original JSON data integrity
2. **Base Layer** - Normalized relational tables for data quality
3. **Mart Layer** - Dimensional model optimized for analytics

## Fact Tables
### fact_receipts
**Purpose:** Receipt-level transaction metrics and measures, considered the receipt-header
**Grain:** One record per receipt
| Column | Data Type | Description |
|--------|-----------|-------------|
| receipt_key | INT64 | Surrogate primary key |
| receipt_id | STRING | Natural key from source system |
| user_key | INT64 | Foreign key to dim_users |
| date_scanned_key | INT64 | Foreign key to dim_date (scan date) |
| purchase_date_key | INT64 | Foreign key to dim_date (purchase date) |
| status_key | INT64 | Foreign key to dim_receipt_status |
| total_spent | DECIMAL | Total receipt amount |
| points_earned | DECIMAL | Points awarded for receipt |
| bonus_points_earned | INT64 | Bonus points from promotions |
| purchased_item_count | INT64 | Number of items on receipt |

### fact_receipt_items
**Purpose:** Item-level transaction details and product metrics, child/line-item to the receipt header table
**Grain:** One record per item per receipt
| Column | Data Type | Description |
|--------|-----------|-------------|
| item_key | INT64 | Surrogate primary key |
| receipt_key | INT64 | Foreign key to fact_receipts |
| brand_key | INT64 | Foreign key to dim_brands |
| barcode | STRING | Product barcode identifier |
| description | STRING | Item description from receipt |
| partner_item_id | STRING | Internal item identifier |
| final_price | DECIMAL | Final price paid for item |
| item_price | DECIMAL | Listed price of item |
| quantity_purchased | INT64 | Number of items purchased |
| points_earned | DECIMAL | Points earned for this item |

## Dimension Tables
### dim_users
**Purpose:** Customer demographics and attributes
**Type:** Slowly Changing Dimension (assumed SCD Type 1, but may be SCD 2 given behavior)
| Column | Data Type | Description |
|--------|-----------|-------------|
| user_key | INT64 | Surrogate primary key |
| user_id | STRING | Natural key from source system |
| state | STRING | User's state of residence |
| created_date | DATETIME | Account creation timestamp |
| last_login | DATETIME | Most recent login timestamp |
| role | STRING | User role (typically 'CONSUMER') |
| active | BOOLEAN | Account status flag |

### dim_brands
**Purpose:** Brand hierarchy and product categorization
**Type:** Slowly Changing Dimension (assumed SCD Type 1, but may be SCD 2 given behavior)
| Column | Data Type | Description |
|--------|-----------|-------------|
| brand_key | INT64 | Surrogate primary key |
| brand_id | STRING | Natural key from source system |
| brand_code | STRING | Brand identifier code |
| brand_name | STRING | Display name of brand |
| category | STRING | Product category name |
| category_code | STRING | Category identifier code |
| top_brand | BOOLEAN | Featured brand indicator |

### dim_date
**Purpose:** Comprehensive date attributes for time-based analysis, using 1900-01-01 to 2200-12-31 (109,573 days)
**Type:** Static dimension
| Column | Data Type | Description |
|--------|-----------|-------------|
| date_key | INT64 | Primary key (YYYYMMDD format) |
| full_date | DATE | Complete date value |
| year | INT64 | Year (YYYY) |
| quarter | INT64 | Quarter (1-4) |
| month | INT64 | Month (1-12) |
| month_name | STRING | Month name (January, February, etc.) |
| day_of_month | INT64 | Day of month (1-31) |
| day_of_week | INT64 | Day of week (0=Sunday, 6=Saturday) |
| day_name | STRING | Day name (Sunday, Monday, etc.) |
| is_weekend | BOOLEAN | Weekend indicator |

### dim_receipt_status
**Purpose:** Receipt processing status lookup
**Type:** Static reference dimension
| Column | Data Type | Description |
|--------|-----------|-------------|
| status_key | INT64 | Surrogate primary key |
| status_code | STRING | Status code from source system |
| status_description | STRING | Human-readable status description |


