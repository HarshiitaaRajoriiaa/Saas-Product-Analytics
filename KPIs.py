import pandas as pd
from data import load_customer_data


# =========================================================
# LOAD DATA
# =========================================================

df = load_customer_data()


# =========================================================
# CORE KPI CALCULATIONS
# =========================================================

total_customers = df["account_id"].nunique()

total_mrr = df["mrr_amount_sum"].sum()

total_arr = df["arr_amount_sum"].sum()

total_subscriptions = df["subscription_count"].sum()

total_usage_records = df["usage_records"].sum()

historical_churned_customers = (
    df["historical_churn_flag"].sum()
)

historical_churn_rate = (
    historical_churned_customers / total_customers
) * 100

average_mrr_per_customer = (
    total_mrr / total_customers
)


# =========================================================
# KPI DICTIONARY
# =========================================================

KPI = {
    "Total Customers": total_customers,
    "Total MRR": total_mrr,
    "Total ARR": total_arr,
    "Total Subscriptions": total_subscriptions,
    "Total Usage Records": total_usage_records,
    "Historical Churned Customers": historical_churned_customers,
    "Historical Churn Rate": historical_churn_rate,
    "Average MRR per Customer": average_mrr_per_customer
}


# =========================================================
# DISPLAY KPIs
# =========================================================

if __name__ == "__main__":

    print("=" * 60)
    print("SAAS PRODUCT ANALYTICS — KPI VALIDATION")
    print("=" * 60)

    print(f"\nTotal Customers              : {total_customers:,}")

    print(f"Total MRR                    : ${total_mrr:,.2f}")

    print(f"Total ARR                    : ${total_arr:,.2f}")

    print(
        f"Total Subscriptions         : "
        f"{total_subscriptions:,}"
    )

    print(
        f"Total Usage Records         : "
        f"{total_usage_records:,}"
    )

    print(
        f"Historical Churned Customers: "
        f"{historical_churned_customers:,}"
    )

    print(
        f"Historical Churn Rate       : "
        f"{historical_churn_rate:.2f}%"
    )

    print(
        f"Average MRR per Customer    : "
        f"${average_mrr_per_customer:,.2f}"
    )

    print("\nKPI calculation completed successfully.")