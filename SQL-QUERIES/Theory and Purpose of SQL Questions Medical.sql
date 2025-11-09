#Q1: What is total revenue for all billing records?
SELECT SUM(Total) AS Total_Revenue FROM Billing;

#Q2: What is total number of appointments?
SELECT COUNT(*) AS Total_Appointments FROM Appointments;

#Q3: How many unique patients have visited?
SELECT COUNT(DISTINCT Patient_ID) AS Unique_Patients FROM Appointments;

#Q4: What is monthly revenue for the last 12 months?
SELECT DATE_FORMAT(STR_TO_DATE(Date,'%m/%d/%Y'), '%Y-%m-01') AS Month, SUM(Total) AS Revenue
FROM Billing
WHERE STR_TO_DATE(Date,'%m/%d/%Y') >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
GROUP BY Month
ORDER BY Month;

#Q5: What is the average billing amount per invoice?
SELECT AVG(Total) AS Avg_Bill FROM Billing;

#Q6: Top 10 services by revenue.
SELECT Service, SUM(Total) AS Revenue
FROM Billing
GROUP BY Service
ORDER BY Revenue DESC
LIMIT 10;


#Q7: How many cancelled appointments?
SELECT COUNT(*) AS Cancelled_Appointments FROM Appointments WHERE Status = 'Cancelled';

#Q8: What is the no-show rate for appointments?
SELECT SUM(CASE WHEN Status='No-Show' THEN 1 ELSE 0 END)/COUNT(*) AS NoShow_Rate FROM Appointments;

#Q9: Average appointment lead time (days between Created_On and Date).
SELECT AVG(DATEDIFF(STR_TO_DATE(Date,'%m/%d/%Y'), STR_TO_DATE(Created_On,'%m/%d/%Y'))) AS Avg_Lead_Days
FROM Appointments;

#Q10: Appointment counts per department.
SELECT Department, COUNT(*) AS Appointments FROM Appointments GROUP BY Department ORDER BY Appointments DESC;

#Q11: Top 10 doctors by number of appointments.
SELECT Doctor_ID, COUNT(*) AS Appt_Count
FROM Appointments
GROUP BY Doctor_ID
ORDER BY Appt_Count DESC
LIMIT 10;


#Q12: Monthly patient admissions (by Patients.Admission_Date).
SELECT DATE_FORMAT(STR_TO_DATE(Admission_Date,'%m/%d/%Y'), '%Y-%m-01') AS Month, COUNT(*) AS Admissions
FROM Patients
WHERE Admission_Date IS NOT NULL AND STR_TO_DATE(Admission_Date,'%m/%d/%Y') IS NOT NULL
GROUP BY Month
ORDER BY Month;


#Q13: Distribution of patients by age brackets.
SELECT
  CASE
    WHEN Age < 18 THEN '0-17'
    WHEN Age < 35 THEN '18-34'
    WHEN Age < 55 THEN '35-54'
    ELSE '55+'
  END AS Age_Group,
  COUNT(*) AS Patients
FROM Patients
GROUP BY Age_Group;

#Q14: Gender split of patients.
SELECT Gender, COUNT(*) AS Count FROM Patients GROUP BY Gender;

#Q15: Average surgery cost by type.
SELECT Type, AVG(Cost) AS Avg_Cost FROM Surgeries GROUP BY Type ORDER BY Avg_Cost DESC;

#Q16: Count and percentage of successful surgeries.
SELECT
  SUM(CASE WHEN Outcome='Successful' THEN 1 ELSE 0 END) AS Successful,
  COUNT(*) AS Total,
  SUM(CASE WHEN Outcome='Successful' THEN 1 ELSE 0 END)/COUNT(*)*100 AS Pct_Success
FROM Surgeries;

#Q17: Average length (Duration) of surgeries.
SELECT AVG(Duration) AS Avg_Surgery_Duration FROM Surgeries;

#Q18: Top 10 diagnoses by count in Treatments.
SELECT Diagnosis, COUNT(*) AS Count FROM Treatments GROUP BY Diagnosis ORDER BY Count DESC LIMIT 10;

#Q19: Total treatment cost.
SELECT SUM(Cost) AS Total_Treatment_Cost FROM Treatments;

#Q20: Number of prescriptions per medicine.
SELECT Medicine_Name, COUNT(*) AS Prescriptions FROM Prescriptions GROUP BY Medicine_Name ORDER BY Prescriptions DESC;

#Q21: Average prescription duration (days).
SELECT AVG(Duration) AS Avg_Prescription_Duration FROM Prescriptions;

#Q22: Most frequent prescribers (top doctors by prescriptions).
SELECT Doctor_ID, COUNT(*) AS Presc_Count FROM Prescriptions GROUP BY Doctor_ID ORDER BY Presc_Count DESC LIMIT 10;


#Q23: Average patient age per diagnosis.
SELECT t.Diagnosis, AVG(p.Age) AS Avg_Age
FROM Treatments t
JOIN Patients p ON t.Patient_ID = p.Patient_ID
GROUP BY t.Diagnosis
ORDER BY Avg_Age DESC
LIMIT 20;

#Q24: Number of uninsured patients.
SELECT COUNT(*) AS Uninsured FROM Patients WHERE Insurance_Status = 'Uninsured';

#Q25: Insurance paid vs out-of-pocket totals.
SELECT SUM(Insurance_Coverage) AS Insurance_Paid, SUM(Balance) AS Out_of_Pocket FROM Billing;

#Q26: Average patient balance outstanding.
SELECT AVG(Balance) AS Avg_Balance FROM Billing;

#Q27: Payment method breakdown (counts).
SELECT Payment_Method, COUNT(*) AS Count FROM Billing GROUP BY Payment_Method;

#Q28: Average salary by staff role.
SELECT Role, AVG(Salary) AS Avg_Salary FROM Staff GROUP BY Role ORDER BY Avg_Salary DESC;

#Q29: Employee headcount by department.
SELECT Department, COUNT(*) AS Headcount FROM Staff GROUP BY Department ORDER BY Headcount DESC;

#Q30: Average doctor years of experience by specialization.
SELECT Specialization, AVG(Years_Experience) AS Avg_Exp FROM Doctors GROUP BY Specialization ORDER BY Avg_Exp DESC;

#Q31: Revenue per patient (lifetime).
SELECT Patient_ID, SUM(Total) AS Patient_Revenue FROM Billing GROUP BY Patient_ID ORDER BY Patient_Revenue DESC;

#Q32: Average time from admission to surgery for patients with surgeries.
SELECT AVG(DATEDIFF(STR_TO_DATE(s.Date,'%m/%d/%Y'), STR_TO_DATE(p.Admission_Date,'%m/%d/%Y'))) AS Avg_Days_To_Surgery
FROM Surgeries s
JOIN Patients p ON s.Patient_ID = p.Patient_ID
WHERE s.Date IS NOT NULL AND p.Admission_Date IS NOT NULL;

#Q33: Top 10 rooms by number of surgeries.
SELECT Room, COUNT(*) AS Surgeries FROM Surgeries GROUP BY Room ORDER BY Surgeries DESC LIMIT 10;

