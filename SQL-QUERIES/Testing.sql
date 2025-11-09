use medical;
-- Inspect table columns (run for each table to confirm column names)
SHOW COLUMNS FROM patients;
SHOW COLUMNS FROM doctors;
SHOW COLUMNS FROM appointments;
SHOW COLUMNS FROM treatments;
SHOW COLUMNS FROM billing;
SHOW COLUMNS FROM prescriptions;
SHOW COLUMNS FROM surgeries;

# Descriptive analysis
/* How many records per table? */
SELECT 'patients' AS table_name, COUNT(*) AS n FROM patients
UNION ALL
SELECT 'doctors', COUNT(*) FROM doctors
UNION ALL
SELECT 'appointments', COUNT(*) FROM appointments
UNION ALL
SELECT 'treatments', COUNT(*) FROM treatments
UNION ALL
SELECT 'billing', COUNT(*) FROM billing
UNION ALL
SELECT 'prescriptions', COUNT(*) FROM prescriptions
UNION ALL
SELECT 'surgeries', COUNT(*) FROM surgeries;

/* Billing totals and summary */
SELECT
  COUNT(*) AS total_bills,
  ROUND(SUM(Total),2) AS sum_total,
  ROUND(AVG(Total),2) AS avg_total,
  ROUND(MIN(Total),2) AS min_total,
  ROUND(MAX(Total),2) AS max_total
FROM billing;

/* Patient demographics summary */
SELECT
  COUNT(*) AS total_patients,
  ROUND(AVG(Age),2) AS avg_age,
  SUM(CASE WHEN Gender='Male' THEN 1 ELSE 0 END) AS male_count,
  SUM(CASE WHEN Gender='Female' THEN 1 ELSE 0 END) AS female_count
FROM patients;

/* Treatments summary */
SELECT
  Proced_ure AS Procedure_Type,
  COUNT(*) AS count_treatments,
  ROUND(AVG(Cost),2) AS avg_cost,
  ROUND(AVG(Duration),2) AS avg_duration
FROM treatments
GROUP BY Proced_ure
ORDER BY count_treatments DESC;

# Univariate analysis
/* Frequency of procedures */
SELECT Proced_ure, COUNT(*) AS freq
FROM treatments
GROUP BY Proced_ure
ORDER BY freq DESC;

/* Age distribution buckets */
SELECT
  CASE
    WHEN Age < 18 THEN 'Under 18'
    WHEN Age BETWEEN 18 AND 30 THEN '18-30'
    WHEN Age BETWEEN 31 AND 45 THEN '31-45'
    WHEN Age BETWEEN 46 AND 60 THEN '46-60'
    ELSE '60+'
  END AS Age_Group,
  COUNT(*) AS patients
FROM patients
GROUP BY Age_Group
ORDER BY FIELD(Age_Group,'Under 18','18-30','31-45','46-60','60+');

/* Distribution of bill amounts in buckets */
SELECT
  CASE
    WHEN Total < 1000 THEN '<1k'
    WHEN Total BETWEEN 1000 AND 4999 THEN '1k-4.9k'
    WHEN Total BETWEEN 5000 AND 19999 THEN '5k-19.9k'
    ELSE '20k+'
  END AS Bill_Band,
  COUNT(*) AS count_bills,
  ROUND(AVG(Total),2) AS avg_total
FROM billing
GROUP BY Bill_Band
ORDER BY MIN(Total);

# Bivariate analysis
/* Avg cost by procedure and by gender (2-way) */
SELECT
  t.Proced_ure,
  p.Gender,
  COUNT(*) AS n,
  ROUND(AVG(t.Cost),2) AS avg_cost
FROM treatments t
JOIN patients p ON t.Patient_ID = p.Patient_ID
GROUP BY t.Proced_ure, p.Gender
ORDER BY t.Proced_ure, p.Gender;

