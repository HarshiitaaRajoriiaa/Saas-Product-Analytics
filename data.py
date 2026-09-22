import pandas as pd
from pathlib import Path


# =========================================================
# PROJECT PATHS
# =========================================================

PROJECT_DIR = Path(__file__).resolve().parent.parent

EXCEL_FILE = PROJECT_DIR / "SaaS Product Analytics_ExcelAnalysis.xlsx"


# =========================================================
# LOAD CUSTOMER ANALYTICS DATA
# =========================================================

def load_customer_data():

    df = pd.read_excel(
        EXCEL_FILE,
        sheet_name="Customer Analytics 2"
    )

    # Convert date column
    df["signup_date"] = pd.to_datetime(
        df["signup_date"],
        errors="coerce"
    )

    return df


# =========================================================
# VALIDATION
# =========================================================

if __name__ == "__main__":

    df = load_customer_data()

    print("=" * 60)
    print("SAAS CUSTOMER ANALYTICS DATA")
    print("=" * 60)

    print(f"\nRows: {df.shape[0]}")
    print(f"Columns: {df.shape[1]}")

    print("\nHistorical churn distribution:")
    print(df["historical_churn_flag"].value_counts())

    print("\nCustomer segmentation:")
    print(df["Customer Segementation"].value_counts())

    print("\nData loaded successfully.")