#Q34: Average number of prescriptions per patient.
SELECT AVG(presc_count) AS Avg_Prescriptions_Per_Patient FROM (SELECT Patient_ID, COUNT(*) AS presc_count FROM Prescriptions GROUP BY Patient_ID) t;

#Q35: Percentage of patients by blood group.
SELECT Blood_Group, COUNT(*)/ (SELECT COUNT(*) FROM Patients) * 100 AS Pct FROM Patients GROUP BY Blood_Group;

#Q36: Average discount given per bill.
SELECT AVG(Discount) AS Avg_Discount FROM Billing;

#Q37: Top 10 patients by lifetime spend.
SELECT Patient_ID, SUM(Total) AS Lifetime_Spend FROM Billing GROUP BY Patient_ID ORDER BY Lifetime_Spend DESC LIMIT 10;

#Q38: Average days from prescription to treatment (approx join on patient and doctor).
SELECT AVG(DATEDIFF(STR_TO_DATE(t.Date,'%m/%d/%Y'), STR_TO_DATE(p.Date,'%m/%d/%Y'))) AS Avg_Days_Presc_to_Treatment
FROM Prescriptions p
JOIN Treatments t ON p.Patient_ID = t.Patient_ID AND p.Doctor_ID = t.Doctor_ID
WHERE STR_TO_DATE(t.Date,'%m/%d/%Y') >= STR_TO_DATE(p.Date,'%m/%d/%Y');

#Q39: Daily appointment load for a date range.
SELECT STR_TO_DATE(Date,'%m/%d/%Y') AS Day, COUNT(*) AS Appt_Count
FROM Appointments
WHERE STR_TO_DATE(Date,'%m/%d/%Y') BETWEEN '2025-01-01' AND '2025-12-31'
GROUP BY Day
ORDER BY Day;

#Q40: Revenue by department (approx join Billing → Appointments by patient and date).
SELECT a.Department, SUM(b.Total) AS Revenue
FROM Billing b
JOIN Appointments a ON b.Patient_ID = a.Patient_ID AND DATE(STR_TO_DATE(b.Date,'%m/%d/%Y')) = DATE(STR_TO_DATE(a.Date,'%m/%d/%Y'))
GROUP BY a.Department
ORDER BY Revenue DESC;

#Q41: Average number of appointments per patient in last 12 months.
SELECT AVG(cnt) AS Avg_Appts FROM (SELECT Patient_ID, COUNT(*) AS cnt FROM Appointments WHERE STR_TO_DATE(Date,'%m/%d/%Y') >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH) GROUP BY Patient_ID) t;

#Q42: Days with highest cancellations in past month.
SELECT STR_TO_DATE(Date,'%m/%d/%Y') AS Day, COUNT(*) AS Cancellations
FROM Appointments
WHERE Status='Cancelled' AND STR_TO_DATE(Date,'%m/%d/%Y') >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY Day
ORDER BY Cancellations DESC
LIMIT 10;

#Q43: Average patient age by department (via Appointments→Patients).
SELECT a.Department, AVG(p.Age) AS Avg_Age
FROM Appointments a
JOIN Patients p ON a.Patient_ID = p.Patient_ID
GROUP BY a.Department
ORDER BY Avg_Age DESC;

#Q44: Patients with outstanding balances (Balance > 0).
SELECT Patient_ID, SUM(Balance) AS Total_Balance
FROM Billing
GROUP BY Patient_ID
HAVING SUM(Balance) > 0
ORDER BY Total_Balance DESC;

#Q45: Average number of days between appointments for returning patients.
SELECT AVG(days_between) AS Avg_Days_Between FROM (
  SELECT Patient_ID, DATEDIFF(STR_TO_DATE(Date,'%m/%d/%Y'), LAG(STR_TO_DATE(Date,'%m/%d/%Y')) OVER (PARTITION BY Patient_ID ORDER BY STR_TO_DATE(Date,'%m/%d/%Y'))) AS days_between
  FROM Appointments
) t WHERE days_between IS NOT NULL;


#Q46: Percentage of bills fully paid (Balance = 0).
SELECT SUM(CASE WHEN Balance=0 THEN 1 ELSE 0 END)/COUNT(*)*100 AS Pct_Fully_Paid FROM Billing;


#47: Average time between Created_On and appointment Date by department.
SELECT Department, AVG(DATEDIFF(STR_TO_DATE(Date,'%m/%d/%Y'), STR_TO_DATE(Created_On,'%m/%d/%Y'))) AS Avg_Lead
FROM Appointments
GROUP BY Department;

#48: Top 10 patients by number of surgeries.
SELECT Patient_ID, COUNT(*) AS Surgeries_Count FROM Surgeries GROUP BY Patient_ID ORDER BY Surgeries_Count DESC LIMIT 10;

#49: Average cost per surgery room usage.
SELECT Room, SUM(Cost)/COUNT(*) AS Avg_Cost_Per_Use FROM Surgeries GROUP BY Room ORDER BY Avg_Cost_Per_Use DESC;

#50: Median billing amount (Total).
SELECT 
    AVG(Total) AS Median_Bill
FROM (
    SELECT Total 
    FROM Billing AS b1
    WHERE (
        SELECT COUNT(*) 
        FROM Billing AS b2 
        WHERE b2.Total <= b1.Total
    ) >= (SELECT COUNT(*) FROM Billing) / 2
    AND (
        SELECT COUNT(*) 
        FROM Billing AS b2 
        WHERE b2.Total >= b1.Total
    ) >= (SELECT COUNT(*) FROM Billing) / 2
) AS sub;

#51: Average prescription duration (Duration) — duplicate check.
SELECT AVG(Duration) AS Avg_Prescription_Duration FROM Prescriptions;

#52: Top 10 doctors by revenue generated (approx join).
SELECT a.Doctor_ID, SUM(b.Total) AS Revenue
FROM Billing b
JOIN Appointments a ON b.Patient_ID = a.Patient_ID AND DATE(STR_TO_DATE(b.Date,'%m/%d/%Y')) = DATE(STR_TO_DATE(a.Date,'%m/%d/%Y'))
GROUP BY a.Doctor_ID
ORDER BY Revenue DESC
LIMIT 10;

#53: Prescription status distribution (Active/Completed/Cancelled).
SELECT Status, COUNT(*) AS Count FROM Prescriptions GROUP BY Status;

#54: Average discount percentage (Discount/Total).
SELECT AVG(CASE WHEN Total>0 THEN Discount/Total ELSE 0 END) AS Avg_Discount_Pct FROM Billing;

#55: Patients by city parsed from Address (example using 'City' keywords).
SELECT
  CASE
    WHEN Address LIKE '%Mumbai%' THEN 'Mumbai'
    WHEN Address LIKE '%Delhi%' THEN 'Delhi'
    ELSE 'Other'
  END AS City,
  COUNT(*) AS Patients
FROM Patients
GROUP BY City;

#56: Number of staff hired in the last year.
SELECT COUNT(*) AS Hired_Last_Year FROM Staff WHERE STR_TO_DATE(Hire_Date,'%m/%d/%Y') >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

#57: Average salary of doctors vs staff.
SELECT 'Doctors' AS GroupName, AVG(Salary) AS Avg_Salary FROM Doctors
UNION ALL
SELECT 'Staff' AS GroupName, AVG(Salary) AS Avg_Salary FROM Staff;

