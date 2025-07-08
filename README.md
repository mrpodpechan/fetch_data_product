# Fetch Data Products Take Home Assessment Repository
This repository is in service towards the technical assessment demonstrating data modeling, SQL proficiency, and data quality analysis skills. 
This project contains files that will unstructured JSON data into a structured relational data model, answer business questions through SQL queries, 
and identify data quality issues within the available data.

The chosen SQL dialect for this project is PostgreSQL.

## Key Components:
* PostgreSQL database file (see [DB Backup File](01_postgres_file/fetch_rewards_db_full.sql.gz))
* Relational database design and ERD modeling files (see [ERD Diagram Rewards Mart](03_erd_diagrams/Fetch_ERD.pdf.png))
* SQL queries used to answer the questions found deeper in this README (see below)
* SQL queries used to assess data quality (see [Quality Queries](04_data_quality/00_quality.md))
* Example stakeholder communication for technical findings (see [Stakeholder Comms](05_stakeholder_responses/stakeholder.md))

## Write queries that directly answer predetermined questions from a business stakeholder:
* What are the top 5 brands by receipts scanned for most recent month? [Top 5 Brands Query](/06_queries/00_top_5_by_receipts.md)
* How does the ranking of the top 5 brands by receipts scanned for the recent month compare to the ranking for the previous month? [Top 5 Brands Query By Receipt](/06_queries/01_top_5_brand_rank.md)
* When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater? [Average Spend](/06_queries/02_average_spend.md)
* When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater? [Total Items Purchased](/06_queries/03_total_items_purchased.md)
* Which brand has the most spend among users who were created within the past 6 months? [Brand Spend Ranking](/06_queries/04_brand_by_spend.md)
* Which brand has the most transactions among users who were created within the past 6 months? [Brand Transaction Ranking](/06_queries/05_top_brand_by_transaction.md)
  
## Communicate with Stakeholders
[Link to Email Comms](/05_stakeholder_comms/stakeholder.md)
* What questions do you have about the data?
* How did you discover the data quality issues?
* What do you need to know to resolve the data quality issues?
* What other information would you need to help you optimize the data assets you're trying to create?
* What performance and scaling concerns do you anticipate in production and how do you plan to address them?
