/* =====================================================================
   Payroll data warehouse - SQL Server 2017 or later
   Layers: landing (raw CSV text) -> staging (typed, cleaned views)
           -> marts (dimension and fact views for Power BI)

   How to run:
     1. Set @folder in section 3 to the folder that holds the CSV files
        (the "Payroll Dataset Generator" folder). The path is read by the
        SQL Server service, so it must be on the same machine.
     2. Run the whole script in SSMS or Azure Data Studio.
   ===================================================================== */

/* ---------------------------------------------------------------------
   1. Database and schemas
   --------------------------------------------------------------------- */
IF DB_ID('payroll') IS NULL
    CREATE DATABASE payroll;
GO

USE payroll;
GO

IF SCHEMA_ID('landing') IS NULL EXEC ('CREATE SCHEMA landing');
IF SCHEMA_ID('staging') IS NULL EXEC ('CREATE SCHEMA staging');
IF SCHEMA_ID('marts')   IS NULL EXEC ('CREATE SCHEMA marts');
GO

/* ---------------------------------------------------------------------
   2. Landing tables
   Every column is stored as text, exactly as it appears in the CSV.
   Types are applied in staging, so a bad value never stops the load.
   --------------------------------------------------------------------- */
DROP TABLE IF EXISTS landing.lnd_allowance;
CREATE TABLE landing.lnd_allowance (
    allowance_id         NVARCHAR(50)  NULL,
    employee_id          NVARCHAR(20)  NULL,
    allowance_type       NVARCHAR(100) NULL,
    allowance_amount     NVARCHAR(50)  NULL,
    allowance_start_date NVARCHAR(20)  NULL,
    allowance_end_date   NVARCHAR(20)  NULL
);

DROP TABLE IF EXISTS landing.lnd_bonus;
CREATE TABLE landing.lnd_bonus (
    bonus_id     NVARCHAR(50)  NULL,
    employee_id  NVARCHAR(20)  NULL,
    bonus_type   NVARCHAR(100) NULL,
    bonus_amount NVARCHAR(50)  NULL,
    bonus_date   NVARCHAR(20)  NULL
);

DROP TABLE IF EXISTS landing.lnd_contract_details;
CREATE TABLE landing.lnd_contract_details (
    contract_id       NVARCHAR(50)  NULL,
    employee_id       NVARCHAR(20)  NULL,
    start_date        NVARCHAR(20)  NULL,
    end_date          NVARCHAR(20)  NULL,
    pay_rate          NVARCHAR(50)  NULL,
    job_title         NVARCHAR(100) NULL,
    payment_frequency NVARCHAR(50)  NULL,
    contract_type     NVARCHAR(50)  NULL,
    employment_type   NVARCHAR(50)  NULL,
    contract_status   NVARCHAR(50)  NULL
);

DROP TABLE IF EXISTS landing.lnd_employee_details;
CREATE TABLE landing.lnd_employee_details (
    employee_id          NVARCHAR(20)  NULL,
    employee_first_name  NVARCHAR(100) NULL,
    employee_middle_name NVARCHAR(100) NULL,
    employee_last_name   NVARCHAR(100) NULL,
    employee_gender      NVARCHAR(20)  NULL,
    employee_location    NVARCHAR(100) NULL,
    date_of_birth        NVARCHAR(20)  NULL,
    hire_date            NVARCHAR(20)  NULL,
    termination_date     NVARCHAR(20)  NULL,
    employee_status      NVARCHAR(20)  NULL
);

DROP TABLE IF EXISTS landing.lnd_employee_leave;
CREATE TABLE landing.lnd_employee_leave (
    leave_id         NVARCHAR(50)  NULL,
    employee_id      NVARCHAR(20)  NULL,
    leave_type       NVARCHAR(100) NULL,
    leave_start_date NVARCHAR(20)  NULL,
    leave_end_date   NVARCHAR(20)  NULL,
    leave_hours      NVARCHAR(50)  NULL
);

DROP TABLE IF EXISTS landing.lnd_junior_pay_rates;
CREATE TABLE landing.lnd_junior_pay_rates (
    age                       NVARCHAR(100) NULL,
    percent_of_adult_pay_rate NVARCHAR(50)  NULL
);

DROP TABLE IF EXISTS landing.lnd_minimum_pay_rates;
CREATE TABLE landing.lnd_minimum_pay_rates (
    pay_rate_id           NVARCHAR(20) NULL,
    effect_from           NVARCHAR(20) NULL,
    effect_to             NVARCHAR(20) NULL,
    hourly_permanent_rate NVARCHAR(50) NULL,
    hourly_casual_rate    NVARCHAR(50) NULL
);

DROP TABLE IF EXISTS landing.lnd_pay_rate_adjustments;
CREATE TABLE landing.lnd_pay_rate_adjustments (
    rate_type        NVARCHAR(100) NULL,
    description      NVARCHAR(400) NULL,
    rate_calculation NVARCHAR(400) NULL
);

DROP TABLE IF EXISTS landing.lnd_roster;
CREATE TABLE landing.lnd_roster (
    roster_id     NVARCHAR(50)  NULL,
    employee_id   NVARCHAR(20)  NULL,
    shift         NVARCHAR(50)  NULL,
    hours         NVARCHAR(50)  NULL,
    work_date     NVARCHAR(20)  NULL,
    services      NVARCHAR(100) NULL,
    location      NVARCHAR(100) NULL,
    pay_period_id NVARCHAR(20)  NULL
);

