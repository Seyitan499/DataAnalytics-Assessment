SELECT
    frequency_category,
    COUNT(owner_id) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 2) AS avg_transactions_per_month
FROM (
    SELECT
        owner_id,
        avg_transactions_per_month,
        CASE
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM (
        SELECT
            owner_id,
            AVG(transactions_per_month) AS avg_transactions_per_month
        FROM (
            SELECT
                sa.owner_id,
                DATE_FORMAT(sa.transaction_date, '%Y-%m') AS txn_month,
                COUNT(*) AS transactions_per_month
            FROM savings_savingsaccount sa
            GROUP BY sa.owner_id, txn_month
        ) monthly
        GROUP BY owner_id
    ) avg_txn
) categorized
GROUP BY frequency_category
ORDER BY 
    CASE frequency_category
        WHEN 'High Frequency' THEN 1
        WHEN 'Medium Frequency' THEN 2
        WHEN 'Low Frequency' THEN 3
    END;

