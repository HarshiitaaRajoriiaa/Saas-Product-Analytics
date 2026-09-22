import pandas as pd
import plotly.express as px


# =========================================================
# 1. CUSTOMER SEGMENT DISTRIBUTION
# =========================================================

def create_segment_chart(data):
    segment = (
        data["Customer Segementation"]
        .value_counts()
        .reset_index()
    )

    segment.columns = ["Customer Segementation", "Customers"]

    fig = px.bar(
        segment,
        x="Customer Segementation",
        y="Customers",
        title="Customer Segment Distribution",
        text="Customers"
    )

    fig.update_traces(textposition="outside")

    fig.update_layout(
        xaxis_title="Customer Segment",
        yaxis_title="Customers",
        showlegend=False
    )

    return fig


# =========================================================
# 2. MRR BY CUSTOMER SEGMENT
# =========================================================

def create_mrr_segment_chart(data):
    result = (
        data.groupby("Customer Segementation")["mrr_amount_sum"]
        .sum()
        .reset_index()
    )

    fig = px.bar(
        result,
        x="Customer Segementation",
        y="mrr_amount_sum",
        title="MRR by Customer Segment",
        text="mrr_amount_sum"
    )

    fig.update_traces(
        texttemplate="$%{text:,.0f}",
        textposition="outside"
    )

    fig.update_layout(
        xaxis_title="Customer Segment",
        yaxis_title="MRR",
        showlegend=False
    )

    return fig


# =========================================================
# 3. HISTORICAL CHURN BY CUSTOMER SEGMENT
# =========================================================

def create_churn_segment_chart(data):
    result = (
        data.groupby("Customer Segementation")
        .agg(
            Customers=("account_id", "nunique"),
            Churned=("historical_churn_flag", "sum")
        )
        .reset_index()
    )

    result["Churn Rate"] = (
        result["Churned"] / result["Customers"] * 100
    )

    fig = px.bar(
        result,
        x="Customer Segementation",
        y="Churn Rate",
        title="Historical Churn Rate by Customer Segment",
        text="Churn Rate"
    )

    fig.update_traces(
        texttemplate="%{text:.1f}%",
        textposition="outside"
    )

    fig.update_layout(
        xaxis_title="Customer Segment",
        yaxis_title="Historical Churn Rate (%)",
        showlegend=False
    )

    return fig


# =========================================================
# 4. MRR BY INDUSTRY
# =========================================================

def create_mrr_industry_chart(data):
    result = (
        data.groupby("industry")["mrr_amount_sum"]
        .sum()
        .reset_index()
        .sort_values("mrr_amount_sum", ascending=False)
    )

    fig = px.bar(
        result,
        x="industry",
        y="mrr_amount_sum",
        title="MRR by Industry",
        text="mrr_amount_sum"
    )

    fig.update_traces(
        texttemplate="$%{text:,.0f}",
        textposition="outside"
    )

    fig.update_layout(
        xaxis_title="Industry",
        yaxis_title="MRR",
        showlegend=False
    )

    return fig


# =========================================================
# 5. CUSTOMER COUNT BY PLAN
# =========================================================

def create_plan_chart(data):
    result = (
        data["plan_tier"]
        .value_counts()
        .reset_index()
    )

    result.columns = ["plan_tier", "Customers"]

    fig = px.bar(
        result,
        x="plan_tier",
        y="Customers",
        title="Customer Count by Plan Tier",
        text="Customers"
    )

    fig.update_traces(textposition="outside")

    fig.update_layout(
        xaxis_title="Plan Tier",
        yaxis_title="Customers",
        showlegend=False
    )

    return fig


# =========================================================
# 6. CUSTOMER COUNT BY REFERRAL SOURCE
# =========================================================

def create_referral_chart(data):
    result = (
        data["referral_source"]
        .value_counts()
        .reset_index()
    )

    result.columns = ["referral_source", "Customers"]

    fig = px.bar(
        result,
        x="referral_source",
        y="Customers",
        title="Customer Count by Referral Source",
        text="Customers"
    )

    fig.update_traces(textposition="outside")

    fig.update_layout(
        xaxis_title="Referral Source",
        yaxis_title="Customers",
        showlegend=False
    )

    return fig


# =========================================================
# 7. CUSTOMER COUNT BY INDUSTRY
# =========================================================

def create_industry_chart(data):
    result = (
        data["industry"]
        .value_counts()
        .reset_index()
    )

    result.columns = ["industry", "Customers"]

    fig = px.bar(
        result,
        x="industry",
        y="Customers",
        title="Customer Count by Industry",
        text="Customers"
    )

    fig.update_traces(textposition="outside")

    fig.update_layout(
        xaxis_title="Industry",
        yaxis_title="Customers",
        showlegend=False
    )

    return fig


# =========================================================
# 8. FEATURE ADOPTION
# =========================================================

def create_feature_adoption_chart(data):
    result = (
        data["Feature Adpotion Band"]
        .value_counts()
        .reset_index()
    )

    result.columns = ["Feature Adpotion Band", "Customers"]

    fig = px.bar(
        result,
        x="Feature Adpotion Band",
        y="Customers",
        title="Feature Adoption Distribution",
        text="Customers"
    )

    fig.update_traces(textposition="outside")

    fig.update_layout(
        xaxis_title="Feature Adoption Band",
        yaxis_title="Customers",
        showlegend=False
    )

    return fig


