USE saas;

-- 1. Customer Overview
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn_flag = TRUE THEN 1 ELSE 0 END) AS churned_customers,
    SUM(CASE WHEN churn_flag = FALSE THEN 1 ELSE 0 END) AS active_customers,
    ROUND(AVG(seats), 2) AS avg_seats_per_customer
FROM accounts;




-- 2. Customer Revenue Analysis
SELECT
    a.account_id,
    a.account_name,
    a.industry,
    a.plan_tier,
    COUNT(s.subscription_id) AS subscription_count,
    SUM(s.mrr_amount) AS total_mrr,
    SUM(s.arr_amount) AS total_arr
FROM accounts a
LEFT JOIN subscriptions s
    ON a.account_id = s.account_id
GROUP BY
    a.account_id,
    a.account_name,
    a.industry,
    a.plan_tier
ORDER BY total_mrr DESC;



-- 3. Customer Segmentation
WITH customer_metrics AS (
    SELECT
        a.account_id,
        a.account_name,
        a.industry,
        a.plan_tier,
        SUM(s.mrr_amount) AS total_mrr,
        SUM(s.seats) AS total_seats
    FROM accounts a
    LEFT JOIN subscriptions s
        ON a.account_id = s.account_id
    GROUP BY
        a.account_id,
        a.account_name,
        a.industry,
        a.plan_tier
)

SELECT
    account_id,
    account_name,
    industry,
    plan_tier,
    total_mrr,
    total_seats,
    CASE
        WHEN total_mrr >= 50000 THEN 'High Value'
        WHEN total_mrr >= 20000 THEN 'Mid Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM customer_metrics
ORDER BY total_mrr DESC;



-- 4. Customer Revenue Ranking
WITH customer_revenue AS (
    SELECT
        a.account_id,
        a.account_name,
        a.industry,
        SUM(s.mrr_amount) AS total_mrr
    FROM accounts a
    JOIN subscriptions s
        ON a.account_id = s.account_id
    GROUP BY
        a.account_id,
        a.account_name,
        a.industry
)

SELECT
    account_id,
    account_name,
    industry,
    total_mrr,
    RANK() OVER (ORDER BY total_mrr DESC) AS revenue_rank
FROM customer_revenue
ORDER BY revenue_rank;



-- 5. Customer Analysis by Industry
SELECT
    a.industry,
    COUNT(DISTINCT a.account_id) AS customer_count,
    SUM(s.mrr_amount) AS total_mrr,
    ROUND(AVG(s.mrr_amount), 2) AS avg_mrr_per_subscription,
    ROUND(AVG(a.seats), 2) AS avg_seats
FROM accounts a
LEFT JOIN subscriptions s
    ON a.account_id = s.account_id
GROUP BY a.industry
ORDER BY total_mrr DESC;



-- 6. Customer Analysis by Plan Tier
SELECT
    a.plan_tier,
    COUNT(DISTINCT a.account_id) AS customer_count,
    COUNT(s.subscription_id) AS subscription_count,
    SUM(s.mrr_amount) AS total_mrr,
    SUM(s.arr_amount) AS total_arr,
    ROUND(AVG(a.seats), 2) AS avg_seats
FROM accounts a
LEFT JOIN subscriptions s
    ON a.account_id = s.account_id
GROUP BY a.plan_tier
ORDER BY total_mrr DESC;