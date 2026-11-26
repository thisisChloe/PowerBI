/* =====================================================================
   Data quality tests for the payroll warehouse
   Run after Transformation.sql. Returns one row per test.
   failed_rows = 0 means the test passed.
   severity: error   = the model is wrong and must be fixed
             warning = a known data issue worth reporting
   ===================================================================== */
USE payroll;
GO

WITH tests AS (

    /* --- Every value converted to its type in staging ---------------- */
    SELECT 'stg_bonuses: bonus_date could not be read' AS test_name, 'error' AS severity,
           COUNT(*) AS failed_rows
    FROM staging.stg_bonuses WHERE bonus_date IS NULL
    UNION ALL
    SELECT 'stg_timesheet: date, times or hours could not be read', 'error', COUNT(*)
    FROM staging.stg_timesheet
    WHERE timesheet_transaction_date IS NULL OR start_time IS NULL OR end_time IS NULL
       OR timesheet_transaction_hours IS NULL
    UNION ALL
    SELECT 'stg_roster: work_date or hours could not be read', 'error', COUNT(*)
    FROM staging.stg_roster WHERE work_date IS NULL OR hours IS NULL
    UNION ALL
    SELECT 'stg_contracts: start_date or pay_rate could not be read', 'error', COUNT(*)
    FROM staging.stg_contracts WHERE start_date IS NULL OR pay_rate IS NULL
    UNION ALL
    SELECT 'dim_pay_rate_adjustments: rate_multiplier could not be read', 'error', COUNT(*)
    FROM marts.dim_pay_rate_adjustments WHERE rate_multiplier IS NULL

    /* --- Primary keys are unique ------------------------------------- */
    UNION ALL
    SELECT 'dim_employees: duplicate employee_pk', 'error', COUNT(*) - COUNT(DISTINCT employee_pk)
    FROM marts.dim_employees
    UNION ALL
    SELECT 'dim_contracts: duplicate contract_pk', 'error', COUNT(*) - COUNT(DISTINCT contract_pk)
    FROM marts.dim_contracts
    UNION ALL
    SELECT 'dim_dates: duplicate date_pk', 'error', COUNT(*) - COUNT(DISTINCT date_pk)
    FROM marts.dim_dates
    UNION ALL
    SELECT 'dim_pay_period: duplicate pay_period_pk', 'error', COUNT(*) - COUNT(DISTINCT pay_period_pk)
    FROM marts.dim_pay_period
    UNION ALL
    SELECT 'dim_tax_rates: duplicate tax_rate_pk', 'error', COUNT(*) - COUNT(DISTINCT tax_rate_pk)
    FROM marts.dim_tax_rates
    UNION ALL
    SELECT 'fact_timesheet: duplicate timesheet_pk (join fan-out)', 'error', COUNT(*) - COUNT(DISTINCT timesheet_pk)
    FROM marts.fact_timesheet
    UNION ALL
    SELECT 'fact_roster: duplicate roster_pk (join fan-out)', 'error', COUNT(*) - COUNT(DISTINCT roster_pk)
    FROM marts.fact_roster

    /* --- Every fact row finds its employee, contract and pay period -- */
    UNION ALL
    SELECT 'fact_timesheet: missing employee, contract or pay period', 'error', COUNT(*)
    FROM marts.fact_timesheet WHERE employee_fk IS NULL OR contract_fk IS NULL OR pay_period_fk IS NULL
    UNION ALL
    SELECT 'fact_roster: missing employee, contract or pay period', 'error', COUNT(*)
    FROM marts.fact_roster WHERE employee_fk IS NULL OR contract_fk IS NULL OR pay_period_fk IS NULL
    UNION ALL
    SELECT 'fact_allowances: missing employee, contract or pay period', 'error', COUNT(*)
    FROM marts.fact_allowances WHERE employee_fk IS NULL OR contract_fk IS NULL OR pay_period_fk IS NULL
    UNION ALL
    SELECT 'fact_bonuses: missing employee, contract or pay period', 'error', COUNT(*)
    FROM marts.fact_bonuses WHERE employee_fk IS NULL OR contract_fk IS NULL OR pay_period_fk IS NULL
    UNION ALL
    SELECT 'fact_employee_leaves: missing employee, contract or pay period', 'error', COUNT(*)
    FROM marts.fact_employee_leaves WHERE employee_fk IS NULL OR contract_fk IS NULL OR pay_period_fk IS NULL
    UNION ALL
    SELECT 'fact_time_off_in_lieu: missing employee', 'error', COUNT(*)
    FROM marts.fact_time_off_in_lieu WHERE employee_fk IS NULL
    UNION ALL
    -- Known source issue: some overtime dates fall outside every contract
    SELECT 'fact_time_off_in_lieu: overtime date outside any contract', 'warning', COUNT(*)
    FROM marts.fact_time_off_in_lieu WHERE contract_fk IS NULL

    /* --- Business rules ------------------------------------------------ */
    UNION ALL
    SELECT 'fact_timesheet: hours not between 0 and 24', 'error', COUNT(*)
    FROM marts.fact_timesheet WHERE timesheet_transaction_hours <= 0 OR timesheet_transaction_hours > 24
    UNION ALL
    SELECT 'fact_employee_leaves: leave longer than one day (model assumes one day)', 'error', COUNT(*)
    FROM marts.fact_employee_leaves WHERE leave_end_date <> leave_start_date
    UNION ALL
    SELECT 'dim_contracts: overlapping contracts for the same employee', 'error', COUNT(*)
    FROM marts.dim_contracts AS a
    JOIN marts.dim_contracts AS b
        ON a.employee_id = b.employee_id
        AND a.contract_pk < b.contract_pk
        AND a.start_date <= ISNULL(b.end_date, '9999-12-31')
        AND b.start_date <= ISNULL(a.end_date, '9999-12-31')
    UNION ALL
    SELECT 'dim_tax_rates: gap or overlap between brackets in a tax year', 'error', COUNT(*)
    FROM (
        SELECT start_range,
               LAG(end_range) OVER (PARTITION BY year ORDER BY start_range) AS previous_end
        FROM marts.dim_tax_rates
    ) AS brackets
    WHERE previous_end IS NOT NULL AND start_range <> previous_end + 1

    /* --- Reconciliation with the source system ----------------------- */
    UNION ALL
    SELECT 'fact_timesheet: source pay_period_id differs from dim_dates', 'warning', COUNT(*)
    FROM marts.fact_timesheet
    WHERE source_pay_period_id IS NOT NULL AND source_pay_period_id <> pay_period_fk
    UNION ALL
    SELECT 'fact_timesheet: source pay_period_id is blank', 'warning', COUNT(*)
    FROM marts.fact_timesheet WHERE source_pay_period_id IS NULL
    UNION ALL
    SELECT 'fact_roster: source pay_period_id differs from dim_dates', 'warning', COUNT(*)
    FROM marts.fact_roster
    WHERE source_pay_period_id IS NOT NULL AND source_pay_period_id <> pay_period_fk
)
SELECT
    test_name,
    severity,
    failed_rows,
    CASE WHEN failed_rows = 0 THEN 'PASS' ELSE 'FAIL' END AS result
FROM tests
ORDER BY CASE severity WHEN 'error' THEN 1 ELSE 2 END, failed_rows DESC, test_name;
