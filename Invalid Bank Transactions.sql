-- ======================================================================
-- Invalid Bank Transactions
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Chase, JP Morgan, Bloomberg
-- Access     : Premium
-- ID         : 2143
-- URL        : https://platform.stratascratch.com/coding/2143-invalid-bank-transactions
-- ======================================================================

/*
Bank of Ireland has requested that you detect invalid transactions in December 2022.

An invalid transaction is one that occurs outside of the bank's normal business hours.

The following are the hours of operation for all branches:




Monday - Friday 09:00 - 16:00

Saturday & Sunday Closed

Irish Public Holidays 25th and 26th December




Determine the transaction ids of all invalid transactions.
*/

-- Tables:
--   boi_transactions(time_stamp timestamp without time zone, transaction_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Assumes table: transactions(transaction_id, transaction_date, transaction_time)
-- transaction_date is DATE type, transaction_time is TIME type

WITH business_hours AS (
    SELECT
        transaction_id,
        transaction_date,
        transaction_time,
        EXTRACT(DOW FROM transaction_date) AS day_of_week, -- 0=Sun, 6=Sat
        transaction_time >= '09:00:00' AND transaction_time < '16:00:00' AS within_hours
    FROM transactions
    WHERE EXTRACT(MONTH FROM transaction_date) = 12
      AND EXTRACT(YEAR  FROM transaction_date) = 2022
)
SELECT transaction_id
FROM business_hours
WHERE
    -- Weekend (Saturday=6, Sunday=0)
    day_of_week IN (0, 6)
    OR
    -- Irish Public Holidays: 25th and 26th December
    EXTRACT(DAY FROM transaction_date) IN (25, 26)
    OR
    -- Outside business hours on a weekday (Mon-Fri, not a public holiday)
    (
        day_of_week NOT IN (0, 6)
        AND EXTRACT(DAY FROM transaction_date) NOT IN (25, 26)
        AND NOT within_hours
    );

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT transaction_id
FROM transactions
WHERE
    EXTRACT(MONTH FROM transaction_date) = 12
    AND EXTRACT(YEAR  FROM transaction_date) = 2022
    AND (
        -- Transaction falls on a weekend
        EXTRACT(DOW FROM transaction_date) IN (0, 6)

        OR

        -- Transaction falls on a public holiday (25th or 26th Dec)
        EXTRACT(DAY FROM transaction_date) IN (25, 26)

        OR

        -- Transaction is on a valid weekday but outside 09:00–16:00
        (
            EXTRACT(DOW FROM transaction_date) NOT IN (0, 6)
            AND EXTRACT(DAY FROM transaction_date) NOT IN (25, 26)
            AND (
                transaction_time < '09:00:00'
                OR transaction_time >= '16:00:00'
            )
        )
    );
