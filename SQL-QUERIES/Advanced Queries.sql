use medical;
SELECT 
    Proced_ure AS Procedure_Type,
    COUNT(*) AS Total_Treatments,
    AVG(Cost) AS Avg_Cost,
    STDDEV(Cost) AS SD_Cost
FROM treatments
WHERE Proced_ure IN ('Blood Test', 'X-Ray', 'MRI')
GROUP BY Proced_ure;


SELECT 
    Proced_ure,
    COUNT(*) AS total_cases,
    ROUND(AVG(Cost), 2) AS avg_cost,
    ROUND(AVG(Duration), 2) AS avg_duration,
    ROUND(STDDEV(Cost), 2) AS stddev_cost
FROM treatments
WHERE Proced_ure IN ('MRI', 'X-Ray')
GROUP BY Proced_ure;

-- Compare male vs female patients
SELECT 
    Gender,
    COUNT(*) AS total_patients,
    ROUND(AVG(Age), 2) AS avg_age
FROM patients
GROUP BY Gender;

-- Compare departments by number of doctors and average salary
SELECT 
    Department,
    COUNT(*) AS total_doctors,
    ROUND(AVG(Salary), 2) AS avg_salary,
    ROUND(AVG(Years_Experience), 2) AS avg_experience
FROM doctors
GROUP BY Department;

-- Compare online vs in-person appointments
SELECT 
    reason,
    COUNT(*) AS total_appointments,
    ROUND(AVG(Time), 2) AS avg_wait_time
FROM appointments
GROUP BY reason;

-- Compare procedures (e.g., MRI, X-Ray, Blood Test)
SELECT 
    Proced_ure,
    COUNT(*) AS total_treatments,
    ROUND(AVG(Cost), 2) AS avg_cost,
    ROUND(AVG(Duration), 2) AS avg_duration
FROM treatments
GROUP BY Proced_ure;

-- Compare most prescribed medicines
SELECT 
    Medicine_Name,
    COUNT(*) AS total_prescriptions,
    ROUND(AVG(Dosage), 2) AS avg_dosage
FROM prescriptions
GROUP BY Medicine_Name
ORDER BY total_prescriptions DESC
LIMIT 10;

-- Compare payment methods by total revenue and discount
SELECT 
    Payment_Method,
    COUNT(*) AS total_bills,
    ROUND(SUM(Total), 2) AS total_revenue,
    ROUND(AVG(Discount), 2) AS avg_discount
FROM billing
GROUP BY Payment_Method;

-- Compare surgery types by average cost and duration
SELECT 
    Type,
    COUNT(*) AS total_surgeries,
    ROUND(AVG(Cost), 2) AS avg_cost,
    ROUND(AVG(Duration), 2) AS avg_duration
FROM surgeries
GROUP BY Type;

-- Compare shifts by number of doctors assigned
SELECT 
    Shift,
    COUNT(*) AS total_doctors,
    ROUND(AVG(Salary), 2) AS avg_salary
FROM doctors
GROUP BY Shift;




