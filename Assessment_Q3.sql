SELECT * FROM 
(
    SELECT
        p.id AS plan_id,
        sa.owner_id,
        CASE 
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            WHEN p.is_a_fund = 1 THEN 'Investment'
            ELSE 'Other'
        END AS type,
        MAX(sa.transaction_date) AS last_transaction_date,
        DATEDIFF(CURDATE(), MAX(sa.transaction_date)) AS inactivity_days
    FROM savings_savingsaccount sa
    JOIN plans_plan p ON sa.plan_id = p.id
    WHERE sa.confirmed_amount > 0
    GROUP BY p.id, sa.owner_id, type
) s
WHERE inactivity_days > 365
ORDER BY inactivity_days DESC;
