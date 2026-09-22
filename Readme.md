# SaaS Product Analytics

## Project Overview

SaaS Product Analytics is an end-to-end data analytics project focused on analyzing customer behavior, revenue, product usage, customer segmentation, historical churn, and support performance for a SaaS business.

The project combines **Excel, SQL-ready analytical thinking, Python, Pandas, Plotly, and Streamlit** to transform customer-level data into business insights and an interactive analytics dashboard.

---

## Business Objectives

The analysis focuses on answering key business questions:

* How large and valuable is the customer base?
* Which customer segments contribute the most revenue?
* How does customer engagement vary across segments?
* What patterns exist in product usage and feature adoption?
* Which customer groups show higher historical churn association?
* How does usage and feature adoption relate to historical churn?
* How do support volume and response times vary across customers?
* What data-quality issues should business users be aware of?

---

## Tools & Technologies

* **Python**
* **Pandas**
* **NumPy**
* **Plotly**
* **Streamlit**
* **Microsoft Excel**
* **Power Query**
* **Pivot Tables**
* **Data Cleaning & Validation**
* **Exploratory Data Analysis**
* **KPI Analysis**
* **Customer Segmentation**
* **Business Intelligence**

---

## Project Workflow

```text
Raw SaaS Data
      ↓
Data Understanding
      ↓
Data Cleaning & Validation
      ↓
Exploratory Data Analysis
      ↓
Excel Analytical Model
      ↓
KPI & Customer Analysis
      ↓
Product Usage Analysis
      ↓
Customer Segmentation
      ↓
Historical Churn Analysis
      ↓
Support Analysis
      ↓
Python Visualization
      ↓
Interactive Streamlit Dashboard
      ↓
Business Insights
```

---

## Key KPIs

The dashboard provides dynamic KPI calculations based on the selected filters.

| KPI                    | Full Dataset |
| ---------------------- | -----------: |
| Total Customers        |          500 |
| Total MRR              |      $11.34M |
| Total ARR              |     $136.06M |
| Total Subscriptions    |        5,000 |
| Total Usage Records    |       13,808 |
| Historical Churn Rate  |       70.40% |
| Average MRR / Customer |      $22,677 |

---

## Dashboard Features

### 1. Executive Overview

Provides a high-level view of:

* Customer segmentation
* Revenue by customer segment
* Historical churn by segment
* Revenue contribution by industry

### 2. Customer & Revenue Analysis

Analyzes:

* Revenue by industry
* Customer distribution by plan
* Customer acquisition/referral sources
* Customer distribution by industry

### 3. Product Analytics

Analyzes:

* Feature adoption
* Usage levels
* Usage duration
* Error levels
* Feature adoption vs. historical churn

### 4. Churn Analytics

Examines:

* Historical churn by customer segment
* Historical churn by feature adoption level

> Historical churn analysis describes previously observed churn events and associations in the dataset. It is not intended as a predictive churn model.

### 5. Support & Customer Experience

Analyzes:

* Support ticket volume
* First response time
* Resolution time

A data-quality warning is included because some support-related metrics contain inconsistencies in the source data.

---

## Interactive Dashboard

The Streamlit dashboard includes:

* Industry filter
* Plan Tier filter
* Customer Segment filter
* Referral Source filter
* Dynamic KPI cards
* Dynamic Plotly visualizations
* Reset Filters functionality
* Interactive dashboard tabs
* Business insight cards

All dashboard charts and KPIs respond to the selected filters.

---

## Data Quality & Validation

During analysis, several source-data inconsistencies were identified, particularly in support-related metrics.

Examples include:

* Non-integer support ticket totals
* Highly concentrated satisfaction values
* Inconsistencies in escalation-related metrics

Rather than silently modifying these values, the dashboard explicitly flags the issue so that users can interpret support analytics appropriately.

---

## Analytical Areas

### Customer Analytics

* Customer segmentation
* Customer value
* MRR and ARR
* Plan distribution
* Industry distribution
* Referral source analysis

### Product Analytics

* Usage frequency
* Usage duration
* Feature adoption
* Error levels
* Customer engagement

### Churn Analytics

* Historical churn rate
* Churn by customer segment
* Churn by feature adoption
* Churn by usage level

### Support Analytics

* Support volume
* First response time
* Resolution time
* Customer support experience

---

## Project Structure

```text
Saas project/
│
├── SaaS Product Analytics_ExcelAnalysis.xlsx
│
├── Python_Visualization/
│   ├── app.py
│   ├── data.py
│   ├── KPIs.py
│   └── Visual.py
│
├── Notebooks/
│   └── data explore.ipynb
│
├── dataset/
│   └── raw data tables
│
├── Image.png
│
└── README.md
```

---

## Running the Dashboard

Install the required Python packages:

```bash
pip install pandas openpyxl plotly streamlit
```

Navigate to the visualization directory:

```bash
cd Python_Visualization
```

Run the Streamlit application:

```bash
python -m streamlit run app.py
```

The dashboard will open in the browser.

---

## Project Highlights

* Built an end-to-end SaaS analytics workflow
* Performed customer-level data analysis using Python and Excel
* Developed business KPIs and analytical metrics
* Created customer segmentation analysis
* Analyzed historical churn patterns
* Identified data-quality issues instead of hiding them
* Built interactive Plotly visualizations
* Developed a filterable Streamlit dashboard
* Implemented dynamic KPIs based on user-selected filters
* Added business insight summaries for decision support

---

## Skills Demonstrated

**Data Analysis:**
Data Cleaning, EDA, KPI Analysis, Customer Analytics, Segmentation, Churn Analysis, Business Analysis

**Python:**
Python, Pandas, NumPy

**Visualization:**
Plotly, Streamlit, Data Visualization

**Excel:**
Advanced Excel, Pivot Tables, Power Query, Analytical Modeling

**Business Intelligence:**
Dashboard Development, KPI Reporting, Business Insights, Data Validation

---

## Author

**Harshita Rajoria**

B.Tech — Computer Science & Engineering (Artificial Intelligence)

Data Analytics | Python | SQL | Excel | Power BI | Business Intelligence
