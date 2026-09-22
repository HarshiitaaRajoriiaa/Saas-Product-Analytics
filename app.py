import streamlit as st

from data import load_customer_data

from KPIs import (
    total_customers,
    total_mrr,
    total_arr,
    historical_churn_rate,
    average_mrr_per_customer
)

from Visual import (
    create_segment_chart,
    create_mrr_segment_chart,
    create_churn_segment_chart,
    create_mrr_industry_chart,
    create_plan_chart,
    create_referral_chart,
    create_industry_chart,
    create_feature_adoption_chart,
    create_usage_chart,
    create_usage_duration_chart,
    create_error_chart,
    create_feature_churn_chart,
    create_support_volume_chart,
    create_first_response_chart,
    create_resolution_time_chart
)


# =========================================================
# PAGE CONFIGURATION
# =========================================================

st.set_page_config(
    page_title="SaaS Product Analytics",
    page_icon="📈",
    layout="wide"
)


# =========================================================
# CUSTOM DASHBOARD STYLING
# =========================================================

st.markdown("""
<style>

    /* Sidebar */
    section[data-testid="stSidebar"] {
        background-color: #0F2747;
    }

    /* Sidebar text */
    section[data-testid="stSidebar"] * {
        color: white;
    }

    /* Sidebar title */
    section[data-testid="stSidebar"] h2,
    section[data-testid="stSidebar"] h3 {
        color: white;
        font-weight: 600;
    }

    /* Selected filter tags */
    section[data-testid="stSidebar"] span[data-baseweb="tag"] {
        background-color: #2563A6 !important;
        color: white !important;
        border: 1px solid #5B9BD5 !important;
    }

    /* Text inside selected tags */
    section[data-testid="stSidebar"] span[data-baseweb="tag"] span {
        color: white !important;
    }

    /* Close icon */
    section[data-testid="stSidebar"] span[data-baseweb="tag"] svg {
        fill: white !important;
        color: white !important;
    }

   

</style>
""", unsafe_allow_html=True)


# =========================================================
# LOAD DATA
# =========================================================

df = load_customer_data()


# =========================================================
# SIDEBAR
# =========================================================

st.sidebar.markdown(
    "## 🎛 Dashboard Filters"
)

st.sidebar.caption(
    "Use the filters below to explore the customer base."
)


# =========================================================
# RESET FILTERS
# =========================================================

if "filter_reset_version" not in st.session_state:
    st.session_state.filter_reset_version = 0


if st.sidebar.button("↻ Reset Filters"):

    st.session_state.filter_reset_version += 1

    st.rerun()


# Unique version for every reset
reset_version = st.session_state.filter_reset_version


# =========================================================
# FILTER OPTIONS
# =========================================================

industry_options = sorted(
    df["industry"].dropna().unique()
)

plan_options = sorted(
    df["plan_tier"].dropna().unique()
)

segment_options = sorted(
    df["Customer Segementation"].dropna().unique()
)

referral_options = sorted(
    df["referral_source"].dropna().unique()
)


# =========================================================
# SIDEBAR FILTERS
# =========================================================

industry_filter = st.sidebar.multiselect(
    "Industry",
    options=industry_options,
    default=industry_options,
    key=f"industry_filter_{reset_version}"
)


plan_filter = st.sidebar.multiselect(
    "Plan Tier",
    options=plan_options,
    default=plan_options,
    key=f"plan_filter_{reset_version}"
)


segment_filter = st.sidebar.multiselect(
    "Customer Segment",
    options=segment_options,
    default=segment_options,
    key=f"segment_filter_{reset_version}"
)


referral_filter = st.sidebar.multiselect(
    "Referral Source",
    options=referral_options,
    default=referral_options,
    key=f"referral_filter_{reset_version}"
)


# =========================================================
# APPLY FILTERS
# =========================================================

filtered_df = df[
    df["industry"].isin(industry_filter)
    & df["plan_tier"].isin(plan_filter)
    & df["Customer Segementation"].isin(segment_filter)
    & df["referral_source"].isin(referral_filter)
]


# =========================================================
# DYNAMIC KPIs
# =========================================================