# =========================================================
# 9. USAGE BAND
# =========================================================

def create_usage_chart(data):
    result = (
        data["Usage Band"]
        .value_counts()
        .reset_index()
    )

    result.columns = ["Usage Band", "Customers"]

    fig = px.bar(
        result,
        x="Usage Band",
        y="Customers",
        title="Usage Band Distribution",
        text="Customers"
    )

    fig.update_traces(textposition="outside")

    fig.update_layout(
        xaxis_title="Usage Band",
        yaxis_title="Customers",
        showlegend=False
    )

    return fig


# =========================================================
# 10. USAGE DURATION
# =========================================================

def create_usage_duration_chart(data):
    result = (
        data["usage duration band"]
        .value_counts()
        .reset_index()
    )

    result.columns = ["usage duration band", "Customers"]

    fig = px.bar(
        result,
        x="usage duration band",
        y="Customers",
        title="Usage Duration Distribution",
        text="Customers"
    )

    fig.update_traces(textposition="outside")

    fig.update_layout(
        xaxis_title="Usage Duration Band",
        yaxis_title="Customers",
        showlegend=False
    )

    return fig


# =========================================================
# 11. ERROR BAND
# =========================================================

def create_error_chart(data):
    result = (
        data["Error band"]
        .value_counts()
        .reset_index()
    )

    result.columns = ["Error band", "Customers"]

    fig = px.bar(
        result,
        x="Error band",
        y="Customers",
        title="Error Band Distribution",
        text="Customers"
    )

    fig.update_traces(textposition="outside")

    fig.update_layout(
        xaxis_title="Error Band",
        yaxis_title="Customers",
        showlegend=False
    )

    return fig


# =========================================================
# 12. FEATURE ADOPTION VS HISTORICAL CHURN
# =========================================================

def create_feature_churn_chart(data):
    result = (
        data.groupby("Feature Adpotion Band")
        .agg(
            Customers=("account_id", "nunique"),
            Churned=("historical_churn_flag", "sum")
        )
        .reset_index()
    )

    result["Churn Rate"] = (
        result["Churned"] / result["Customers"] * 100
    )

    fig = px.bar(
        result,
        x="Feature Adpotion Band",
        y="Churn Rate",
        title="Feature Adoption vs Historical Churn",
        text="Churn Rate"
    )

    fig.update_traces(
        texttemplate="%{text:.1f}%",
        textposition="outside"
    )

    fig.update_layout(
        xaxis_title="Feature Adoption Band",
        yaxis_title="Historical Churn Rate (%)",
        showlegend=False
    )

    return fig


# =========================================================
# 13. SUPPORT TICKET VOLUME
# =========================================================

def create_support_volume_chart(data):
    result = (
        data.groupby("Support Volumne Band")
        .agg(
            Customers=("account_id", "nunique"),
            Total_Tickets=("support_ticket_count", "sum")
        )
        .reset_index()
    )

    fig = px.bar(
        result,
        x="Support Volumne Band",
        y="Total_Tickets",
        title="Support Ticket Volume by Support Volume Band",
        text="Total_Tickets"
    )

    fig.update_traces(
        texttemplate="%{text:.0f}",
        textposition="outside"
    )

    fig.update_layout(
        xaxis_title="Support Volume Band",
        yaxis_title="Total Support Tickets",
        showlegend=False
    )

    return fig


# =========================================================
# 14. FIRST RESPONSE TIME
# =========================================================

def create_first_response_chart(data):
    result = (
        data.groupby("Support Volumne Band")
        .agg(
            Avg_First_Response=("avg_first_response_minutes", "mean")
        )
        .reset_index()
    )

    fig = px.bar(
        result,
        x="Support Volumne Band",
        y="Avg_First_Response",
        title="Average First Response Time by Support Volume Band",
        text="Avg_First_Response"
    )

    fig.update_traces(
        texttemplate="%{text:.1f} min",
        textposition="outside"
    )

    fig.update_layout(
        xaxis_title="Support Volume Band",
        yaxis_title="Average First Response Time (Minutes)",
        showlegend=False
    )

    return fig


# =========================================================
# 15. RESOLUTION TIME
# =========================================================

def create_resolution_time_chart(data):
    result = (
        data.groupby("Support Volumne Band")
        .agg(
            Avg_Resolution_Time=("avg_resolution_time_hours", "mean")
        )
        .reset_index()
    )

    fig = px.bar(
        result,
        x="Support Volumne Band",
        y="Avg_Resolution_Time",
        title="Average Resolution Time by Support Volume Band",
        text="Avg_Resolution_Time"
    )

    fig.update_traces(
        texttemplate="%{text:.1f} hrs",
        textposition="outside"
    )

    fig.update_layout(
        xaxis_title="Support Volume Band",
        yaxis_title="Average Resolution Time (Hours)",
        showlegend=False
    )

    return fig