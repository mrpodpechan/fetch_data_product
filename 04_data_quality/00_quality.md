# Data Quality Analysis
This document provides comprehensive data quality analysis for the Fetch Rewards analytics database, covering multiple dimensions of data integrity and reliability.

## Overview
Data quality is assessed across three architectural layers:
- **Raw Layer** (`00_raw_json`): Original JSON data preservation
- **Base Layer** (`01_base`): Normalized relational tables
- **Mart Layer** (`02_mart`): Dimensional model for analytics

## Data Quality Dimensions
### 1. Completeness Analysis
**Purpose:** Identify missing data patterns that could impact analytical accuracy.
**Script:** `02_null_checks.sql`
**Key Metrics:**
- Null percentage by table and column
- Critical business fields validation
- Cross-layer completeness comparison

### 2. Referential Integrity
**Purpose:** Ensure proper relationships between tables and identify orphaned records.
**Script:** `03_referential_integrity.sql`
**Key Tests:**
- Orphaned Records Detection
- Duplicate Key Validation
- Cross-Layer Integrity
- Expected Results

### 3. Data Freshness Assessment
**Purpose:** Evaluate data recency and identify potential staleness issues.
**Script:** `04_freshness_checks.sql`
**Freshness Metrics:**
- Receipt Data Recency
- User Registration Patterns
- Monthly Volume Analysis





