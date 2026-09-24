USE saas;

-- 1. Overall Product Usage KPIs
SELECT
    COUNT(*) AS total_usage_records,
    COUNT(DISTINCT subscription_id) AS subscriptions_with_usage,
    COUNT(DISTINCT feature_name) AS unique_features,
    SUM(usage_count) AS total_usage_count,
    SUM(usage_duration_secs) AS total_usage_duration_secs,
    SUM(error_count) AS total_errors,
    ROUND(AVG(usage_count), 2) AS avg_usage_per_record
FROM feature_usage;


-- 2. Product Usage by Feature
SELECT
    feature_name,
    COUNT(*) AS usage_records,
    COUNT(DISTINCT subscription_id) AS subscriptions_using_feature,
    SUM(usage_count) AS total_usage,
    SUM(usage_duration_secs) AS total_duration_secs,
    SUM(error_count) AS total_errors,
    ROUND(AVG(usage_count), 2) AS avg_usage_per_record
FROM feature_usage
GROUP BY feature_name
ORDER BY total_usage DESC;


-- 3. Product Usage by Plan Tier
SELECT
    s.plan_tier,
    COUNT(DISTINCT s.subscription_id) AS subscriptions,
    SUM(f.usage_count) AS total_usage,
    SUM(f.usage_duration_secs) AS total_duration_secs,
    SUM(f.error_count) AS total_errors,
    ROUND(AVG(f.usage_count), 2) AS avg_usage_per_record
FROM subscriptions s
JOIN feature_usage f
    ON s.subscription_id = f.subscription_id
GROUP BY s.plan_tier
ORDER BY total_usage DESC;



-- 4. Customer Product Engagement
SELECT
    a.account_id,
    a.account_name,
    a.industry,
    COUNT(DISTINCT s.subscription_id) AS subscription_count,
    COUNT(DISTINCT f.feature_name) AS features_used,
    SUM(f.usage_count) AS total_usage,
    SUM(f.error_count) AS total_errors,
    ROUND(AVG(f.usage_count), 2) AS avg_usage_per_record
FROM accounts a
JOIN subscriptions s
    ON a.account_id = s.account_id
JOIN feature_usage f
    ON s.subscription_id = f.subscription_id
GROUP BY
    a.account_id,
    a.account_name,
    a.industry
ORDER BY total_usage DESC;



-- 5. Feature Error Rate
SELECT
    feature_name,
    SUM(usage_count) AS total_usage,
    SUM(error_count) AS total_errors,
    ROUND(
        SUM(error_count) * 100.0 /
        NULLIF(SUM(usage_count), 0),
        2
    ) AS error_rate_pct
FROM feature_usage
GROUP BY feature_name
ORDER BY error_rate_pct DESC;




-- 6. Beta vs Non-Beta Feature Usage
SELECT
    CASE
        WHEN is_beta_feature = TRUE THEN 'Beta Feature'
        ELSE 'Standard Feature'
    END AS feature_type,
    COUNT(*) AS usage_records,
    COUNT(DISTINCT feature_name) AS unique_features,
    SUM(usage_count) AS total_usage,
    SUM(error_count) AS total_errors,
    ROUND(AVG(usage_count), 2) AS avg_usage_per_record
FROM feature_usage
GROUP BY
    CASE
        WHEN is_beta_feature = TRUE THEN 'Beta Feature'
        ELSE 'Standard Feature'
    END
ORDER BY total_usage DESC;


-- 7. Most Used Features by Plan Tier
WITH feature_plan_usage AS (
    SELECT
        s.plan_tier,
        f.feature_name,
        SUM(f.usage_count) AS total_usage
    FROM subscriptions s
    JOIN feature_usage f
        ON s.subscription_id = f.subscription_id
    GROUP BY
        s.plan_tier,
        f.feature_name
)

SELECT
    plan_tier,
    feature_name,
    total_usage,
    RANK() OVER (
        PARTITION BY plan_tier
        ORDER BY total_usage DESC
    ) AS feature_rank
FROM feature_plan_usage
ORDER BY
    plan_tier,
    feature_rank;



    -- 8. Customer Usage Segmentation
WITH customer_usage AS (
    SELECT
        a.account_id,
        a.account_name,
        a.industry,
        SUM(f.usage_count) AS total_usage
    FROM accounts a
    JOIN subscriptions s
        ON a.account_id = s.account_id
    JOIN feature_usage f
        ON s.subscription_id = f.subscription_id
    GROUP BY
        a.account_id,
        a.account_name,
        a.industry
)

SELECT
    account_id,
    account_name,
    industry,
    total_usage,
    CASE
        WHEN total_usage >= 10000 THEN 'High Usage'
        WHEN total_usage >= 5000 THEN 'Medium Usage'
        ELSE 'Low Usage'
    END AS usage_segment
FROM customer_usage
ORDER BY total_usage DESC;




-- 9. Product Usage by Industry
SELECT
    a.industry,
    COUNT(DISTINCT a.account_id) AS customer_count,
    COUNT(DISTINCT f.feature_name) AS unique_features_used,
    SUM(f.usage_count) AS total_usage,
    SUM(f.error_count) AS total_errors,
    ROUND(AVG(f.usage_count), 2) AS avg_usage_per_record
FROM accounts a
JOIN subscriptions s
    ON a.account_id = s.account_id
JOIN feature_usage f
    ON s.subscription_id = f.subscription_id
GROUP BY a.industry
ORDER BY total_usage DESC;


-- 10. Top Feature by Plan Tier
WITH feature_usage_by_plan AS (
    SELECT
        s.plan_tier,
        f.feature_name,
        SUM(f.usage_count) AS total_usage
    FROM subscriptions s
    JOIN feature_usage f
        ON s.subscription_id = f.subscription_id
    GROUP BY
        s.plan_tier,
        f.feature_name
),
ranked_features AS (
    SELECT
        plan_tier,
        feature_name,
        total_usage,
        ROW_NUMBER() OVER (
            PARTITION BY plan_tier
            ORDER BY total_usage DESC
        ) AS feature_rank
    FROM feature_usage_by_plan
)

SELECT
    plan_tier,
    feature_name,
    total_usage
FROM ranked_features
WHERE feature_rank = 1
ORDER BY plan_tier;