/* Appointment wait time vs department (avg) */
SELECT
  a.Department,
  COUNT(*) AS appointments,
  ROUND(AVG(a.Time),2) AS avg_wait_time
FROM appointments a
GROUP BY a.Department
ORDER BY appointments DESC;
select * from appointments;

/* avg total billing by patient's age group */
SELECT
  CASE WHEN p.Age < 30 THEN 'Under30'
       WHEN p.Age BETWEEN 30 AND 50 THEN '30-50'
       ELSE '50plus' END AS Age_Group,
  COUNT(DISTINCT p.Patient_ID) AS patients,
  ROUND(AVG(b.Total),2) AS avg_bill_per_invoice,
  ROUND(SUM(b.Total),2) AS total_revenue
FROM patients p
JOIN billing b ON p.Patient_ID = b.Patient_ID
GROUP BY Age_Group;

/* Avg treatment cost by procedure, department of treating doctor, and patient age group */
SELECT
  t.Proced_ure,
  d.Specialization AS Doctor_Specialty,
  CASE WHEN p.Age < 30 THEN 'U30' WHEN p.Age BETWEEN 30 AND 50 THEN '30-50' ELSE '50+' END AS Age_Group,
  COUNT(*) AS n,
  ROUND(AVG(t.Cost),2) AS avg_cost,
  ROUND(AVG(t.Duration),2) AS avg_duration
FROM treatments t
JOIN doctors d ON t.Doctor_ID = d.Doctor_ID
JOIN patients p ON t.Patient_ID = p.Patient_ID
GROUP BY t.Proced_ure, d.Specialization, Age_Group
ORDER BY avg_cost DESC
LIMIT 200;

# Inferential analysis
/* Prepare summary stats for MRI vs X-Ray cost (mean, sd, n) */
SELECT
  Proced_ure,
  COUNT(*) AS n,
  ROUND(AVG(Cost),2) AS mean_cost,
  ROUND(STDDEV(Cost),2) AS sd_cost
FROM treatments
WHERE Proced_ure IN ('MRI','X-Ray')
GROUP BY Proced_ure;

/* Prepare summary stats for Insured vs Non-Insured billing totals */
SELECT
  CASE WHEN p.Insurance_Status LIKE 'Insured' OR p.Insurance_Status='Yes' OR b.Insurance_Coverage>0 THEN 'Insured' ELSE 'Non-Insured' END AS insurance_group,
  COUNT(*) AS n,
  ROUND(AVG(b.Total),2) AS mean_total,
  ROUND(STDDEV(b.Total),2) AS sd_total
FROM billing b
JOIN patients p ON b.Patient_ID = p.Patient_ID
GROUP BY insurance_group;

