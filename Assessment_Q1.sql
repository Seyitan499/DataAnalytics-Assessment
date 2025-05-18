SELECT
    uc.id AS owner_id,
    CONCAT(uc.first_name, ' ', uc.last_name) AS name,
    s.savings_count,
    i.investment_count,
    ROUND(s.total_savings + i.total_investments, 2) AS total_deposits
    FROM
        (
            SELECT
                sa.owner_id,
                COUNT(*) AS savings_count,
                SUM(sa.confirmed_amount) AS total_savings
            FROM savings_savingsaccount sa
            JOIN plans_plan p ON sa.plan_id = p.id
            WHERE p.is_regular_savings = 1
            AND sa.confirmed_amount > 0
            GROUP BY sa.owner_id
        ) s
    JOIN
        (
            SELECT
                sa.owner_id,
                COUNT(*) AS investment_count,
                SUM(sa.confirmed_amount) AS total_investments
            FROM savings_savingsaccount sa
            JOIN plans_plan p ON sa.plan_id = p.id
            WHERE p.is_a_fund = 1
            AND sa.confirmed_amount > 0
            GROUP BY sa.owner_id
        ) i ON s.owner_id = i.owner_id
    JOIN users_customuser uc ON uc.id = s.owner_id
    ORDER BY total_deposits DESC;