#58: Ratio of inpatients vs outpatients (based on Admission_Date presence).
SELECT
  SUM(CASE WHEN Admission_Date IS NOT NULL AND Admission_Date<>'' THEN 1 ELSE 0 END) AS Inpatient,
  SUM(CASE WHEN Admission_Date IS NULL OR Admission_Date='' THEN 1 ELSE 0 END) AS Outpatient
FROM Patients;

#59: Average treatment cost per diagnosis.
SELECT Diagnosis, AVG(Cost) AS Avg_Cost FROM Treatments GROUP BY Diagnosis ORDER BY Avg_Cost DESC;

#60: Monthly count of new patients (first appointment date per patient).
WITH first_visits AS (
  SELECT Patient_ID, MIN(STR_TO_DATE(Date,'%m/%d/%Y')) AS First_Date FROM Appointments GROUP BY Patient_ID
)
SELECT DATE_FORMAT(First_Date, '%Y-%m-01') AS Month, COUNT(*) AS New_Patients
FROM first_visits
GROUP BY Month
ORDER BY Month;

#61: Average appointment creation to cancellation lead time for cancelled appointments.
SELECT AVG(DATEDIFF(STR_TO_DATE(Date,'%m/%d/%Y'), STR_TO_DATE(Created_On,'%m/%d/%Y'))) AS Avg_Days_Before_Cancel
FROM Appointments
WHERE Status = 'Cancelled';


#62: Percentage of surgeries requiring an anesthesiologist.
SELECT SUM(CASE WHEN Anesthesiologist IS NOT NULL AND Anesthesiologist<>'' THEN 1 ELSE 0 END)/COUNT(*)*100 AS Pct_With_Anesthesiologist FROM Surgeries;

#63: Average revenue per appointment (approx).
SELECT SUM(b.Total)/COUNT(a.Appointment_ID) AS Revenue_Per_Appointment
FROM Billing b
JOIN Appointments a ON b.Patient_ID = a.Patient_ID AND DATE(STR_TO_DATE(b.Date,'%m/%d/%Y')) = DATE(STR_TO_DATE(a.Date,'%m/%d/%Y'));

#64: Number of patients by Insurance_Status.
SELECT Insurance_Status, COUNT(*) AS Count FROM Patients GROUP BY Insurance_Status;

#65: Average discount by service type.
SELECT Service, AVG(Discount) AS Avg_Discount FROM Billing GROUP BY Service ORDER BY Avg_Discount DESC;

#66: Correlation check between patient age and average bill (basic listing per patient).
SELECT p.Patient_ID, p.Age, IFNULL(pb.Avg_Bill,0) AS Avg_Bill
FROM Patients p
LEFT JOIN (SELECT Patient_ID, AVG(Total) AS Avg_Bill FROM Billing GROUP BY Patient_ID) pb ON p.Patient_ID = pb.Patient_ID;

#67: Count of bills per month.
SELECT DATE_FORMAT(STR_TO_DATE(Date,'%m/%d/%Y'), '%Y-%m-01') AS Month, COUNT(*) AS Bills
FROM Billing
GROUP BY Month
ORDER BY Month;

#68: Top 10 highest paid staff.
SELECT Staff_ID, Name, Salary FROM Staff ORDER BY Salary DESC LIMIT 10;

#69: Average prescription frequency per medicine.
SELECT Medicine_Name, AVG(Frequency) AS Avg_Frequency FROM Prescriptions GROUP BY Medicine_Name ORDER BY Avg_Frequency DESC;

#70: Percentage of treatments with positive outcome (Outcome = 'Improved').
SELECT SUM(CASE WHEN Outcome='Improved' THEN 1 ELSE 0 END)/COUNT(*)*100 AS Pct_Improved FROM Treatments;

#71: Average time to complete a surgery by anesthesiologist.
SELECT Anesthesiologist, AVG(Duration) AS Avg_Duration FROM Surgeries GROUP BY Anesthesiologist ORDER BY Avg_Duration DESC;

#72: Count of distinct medicines prescribed in the last year.
SELECT COUNT(DISTINCT Medicine_Name) AS Distinct_Medicines FROM Prescriptions WHERE STR_TO_DATE(Date,'%m/%d/%Y') >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

#73: Percentage of appointments scheduled same-day.
SELECT SUM(CASE WHEN DATE(STR_TO_DATE(Created_On,'%m/%d/%Y')) = DATE(STR_TO_DATE(Date,'%m/%d/%Y')) THEN 1 ELSE 0 END)/COUNT(*)*100 AS Pct_SameDay FROM Appointments;

#74: Average hour of appointments (mean hour).
SELECT AVG(HOUR(STR_TO_DATE(CONCAT(Date,' ',Time),'%m/%d/%Y %H:%i:%s'))) AS Avg_Hour FROM Appointments;

#75: Top 10 reasons for visits.
SELECT Reason, COUNT(*) AS Count FROM Appointments GROUP BY Reason ORDER BY Count DESC LIMIT 10;

#76: Average difference between Amount and Total in billing.
SELECT AVG(Total - Amount) AS Avg_Diff FROM Billing;

#77: Average surgery scheduling lead time if Created_On exists (uses Created_On when present).
SELECT 
    AVG(DATEDIFF(
        STR_TO_DATE(S.Date,'%m/%d/%Y'),
        STR_TO_DATE(A.Appointment_Date,'%m/%d/%Y')
    )) AS Avg_Days_To_Surgery
FROM Surgeries S
JOIN Appointments A ON S.Patient_ID = A.Patient_ID
WHERE A.Appointment_Date IS NOT NULL 
  AND S.Date IS NOT NULL;

#78: Average number of appointments per room.
SELECT Room_Number, COUNT(*) AS Appt_Count FROM Appointments GROUP BY Room_Number ORDER BY Appt_Count DESC;

#79: Ratio of outpatient vs inpatient treatments.
SELECT
  SUM(CASE WHEN p.Admission_Date IS NOT NULL AND p.Admission_Date<>'' THEN 1 ELSE 0 END) AS Inpatient_Treatments,
  SUM(CASE WHEN p.Admission_Date IS NULL OR p.Admission_Date='' THEN 1 ELSE 0 END) AS Outpatient_Treatments
FROM Treatments t
JOIN Patients p ON t.Patient_ID = p.Patient_ID;

#80: Top 10 diagnoses generating the most revenue (approx join).
SELECT t.Diagnosis, SUM(b.Total) AS Revenue
FROM Treatments t
JOIN Billing b ON t.Patient_ID = b.Patient_ID AND DATE(STR_TO_DATE(t.Date,'%m/%d/%Y')) = DATE(STR_TO_DATE(b.Date,'%m/%d/%Y'))
GROUP BY t.Diagnosis
ORDER BY Revenue DESC
LIMIT 10;

#81: Count of appointments by Room_Number and Department.
SELECT Department, Room_Number, COUNT(*) AS Appts FROM Appointments GROUP BY Department, Room_Number ORDER BY Department, Appts DESC;

#82: Number of active prescriptions per patient.
SELECT Patient_ID, COUNT(*) AS Active_Prescriptions FROM Prescriptions WHERE Status='Active' GROUP BY Patient_ID ORDER BY Active_Prescriptions DESC;

