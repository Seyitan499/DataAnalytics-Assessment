SELECT 
    customer_id,
    customer_data.name,
    tenure_months,
    total_transactions,
    ROUND(((total_transaction_value * 0.001) / tenure_months) * 12, 2) AS estimated_clv
FROM (
    SELECT 
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
        COUNT(sa.id) AS total_transactions,
        SUM(sa.confirmed_amount) AS total_transaction_value
    FROM users_customuser u
    JOIN savings_savingsaccount sa ON sa.owner_id = u.id
    WHERE sa.confirmed_amount > 0
    GROUP BY u.id, u.name, tenure_months
) AS customer_data
WHERE tenure_months > 0
ORDER BY estimated_clv DESC;