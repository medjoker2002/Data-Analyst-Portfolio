SELECT * FROM lemur.transactions;

WITH RECURSIVE numbered AS (
    SELECT 
        transaction_id,
        merchant_id,
        credit_card_id,
        amount,
        transaction_timestamp,
        ROW_NUMBER() OVER (PARTITION BY merchant_id, credit_card_id, amount 
                           ORDER BY transaction_timestamp ASC) AS rn
    FROM transactions
),
recursive_cte AS 
(
    -- Anchor member: first transaction in each group
    SELECT 
        transaction_id,
        merchant_id,
        credit_card_id,
        amount,
        transaction_timestamp,
        rn,
        CAST('No' AS CHAR(3)) AS duplicate
    FROM numbered
    WHERE rn = 1

    UNION ALL

    -- Recursive member: check next transaction
    SELECT 
        n.transaction_id,
        n.merchant_id,
        n.credit_card_id,
        n.amount,
        n.transaction_timestamp,
        n.rn,
        CASE 
            WHEN r.duplicate = 'No' 
                 AND TIMESTAMPDIFF(MINUTE, r.transaction_timestamp, n.transaction_timestamp) < 10 
            THEN 'Yes' 
            ELSE 'No' 
        END AS duplicate
    FROM recursive_cte r
    JOIN numbered n 
        ON n.merchant_id = r.merchant_id
        AND n.credit_card_id = r.credit_card_id
        AND n.amount = r.amount
        AND n.rn = r.rn + 1
)
SELECT 
    count(*) AS duplicates_count
FROM recursive_cte
WHERE duplicate = "Yes"