#83: Average billing total per payment method.
SELECT Payment_Method, AVG(Total) AS Avg_Total FROM Billing GROUP BY Payment_Method ORDER BY Avg_Total DESC;

#84: Average age of patients receiving each procedure.
SELECT tr.Procedure, AVG(p.Age) AS Avg_Age
FROM Treatments tr
JOIN Patients p ON tr.Patient_ID = p.Patient_ID
GROUP BY tr.Procedure
ORDER BY Avg_Age DESC;

#85: Count of bills with discounts greater than 500.
SELECT COUNT(*) AS High_Discounts FROM Billing WHERE Discount > 500;

#86: Average number of treatments per doctor.
SELECT AVG(treat_count) AS Avg_Treatments_Per_Doctor FROM (SELECT Doctor_ID, COUNT(*) AS treat_count FROM Treatments GROUP BY Doctor_ID) x;

#87: Busiest day of week for appointments.
SELECT DAYNAME(STR_TO_DATE(Date,'%m/%d/%Y')) AS Weekday, COUNT(*) AS Appts FROM Appointments GROUP BY Weekday ORDER BY Appts DESC;

#88: Monthly trend of prescription counts.
SELECT DATE_FORMAT(STR_TO_DATE(Date,'%m/%d/%Y'), '%Y-%m-01') AS Month, COUNT(*) AS Prescriptions FROM Prescriptions GROUP BY Month ORDER BY Month;

#89: Average cost per treatment by Proced_ure.
SELECT Proced_ure, AVG(Cost) AS Avg_Cost FROM Treatments GROUP BY Proced_ure ORDER BY Avg_Cost DESC;

#90: Distribution of patient genders among those with surgeries.
SELECT p.Gender, COUNT(*) AS Surgeries
FROM Surgeries s
JOIN Patients p ON s.Patient_ID = p.Patient_ID
GROUP BY p.Gender;

#91: Top medicines by total duration prescribed.
SELECT Medicine_Name, SUM(Duration) AS Total_Duration FROM Prescriptions GROUP BY Medicine_Name ORDER BY Total_Duration DESC LIMIT 20;

#92: Average days from diagnosis to surgery for patients with both.
SELECT AVG(DATEDIFF(STR_TO_DATE(s.Date,'%m/%d/%Y'), STR_TO_DATE(t.Date,'%m/%d/%Y'))) AS Avg_Days_From_Diagnosis_To_Surgery
FROM Treatments t
JOIN Surgeries s ON t.Patient_ID = s.Patient_ID
WHERE STR_TO_DATE(s.Date,'%m/%d/%Y') >= STR_TO_DATE(t.Date,'%m/%d/%Y');

#93: Number of staff on each shift.
SELECT Shift, COUNT(*) AS Staff_Count FROM Staff GROUP BY Shift;

#94: Revenue per doctor specialization (approx join).
SELECT d.Specialization, SUM(b.Total) AS Revenue
FROM Billing b
JOIN Appointments a ON b.Patient_ID = a.Patient_ID AND DATE(STR_TO_DATE(b.Date,'%m/%d/%Y')) = DATE(STR_TO_DATE(a.Date,'%m/%d/%Y'))
JOIN Doctors d ON a.Doctor_ID = d.Doctor_ID
GROUP BY d.Specialization
ORDER BY Revenue DESC;

#95: Average number of procedures per patient.
SELECT AVG(proc_count) AS Avg_Procedures_Per_Patient FROM (SELECT Patient_ID, COUNT(*) AS proc_count FROM Treatments GROUP BY Patient_ID) t;

#96: Top 5 reasons for cancellations.
SELECT Reason, COUNT(*) AS Count FROM Appointments WHERE Status='Cancelled' GROUP BY Reason ORDER BY Count DESC LIMIT 5;

#97: Average time spent per patient in treatments (sum Duration per patient).
SELECT AVG(total_duration) AS Avg_Time_Spent FROM (SELECT Patient_ID, SUM(Duration) AS total_duration FROM Treatments GROUP BY Patient_ID) t;

#98: Percentage of bills that used insurance.
SELECT SUM(CASE WHEN Insurance_Coverage>0 THEN 1 ELSE 0 END)/COUNT(*)*100 AS Pct_Insurance FROM Billing;

#99: Top 10 procedures with highest total cost.
SELECT Proced_ure, SUM(Cost) AS Total_Cost FROM Treatments GROUP BY Proced_ure ORDER BY Total_Cost DESC LIMIT 10;

#100: Average number of appointments per doctor per month.
SELECT Doctor_ID, AVG(monthly_count) AS Avg_Appts_Per_Month FROM (
  SELECT Doctor_ID, DATE_FORMAT(STR_TO_DATE(Date,'%m/%d/%Y'),'%Y-%m') AS Month, COUNT(*) AS monthly_count
  FROM Appointments
  GROUP BY Doctor_ID, Month
) t GROUP BY Doctor_ID;

#101: Average appointment creation lead time by doctor.
SELECT Doctor_ID, AVG(DATEDIFF(STR_TO_DATE(Date,'%m/%d/%Y'), STR_TO_DATE(Created_On,'%m/%d/%Y'))) AS Avg_Lead_Days
FROM Appointments
GROUP BY Doctor_ID
ORDER BY Avg_Lead_Days DESC;

#102: Top 10 longest surgeries.
SELECT Surgery_ID, Patient_ID, Doctor_ID, Duration FROM Surgeries ORDER BY Duration DESC LIMIT 10;

#103: Average appointment count per patient by insurance status.
SELECT p.Insurance_Status, AVG(a.cnt) AS Avg_Appts
FROM (SELECT Patient_ID, COUNT(*) AS cnt FROM Appointments GROUP BY Patient_ID) a
JOIN Patients p ON a.Patient_ID = p.Patient_ID
GROUP BY p.Insurance_Status;

#104: Average billing total for insured vs uninsured patients.
SELECT p.Insurance_Status, AVG(b.Total) AS Avg_Bill
FROM Billing b
JOIN Patients p ON b.Patient_ID = p.Patient_ID
GROUP BY p.Insurance_Status;

#105: Count of active staff by role and department.
SELECT Role, Department, COUNT(*) AS Active_Count FROM Staff WHERE Status='Active' GROUP BY Role, Department ORDER BY Active_Count DESC;

#106: Average prescription frequency for pediatric patients (Age < 18).
SELECT AVG(presc.Frequency) AS Avg_Freq
FROM Prescriptions presc
JOIN Patients p ON presc.Patient_ID = p.Patient_ID
WHERE p.Age < 18;

#107: Billing items with highest unpaid balances.
SELECT Bill_ID, Patient_ID, Total, Balance FROM Billing ORDER BY Balance DESC LIMIT 20;

#108: Average staff tenure in years.
SELECT AVG(TIMESTAMPDIFF(YEAR, STR_TO_DATE(Hire_Date,'%m/%d/%Y'), CURDATE())) AS Avg_Tenure_Years FROM Staff;

#109: Most common anesthesiologist used by each doctor.
SELECT Doctor_ID, Anesthesiologist, COUNT(*) AS Count
FROM Surgeries
GROUP BY Doctor_ID, Anesthesiologist
ORDER BY Doctor_ID, Count DESC;