DROP TABLE IF EXISTS landing.lnd_tax_rates;
CREATE TABLE landing.lnd_tax_rates (
    taxable_income     NVARCHAR(100) NULL,
    tax_on_this_income NVARCHAR(400) NULL,
    year               NVARCHAR(20)  NULL,
    note               NVARCHAR(400) NULL,
    start_range        NVARCHAR(50)  NULL,
    end_range          NVARCHAR(50)  NULL,
    date_start         NVARCHAR(20)  NULL,
    date_end           NVARCHAR(20)  NULL,
    fixed_tax          NVARCHAR(50)  NULL,
    cumulative_tax     NVARCHAR(50)  NULL
);

DROP TABLE IF EXISTS landing.lnd_time_off_in_lieu;
CREATE TABLE landing.lnd_time_off_in_lieu (
    toil_id            NVARCHAR(50) NULL,
    employee_id        NVARCHAR(20) NULL,
    overtime_date      NVARCHAR(20) NULL,
    toil_hours_accrued NVARCHAR(50) NULL,
    toil_usage_date    NVARCHAR(20) NULL
);

DROP TABLE IF EXISTS landing.lnd_timesheet;
CREATE TABLE landing.lnd_timesheet (
    timesheet_id                NVARCHAR(50) NULL,
    employee_code               NVARCHAR(20) NULL,
    timesheet_transaction_date  NVARCHAR(20) NULL,
    start_time                  NVARCHAR(20) NULL,
    end_time                    NVARCHAR(20) NULL,
    timesheet_transaction_hours NVARCHAR(50) NULL,
    pay_period_id               NVARCHAR(20) NULL
);

DROP TABLE IF EXISTS landing.lnd_dim_dates;
CREATE TABLE landing.lnd_dim_dates (
    date_pk NVARCHAR(100) NULL,
    [date] NVARCHAR(100) NULL,
    date_long_description NVARCHAR(100) NULL,
    date_short_description NVARCHAR(100) NULL,
    day_long_name NVARCHAR(100) NULL,
    day_short_name NVARCHAR(100) NULL,
    month_long_name NVARCHAR(100) NULL,
    month_short_name NVARCHAR(100) NULL,
    calendar_day NVARCHAR(100) NULL,
    calendar_week NVARCHAR(100) NULL,
    calendar_week_start_date NVARCHAR(100) NULL,
    calendar_week_end_date NVARCHAR(100) NULL,
    calendar_day_in_week NVARCHAR(100) NULL,
    calendar_month NVARCHAR(100) NULL,
    calendar_month_start_date NVARCHAR(100) NULL,
    calendar_month_end_date NVARCHAR(100) NULL,
    calendar_number_of_days_in_month NVARCHAR(100) NULL,
    calendar_day_in_month NVARCHAR(100) NULL,
    calendar_quarter NVARCHAR(100) NULL,
    calendar_quarter_start_date NVARCHAR(100) NULL,
    calendar_quarter_end_date NVARCHAR(100) NULL,
    calendar_number_of_days_in_quarter NVARCHAR(100) NULL,
    calendar_day_in_quarter NVARCHAR(100) NULL,
    calendar_year NVARCHAR(100) NULL,
    calendar_year_start_date NVARCHAR(100) NULL,
    calendar_year_end_date NVARCHAR(100) NULL,
    calendar_number_of_days_in_year NVARCHAR(100) NULL,
    fiscal_year NVARCHAR(100) NULL,
    fiscal_year_start_date NVARCHAR(100) NULL,
    fiscal_year_end_date NVARCHAR(100) NULL,
    fiscal_month NVARCHAR(100) NULL,
    fiscal_quarter NVARCHAR(100) NULL,
    fiscal_quarter_start_date NVARCHAR(100) NULL,
    fiscal_quarter_end_date NVARCHAR(100) NULL,
    fiscal_week NVARCHAR(100) NULL,
    pay_period_week NVARCHAR(100) NULL,
    pay_period_month NVARCHAR(100) NULL,
    pay_period_fortnight NVARCHAR(100) NULL
);
GO

/* ---------------------------------------------------------------------
   3. Load the CSV files into landing
   Change @folder to your own path. Most files end lines with CRLF;
   minimum_pay_rates.csv and pay_rate_adjustments.csv use LF only.
   --------------------------------------------------------------------- */
DECLARE @folder NVARCHAR(400) = N'C:\Users\<you>\Desktop\PayRoll Project\Payroll Dataset Generator\';

DECLARE @files TABLE (
    table_name     SYSNAME,
    file_name      NVARCHAR(200),
    row_terminator VARCHAR(10)
);