filtered_customers = filtered_df["account_id"].nunique()

filtered_mrr = filtered_df["mrr_amount_sum"].sum()

filtered_arr = filtered_df["arr_amount_sum"].sum()

filtered_churned = filtered_df["historical_churn_flag"].sum()

filtered_churn_rate = (
    filtered_churned / filtered_customers * 100
    if filtered_customers > 0
    else 0
)

filtered_avg_mrr = (
    filtered_mrr / filtered_customers
    if filtered_customers > 0
    else 0
)


# =========================================================
# DASHBOARD HEADER
# =========================================================

header_left, header_right = st.columns([3, 1])


with header_left:

    st.title("SaaS Product Analytics Dashboard")

    st.caption(
        "Customer, product usage, revenue, support and historical churn analysis"
    )


with header_right:

    st.image(
        "Image.png",
        use_container_width=True
    )


st.divider()


# =========================================================
# KPI CARDS
# =========================================================

col1, col2, col3, col4, col5 = st.columns(5)


col1.metric(
    "Total Customers",
    f"{filtered_customers:,}"
)


col2.metric(
    "Total MRR",
    f"${filtered_mrr / 1_000_000:.2f}M"
)


col3.metric(
    "Total ARR",
    f"${filtered_arr / 1_000_000:.2f}M"
)


col4.metric(
    "Historical Churn",
    f"{filtered_churn_rate:.2f}%"
)


col5.metric(
    "Avg MRR / Customer",
    f"${filtered_avg_mrr:,.0f}"
)


st.divider()


# =========================================================
# KEY BUSINESS INSIGHTS
# =========================================================

st.subheader("Key Business Insights")


insight1, insight2, insight3, insight4 = st.columns(4)


with insight1:

    st.info(
        f"**Customer Base**\n\n"
        f"{filtered_customers:,} customers are included "
        f"in the current filter selection."
    )


with insight2:

    st.info(
        f"**Revenue**\n\n"
        f"Current MRR is ${filtered_mrr:,.0f}, "
        f"with an average of ${filtered_avg_mrr:,.0f} per customer."
    )


with insight3:

    st.warning(
        f"**Historical Churn**\n\n"
        f"{filtered_churn_rate:.1f}% of customers have a "
        f"historical churn event in the current selection."
    )


with insight4:

    st.info(
        f"**Customer Segments**\n\n"
        f"The dashboard allows segment-level analysis "
        f"of customer value and engagement."
    )


# =========================================================
# DASHBOARD TABS
# =========================================================

tab1, tab2, tab3, tab4, tab5 = st.tabs([
    "Executive Overview",
    "Customer & Revenue",
    "Product Analytics",
    "Churn Analytics",
    "Support & Experience"
])


# =========================================================
# TAB 1 — EXECUTIVE OVERVIEW
# =========================================================

with tab1:

    st.subheader("Customer & Revenue Overview")


    col1, col2 = st.columns(2)


    with col1:

        fig_segment_filtered = create_segment_chart(filtered_df)

        st.plotly_chart(
            fig_segment_filtered,
            use_container_width=True,
            key="executive_segment"
        )


    with col2:

        fig_mrr_filtered = create_mrr_segment_chart(filtered_df)

        st.plotly_chart(
            fig_mrr_filtered,
            use_container_width=True,
            key="executive_mrr"
        )


    col1, col2 = st.columns(2)


    with col1:

        fig_churn_filtered = create_churn_segment_chart(filtered_df)

        st.plotly_chart(
            fig_churn_filtered,
            use_container_width=True,
            key="executive_churn"
        )


    with col2:

        fig_mrr_industry_filtered = create_mrr_industry_chart(filtered_df)

        st.plotly_chart(
            fig_mrr_industry_filtered,
            use_container_width=True,
            key="executive_mrr_industry"
        )


# =========================================================
# TAB 2 — CUSTOMER & REVENUE
# =========================================================