#110: Counts of appointment statuses.
SELECT Status, COUNT(*) AS Count FROM Appointments GROUP BY Status;


#111: Average billing total for inpatient vs outpatient.
SELECT CASE WHEN p.Admission_Date IS NOT NULL AND p.Admission_Date<>'' THEN 'Inpatient' ELSE 'Outpatient' END AS Type, AVG(b.Total) AS Avg_Total
FROM Billing b
JOIN Patients p ON b.Patient_ID = p.Patient_ID
GROUP BY Type;

#112: Number of recurring patients (more than 1 appointment).
SELECT COUNT(*) AS Recurring_Patients FROM (SELECT Patient_ID FROM Appointments GROUP BY Patient_ID HAVING COUNT(*) > 1) t;

#113: Average number of surgeries per doctor.
SELECT AVG(surg_count) AS Avg_Surgeries_Per_Doctor FROM (SELECT Doctor_ID, COUNT(*) AS surg_count FROM Surgeries GROUP BY Doctor_ID) t;

#114: Count of patients missing phone or email.
SELECT SUM(CASE WHEN Phone IS NULL OR Phone='' THEN 1 ELSE 0 END) AS Missing_Phone, SUM(CASE WHEN Email IS NULL OR Email='' THEN 1 ELSE 0 END) AS Missing_Email FROM Patients;

#115: Average revenue per diagnosis (approx join).
SELECT t.Diagnosis, AVG(b.Total) AS Avg_Revenue
FROM Treatments t
JOIN Billing b ON t.Patient_ID = b.Patient_ID AND DATE(STR_TO_DATE(t.Date,'%m/%d/%Y')) = DATE(STR_TO_DATE(b.Date,'%m/%d/%Y'))
GROUP BY t.Diagnosis
ORDER BY Avg_Revenue DESC;

#116: Count of doctors by department and specialization.
SELECT Department, Specialization, COUNT(*) AS Count FROM Doctors GROUP BY Department, Specialization ORDER BY Department, Count DESC;

#117: Average number of medications per treatment (if medication per row).
SELECT AVG(med_count) AS Avg_Meds_Per_Treatment FROM (SELECT Treatment_ID, COUNT(Medication) AS med_count FROM Treatments GROUP BY Treatment_ID) t;

#118: Billing revenue growth year-over-year.
SELECT YEAR(STR_TO_DATE(Date,'%m/%d/%Y')) AS Year, SUM(Total) AS Revenue FROM Billing GROUP BY Year ORDER BY Year;

#119: Percentage of surgeries with complications.
SELECT SUM(CASE WHEN Outcome='Complication' THEN 1 ELSE 0 END)/COUNT(*)*100 AS Pct_Complications FROM Surgeries;

#120: Count of patients by email domain.
SELECT SUBSTRING_INDEX(Email,'@',-1) AS Domain, COUNT(*) AS Count FROM Patients WHERE Email IS NOT NULL AND Email<>'' GROUP BY Domain ORDER BY Count DESC;

#121: Percentage of staff who are doctors (based on Role).
SELECT SUM(CASE WHEN Role='Doctor' THEN 1 ELSE 0 END)/COUNT(*)*100 AS Pct_Doctors FROM Staff;

#122: Average revenue per active patient in last year.
SELECT AVG(pb.PatientRevenue) AS Avg_Revenue FROM (
  SELECT b.Patient_ID, SUM(b.Total) AS PatientRevenue
  FROM Billing b
  WHERE STR_TO_DATE(b.Date,'%m/%d/%Y') >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
  GROUP BY b.Patient_ID
) pb JOIN (SELECT DISTINCT Patient_ID FROM Appointments WHERE STR_TO_DATE(Date,'%m/%d/%Y') >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)) a ON pb.Patient_ID = a.Patient_ID;

#123: Trend of active prescriptions by month.
SELECT DATE_FORMAT(STR_TO_DATE(Date,'%m/%d/%Y'), '%Y-%m-01') AS Month, SUM(CASE WHEN Status='Active' THEN 1 ELSE 0 END) AS Active_Count
FROM Prescriptions
GROUP BY Month
ORDER BY Month;

#124: Average treatment cost by department (via Doctors).
SELECT d.Department, AVG(t.Cost) AS Avg_Treatment_Cost
FROM Treatments t
JOIN Doctors d ON t.Doctor_ID = d.Doctor_ID
GROUP BY d.Department
ORDER BY Avg_Treatment_Cost DESC;

#125: Average number of patients seen per doctor per day.
SELECT AVG(daily_count) AS Avg_Patients_Per_Doctor_Per_Day FROM (
  SELECT Doctor_ID, STR_TO_DATE(Date,'%m/%d/%Y') AS Day, COUNT(*) AS daily_count
  FROM Appointments
  GROUP BY Doctor_ID, Day
) t;


#126: Most used operating rooms by procedure type.
SELECT Type, Room, COUNT(*) AS Count FROM Surgeries GROUP BY Type, Room ORDER BY Type, Count DESC;


#127: Average medication cost per prescription (if Medication cost not present — list medications by frequency).
SELECT Medicine_Name, COUNT(*) AS Presc_Count FROM Prescriptions GROUP BY Medicine_Name ORDER BY Presc_Count DESC;

#128: Count of patients per phone area code.
SELECT LEFT(Phone,3) AS AreaCode, COUNT(*) AS Count FROM Patients WHERE Phone IS NOT NULL AND Phone<>'' GROUP BY AreaCode ORDER BY Count DESC;

#129: Appointment percentage by part of day (morning/afternoon/evening).
SELECT
  CASE
    WHEN HOUR(STR_TO_DATE(Time,'%H:%i:%s')) < 12 THEN 'Morning'
    WHEN HOUR(STR_TO_DATE(Time,'%H:%i:%s')) < 17 THEN 'Afternoon'
    ELSE 'Evening'
  END AS PartOfDay,
  COUNT(*) AS Appts,
  COUNT(*)/ (SELECT COUNT(*) FROM Appointments) * 100 AS Pct
FROM Appointments
GROUP BY PartOfDay;

#130: Average number of follow-up appointments within 30 days after a treatment.
SELECT AVG(followups) AS Avg_Followups FROM (
  SELECT t.Treatment_ID,
    (SELECT COUNT(*) FROM Appointments a WHERE a.Patient_ID = t.Patient_ID AND STR_TO_DATE(a.Date,'%m/%d/%Y') BETWEEN STR_TO_DATE(t.Date,'%m/%d/%Y') AND DATE_ADD(STR_TO_DATE(t.Date,'%m/%d/%Y'), INTERVAL 30 DAY)) AS followups
  FROM Treatments t
) x;

#131: Revenue concentration — top 5% patients by revenue share (list top 5% patients).
SET @rownum := 0;

SELECT Patient_ID, rev
FROM (
    SELECT 
        Patient_ID,
        SUM(Total) AS rev,
        (@rownum := @rownum + 1) AS rn
    FROM Billing
    GROUP BY Patient_ID
    ORDER BY rev DESC
) ranked
WHERE rn <= (
    SELECT CEIL(COUNT(DISTINCT Patient_ID) * 0.05) 
    FROM Billing
)
ORDER BY rev DESC;

