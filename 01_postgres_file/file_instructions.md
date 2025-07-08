# Database Setup Instructions
This repository contains a PostgreSQL database setup for the Fetch Rewards assessment.

## Prerequisites
- PostgreSQL 12+ installed locally (backed up with PostgreSQL 17.5)
- pgAdmin 4 (recommended) or any PostgreSQL client (DBeaver, etc.)

## Database File
The database is provided as a compressed backup file:
- **File:** `fetch_rewards_db_full.sql.gz`
- **Type:** PostgreSQL custom backup format
- **Size:** Contains full schema and sample data

## Setup Instructions
### Step 1: Create Database
1. **Open pgAdmin 4**
2. **Connect to your PostgreSQL server**
3. **Create a new database:**
  - Right-click "Databases" → Create → Database
  - **Database name:** `fetch_rewards_analytics`
  - Click "Save"

### Step 2: Restore Database
1. **Right-click the new database** `fetch_rewards_analytics`
2. **Select "Restore..."**
3. **Configure restore settings:**
  - **Format:** Custom or tar
  - **Filename:** Browse and select `fetch_rewards_db_full.sql.gz`
  - **Role name:** postgres (or your admin user)
4. **Click "Restore"**
5. **Wait for completion** (should take 1-2 minutes)