with tab2:

    st.subheader("Customer & Revenue Analysis")


    col1, col2 = st.columns(2)


    with col1:

        fig_mrr_industry_filtered = create_mrr_industry_chart(filtered_df)

        st.plotly_chart(
            fig_mrr_industry_filtered,
            use_container_width=True,
            key="customer_mrr_industry"
        )


    with col2:

        fig_plan_filtered = create_plan_chart(filtered_df)

        st.plotly_chart(
            fig_plan_filtered,
            use_container_width=True,
            key="customer_plan"
        )


    col1, col2 = st.columns(2)


    with col1:

        fig_referral_filtered = create_referral_chart(filtered_df)

        st.plotly_chart(
            fig_referral_filtered,
            use_container_width=True,
            key="customer_referral"
        )


    with col2:

        fig_industry_filtered = create_industry_chart(filtered_df)

        st.plotly_chart(
            fig_industry_filtered,
            use_container_width=True,
            key="customer_industry"
        )


# =========================================================
# TAB 3 — PRODUCT ANALYTICS
# =========================================================

with tab3:

    st.subheader("Product Usage & Adoption")


    col1, col2 = st.columns(2)


    with col1:

        fig_feature_adoption_filtered = create_feature_adoption_chart(
            filtered_df
        )

        st.plotly_chart(
            fig_feature_adoption_filtered,
            use_container_width=True,
            key="product_feature_adoption"
        )


    with col2:

        fig_usage_filtered = create_usage_chart(filtered_df)

        st.plotly_chart(
            fig_usage_filtered,
            use_container_width=True,
            key="product_usage"
        )


    col1, col2 = st.columns(2)


    with col1:

        fig_usage_duration_filtered = create_usage_duration_chart(
            filtered_df
        )

        st.plotly_chart(
            fig_usage_duration_filtered,
            use_container_width=True,
            key="product_usage_duration"
        )


    with col2:

        fig_errors_filtered = create_error_chart(filtered_df)

        st.plotly_chart(
            fig_errors_filtered,
            use_container_width=True,
            key="product_errors"
        )


    col1, col2 = st.columns(2)


    with col1:

        fig_feature_churn_filtered = create_feature_churn_chart(
            filtered_df
        )

        st.plotly_chart(
            fig_feature_churn_filtered,
            use_container_width=True,
            key="product_feature_churn"
        )


# =========================================================
# TAB 4 — CHURN ANALYTICS
# =========================================================

with tab4:

    st.subheader("Historical Churn Analysis")


    col1, col2 = st.columns(2)


    with col1:

        fig_churn_filtered = create_churn_segment_chart(
            filtered_df
        )

        st.plotly_chart(
            fig_churn_filtered,
            use_container_width=True,
            key="churn_analysis"
        )


    with col2:

        fig_feature_churn_filtered = create_feature_churn_chart(
            filtered_df
        )

        st.plotly_chart(
            fig_feature_churn_filtered,
            use_container_width=True,
            key="churn_feature_adoption"
        )


# =========================================================
# TAB 5 — SUPPORT & EXPERIENCE
# =========================================================

with tab5:

    st.subheader("Support & Customer Experience")


    st.warning(
        "Data Quality Note: Some support-related metrics show "
        "inconsistencies in the source data. Interpret support "
        "metrics with caution."
    )


    col1, col2 = st.columns(2)


    with col1:

        fig_support_volume_filtered = create_support_volume_chart(
            filtered_df
        )

        st.plotly_chart(
            fig_support_volume_filtered,
            use_container_width=True,
            key="support_volume"
        )


    with col2:

        fig_first_response_filtered = create_first_response_chart(
            filtered_df
        )

        st.plotly_chart(
            fig_first_response_filtered,
            use_container_width=True,
            key="first_response"
        )


    col1, col2 = st.columns(2)


    with col1:

        fig_resolution_time_filtered = create_resolution_time_chart(
            filtered_df
        )

        st.plotly_chart(
            fig_resolution_time_filtered,
            use_container_width=True,
            key="resolution_time"
        )


# =========================================================
# FOOTER
# =========================================================

st.divider()

st.caption(
    "SaaS Product Analytics | Built with Python, Pandas, Plotly "
    "| Streamlit | Harshita Rajoria 2026"
)