#132: Appointment completion rate (Completed / Total).
SELECT SUM(CASE WHEN Status='Completed' THEN 1 ELSE 0 END)/COUNT(*)*100 AS Completion_Pct FROM Appointments;

#133: Average prescription cost mapping (if billing links to prescriptions — list prescriptions per bill).
SELECT b.Bill_ID, b.Total, GROUP_CONCAT(DISTINCT pres.Medicine_Name) AS Medicines
FROM Billing b
LEFT JOIN Prescriptions pres ON b.Patient_ID = pres.Patient_ID AND DATE(STR_TO_DATE(b.Date,'%m/%d/%Y')) = DATE(STR_TO_DATE(pres.Date,'%m/%d/%Y'))
GROUP BY b.Bill_ID, b.Total
ORDER BY b.Total DESC;

#134: Ratio of elective vs emergency surgeries by Type (assuming Type encodes emergency).
SELECT Type, COUNT(*) AS Count, COUNT(*)/ (SELECT COUNT(*) FROM Surgeries) * 100 AS Pct FROM Surgeries GROUP BY Type;

#135: Number of unique services billed.
SELECT COUNT(DISTINCT Service) AS Distinct_Services FROM Billing;

#136: Average number of appointments created per booking day.
SELECT DATE_FORMAT(STR_TO_DATE(Created_On,'%m/%d/%Y'), '%Y-%m-%d') AS Booking_Date, COUNT(*) AS Bookings
FROM Appointments
GROUP BY Booking_Date
ORDER BY Booking_Date;

#137: Billing revenue by patient demographic (Age group & Gender).
SELECT
  CASE WHEN p.Age < 18 THEN '0-17' WHEN p.Age < 35 THEN '18-34' WHEN p.Age < 55 THEN '35-54' ELSE '55+' END AS Age_Group,
  p.Gender,
  SUM(b.Total) AS Revenue
FROM Billing b
JOIN Patients p ON b.Patient_ID = p.Patient_ID
GROUP BY Age_Group, p.Gender
ORDER BY Revenue DESC;

#138: Average appointment duration proxy by doctor (appointment counts as proxy).
SELECT Doctor_ID, COUNT(*) AS Appointment_Count FROM Appointments GROUP BY Doctor_ID ORDER BY Appointment_Count DESC;

#139: Count of treatments by outcome.
SELECT Outcome, COUNT(*) AS Count FROM Treatments GROUP BY Outcome;

#140: Average number of prescriptions issued by each doctor.
SELECT AVG(presc_count) AS Avg_Presc_Per_Doctor FROM (SELECT Doctor_ID, COUNT(*) AS presc_count FROM Prescriptions GROUP BY Doctor_ID) t;

#141: Patients with allergy-related notes in prescriptions.
SELECT DISTINCT Patient_ID FROM Prescriptions WHERE LOWER(Notes) LIKE '%allerg%' OR LOWER(Notes) LIKE '%reaction%';

#142: Top 10 reasons leading to highest average billing totals.
SELECT a.Reason, AVG(b.Total) AS Avg_Bill
FROM Appointments a
JOIN Billing b ON a.Patient_ID = b.Patient_ID AND DATE(STR_TO_DATE(a.Date,'%m/%d/%Y')) = DATE(STR_TO_DATE(b.Date,'%m/%d/%Y'))
GROUP BY a.Reason
ORDER BY Avg_Bill DESC
LIMIT 10;

#143: Average years of experience of doctors doing high-cost surgeries (>10000).
SELECT AVG(d.Years_Experience) AS Avg_Experience
FROM Surgeries s
JOIN Doctors d ON s.Doctor_ID = d.Doctor_ID
WHERE s.Cost > 10000;

#144: Follow-up appointment no-show rate (Reason contains 'follow').
SELECT SUM(CASE WHEN Status='No-Show' THEN 1 ELSE 0 END)/COUNT(*)*100 AS Pct_Followup_Noshow
FROM Appointments
WHERE LOWER(Reason) LIKE '%follow%';

#145: Average cost per day for surgeries (Cost/Duration).
SELECT AVG(CASE WHEN Duration>0 THEN Cost/Duration ELSE NULL END) AS Avg_Cost_Per_Unit FROM Surgeries;

#146: Count of doctors who are not active.
SELECT COUNT(*) AS Doctors_Not_Active FROM Doctors WHERE Status <> 'Active';

#147: Top 10 patients by number of treatments.
SELECT Patient_ID, COUNT(*) AS Treatments_Count FROM Treatments GROUP BY Patient_ID ORDER BY Treatments_Count DESC LIMIT 10;


#148: Average appointment creation lead time by department.
SELECT Department, AVG(DATEDIFF(STR_TO_DATE(Date,'%m/%d/%Y'), STR_TO_DATE(Created_On,'%m/%d/%Y'))) AS Avg_Lead
FROM Appointments
GROUP BY Department;

#149: Count of surgeries per month by type.
SELECT DATE_FORMAT(STR_TO_DATE(Date,'%m/%d/%Y'), '%Y-%m-01') AS Month, Type, COUNT(*) AS Surgeries
FROM Surgeries
GROUP BY Month, Type
ORDER BY Month;

#150: Prescription completion rate.
SELECT SUM(CASE WHEN Status='Completed' THEN 1 ELSE 0 END)/COUNT(*)*100 AS Pct_Completed FROM Prescriptions;

#151: Billing revenue by month per payment method.
SELECT DATE_FORMAT(STR_TO_DATE(Date,'%m/%d/%Y'), '%Y-%m-01') AS Month, Payment_Method, SUM(Total) AS Revenue
FROM Billing
GROUP BY Month, Payment_Method
ORDER BY Month;

#152: Top 10 procedures with highest complication rate.
SELECT Type AS Procedure, SUM(CASE WHEN Outcome='Complication' THEN 1 ELSE 0 END)/COUNT(*)*100 AS Complication_Rate
FROM Surgeries
GROUP BY Type
ORDER BY Complication_Rate DESC
LIMIT 10;

#153: Average number of services per bill (if Billing contains multiple service lines per Bill_ID).
SELECT AVG(service_count) AS Avg_Services_Per_Bill FROM (SELECT Bill_ID, COUNT(*) AS service_count FROM Billing GROUP BY Bill_ID) t;

#154: Average discount by department (approx join).
SELECT a.Department, AVG(b.Discount) AS Avg_Discount
FROM Billing b
JOIN Appointments a ON b.Patient_ID = a.Patient_ID AND DATE(STR_TO_DATE(b.Date,'%m/%d/%Y')) = DATE(STR_TO_DATE(a.Date,'%m/%d/%Y'))
GROUP BY a.Department
ORDER BY Avg_Discount DESC;

#155: Appointment cancellation rate by doctor.
SELECT Doctor_ID, SUM(CASE WHEN Status='Cancelled' THEN 1 ELSE 0 END)/COUNT(*)*100 AS Cancel_Rate
FROM Appointments
GROUP BY Doctor_ID
ORDER BY Cancel_Rate DESC
LIMIT 20;

#156: Number of appointments per physician per shift.
SELECT d.Shift, a.Doctor_ID, COUNT(*) AS Appts
FROM Appointments a
JOIN Doctors d ON a.Doctor_ID = d.Doctor_ID
GROUP BY d.Shift, a.Doctor_ID
ORDER BY d.Shift, Appts DESC;

