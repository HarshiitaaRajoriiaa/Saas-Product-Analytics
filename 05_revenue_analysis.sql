USE saas;

-- 1. Overall Revenue KPIs
SELECT
    SUM(mrr_amount) AS total_mrr,
    SUM(arr_amount) AS total_arr,
    ROUND(AVG(mrr_amount), 2) AS avg_mrr_per_subscription,
    ROUND(AVG(arr_amount), 2) AS avg_arr_per_subscription,
    MAX(mrr_amount) AS highest_subscription_mrr
FROM subscriptions;


-- 2. Revenue by Plan Tier
SELECT
    plan_tier,
    COUNT(*) AS subscription_count,
    SUM(mrr_amount) AS total_mrr,
    SUM(arr_amount) AS total_arr,
    ROUND(AVG(mrr_amount), 2) AS avg_mrr
FROM subscriptions
GROUP BY plan_tier
ORDER BY total_mrr DESC;



-- 3. Top 10 Customers by Revenue
SELECT
    a.account_id,
    a.account_name,
    a.industry,
    a.plan_tier,
    SUM(s.mrr_amount) AS total_mrr,
    SUM(s.arr_amount) AS total_arr
FROM accounts a
JOIN subscriptions s
    ON a.account_id = s.account_id
GROUP BY
    a.account_id,
    a.account_name,
    a.industry,
    a.plan_tier
ORDER BY total_mrr DESC
LIMIT 10;



-- 4. Revenue Contribution by Industry
WITH industry_revenue AS (
    SELECT
        a.industry,
        SUM(s.mrr_amount) AS industry_mrr
    FROM accounts a
    JOIN subscriptions s
        ON a.account_id = s.account_id
    GROUP BY a.industry
)

SELECT
    industry,
    industry_mrr,
    ROUND(
        industry_mrr * 100.0 /
        SUM(industry_mrr) OVER (),
        2
    ) AS revenue_contribution_pct
FROM industry_revenue
ORDER BY industry_mrr DESC;



-- 5. Monthly Revenue Trend
SELECT
    DATE_FORMAT(start_date, '%Y-%m') AS revenue_month,
    SUM(mrr_amount) AS total_mrr,
    SUM(arr_amount) AS total_arr,
    COUNT(DISTINCT account_id) AS active_customers
FROM subscriptions
GROUP BY DATE_FORMAT(start_date, '%Y-%m')
ORDER BY revenue_month;



-- 6. Monthly Revenue Growth
WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(start_date, '%Y-%m') AS revenue_month,
        SUM(mrr_amount) AS total_mrr
    FROM subscriptions
    GROUP BY DATE_FORMAT(start_date, '%Y-%m')
)

SELECT
    revenue_month,
    total_mrr,
    LAG(total_mrr) OVER (ORDER BY revenue_month) AS previous_month_mrr,
    ROUND(
        (total_mrr - LAG(total_mrr) OVER (ORDER BY revenue_month))
        * 100.0 /
        NULLIF(LAG(total_mrr) OVER (ORDER BY revenue_month), 0),
        2
    ) AS mom_growth_pct
FROM monthly_revenue
ORDER BY revenue_month;




-- 7. Customer Revenue Concentration
WITH customer_revenue AS (
    SELECT
        a.account_id,
        a.account_name,
        SUM(s.mrr_amount) AS total_mrr
    FROM accounts a
    JOIN subscriptions s
        ON a.account_id = s.account_id
    GROUP BY
        a.account_id,
        a.account_name
)

SELECT
    account_id,
    account_name,
    total_mrr,
    ROUND(
        total_mrr * 100.0 /
        SUM(total_mrr) OVER (),
        2
    ) AS revenue_share_pct,
    ROUND(
        SUM(total_mrr) OVER (
            ORDER BY total_mrr DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) * 100.0 /
        SUM(total_mrr) OVER (),
        2
    ) AS cumulative_revenue_pct
FROM customer_revenue
ORDER BY total_mrr DESC;



-- 8. Revenue by Billing Frequency
SELECT
    billing_frequency,
    COUNT(*) AS subscription_count,
    SUM(mrr_amount) AS total_mrr,
    SUM(arr_amount) AS total_arr,
    ROUND(AVG(mrr_amount), 2) AS avg_mrr
FROM subscriptions
GROUP BY billing_frequency
ORDER BY total_mrr DESC;