# Hypothesis testing
-- Compute Welch t-statistic for MRI vs X-Ray cost
WITH stats AS (
  SELECT
    Proced_ure,
    COUNT(*) AS n,
    AVG(Cost) AS mean_cost,
    STDDEV(Cost) AS sd_cost
  FROM treatments
  WHERE Proced_ure IN ('MRI','X-Ray')
  GROUP BY Proced_ure
)
SELECT
  (MAX(CASE WHEN Proced_ure='MRI' THEN mean_cost END) - MAX(CASE WHEN Proced_ure='X-Ray' THEN mean_cost END)) AS mean_difference,
  SQRT(
    POW(MAX(CASE WHEN Proced_ure='MRI' THEN sd_cost END),2) / MAX(CASE WHEN Proced_ure='MRI' THEN n END)
    +
    POW(MAX(CASE WHEN Proced_ure='X-Ray' THEN sd_cost END),2) / MAX(CASE WHEN Proced_ure='X-Ray' THEN n END)
  ) AS standard_error,
  ( (MAX(CASE WHEN Proced_ure='MRI' THEN mean_cost END) - MAX(CASE WHEN Proced_ure='X-Ray' THEN mean_cost END))
    / SQRT(
      POW(MAX(CASE WHEN Proced_ure='MRI' THEN sd_cost END),2) / MAX(CASE WHEN Proced_ure='MRI' THEN n END)
      +
      POW(MAX(CASE WHEN Proced_ure='X-Ray' THEN sd_cost END),2) / MAX(CASE WHEN Proced_ure='X-Ray' THEN n END)
    )
  ) AS t_value,
  /* approximate degrees of freedom (Welch–Satterthwaite) */
  (
    POW(
      POW(MAX(CASE WHEN Proced_ure='MRI' THEN sd_cost END),2) / MAX(CASE WHEN Proced_ure='MRI' THEN n END)
      +
      POW(MAX(CASE WHEN Proced_ure='X-Ray' THEN sd_cost END),2) / MAX(CASE WHEN Proced_ure='X-Ray' THEN n END)
    ,2)
    /
    (
      ( POW( POW(MAX(CASE WHEN Proced_ure='MRI' THEN sd_cost END),2) / MAX(CASE WHEN Proced_ure='MRI' THEN n END), 2) / (MAX(CASE WHEN Proced_ure='MRI' THEN n END)-1) )
      +
      ( POW( POW(MAX(CASE WHEN Proced_ure='X-Ray' THEN sd_cost END),2) / MAX(CASE WHEN Proced_ure='X-Ray' THEN n END), 2) / (MAX(CASE WHEN Proced_ure='X-Ray' THEN n END)-1) )
    )
  ) AS approx_df
FROM stats;

#Time series analysis
/* Monthly revenue trend */
SELECT
  DATE_FORMAT(Date, '%Y-%m') AS YearMonth,
  COUNT(Bill_ID) AS bill_count,
  ROUND(SUM(Total),2) AS revenue
FROM billing
GROUP BY YearMonth
ORDER BY YearMonth;

/* Appointments per week trend */
SELECT
  YEAR(Appointments.Date) AS yr,
  WEEK(Appointments.Date,1) AS week_of_year,
  COUNT(Appointment_ID) AS appointments
FROM appointments
GROUP BY yr, week_of_year
ORDER BY yr, week_of_year;

