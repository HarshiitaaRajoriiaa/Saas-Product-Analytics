import os
import pandas as pd
import mysql.connector


# --------------------------------
# MySQL connection
# --------------------------------

password = os.getenv("MYSQL_PASSWORD")

if not password:
    raise ValueError("MYSQL_PASSWORD environment variable is not set.")

connection = mysql.connector.connect(
    host="localhost",
    port=3306,
    user="root",
    password=password,
    database="saas"
)

cursor = connection.cursor()


# --------------------------------
# Clear existing data
# --------------------------------

print("Clearing existing data...")

cursor.execute("SET FOREIGN_KEY_CHECKS = 0")

for table in [
    "feature_usage",
    "subscriptions",
    "support_tickets",
    "churn_events",
    "accounts"
]:
    cursor.execute(f"TRUNCATE TABLE {table}")

cursor.execute("SET FOREIGN_KEY_CHECKS = 1")

connection.commit()

print("Existing data cleared.")


# --------------------------------
# Dataset path
# --------------------------------

BASE_PATH = r"C:\Users\harsh\OneDrive\Desktop\Saas project\Dataset"


# --------------------------------
# Load CSV function
# --------------------------------

def load_csv(file_name, table_name):

    file_path = f"{BASE_PATH}\\{file_name}"

    df = pd.read_csv(file_path)

    print(f"\nLoading {file_name}")
    print(f"Rows found: {len(df)}")

    columns = list(df.columns)

    column_names = ", ".join(
        f"`{column}`" for column in columns
    )

    placeholders = ", ".join(
        ["%s"] * len(columns)
    )

    query = f"""
        INSERT INTO {table_name}
        ({column_names})
        VALUES ({placeholders})
    """

    data = []

    for row in df.itertuples(index=False, name=None):

        cleaned_row = tuple(
            None if pd.isna(value) else value
            for value in row
        )

        data.append(cleaned_row)

    cursor.executemany(query, data)

    connection.commit()

    print(f"Inserted into {table_name}: {cursor.rowcount}")


# --------------------------------
# Load all datasets
# --------------------------------

load_csv("accounts.csv", "accounts")

load_csv("Subscriptions.csv", "subscriptions")

load_csv("Feature_usage.csv", "feature_usage")

load_csv("support_tickets.csv", "support_tickets")

load_csv("churn_events.csv", "churn_events")


# --------------------------------
# Close connection
# --------------------------------

cursor.close()
connection.close()

print("\nAll CSV data loaded successfully!")