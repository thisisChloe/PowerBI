# SQL

The SQL script that builds the payroll data warehouse used by the Power BI dashboard.

Data moves through three layers:

| Layer | What it holds |
|---|---|
| Landing | Raw tables imported from the CSV files in Payroll Dataset Generator |
| Staging | Views that clean and standardise the raw data |
| Marts | The final dimension and fact tables that Power BI connects to |