/* Rolling 3-month revenue (requires MySQL 8+ window functions) */
SELECT
  YearMonth,
  revenue,
  ROUND(AVG(revenue) OVER (ORDER BY YearMonth ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS rolling_3mo_avg
FROM (
  SELECT DATE_FORMAT(Date,'%Y-%m') AS YearMonth, SUM(Total) AS revenue
  FROM billing
  GROUP BY YearMonth
) m;

# Exploratory Data Analysis
/* Null counts by column (example for main tables) */
SELECT 'patients' AS table_name,
  SUM(CASE WHEN Patient_ID IS NULL THEN 1 ELSE 0 END) AS Patient_ID_null,
  SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Age_null,
  SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS Gender_null
FROM patients;

SELECT 'billing' AS table_name,
  SUM(CASE WHEN Total IS NULL THEN 1 ELSE 0 END) AS Total_null,
  SUM(CASE WHEN Bill_Date IS NULL THEN 1 ELSE 0 END) AS Bill_Date_null
FROM billing;


/* Simple pairwise covariance approx (by computing means & cross-products) */
SELECT
  AVG(Cost) AS mean_cost,
  AVG(Duration) AS mean_duration,
  (AVG(Cost*Duration) - AVG(Cost)*AVG(Duration)) AS cov_cost_duration
FROM treatments;

# Comparative analysis
/* Average bill: insured vs non-insured (basic comparison) */
SELECT
  CASE WHEN p.Insurance_Status IN ('Insured', 'Yes') OR b.Insurance_Coverage>0 THEN 'Insured' ELSE 'Non-Insured' END AS insurance_group,
  COUNT(*) AS n_bills,
  ROUND(AVG(b.Total),2) AS avg_total,
  ROUND(STDDEV(b.Total),2) AS sd_total
FROM billing b
JOIN patients p ON b.Patient_ID = p.Patient_ID
GROUP BY insurance_group;

/* Compare average treatment cost by doctor specialization */
SELECT
  d.Specialization,
  COUNT(t.Treatment_ID) AS num_treatments,
  ROUND(AVG(t.Cost),2) AS avg_cost
FROM treatments t
JOIN doctors d ON t.Doctor_ID = d.Doctor_ID
GROUP BY d.Specialization
ORDER BY avg_cost DESC LIMIT 20;

# SWOT analysis
/* Weakness evidence: top procedures with high cancellation or readmission rates */
SELECT t.Proced_ure, COUNT(*) AS total_cases,
  SUM(CASE WHEN t.Outcome='Readmit' THEN 1 ELSE 0 END) AS readmit_count
FROM treatments t
GROUP BY t.Proced_ure
ORDER BY readmit_count DESC;

-- Compare surgery success rate between two types
SELECT 
    Type,
    ROUND(SUM(CASE WHEN Outcome = 'Successful' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Success_Rate
FROM Surgeries
WHERE type IN ('Liver', 'Eye')
GROUP BY Type;


/* growing procedure trends (last 12 months) */
SELECT Proced_ure, DATE_FORMAT(Date,'%Y-%m') AS ym, COUNT(*) cnt
FROM treatments
WHERE Date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
GROUP BY Proced_ure, ym
ORDER BY Proced_ure, ym;

/*  unpaid balances per month */
SELECT DATE_FORMAT(Date,'%Y-%m') AS ym,
  ROUND(SUM(CASE WHEN b.Balance>0 THEN b.Balance ELSE 0 END),2) AS unpaid_balance,
  ROUND(SUM(b.Total),2) AS total_billed,
  ROUND(SUM(CASE WHEN b.Balance>0 THEN b.Balance ELSE 0 END)/SUM(b.Total)*100,2) AS unpaid_pct
FROM billing b
GROUP BY ym
ORDER BY ym DESC;

# A/B Testing (Split testing)
/*Descriptive summary for MRI vs X-Ray cost & duration */
SELECT
  Proced_ure, COUNT(*) AS n, ROUND(AVG(Cost),2) AS mean_cost, ROUND(STDDEV(Cost),2) AS sd_cost,
  ROUND(AVG(Duration),2) AS mean_dur, ROUND(STDDEV(Duration),2) AS sd_dur
FROM treatments
WHERE Proced_ure IN ('MRI','X-Ray')
GROUP BY Proced_ure;

-- Compare average billing by gender
SELECT 
    p.Gender,
    ROUND(AVG(b.Total), 2) AS Avg_Billing,
    COUNT(b.Bill_ID) AS Total_Bills
FROM Billing b
JOIN Patients p ON b.Patient_ID = p.Patient_ID
GROUP BY p.Gender;

-- Compare average prescription cost between generic and branded medicines
SELECT 
    Medicine_Name,
    ROUND(AVG(Duration), 2) AS Avg_Medicine_Duration,
    COUNT(Prescription_ID) AS Total_Prescriptions
FROM Prescriptions
WHERE Medicine_Name IN ('Metformin', 'Aspirin')
GROUP BY Medicine_name;

-- Compare total revenue on weekdays vs weekends
SELECT 
    CASE 
        WHEN DAYOFWEEK(Date) IN (1,7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS Day_Type,
    ROUND(SUM(Total), 2) AS Total_Revenue
FROM Billing
GROUP BY Day_Type;

-- Compare treatment success rate between two departments
SELECT 
    d.Department,
    ROUND(SUM(CASE WHEN t.Outcome = 'Successful' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Success_Rate
FROM Treatments t
JOIN Doctors d ON t.Doctor_ID = d.Doctor_ID
WHERE d.Department IN ('Cardiology', 'Orthopedics')
GROUP BY d.Department
ORDER BY Success_Rate DESC;