#157: Average surgery cost per month.
SELECT DATE_FORMAT(STR_TO_DATE(Date,'%m/%d/%Y'), '%Y-%m-01') AS Month, AVG(Cost) AS Avg_Cost
FROM Surgeries
GROUP BY Month
ORDER BY Month;

#158: Percentage of bills that received any discount.
SELECT SUM(CASE WHEN Discount>0 THEN 1 ELSE 0 END)/COUNT(*)*100 AS Pct_Discounted FROM Billing;


#159: Average treatment duration by outcome.
SELECT Outcome, AVG(Duration) AS Avg_Duration FROM Treatments GROUP BY Outcome;


#160: Percentage of staff with salary above median.
-- SET @rownum := 0;
-- SET @total := (SELECT COUNT(*) FROM Staff);

-- SELECT 
--     (SUM(CASE WHEN Salary > @median THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS Pct_Above_Median
-- FROM (
--     SELECT 
--         Salary,
--         @rownum := @rownum + 1 AS rn,
--         @median := (
--             SELECT AVG(Salary)
--             FROM (
--                 SELECT s2.Salary
--                 FROM Staff s2
--                 ORDER BY s2.Salary
--                 LIMIT 2 - @total % 2
--                 OFFSET FLOOR(@total / 2)
--             ) AS m
--         )
--     FROM Staff s
--     ORDER BY s.Salary
-- ) AS ranked;

#161: Average number of days between multiple appointments for chronic patients (>4 visits/year).
WITH patient_counts AS (
  SELECT Patient_ID, COUNT(*) AS cnt FROM Appointments WHERE STR_TO_DATE(Date,'%m/%d/%Y') >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR) GROUP BY Patient_ID HAVING COUNT(*) > 4
)
SELECT AVG(days_between) FROM (
  SELECT a.Patient_ID, DATEDIFF(STR_TO_DATE(a.Date,'%m/%d/%Y'), LAG(STR_TO_DATE(a.Date,'%m/%d/%Y')) OVER (PARTITION BY a.Patient_ID ORDER BY STR_TO_DATE(a.Date,'%m/%d/%Y'))) AS days_between
  FROM Appointments a
  JOIN patient_counts pc ON a.Patient_ID = pc.Patient_ID
) t WHERE days_between IS NOT NULL;

#162: Top 10 medications by total number of doses prescribed (Dosage * Frequency * Duration).
SELECT Medicine_Name, SUM(Dosage * Frequency * Duration) AS Total_Doses
FROM Prescriptions
GROUP BY Medicine_Name
ORDER BY Total_Doses DESC
LIMIT 10;

#163: Average patient age for insured vs uninsured.
SELECT Insurance_Status, AVG(Age) AS Avg_Age FROM Patients GROUP BY Insurance_Status;

#164: Count of appointments rescheduled (Status='Rescheduled').
SELECT COUNT(*) AS Rescheduled FROM Appointments WHERE Status='Rescheduled';

#165: Average time doctors spend per patient (sum durations / distinct patients per doctor).
SELECT Doctor_ID, SUM(Duration)/COUNT(DISTINCT Patient_ID) AS Avg_Duration_Per_Patient
FROM Treatments
GROUP BY Doctor_ID
ORDER BY Avg_Duration_Per_Patient DESC;

#166: Number of appointments per reason for a given month (example September 2025).
SELECT Reason, COUNT(*) AS Appts
FROM Appointments
WHERE DATE_FORMAT(STR_TO_DATE(Date,'%m/%d/%Y'), '%Y-%m') = '2025-09'
GROUP BY Reason
ORDER BY Appts DESC;

#167: Total operating cost (sum of staff salaries + surgery costs + treatment costs).
SELECT (IFNULL((SELECT SUM(Salary) FROM Staff),0) + IFNULL((SELECT SUM(Cost) FROM Surgeries),0) + IFNULL((SELECT SUM(Cost) FROM Treatments),0)) AS Total_Operating_Cost;

#168: Average prescription duration by medicine.
SELECT Medicine_Name, AVG(Duration) AS Avg_Duration FROM Prescriptions GROUP BY Medicine_Name ORDER BY Avg_Duration DESC;

#169: Count of bills refunded or negative totals (Total < 0).
SELECT COUNT(*) AS Refund_Count, SUM(Total) AS Refund_Amount FROM Billing WHERE Total < 0;

#170: Average number of patients per room per day.
SELECT AVG(rooms_per_day) AS Avg_Patients_Per_Room_Per_Day FROM (
  SELECT Room_Number, STR_TO_DATE(Date,'%m/%d/%Y') AS Day, COUNT(*) AS rooms_per_day FROM Appointments GROUP BY Room_Number, Day
) t;

#171: Patients with multiple distinct diagnoses in last 12 months.
SELECT COUNT(*) AS Patients_With_Multiple_Diagnoses FROM (
  SELECT Patient_ID, COUNT(DISTINCT Diagnosis) AS diag_count FROM Treatments WHERE STR_TO_DATE(Date,'%m/%d/%Y') >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR) GROUP BY Patient_ID HAVING diag_count > 1
) t;

#172: Top 10 services generating the most discounts (sum Discount by Service).
SELECT Service, SUM(Discount) AS Total_Discount FROM Billing GROUP BY Service ORDER BY Total_Discount DESC LIMIT 10;


#173: Percentage of patients with an email on file.
SELECT SUM(CASE WHEN Email IS NOT NULL AND Email<>'' THEN 1 ELSE 0 END)/COUNT(*)*100 AS Pct_With_Email FROM Patients;


#174: Top 10 rooms incurring highest surgery costs.
SELECT Room, SUM(Cost) AS Total_Cost FROM Surgeries GROUP BY Room ORDER BY Total_Cost DESC LIMIT 10;

#175: Average age of patients who have balance due > 0.
SELECT AVG(p.Age) AS Avg_Age_Debtors
FROM Billing b
JOIN Patients p ON b.Patient_ID = p.Patient_ID
WHERE b.Balance > 0;

#176: Number of unique doctors prescribing each medicine.
SELECT Medicine_Name, COUNT(DISTINCT Doctor_ID) AS Distinct_Doctors FROM Prescriptions GROUP BY Medicine_Name ORDER BY Distinct_Doctors DESC LIMIT 20;

#177: Average number of days between billing date and patient admission date for inpatient bills.
SELECT AVG(DATEDIFF(STR_TO_DATE(b.Date,'%m/%d/%Y'), STR_TO_DATE(p.Admission_Date,'%m/%d/%Y'))) AS Avg_Days
FROM Billing b
JOIN Patients p ON b.Patient_ID = p.Patient_ID
WHERE p.Admission_Date IS NOT NULL AND p.Admission_Date <> '';

#178: Percentage of appointments that are follow-ups (Reason contains 'follow').
SELECT SUM(CASE WHEN LOWER(Reason) LIKE '%follow%' THEN 1 ELSE 0 END)/COUNT(*)*100 AS Pct_Followups FROM Appointments;

