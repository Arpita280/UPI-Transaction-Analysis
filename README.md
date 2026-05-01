# UPI-Transaction-Analysis
Analyzed 250K UPI transactions from 2024 to uncover user behavior, spending trends, peak hours, merchant category patterns, and fraud hotspots. Built 22+ SQL queries (CTEs, window functions) and a 3‑page Power BI dashboard covering Overview, Behavior, and Fraud Analysis.
---
## Project Overview
This project analyzes 250K UPI transactions from 2024 to understand:
User behavior across age groups, states, devices, and networks
Spending patterns across merchant categories
Fraud detection insights
Transaction performance (success, failure, peak hours, weekends)
High‑risk states, banks, and transaction types
The analysis was performed using SQL, and insights were visualized using a multi‑page Power BI dashboard.
--
## Dataset Structure
The dataset contains the following fields:
transaction_id, timestamp, transaction_type, merchant_category
amount, transaction_status, fraud_flag
sender_age_group, receiver_age_group
sender_state, sender_bank, receiver_bank
device_type, network_type
hour_of_day, day_of_week, is_weekend
--
## Tech Stack
SQL (MySQL) – Data cleaning, transformation, and analysis
Power BI – Dashboard creation
Excel – Initial data checks

## Key Insights
#### 1. Transaction Performance
Total transactions: 250K
Total amount processed: ₹328M
Average transaction value: ₹1.31K
Failure rate: 4.95%
Fraud rate: 0.19%

#### 2. Behavioral Insights
Peak activity: 6 PM – 10 PM
Weekends contribute higher transaction volume
Most used transaction type: P2P
Most preferred merchant category: Grocery (across all age groups)
Mobile devices dominate UPI usage (~75%)

#### 3. Fraud Insights
Fraud‑prone states: Maharashtra, Karnataka, Uttar Pradesh
Highest fraud age group: 26–35
Fraud‑prone banks: SBI, ICICI, HDFC
Highest fraud categories: Recharge & Bill Payments

## SQL Analysis
The project includes 22+ SQL queries covering:
Summary statistics
Monthly, hourly, weekday trends
Merchant category analysis
Device & network analysis
Fraud detection
Age‑group behavior
Weekend vs weekday contribution
Top states, banks, categories

All SQL queries are included in the repository.

## Power BI Dashboard
The dashboard contains 3 pages:

#### 1. Overview
KPIs
Monthly trend
Hourly trend
Transaction type analysis
Weekend vs weekday contribution

#### 2. Behavior Analysis
Merchant category breakdown
Device & network insights
Age‑group spending patterns
Preferred categories per age group

#### 3. Fraud Analysis
Fraud by state
Fraud by bank
Fraud by age group
Fraud by transaction type
Hourly failure pattern

## Repository Structure
📦 UPI-Transaction-Analysis
 ┣ 📄 upi_sql_solution.sql
 ┣ 📄 dashboard.pbix
 ┣ 📄 README.md
 ┗ 📁 dataset

## Key Outcomes
This project demonstrates:
Real‑world fintech analytics
Fraud detection logic
Advanced SQL (CTEs, window functions, aggregations)
Professional dashboard storytelling
End‑to‑end data analysis workflow
