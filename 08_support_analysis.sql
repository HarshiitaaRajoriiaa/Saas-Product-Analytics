USE saas;

-- =========================================================
-- SUPPORT & CUSTOMER EXPERIENCE ANALYSIS
-- =========================================================


-- 1. Overall Support KPIs
SELECT
    COUNT(*) AS total_tickets,
    COUNT(DISTINCT account_id) AS customers_with_tickets,
    ROUND(AVG(resolution_time_hours), 2) AS avg_resolution_time_hours,
    ROUND(AVG(first_response_time_minutes), 2) AS avg_first_response_minutes,
    ROUND(AVG(satisfaction_score), 2) AS avg_satisfaction_score,
    SUM(CASE WHEN escalation_flag = TRUE THEN 1 ELSE 0 END) AS escalated_tickets
FROM support_tickets;


-- 2. Support Tickets by Priority
SELECT
    priority,
    COUNT(*) AS ticket_count,
    ROUND(AVG(resolution_time_hours), 2) AS avg_resolution_time_hours,
    ROUND(AVG(first_response_time_minutes), 2) AS avg_first_response_minutes,
    ROUND(AVG(satisfaction_score), 2) AS avg_satisfaction_score,
    SUM(CASE WHEN escalation_flag = TRUE THEN 1 ELSE 0 END) AS escalated_tickets
FROM support_tickets
GROUP BY priority
ORDER BY ticket_count DESC;


-- 3. Support Performance by Industry
SELECT
    a.industry,
    COUNT(s.ticket_id) AS ticket_count,
    COUNT(DISTINCT s.account_id) AS customers_with_tickets,
    ROUND(AVG(s.resolution_time_hours), 2) AS avg_resolution_time_hours,
    ROUND(AVG(s.first_response_time_minutes), 2) AS avg_first_response_minutes,
    ROUND(AVG(s.satisfaction_score), 2) AS avg_satisfaction_score,
    SUM(CASE WHEN s.escalation_flag = TRUE THEN 1 ELSE 0 END) AS escalated_tickets
FROM accounts a
JOIN support_tickets s
    ON a.account_id = s.account_id
GROUP BY a.industry
ORDER BY ticket_count DESC;


-- 4. Customer Support Profile
SELECT
    a.account_id,
    a.account_name,
    a.industry,
    a.plan_tier,
    COUNT(s.ticket_id) AS ticket_count,
    ROUND(AVG(s.resolution_time_hours), 2) AS avg_resolution_time_hours,
    ROUND(AVG(s.first_response_time_minutes), 2) AS avg_first_response_minutes,
    ROUND(AVG(s.satisfaction_score), 2) AS avg_satisfaction_score,
    SUM(CASE WHEN s.escalation_flag = TRUE THEN 1 ELSE 0 END) AS escalated_tickets
FROM accounts a
LEFT JOIN support_tickets s
    ON a.account_id = s.account_id
GROUP BY
    a.account_id,
    a.account_name,
    a.industry,
    a.plan_tier
ORDER BY ticket_count DESC;


-- 5. Support Escalation Analysis
SELECT
    CASE
        WHEN escalation_flag = TRUE THEN 'Escalated'
        ELSE 'Not Escalated'
    END AS escalation_status,
    COUNT(*) AS ticket_count,
    ROUND(AVG(resolution_time_hours), 2) AS avg_resolution_time_hours,
    ROUND(AVG(first_response_time_minutes), 2) AS avg_first_response_minutes,
    ROUND(AVG(satisfaction_score), 2) AS avg_satisfaction_score
FROM support_tickets
GROUP BY
    CASE
        WHEN escalation_flag = TRUE THEN 'Escalated'
        ELSE 'Not Escalated'
    END
ORDER BY ticket_count DESC;


-- 6. Support Volume Segmentation
WITH customer_support AS (
    SELECT
        a.account_id,
        a.account_name,
        a.industry,
        COUNT(s.ticket_id) AS ticket_count,
        ROUND(AVG(s.satisfaction_score), 2) AS avg_satisfaction_score
    FROM accounts a
    LEFT JOIN support_tickets s
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
    ticket_count,
    avg_satisfaction_score,
    CASE
        WHEN ticket_count >= 8 THEN 'High Support Volume'
        WHEN ticket_count >= 4 THEN 'Medium Support Volume'
        WHEN ticket_count > 0 THEN 'Low Support Volume'
        ELSE 'No Support Tickets'
    END AS support_volume_segment
FROM customer_support
ORDER BY ticket_count DESC;


-- 7. Support Experience by Churn Status
SELECT
    a.churn_flag,
    COUNT(DISTINCT a.account_id) AS customer_count,
    COUNT(s.ticket_id) AS ticket_count,
    ROUND(AVG(s.resolution_time_hours), 2) AS avg_resolution_time_hours,
    ROUND(AVG(s.first_response_time_minutes), 2) AS avg_first_response_minutes,
    ROUND(AVG(s.satisfaction_score), 2) AS avg_satisfaction_score,
    ROUND(
        AVG(
            CASE
                WHEN s.escalation_flag = TRUE THEN 1.0
                ELSE 0.0
            END
        ) * 100,
        2
    ) AS escalation_rate_pct
FROM accounts a
LEFT JOIN support_tickets s
    ON a.account_id = s.account_id
GROUP BY a.churn_flag;


-- 8. Customer Support Ranking by Ticket Volume
WITH customer_support AS (
    SELECT
        a.account_id,
        a.account_name,
        a.industry,
        COUNT(s.ticket_id) AS ticket_count,
        ROUND(AVG(s.satisfaction_score), 2) AS avg_satisfaction_score
    FROM accounts a
    LEFT JOIN support_tickets s
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
    ticket_count,
    avg_satisfaction_score,
    RANK() OVER (
        ORDER BY ticket_count DESC
    ) AS support_volume_rank
FROM customer_support
ORDER BY support_volume_rank;


-- 9. Monthly Support Trend
SELECT
    DATE_FORMAT(submitted_at, '%Y-%m') AS support_month,
    COUNT(*) AS ticket_count,
    ROUND(AVG(resolution_time_hours), 2) AS avg_resolution_time_hours,
    ROUND(AVG(first_response_time_minutes), 2) AS avg_first_response_minutes,
    ROUND(AVG(satisfaction_score), 2) AS avg_satisfaction_score
FROM support_tickets
GROUP BY DATE_FORMAT(submitted_at, '%Y-%m')
ORDER BY support_month;


-- 10. High-Support Customers with Churn Status
WITH customer_support AS (
    SELECT
        a.account_id,
        a.account_name,
        a.industry,
        a.churn_flag,
        COUNT(s.ticket_id) AS ticket_count,
        ROUND(AVG(s.satisfaction_score), 2) AS avg_satisfaction_score
    FROM accounts a
    LEFT JOIN support_tickets s
        ON a.account_id = s.account_id
    GROUP BY
        a.account_id,
        a.account_name,
        a.industry,
        a.churn_flag
)

SELECT
    account_id,
    account_name,
    industry,
    churn_flag,
    ticket_count,
    avg_satisfaction_score,
    CASE
        WHEN ticket_count >= 8 THEN 'High Support Volume'
        WHEN ticket_count >= 4 THEN 'Medium Support Volume'
        WHEN ticket_count > 0 THEN 'Low Support Volume'
        ELSE 'No Support Tickets'
    END AS support_segment
FROM customer_support
WHERE ticket_count >= 8
ORDER BY ticket_count DESC;