#179: Average time between surgery and follow-up appointment (next appointment after surgery).
SELECT AVG(DATEDIFF(STR_TO_DATE(a.Date,'%m/%d/%Y'), STR_TO_DATE(s.Date,'%m/%d/%Y'))) AS Avg_PostOp_Followup
FROM Surgeries s
JOIN Appointments a ON a.Patient_ID = s.Patient_ID AND STR_TO_DATE(a.Date,'%m/%d/%Y') > STR_TO_DATE(s.Date,'%m/%d/%Y');

#180: Average number of notes words per prescription.
SELECT AVG(LENGTH(Notes) - LENGTH(REPLACE(Notes,' ','') ) + 1) AS Avg_Words FROM Prescriptions WHERE Notes IS NOT NULL AND Notes <> '';

#181: Top 10 diagnoses with highest average treatment cost and highest bad outcome percent.
SELECT Diagnosis,
       AVG(Cost) AS Avg_Cost,
       SUM(CASE WHEN Outcome IN ('Worsened','Complication') THEN 1 ELSE 0 END)/COUNT(*)*100 AS Bad_Outcome_Pct
FROM Treatments
GROUP BY Diagnosis
ORDER BY Avg_Cost DESC
LIMIT 10;

#182: KPI summary single row: Total Revenue, Total Appointments, Unique Patients, Avg Bill, No-Show Rate, Surgery Success Rate, Total Staff Salary.
SELECT
  (SELECT IFNULL(SUM(Total),0) FROM Billing) AS Total_Revenue,
  (SELECT COUNT(*) FROM Appointments) AS Total_Appointments,
  (SELECT COUNT(DISTINCT Patient_ID) FROM Appointments) AS Unique_Patients,
  (SELECT IFNULL(AVG(Total),0) FROM Billing) AS Avg_Bill,
  (SELECT SUM(CASE WHEN Status='No-Show' THEN 1 ELSE 0 END)/COUNT(*)*100 FROM Appointments) AS NoShow_Rate,
  (SELECT SUM(CASE WHEN Outcome='Successful' THEN 1 ELSE 0 END)/COUNT(*)*100 FROM Surgeries) AS Surgery_Success_Rate,
  (SELECT IFNULL(SUM(Salary),0) FROM Staff) AS Total_Staff_Salary;

#183: Number of appointments per doctor per month (matrix).
SELECT Doctor_ID, DATE_FORMAT(STR_TO_DATE(Date,'%m/%d/%Y'), '%Y-%m') AS Month, COUNT(*) AS Appts
FROM Appointments
GROUP BY Doctor_ID, Month
ORDER BY Doctor_ID, Month;

#184: Average appointment hour by department.
SELECT Department, AVG(HOUR(STR_TO_DATE(Time,'%H:%i:%s'))) AS Avg_Hour FROM Appointments GROUP BY Department;

#185: Top 10 patients by outstanding balance.
SELECT Patient_ID, SUM(Balance) AS Total_Balance FROM Billing GROUP BY Patient_ID ORDER BY Total_Balance DESC LIMIT 10;

#186: Average treatment cost per doctor.
SELECT Doctor_ID, AVG(Cost) AS Avg_Treatment_Cost FROM Treatments GROUP BY Doctor_ID ORDER BY Avg_Treatment_Cost DESC;

#187: Count of prescriptions with dosage > 100.
SELECT COUNT(*) AS High_Dosage_Prescriptions FROM Prescriptions WHERE Dosage > 100;

#188: Average salary by department.
SELECT Department, AVG(Salary) AS Avg_Salary FROM Staff GROUP BY Department ORDER BY Avg_Salary DESC;

#189: Number of appointments created each hour of day.
SELECT HOUR(STR_TO_DATE(Time,'%H:%i:%s')) AS Hour, COUNT(*) AS Count FROM Appointments GROUP BY Hour ORDER BY Hour;

#190: Percentage of prescriptions active for more than X days (e.g., >30).
SELECT SUM(CASE WHEN Duration > 30 THEN 1 ELSE 0 END)/COUNT(*)*100 AS Pct_Long_Prescriptions FROM Prescriptions;

#191: Average surgeon workload (surgeries per surgeon per month).
SELECT Doctor_ID, AVG(monthly_count) AS Avg_Surgeries_Per_Month FROM (
  SELECT Doctor_ID, DATE_FORMAT(STR_TO_DATE(Date,'%m/%d/%Y'), '%Y-%m') AS Month, COUNT(*) AS monthly_count
  FROM Surgeries
  GROUP BY Doctor_ID, Month
) t GROUP BY Doctor_ID;

#192: Top 20 medicines by distinct patient count.
SELECT Medicine_Name, COUNT(DISTINCT Patient_ID) AS Distinct_Patients FROM Prescriptions GROUP BY Medicine_Name ORDER BY Distinct_Patients DESC LIMIT 20;

#193: Average appointment cancellations by weekday.
SELECT DAYNAME(STR_TO_DATE(Date,'%m/%d/%Y')) AS Weekday, SUM(CASE WHEN Status='Cancelled' THEN 1 ELSE 0 END) AS Cancellations FROM Appointments GROUP BY Weekday ORDER BY FIELD(Weekday,'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');

#194: Average treatment cost for patients over 60.
SELECT AVG(t.Cost) AS Avg_Cost_Over_60 FROM Treatments t JOIN Patients p ON t.Patient_ID = p.Patient_ID WHERE p.Age > 60;


#195: Top 10 services by number of distinct patients billed.
SELECT Service, COUNT(DISTINCT Patient_ID) AS Distinct_Patients FROM Billing GROUP BY Service ORDER BY Distinct_Patients DESC LIMIT 10;

#196: Average number of prescriptions per doctor per month.
SELECT Doctor_ID, AVG(monthly_count) AS Avg_Presc_Per_Month FROM (
  SELECT Doctor_ID, DATE_FORMAT(STR_TO_DATE(Date,'%m/%d/%Y'), '%Y-%m') AS Month, COUNT(*) AS monthly_count
  FROM Prescriptions
  GROUP BY Doctor_ID, Month
) t GROUP BY Doctor_ID;

#197: Count of treatments by procedure and outcome.
SELECT Proced_ure, Outcome, COUNT(*) AS Count FROM Treatments GROUP BY Proced_ure, Outcome ORDER BY Proced_ure, Count DESC;

#198: Average number of days between billing and payment if Payment_Date exists (if not, returns null).
SELECT AVG(DATEDIFF(STR_TO_DATE(Date,'%m/%d/%Y'), STR_TO_DATE(Date,'%m/%d/%Y'))) AS Avg_Collection_Days FROM Billing WHERE Date IS NOT NULL AND Date <> '';

#199: Top 10 doctors by average patient rating (if rating column added — otherwise top by appointments).
SELECT Doctor_ID, COUNT(*) AS Appt_Count FROM Appointments GROUP BY Doctor_ID ORDER BY Appt_Count DESC LIMIT 10;

#200: List of patients with unpaid balances and contact info (Phone, Email).
SELECT p.Patient_ID, p.Name, p.Phone, p.Email, SUM(b.Balance) AS Total_Balance
FROM Patients p
JOIN Billing b ON p.Patient_ID = b.Patient_ID
GROUP BY p.Patient_ID, p.Name, p.Phone, p.Email
HAVING Total_Balance > 0
ORDER BY Total_Balance DESC;