INSERT INTO @files (table_name, file_name, row_terminator)
VALUES
    ('lnd_allowance',            'allowance.csv',            '0x0d0a'),
    ('lnd_bonus',                'bonus.csv',                '0x0d0a'),
    ('lnd_contract_details',     'contract_details.csv',     '0x0d0a'),
    ('lnd_employee_details',     'employee_details.csv',     '0x0d0a'),
    ('lnd_employee_leave',       'employee_leave.csv',       '0x0d0a'),
    ('lnd_junior_pay_rates',     'junior_pay_rates.csv',     '0x0d0a'),
    ('lnd_minimum_pay_rates',    'minimum_pay_rates.csv',    '0x0a'),
    ('lnd_pay_rate_adjustments', 'pay_rate_adjustments.csv', '0x0a'),
    ('lnd_roster',               'roster.csv',               '0x0d0a'),
    ('lnd_tax_rates',            'tax_rates.csv',            '0x0d0a'),
    ('lnd_time_off_in_lieu',     'time_off_in_lieu.csv',     '0x0d0a'),
    ('lnd_timesheet',            'timesheet.csv',            '0x0d0a'),
    ('lnd_dim_dates',            'dim_dates.csv',            '0x0d0a');

DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql += N'TRUNCATE TABLE landing.' + QUOTENAME(table_name) + N';' + CHAR(10)
    + N'BULK INSERT landing.' + QUOTENAME(table_name)
    + N' FROM ''' + REPLACE(@folder + file_name, N'''', N'''''') + N''''
    + N' WITH (FORMAT = ''CSV'', FIRSTROW = 2, FIELDQUOTE = ''"'', ROWTERMINATOR = '''
    + row_terminator + N''', CODEPAGE = ''65001'', TABLOCK);' + CHAR(10)
FROM @files;

EXEC sp_executesql @sql;
GO

/* ---------------------------------------------------------------------
   4. Staging views
   Trim text, turn empty strings into NULL and convert each column to
   its proper type. Dates are ISO (style 23) except bonus_date, which is
   day-first in the source (style 103).
   --------------------------------------------------------------------- */

-- staging.stg_allowances
CREATE OR ALTER VIEW staging.stg_allowances AS
SELECT
    NULLIF(TRIM(allowance_id), '')                                AS allowance_id,
    NULLIF(TRIM(employee_id), '')                                 AS employee_id,
    NULLIF(TRIM(allowance_type), '')                              AS allowance_type,
    TRY_CONVERT(DECIMAL(10, 2), NULLIF(TRIM(allowance_amount), '')) AS allowance_amount,
    TRY_CONVERT(DATE, NULLIF(TRIM(allowance_start_date), ''), 23) AS allowance_start_date,
    TRY_CONVERT(DATE, NULLIF(TRIM(allowance_end_date), ''), 23)   AS allowance_end_date
FROM landing.lnd_allowance;
GO

-- staging.stg_bonuses
CREATE OR ALTER VIEW staging.stg_bonuses AS
SELECT
    NULLIF(TRIM(bonus_id), '')                                  AS bonus_id,
    NULLIF(TRIM(employee_id), '')                               AS employee_id,
    NULLIF(TRIM(bonus_type), '')                                AS bonus_type,
    TRY_CONVERT(DECIMAL(10, 2), NULLIF(TRIM(bonus_amount), '')) AS bonus_amount,
    TRY_CONVERT(DATE, NULLIF(TRIM(bonus_date), ''), 103)        AS bonus_date   -- source is dd/mm/yyyy
FROM landing.lnd_bonus;
GO

-- staging.stg_contracts
CREATE OR ALTER VIEW staging.stg_contracts AS
SELECT
    NULLIF(TRIM(contract_id), '')                           AS contract_id,
    NULLIF(TRIM(employee_id), '')                           AS employee_id,
    TRY_CONVERT(DATE, NULLIF(TRIM(start_date), ''), 23)     AS start_date,
    TRY_CONVERT(DATE, NULLIF(TRIM(end_date), ''), 23)       AS end_date,
    TRY_CONVERT(DECIMAL(10, 2), NULLIF(TRIM(pay_rate), '')) AS pay_rate,
    NULLIF(TRIM(job_title), '')                             AS job_title,
    NULLIF(TRIM(payment_frequency), '')                     AS payment_frequency,
    NULLIF(TRIM(contract_type), '')                         AS contract_type,
    NULLIF(TRIM(employment_type), '')                       AS employment_type,
    NULLIF(TRIM(contract_status), '')                       AS contract_status
FROM landing.lnd_contract_details;
GO

-- staging.stg_employee_leaves
CREATE OR ALTER VIEW staging.stg_employee_leaves AS
SELECT
    NULLIF(TRIM(leave_id), '')                                 AS leave_id,
    NULLIF(TRIM(employee_id), '')                              AS employee_id,
    NULLIF(TRIM(leave_type), '')                               AS leave_type,
    TRY_CONVERT(DATE, NULLIF(TRIM(leave_start_date), ''), 23)  AS leave_start_date,
    TRY_CONVERT(DATE, NULLIF(TRIM(leave_end_date), ''), 23)    AS leave_end_date,
    TRY_CONVERT(DECIMAL(6, 2), NULLIF(TRIM(leave_hours), ''))  AS leave_hours
FROM landing.lnd_employee_leave;
GO

-- staging.stg_employees
CREATE OR ALTER VIEW staging.stg_employees AS
SELECT
    NULLIF(TRIM(employee_id), '')                             AS employee_id,
    NULLIF(TRIM(employee_first_name), '')                     AS employee_first_name,
    NULLIF(TRIM(employee_middle_name), '')                    AS employee_middle_name,
    NULLIF(TRIM(employee_last_name), '')                      AS employee_last_name,
    NULLIF(TRIM(employee_gender), '')                         AS employee_gender,
    NULLIF(TRIM(employee_location), '')                       AS employee_location,
    TRY_CONVERT(DATE, NULLIF(TRIM(date_of_birth), ''), 23)    AS date_of_birth,
    TRY_CONVERT(DATE, NULLIF(TRIM(hire_date), ''), 23)        AS hire_date,
    TRY_CONVERT(DATE, NULLIF(TRIM(termination_date), ''), 23) AS termination_date,
    NULLIF(TRIM(employee_status), '')                         AS employee_status
FROM landing.lnd_employee_details;
GO

-- staging.stg_junior_pay_rates
CREATE OR ALTER VIEW staging.stg_junior_pay_rates AS
WITH cleaned AS (
    SELECT
        NULLIF(TRIM(age), '') AS age,
        TRY_CONVERT(DECIMAL(5, 2), NULLIF(TRIM(percent_of_adult_pay_rate), '')) AS percent_of_adult_pay_rate
    FROM landing.lnd_junior_pay_rates
)
SELECT
    CASE
        WHEN age LIKE 'Under 16%' THEN 'JPR15'
        WHEN age LIKE 'At 16%'    THEN 'JPR16'
        WHEN age LIKE 'At 17%'    THEN 'JPR17'
        WHEN age LIKE 'At 18%'    THEN 'JPR18'
        WHEN age LIKE 'At 19%'    THEN 'JPR19'
        WHEN age LIKE 'At 20%'    THEN 'JPR20'
    END AS pay_rate_id,
    age,
    percent_of_adult_pay_rate
FROM cleaned;
GO

-- staging.stg_minimum_pay_rates
CREATE OR ALTER VIEW staging.stg_minimum_pay_rates AS
SELECT
    NULLIF(TRIM(pay_rate_id), '')                                        AS pay_rate_id,
    TRY_CONVERT(DATE, NULLIF(TRIM(effect_from), ''), 23)                 AS effect_from,
    TRY_CONVERT(DATE, NULLIF(TRIM(effect_to), ''), 23)                   AS effect_to,
    TRY_CONVERT(DECIMAL(10, 2), NULLIF(TRIM(hourly_permanent_rate), '')) AS hourly_permanent_rate,
    TRY_CONVERT(DECIMAL(10, 2), NULLIF(TRIM(hourly_casual_rate), ''))    AS hourly_casual_rate
FROM landing.lnd_minimum_pay_rates;
GO

-- staging.stg_pay_rate_adjustments
-- rate_multiplier is read from the source text instead of being hardcoded:
-- "1.5x hourly rate (150% of base rate)"   -> 1.50
-- "+25% (1.25x) on top of hourly base rate" -> 1.25
-- It takes the number just before the first "x".
CREATE OR ALTER VIEW staging.stg_pay_rate_adjustments AS
WITH cleaned AS (
    SELECT
        NULLIF(TRIM(rate_type), '')        AS rate_type,
        NULLIF(TRIM(description), '')      AS description,
        NULLIF(TRIM(rate_calculation), '') AS rate_calculation
    FROM landing.lnd_pay_rate_adjustments
)
SELECT
    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
        UPPER(c.rate_type),
        ' ', '_'),
        '-', '_'),
        '(', ''),
        ')', ''),
        '.', ''),
        ',', '') AS pay_rate_id,
    c.rate_type,
    c.description,
    c.rate_calculation,
    TRY_CONVERT(DECIMAL(5, 2),
        RIGHT(b.before_x, CHARINDEX('(', REVERSE('(' + b.before_x)) - 1)
    ) AS rate_multiplier
FROM cleaned AS c
CROSS APPLY (
    SELECT CASE
               WHEN CHARINDEX('x', c.rate_calculation) > 1
               THEN TRIM(LEFT(c.rate_calculation, CHARINDEX('x', c.rate_calculation) - 1))
           END AS before_x
) AS b;
GO

-- staging.stg_roster
CREATE OR ALTER VIEW staging.stg_roster AS
SELECT
    NULLIF(TRIM(roster_id), '')                           AS roster_id,
    NULLIF(TRIM(employee_id), '')                         AS employee_id,
    NULLIF(TRIM(shift), '')                               AS shift,
    TRY_CONVERT(DECIMAL(6, 2), NULLIF(TRIM(hours), ''))   AS hours,
    TRY_CONVERT(DATE, NULLIF(TRIM(work_date), ''), 23)    AS work_date,
    NULLIF(TRIM(services), '')                            AS services,
    NULLIF(TRIM(location), '')                            AS location,
    NULLIF(TRIM(pay_period_id), '')                       AS source_pay_period_id
FROM landing.lnd_roster;
GO

-- staging.stg_tax_rates
-- The Date Start / Date End columns in the source are wrong (a one-day
-- range, e.g. 30/06/2019 to 1/07/2019 for 2019-2020). The tax year is
-- worked out from the Year column instead: 1 July to 30 June.
CREATE OR ALTER VIEW staging.stg_tax_rates AS
WITH cleaned AS (
    SELECT
        NULLIF(TRIM(taxable_income), '')                          AS taxable_income,
        NULLIF(TRIM(tax_on_this_income), '')                      AS tax_on_this_income,
        NULLIF(TRIM(year), '')                                    AS year,
        NULLIF(TRIM(note), '')                                    AS note,
        TRY_CONVERT(INT, NULLIF(TRIM(start_range), ''))           AS start_range,
        TRY_CONVERT(INT, NULLIF(TRIM(end_range), ''))             AS end_range,
        TRY_CONVERT(DECIMAL(10, 2), NULLIF(TRIM(fixed_tax), ''))  AS fixed_tax,
        TRY_CONVERT(DECIMAL(6, 4), NULLIF(TRIM(cumulative_tax), '')) AS marginal_tax_rate
    FROM landing.lnd_tax_rates
)
SELECT
    'TR' + REPLACE(year, '-', '')
        + '_' + CAST(start_range AS VARCHAR(10))
        + '_' + CAST(end_range AS VARCHAR(10)) AS tax_rate_id,   -- e.g. TR20192020_0_18200
    taxable_income,
    tax_on_this_income,
    year,
    note,
    start_range,
    end_range,
    DATEFROMPARTS(TRY_CONVERT(INT, LEFT(year, 4)), 7, 1)    AS date_start,
    DATEFROMPARTS(TRY_CONVERT(INT, RIGHT(year, 4)), 6, 30)  AS date_end,
    fixed_tax,
    marginal_tax_rate
FROM cleaned;
GO

-- staging.stg_time_off_in_lieu
CREATE OR ALTER VIEW staging.stg_time_off_in_lieu AS
SELECT
    NULLIF(TRIM(toil_id), '')                                       AS toil_id,
    NULLIF(TRIM(employee_id), '')                                   AS employee_id,
    TRY_CONVERT(DATE, NULLIF(TRIM(overtime_date), ''), 23)          AS overtime_date,
    TRY_CONVERT(DECIMAL(6, 2), NULLIF(TRIM(toil_hours_accrued), '')) AS toil_hours_accrued,
    TRY_CONVERT(DATE, NULLIF(TRIM(toil_usage_date), ''), 23)        AS toil_usage_date
FROM landing.lnd_time_off_in_lieu;
GO

-- staging.stg_timesheet
CREATE OR ALTER VIEW staging.stg_timesheet AS
SELECT
    NULLIF(TRIM(timesheet_id), '')                                           AS timesheet_id,
    NULLIF(TRIM(employee_code), '')                                          AS employee_id,
    TRY_CONVERT(DATE, NULLIF(TRIM(timesheet_transaction_date), ''), 23)      AS timesheet_transaction_date,
    TRY_CONVERT(TIME(0), NULLIF(TRIM(start_time), ''))                       AS start_time,
    TRY_CONVERT(TIME(0), NULLIF(TRIM(end_time), ''))                         AS end_time,
    TRY_CONVERT(DECIMAL(6, 2), NULLIF(TRIM(timesheet_transaction_hours), '')) AS timesheet_transaction_hours,
    NULLIF(TRIM(pay_period_id), '')                                          AS source_pay_period_id
FROM landing.lnd_timesheet;
GO

-- staging.stg_dates
CREATE OR ALTER VIEW staging.stg_dates AS
SELECT
    TRY_CONVERT(INT, NULLIF(TRIM(date_pk), '')) AS date_pk,
    TRY_CONVERT(DATE, NULLIF(TRIM([date]), ''), 23) AS [date],
    NULLIF(TRIM(date_long_description), '') AS date_long_description,
    NULLIF(TRIM(date_short_description), '') AS date_short_description,
    NULLIF(TRIM(day_long_name), '') AS day_long_name,
    NULLIF(TRIM(day_short_name), '') AS day_short_name,
    NULLIF(TRIM(month_long_name), '') AS month_long_name,
    NULLIF(TRIM(month_short_name), '') AS month_short_name,
    TRY_CONVERT(INT, NULLIF(TRIM(calendar_day), '')) AS calendar_day,
    TRY_CONVERT(INT, NULLIF(TRIM(calendar_week), '')) AS calendar_week,
    TRY_CONVERT(DATE, NULLIF(TRIM(calendar_week_start_date), ''), 23) AS calendar_week_start_date,
    TRY_CONVERT(DATE, NULLIF(TRIM(calendar_week_end_date), ''), 23) AS calendar_week_end_date,
    TRY_CONVERT(INT, NULLIF(TRIM(calendar_day_in_week), '')) AS calendar_day_in_week,
    TRY_CONVERT(INT, NULLIF(TRIM(calendar_month), '')) AS calendar_month,
    TRY_CONVERT(DATE, NULLIF(TRIM(calendar_month_start_date), ''), 23) AS calendar_month_start_date,
    TRY_CONVERT(DATE, NULLIF(TRIM(calendar_month_end_date), ''), 23) AS calendar_month_end_date,
    TRY_CONVERT(INT, NULLIF(TRIM(calendar_number_of_days_in_month), '')) AS calendar_number_of_days_in_month,
    TRY_CONVERT(INT, NULLIF(TRIM(calendar_day_in_month), '')) AS calendar_day_in_month,
    TRY_CONVERT(INT, NULLIF(TRIM(calendar_quarter), '')) AS calendar_quarter,
    TRY_CONVERT(DATE, NULLIF(TRIM(calendar_quarter_start_date), ''), 23) AS calendar_quarter_start_date,
    TRY_CONVERT(DATE, NULLIF(TRIM(calendar_quarter_end_date), ''), 23) AS calendar_quarter_end_date,
    TRY_CONVERT(INT, NULLIF(TRIM(calendar_number_of_days_in_quarter), '')) AS calendar_number_of_days_in_quarter,
    TRY_CONVERT(INT, NULLIF(TRIM(calendar_day_in_quarter), '')) AS calendar_day_in_quarter,
    TRY_CONVERT(INT, NULLIF(TRIM(calendar_year), '')) AS calendar_year,
    TRY_CONVERT(DATE, NULLIF(TRIM(calendar_year_start_date), ''), 23) AS calendar_year_start_date,
    TRY_CONVERT(DATE, NULLIF(TRIM(calendar_year_end_date), ''), 23) AS calendar_year_end_date,
    TRY_CONVERT(INT, NULLIF(TRIM(calendar_number_of_days_in_year), '')) AS calendar_number_of_days_in_year,
    TRY_CONVERT(INT, NULLIF(TRIM(fiscal_year), '')) AS fiscal_year,
    TRY_CONVERT(DATE, NULLIF(TRIM(fiscal_year_start_date), ''), 23) AS fiscal_year_start_date,
    TRY_CONVERT(DATE, NULLIF(TRIM(fiscal_year_end_date), ''), 23) AS fiscal_year_end_date,
    TRY_CONVERT(INT, NULLIF(TRIM(fiscal_month), '')) AS fiscal_month,
    TRY_CONVERT(INT, NULLIF(TRIM(fiscal_quarter), '')) AS fiscal_quarter,
    TRY_CONVERT(DATE, NULLIF(TRIM(fiscal_quarter_start_date), ''), 23) AS fiscal_quarter_start_date,
    TRY_CONVERT(DATE, NULLIF(TRIM(fiscal_quarter_end_date), ''), 23) AS fiscal_quarter_end_date,
    TRY_CONVERT(INT, NULLIF(TRIM(fiscal_week), '')) AS fiscal_week,
    NULLIF(TRIM(pay_period_week), '') AS pay_period_week,
    NULLIF(TRIM(pay_period_month), '') AS pay_period_month,
    NULLIF(TRIM(pay_period_fortnight), '') AS pay_period_fortnight
FROM landing.lnd_dim_dates;
GO

/* ---------------------------------------------------------------------
   5. Marts: dimensions
   --------------------------------------------------------------------- */

-- marts.dim_dates
CREATE OR ALTER VIEW marts.dim_dates AS
SELECT *
FROM staging.stg_dates;
GO

-- marts.dim_contracts
CREATE OR ALTER VIEW marts.dim_contracts AS
SELECT
    CONVERT(CHAR(40), HASHBYTES('SHA1',
        CONCAT_WS('|',
            CAST(contract_id AS NVARCHAR(50)),
            CONVERT(CHAR(19), CAST(start_date AS DATETIME2(0)), 120)
        )
    ), 2) AS contract_pk,   -- surrogate key
    contract_id,
    employee_id,
    start_date,
    end_date,
    pay_rate,
    job_title,
    payment_frequency,
    contract_type,
    employment_type,
    contract_status
FROM staging.stg_contracts;
GO

-- marts.dim_employees
CREATE OR ALTER VIEW marts.dim_employees AS
SELECT
    CONVERT(CHAR(40), HASHBYTES('SHA1',
        CONCAT_WS('|',
            CAST(employee_id AS NVARCHAR(50)),
            CONVERT(CHAR(19), CAST(hire_date AS DATETIME2(0)), 120)
        )
    ), 2) AS employee_pk,   -- surrogate key
    employee_id,
    employee_first_name,
    employee_middle_name,
    employee_last_name,
    employee_gender,
    employee_location,
    date_of_birth,
    hire_date,
    termination_date,
    employee_status
FROM staging.stg_employees;
GO

-- marts.dim_junior_pay_rates
CREATE OR ALTER VIEW marts.dim_junior_pay_rates AS
SELECT
    pay_rate_id AS pay_rate_pk,
    age,
    percent_of_adult_pay_rate / 100.0 AS adult_pay_rate_multiplier
FROM staging.stg_junior_pay_rates;
GO

-- marts.dim_minimum_pay_rates
CREATE OR ALTER VIEW marts.dim_minimum_pay_rates AS
SELECT
    pay_rate_id AS pay_rate_pk,
    effect_from,
    effect_to,
    hourly_permanent_rate,
    hourly_casual_rate
FROM staging.stg_minimum_pay_rates;
GO

-- marts.dim_pay_period
-- One row per pay period for each pay cycle. Keys cannot clash because
-- they are coded 2020W01 (weekly), 2020F01 (fortnightly), 2020M01 (monthly).
-- Assumption: payday is the day after the period ends.
CREATE OR ALTER VIEW marts.dim_pay_period AS
WITH base AS (
    SELECT
        [date],
        pay_period_month,
        pay_period_fortnight,
        pay_period_week
    FROM marts.dim_dates
),
monthly AS (
    SELECT
        pay_period_month AS pay_period_pk,
        MIN([date]) AS period_start_date,
        MAX([date]) AS period_end_date,
        DATEADD(DAY, 1, MAX([date])) AS payday,
        'Monthly' AS frequency,
        DATENAME(MONTH, MIN([date])) + ' ' + CAST(YEAR(MIN([date])) AS VARCHAR(4)) AS pay_period_label
    FROM base
    GROUP BY pay_period_month
),
fortnightly AS (
    SELECT
        pay_period_fortnight AS pay_period_pk,
        MIN([date]) AS period_start_date,
        MAX([date]) AS period_end_date,
        DATEADD(DAY, 1, MAX([date])) AS payday,
        'Fortnightly' AS frequency,
        'Fortnight ' + RIGHT(pay_period_fortnight, 2) + ' ' + DATENAME(MONTH, MIN([date])) + ' ' + CAST(YEAR(MIN([date])) AS VARCHAR(4)) AS pay_period_label
    FROM base
    GROUP BY pay_period_fortnight
),
weekly AS (
    SELECT
        pay_period_week AS pay_period_pk,
        MIN([date]) AS period_start_date,
        MAX([date]) AS period_end_date,
        DATEADD(DAY, 1, MAX([date])) AS payday,
        'Weekly' AS frequency,
        'Week ' + RIGHT(pay_period_week, 2) + ' ' + DATENAME(MONTH, MIN([date])) + ' ' + CAST(YEAR(MIN([date])) AS VARCHAR(4)) AS pay_period_label
    FROM base
    GROUP BY pay_period_week
)
SELECT * FROM monthly
UNION ALL
SELECT * FROM fortnightly
UNION ALL
SELECT * FROM weekly;
GO

-- marts.dim_pay_rate_adjustments
CREATE OR ALTER VIEW marts.dim_pay_rate_adjustments AS
SELECT
    pay_rate_id AS pay_rate_pk,
    rate_type,
    description,
    rate_calculation,
    rate_multiplier
FROM staging.stg_pay_rate_adjustments;
GO

-- marts.dim_tax_rates
CREATE OR ALTER VIEW marts.dim_tax_rates AS
SELECT
    tax_rate_id AS tax_rate_pk,
    taxable_income,
    tax_on_this_income,
    year,
    note,
    start_range,
    end_range,
    date_start,
    date_end,
    fixed_tax,
    marginal_tax_rate
FROM staging.stg_tax_rates;
GO

/* ---------------------------------------------------------------------
   6. Marts: facts
   Each fact row is matched to the employee and to the contract that was
   active on the transaction date. pay_period_fk follows the contract's
   payment frequency and is taken from dim_dates, so every fact uses the
   same pay period definitions as dim_pay_period. Date keys are yyyymmdd
   integers that match dim_dates.date_pk.
   --------------------------------------------------------------------- */

-- marts.fact_allowances
CREATE OR ALTER VIEW marts.fact_allowances AS
SELECT
    a.allowance_id AS allowance_pk,
    e.employee_pk  AS employee_fk,
    c.contract_pk  AS contract_fk,
    a.allowance_type,
    a.allowance_amount,
    a.allowance_start_date,
    a.allowance_end_date,
    CONVERT(INT, CONVERT(CHAR(8), a.allowance_start_date, 112)) AS allowance_start_date_fk,
    CONVERT(INT, CONVERT(CHAR(8), a.allowance_end_date, 112))   AS allowance_end_date_fk,
    CASE LOWER(c.payment_frequency)
        WHEN 'weekly'      THEN d.pay_period_week
        WHEN 'fortnightly' THEN d.pay_period_fortnight
        WHEN 'monthly'     THEN d.pay_period_month
    END AS pay_period_fk
FROM staging.stg_allowances AS a
LEFT JOIN marts.dim_employees AS e
    ON a.employee_id = e.employee_id
LEFT JOIN marts.dim_contracts AS c
    ON a.employee_id = c.employee_id
    AND a.allowance_start_date BETWEEN c.start_date AND ISNULL(c.end_date, '9999-12-31')
LEFT JOIN marts.dim_dates AS d
    ON a.allowance_start_date = d.[date];
GO

-- marts.fact_bonuses
CREATE OR ALTER VIEW marts.fact_bonuses AS
SELECT
    b.bonus_id    AS bonus_pk,
    e.employee_pk AS employee_fk,
    c.contract_pk AS contract_fk,
    b.bonus_type,
    b.bonus_amount,
    b.bonus_date,
    CONVERT(INT, CONVERT(CHAR(8), b.bonus_date, 112)) AS bonus_date_fk,
    CASE LOWER(c.payment_frequency)
        WHEN 'weekly'      THEN d.pay_period_week
        WHEN 'fortnightly' THEN d.pay_period_fortnight
        WHEN 'monthly'     THEN d.pay_period_month
    END AS pay_period_fk
FROM staging.stg_bonuses AS b
LEFT JOIN marts.dim_employees AS e
    ON b.employee_id = e.employee_id
LEFT JOIN marts.dim_contracts AS c
    ON b.employee_id = c.employee_id
    AND b.bonus_date BETWEEN c.start_date AND ISNULL(c.end_date, '9999-12-31')
LEFT JOIN marts.dim_dates AS d
    ON b.bonus_date = d.[date];
GO

-- marts.fact_employee_leaves
-- Every leave record in the source is a single day (start = end), so the
-- pay period of the start date is the pay period of the whole leave.
CREATE OR ALTER VIEW marts.fact_employee_leaves AS
SELECT
    l.leave_id    AS leave_pk,
    e.employee_pk AS employee_fk,
    c.contract_pk AS contract_fk,
    l.leave_type,
    l.leave_start_date,
    l.leave_end_date,
    CONVERT(INT, CONVERT(CHAR(8), l.leave_start_date, 112)) AS leave_start_date_fk,
    CONVERT(INT, CONVERT(CHAR(8), l.leave_end_date, 112))   AS leave_end_date_fk,
    l.leave_hours,
    CASE LOWER(c.payment_frequency)
        WHEN 'weekly'      THEN d.pay_period_week
        WHEN 'fortnightly' THEN d.pay_period_fortnight
        WHEN 'monthly'     THEN d.pay_period_month
    END AS pay_period_fk
FROM staging.stg_employee_leaves AS l
LEFT JOIN marts.dim_employees AS e
    ON l.employee_id = e.employee_id
LEFT JOIN marts.dim_contracts AS c
    ON l.employee_id = c.employee_id
    AND l.leave_start_date BETWEEN c.start_date AND ISNULL(c.end_date, '9999-12-31')
LEFT JOIN marts.dim_dates AS d
    ON l.leave_start_date = d.[date];
GO

-- marts.fact_roster
-- source_pay_period_id is the pay period from the source file, kept for comparison.
CREATE OR ALTER VIEW marts.fact_roster AS
SELECT
    r.roster_id   AS roster_pk,
    e.employee_pk AS employee_fk,
    c.contract_pk AS contract_fk,
    r.shift,
    r.hours,
    r.work_date,
    CONVERT(INT, CONVERT(CHAR(8), r.work_date, 112)) AS work_date_fk,
    r.services,
    r.location,
    CASE LOWER(c.payment_frequency)
        WHEN 'weekly'      THEN d.pay_period_week
        WHEN 'fortnightly' THEN d.pay_period_fortnight
        WHEN 'monthly'     THEN d.pay_period_month
    END AS pay_period_fk,
    r.source_pay_period_id
FROM staging.stg_roster AS r
LEFT JOIN marts.dim_employees AS e
    ON r.employee_id = e.employee_id
LEFT JOIN marts.dim_contracts AS c
    ON r.employee_id = c.employee_id
    AND r.work_date BETWEEN c.start_date AND ISNULL(c.end_date, '9999-12-31')
LEFT JOIN marts.dim_dates AS d
    ON r.work_date = d.[date];
GO

-- marts.fact_time_off_in_lieu
CREATE OR ALTER VIEW marts.fact_time_off_in_lieu AS
SELECT
    t.toil_id     AS toil_pk,
    e.employee_pk AS employee_fk,
    c.contract_pk AS contract_fk,
    t.overtime_date,
    CONVERT(INT, CONVERT(CHAR(8), t.overtime_date, 112)) AS overtime_date_fk,
    t.toil_hours_accrued,
    t.toil_usage_date,
    CONVERT(INT, CONVERT(CHAR(8), t.toil_usage_date, 112)) AS toil_usage_date_fk,
    CASE LOWER(c.payment_frequency)
        WHEN 'weekly'      THEN d.pay_period_week
        WHEN 'fortnightly' THEN d.pay_period_fortnight
        WHEN 'monthly'     THEN d.pay_period_month
    END AS pay_period_fk
FROM staging.stg_time_off_in_lieu AS t
LEFT JOIN marts.dim_employees AS e
    ON t.employee_id = e.employee_id
LEFT JOIN marts.dim_contracts AS c
    ON t.employee_id = c.employee_id
    AND t.overtime_date BETWEEN c.start_date AND ISNULL(c.end_date, '9999-12-31')
LEFT JOIN marts.dim_dates AS d
    ON t.overtime_date = d.[date];
GO

-- marts.fact_timesheet
-- source_pay_period_id is the pay period from the source file, kept for comparison.
CREATE OR ALTER VIEW marts.fact_timesheet AS
SELECT
    t.timesheet_id AS timesheet_pk,
    e.employee_pk  AS employee_fk,
    c.contract_pk  AS contract_fk,
    t.timesheet_transaction_date,
    CONVERT(INT, CONVERT(CHAR(8), t.timesheet_transaction_date, 112)) AS timesheet_transaction_date_fk,
    t.start_time,
    t.end_time,
    t.timesheet_transaction_hours,
    CASE LOWER(c.payment_frequency)
        WHEN 'weekly'      THEN d.pay_period_week
        WHEN 'fortnightly' THEN d.pay_period_fortnight
        WHEN 'monthly'     THEN d.pay_period_month
    END AS pay_period_fk,
    t.source_pay_period_id
FROM staging.stg_timesheet AS t
LEFT JOIN marts.dim_employees AS e
    ON t.employee_id = e.employee_id
LEFT JOIN marts.dim_contracts AS c
    ON t.employee_id = c.employee_id
    AND t.timesheet_transaction_date BETWEEN c.start_date AND ISNULL(c.end_date, '9999-12-31')
LEFT JOIN marts.dim_dates AS d
    ON t.timesheet_transaction_date = d.[date];
GO
