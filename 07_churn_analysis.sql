USE saas;

-- 1. Overall Churn KPIs
SELECT
    COUNT(DISTINCT account_id) AS customers_with_churn_events,
    COUNT(*) AS total_churn_events,
    COUNT(DISTINCT CASE
        WHEN is_reactivation = TRUE THEN account_id
    END) AS reactivated_customers,
    SUM(refund_amount_usd) AS total_refunds,
    ROUND(AVG(refund_amount_usd), 2) AS avg_refund_amount
FROM churn_events;



-- 2. Churn Analysis by Industry
SELECT
    a.industry,
    COUNT(DISTINCT a.account_id) AS total_customers,
    COUNT(DISTINCT CASE
        WHEN a.churn_flag = TRUE THEN a.account_id
    END) AS churned_customers,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN a.churn_flag = TRUE THEN a.account_id
        END) * 100.0 /
        NULLIF(COUNT(DISTINCT a.account_id), 0),
        2
    ) AS churn_rate_pct
FROM accounts a
GROUP BY a.industry
ORDER BY churn_rate_pct DESC;



-- 3. Churn Analysis by Plan Tier
SELECT
    plan_tier,
    COUNT(*) AS total_customers,
    SUM(CASE
        WHEN churn_flag = TRUE THEN 1
        ELSE 0
    END) AS churned_customers,
    ROUND(
        SUM(CASE
            WHEN churn_flag = TRUE THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_pct
FROM accounts
GROUP BY plan_tier
ORDER BY churn_rate_pct DESC;



-- 4. Churn Analysis by Reason
SELECT
    reason_code,
    COUNT(*) AS churn_events,
    COUNT(DISTINCT account_id) AS affected_customers,
    SUM(refund_amount_usd) AS total_refunds,
    ROUND(AVG(refund_amount_usd), 2) AS avg_refund
FROM churn_events
GROUP BY reason_code
ORDER BY churn_events DESC;



-- 5. Churn Events Following Upgrade or Downgrade
SELECT
    CASE
        WHEN preceding_upgrade_flag = TRUE THEN 'After Upgrade'
        WHEN preceding_downgrade_flag = TRUE THEN 'After Downgrade'
        ELSE 'No Recent Plan Change'
    END AS preceding_plan_change,
    COUNT(*) AS churn_events,
    COUNT(DISTINCT account_id) AS affected_customers,
    SUM(refund_amount_usd) AS total_refunds
FROM churn_events
GROUP BY
    CASE
        WHEN preceding_upgrade_flag = TRUE THEN 'After Upgrade'
        WHEN preceding_downgrade_flag = TRUE THEN 'After Downgrade'
        ELSE 'No Recent Plan Change'
    END
ORDER BY churn_events DESC;



-- 6. Churn and Product Usage Relationship
WITH customer_usage AS (
    SELECT
        s.account_id,
        SUM(f.usage_count) AS total_usage,
        COUNT(DISTINCT f.feature_name) AS features_used
    FROM subscriptions s
    JOIN feature_usage f
        ON s.subscription_id = f.subscription_id
    GROUP BY s.account_id
)

SELECT
    a.churn_flag,
    COUNT(DISTINCT a.account_id) AS customer_count,
    ROUND(AVG(cu.total_usage), 2) AS avg_total_usage,
    ROUND(AVG(cu.features_used), 2) AS avg_features_used
FROM accounts a
LEFT JOIN customer_usage cu
    ON a.account_id = cu.account_id
GROUP BY a.churn_flag;



-- 7. Churn and Revenue Relationship
WITH customer_revenue AS (
    SELECT
        account_id,
        SUM(mrr_amount) AS total_mrr,
        SUM(arr_amount) AS total_arr
    FROM subscriptions
    GROUP BY account_id
)

SELECT
    a.churn_flag,
    COUNT(DISTINCT a.account_id) AS customer_count,
    ROUND(AVG(cr.total_mrr), 2) AS avg_mrr,
    ROUND(AVG(cr.total_arr), 2) AS avg_arr,
    ROUND(SUM(cr.total_mrr), 2) AS total_mrr
FROM accounts a
LEFT JOIN customer_revenue cr
    ON a.account_id = cr.account_id
GROUP BY a.churn_flag;



-- 8. Industry Churn Ranking
WITH industry_churn AS (
    SELECT
        industry,
        COUNT(*) AS total_customers,
        SUM(CASE WHEN churn_flag = TRUE THEN 1 ELSE 0 END) AS churned_customers
    FROM accounts
    GROUP BY industry
)

SELECT
    industry,
    total_customers,
    churned_customers,
    ROUND(
        churned_customers * 100.0 / total_customers,
        2
    ) AS churn_rate_pct,
    RANK() OVER (
        ORDER BY churned_customers * 100.0 / total_customers DESC
    ) AS churn_rate_rank
FROM industry_churn
ORDER BY churn_rate_rank;


-- 9. Churn by Customer Revenue Segment
WITH customer_revenue AS (
    SELECT
        a.account_id,
        a.account_name,
        a.churn_flag,
        SUM(s.mrr_amount) AS total_mrr
    FROM accounts a
    LEFT JOIN subscriptions s
        ON a.account_id = s.account_id
    GROUP BY
        a.account_id,
        a.account_name,
        a.churn_flag
),
customer_segments AS (
    SELECT
        *,
        CASE
            WHEN total_mrr >= 50000 THEN 'High Value'
            WHEN total_mrr >= 20000 THEN 'Mid Value'
            ELSE 'Low Value'
        END AS revenue_segment
    FROM customer_revenue
)

SELECT
    revenue_segment,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn_flag = TRUE THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN churn_flag = TRUE THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS churn_rate_pct
FROM customer_segments
GROUP BY revenue_segment
ORDER BY churn_rate_pct DESC;



-- 10. Monthly Churn Event Trend
SELECT
    DATE_FORMAT(churn_date, '%Y-%m') AS churn_month,
    COUNT(*) AS churn_events,
    COUNT(DISTINCT account_id) AS affected_customers,
    SUM(refund_amount_usd) AS total_refunds
FROM churn_events
GROUP BY DATE_FORMAT(churn_date, '%Y-%m')
ORDER BY churn_month;