-- USE saas;

-- DELETE FROM feature_usage;
-- DELETE FROM subscriptions;
-- DELETE FROM support_tickets;
-- DELETE FROM churn_events;
-- DELETE FROM accounts;

-- SELECT COUNT(*) AS accounts_count FROM accounts;
-- SELECT COUNT(*) AS subscriptions_count FROM subscriptions;
-- SELECT COUNT(*) AS feature_usage_count FROM feature_usage;
-- SELECT COUNT(*) AS support_tickets_count FROM support_tickets;
-- SELECT COUNT(*) AS churn_events_count FROM churn_events;


USE saas;

-- Check duplicate usage IDs in the raw CSV
SELECT
    usage_id,
    COUNT(*) AS occurrence_count
FROM (
    SELECT usage_id
    FROM feature_usage
) AS raw_data
GROUP BY usage_id
HAVING COUNT(*) > 1;




USE saas;

SELECT 'accounts' AS table_name, COUNT(*) AS row_count
FROM accounts

UNION ALL

SELECT 'subscriptions', COUNT(*)
FROM subscriptions

UNION ALL

SELECT 'feature_usage', COUNT(*)
FROM feature_usage

UNION ALL

SELECT 'support_tickets', COUNT(*)
FROM support_tickets

UNION ALL

SELECT 'churn_events', COUNT(*)
FROM churn_events;