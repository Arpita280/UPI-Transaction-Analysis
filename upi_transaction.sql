create database upi_txn;
use upi_txn;

CREATE TABLE upi_trans (
    transaction_id VARCHAR(20),
    transaction_time DATETIME,
    transaction_type VARCHAR(20),
    merchant_category VARCHAR(20),
    amount DECIMAL(10 , 2 ),
    transaction_status VARCHAR(15),
    sender_age_group VARCHAR(10),
    receiver_age_group VARCHAR(10),
    sender_state VARCHAR(20),
    sender_bank VARCHAR(15),
    receiver_bank VARCHAR(15),
    device_type VARCHAR(15),
    network_type VARCHAR(15),
    fraud_flag INT,
    hour_of_day INT,
    day_of_week VARCHAR(10),
    is_weekend INT
);

SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

LOAD DATA LOCAL INFILE "C:/data analystresource/Portfolio-data analyst/upi_transaction_2024/upi_transactions_2024.csv"
INTO TABLE upi_trans
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


SELECT 
    *
FROM
    upi_trans;

-- total number of transaction
SELECT 
    COUNT(*) AS total_transactions
FROM
    upi_trans;

-- range of transaction date
SELECT 
    MIN(transaction_time) AS Start_date,
    MAX(transaction_time) AS End_date
FROM
    upi_trans;

-- summary statistics of transaction amount
SELECT 
    MIN(amount) AS min_amount,
    MAX(amount) AS max_amount,
    AVG(amount) AS avg_amount
FROM
    upi_trans;

-- Transactions by status (SUCCESS/FAILED)
SELECT 
    transaction_status, COUNT(*) AS count_trans, round( count(*) * 100 / sum(count(*)) over(), 2 ) as percentage_share
FROM
    upi_trans
GROUP BY 1
ORDER BY 2;

-- top 10 highest transaction amount by merchant category
SELECT 
    transaction_id, merchant_category, sender_state, amount
FROM
    upi_trans
ORDER BY amount DESC
LIMIT 10;

-- Monthly trend of transactions
SELECT 
    DATE_FORMAT(transaction_time, '%Y-%m') AS month,
    COUNT(*) AS trans_count,
    SUM(amount) AS total_amount
FROM
    upi_trans
GROUP BY 1
ORDER BY FIELD(month,
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December');

-- Hourly transaction pattern
SELECT 
    hour_of_day,
    COUNT(*) AS total_transaction,
    SUM(amount) AS total_amount,
    AVG(amount) AS avg_amount
FROM
    upi_trans
GROUP BY 1
ORDER BY 1;

-- Weekday Transaction pattern 
SELECT 
    day_of_week,
    COUNT(*) AS total_transaction,
    SUM(amount) AS total_amount,
    AVG(amount) AS avg_amount
FROM
    upi_trans
GROUP BY 1
ORDER BY FIELD(day_of_week,
        'Sunday',
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday');

-- weekday vs weekend transaction
SELECT 
    CASE
        WHEN is_weekend = 1 THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(*) AS trans_count,
    SUM(amount) AS total_amount
FROM
    upi_trans
GROUP BY is_weekend;

-- percentage contribution
SELECT
    CASE 
        WHEN is_weekend = 1 THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(*) AS trans_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_share
FROM upi_trans
GROUP BY is_weekend;

-- top transaction type
SELECT 
    transaction_type, SUM(amount) AS total_amount
FROM
    upi_trans
GROUP BY 1
ORDER BY 2 DESC;

-- transactions by merchant category
SELECT 
    merchant_category, SUM(amount) AS total_amount
FROM
    upi_trans
GROUP BY 1
ORDER BY 2 DESC;

-- Average transaction amount by merchant category
SELECT 
    merchant_category, AVG(amount) AS avg_amount
FROM
    upi_trans
GROUP BY 1
ORDER BY 2 DESC;

-- Count of fraudulent vs legitimate transactions
SELECT 
    fraud_flag, COUNT(*) AS trans_count
FROM
    upi_trans
GROUP BY 1;

-- Fraud rate by transaction type
SELECT 
    transaction_type,
    SUM(fraud_flag) AS fraud_count,
    COUNT(*) AS total_count,
    SUM(fraud_flag) / COUNT(*) * 100 AS fraud_rate_pct
FROM
    upi_trans
GROUP BY 1
ORDER BY 4 DESC;

-- Transactions by device type
SELECT 
    device_type, COUNT(*) AS trans_count
FROM
    upi_trans
GROUP BY 1
ORDER BY 2 DESC;

-- Failed transactions by hour of day
SELECT 
    hour_of_day, COUNT(*) AS failed_count
FROM
    upi_trans
WHERE
    transaction_status = 'FAILED'
GROUP BY 1
ORDER BY 2 DESC;

-- Top 5 fraud prone state
SELECT 
    sender_state,
    COUNT(*) AS fraud_flag,
    SUM(amount) AS fraud_amount
FROM
    upi_trans
WHERE
    fraud_flag = 1
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Identified top states with highest weekend UPI usage
SELECT 
    sender_state,
    COUNT(*) AS weekend_transactions,
    SUM(amount) AS weekend_amount
FROM
    upi_trans
WHERE
    is_weekend = 1
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- top most prefered merchant category per age group
WITH age_category_stats AS (
    SELECT
        sender_age_group,
        merchant_category,
        COUNT(*) AS transaction_count,
        SUM(amount) AS total_amount,
        ROW_NUMBER() OVER (
            PARTITION BY sender_age_group
            ORDER BY COUNT(*) DESC
        ) AS rn
    FROM upi_trans
    GROUP BY sender_age_group, merchant_category
)

SELECT
    sender_age_group,
    merchant_category AS most_preferred_category,
    transaction_count,
    total_amount
    
FROM age_category_stats
WHERE rn = 1
ORDER BY sender_age_group;

-- top transaction type per age group
WITH age_txn_type AS (
    SELECT
        sender_age_group,
        transaction_type,
        COUNT(*) AS transaction_count,
        ROW_NUMBER() OVER (
            PARTITION BY sender_age_group
            ORDER BY COUNT(*) DESC
        ) AS rn
    FROM upi_trans
    GROUP BY sender_age_group, transaction_type
)

SELECT
    sender_age_group,
    transaction_type AS most_used_transaction_type,
    transaction_count
FROM age_txn_type
WHERE rn = 1
ORDER BY sender_age_group;

-- fraud prone age group
SELECT
    sender_age_group,
    COUNT(*) AS fraud_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS fraud_percentage
FROM upi_trans
WHERE fraud_flag = 1
GROUP BY sender_age_group
ORDER BY fraud_count DESC;

-- Sender Bank vs Fraud (Risky banks)
SELECT 
    sender_bank,
    COUNT(*) AS fraud_cases,
    SUM(amount) AS fraud_amount
FROM
    upi_trans
WHERE
    fraud_flag = 1
GROUP BY sender_bank
ORDER BY fraud_cases DESC;


