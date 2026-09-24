USE saas;

-- 1. Accounts
CREATE TABLE IF NOT EXISTS accounts (
    account_id VARCHAR(50) PRIMARY KEY,
    account_name VARCHAR(255),
    industry VARCHAR(100),
    country VARCHAR(100),
    signup_date DATE,
    referral_source VARCHAR(100),
    plan_tier VARCHAR(50),
    seats INT,
    is_trial BOOLEAN,
    churn_flag BOOLEAN
);


-- 2. Subscriptions
CREATE TABLE IF NOT EXISTS subscriptions (
    subscription_id VARCHAR(50) PRIMARY KEY,
    account_id VARCHAR(50),
    start_date DATE,
    end_date DATE,
    plan_tier VARCHAR(50),
    seats INT,
    mrr_amount INT,
    arr_amount INT,
    is_trial BOOLEAN,
    upgrade_flag BOOLEAN,
    downgrade_flag BOOLEAN,
    churn_flag BOOLEAN,
    billing_frequency VARCHAR(50),
    auto_renew_flag BOOLEAN,

    FOREIGN KEY (account_id)
        REFERENCES accounts(account_id)
);


-- 3. Feature Usage
CREATE TABLE IF NOT EXISTS feature_usage (
    record_id INT AUTO_INCREMENT PRIMARY KEY,  
    --  self-incrementing primary key for uniqueness
    usage_id VARCHAR(50),
    subscription_id VARCHAR(50),
    usage_date DATE,
    feature_name VARCHAR(255),
    usage_count INT,
    usage_duration_secs INT,
    error_count INT,
    is_beta_feature BOOLEAN,

    FOREIGN KEY (subscription_id)
        REFERENCES subscriptions(subscription_id)
);


-- 4. Support Tickets
CREATE TABLE IF NOT EXISTS support_tickets (
    ticket_id VARCHAR(50) PRIMARY KEY,
    account_id VARCHAR(50),
    submitted_at DATETIME,
    closed_at DATETIME,
    resolution_time_hours DECIMAL(10,2),
    priority VARCHAR(50),
    first_response_time_minutes INT,
    satisfaction_score DECIMAL(5,2),
    escalation_flag BOOLEAN,

    FOREIGN KEY (account_id)
        REFERENCES accounts(account_id)
);


-- 5. Churn Events
CREATE TABLE IF NOT EXISTS churn_events (
    churn_event_id VARCHAR(50) PRIMARY KEY,
    account_id VARCHAR(50),
    churn_date DATE,
    reason_code VARCHAR(100),
    refund_amount_usd DECIMAL(12,2),
    preceding_upgrade_flag BOOLEAN,
    preceding_downgrade_flag BOOLEAN,
    is_reactivation BOOLEAN,
    feedback_text TEXT,

    FOREIGN KEY (account_id)
        REFERENCES accounts(account_id)
);


-- Verify tables
SHOW TABLES;


USE saas;

DROP TABLE feature_usage;

CREATE TABLE feature_usage (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    usage_id VARCHAR(50),
    subscription_id VARCHAR(50),
    usage_date DATE,
    feature_name VARCHAR(255),
    usage_count INT,
    usage_duration_secs INT,
    error_count INT,
    is_beta_feature BOOLEAN,

    FOREIGN KEY (subscription_id)
        REFERENCES subscriptions(subscription_id)
);



select * from feature_usage;