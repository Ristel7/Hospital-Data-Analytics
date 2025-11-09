# 🧾 Hospital Management Datasets

This folder contains all the primary datasets used for the **Hospital Data Analytics & Power BI Dashboard Project**.  
Each CSV file represents a key entity within the hospital’s data system, forming the foundation for SQL analysis, data cleaning, and dashboard visualization.

---

## 📂 Datasets Overview

| File Name | Description | Key Columns |
|------------|--------------|--------------|
| **Patients.csv** | Contains demographic and personal information about patients. | `Patient_ID`, `Name`, `Gender`, `Age`, `Blood_Group`, `Contact`, `Email`, `Address`, `Registration_Date` |
| **Doctors.csv** | Holds data about doctors, their specializations, and experience levels. | `Doctor_ID`, `Name`, `Department`, `Experience_Years`, `Salary`, `Contact`, `Email`, `Shift` |
| **Appointments.csv** | Records all appointment details between doctors and patients. | `Appointment_ID`, `Patient_ID`, `Doctor_ID`, `Appointment_Date`, `Status`, `Purpose`, `Duration`, `Remarks` |
| **Treatments.csv** | Contains treatment details, procedures, and associated costs. | `Treatment_ID`, `Patient_ID`, `Doctor_ID`, `Procedure`, `Diagnosis`, `Cost`, `Outcome`, `Date` |
| **Billing.csv** | Includes billing and payment details for hospital services. | `Bill_ID`, `Patient_ID`, `Date`, `Total`, `Discount`, `Payment_Method`, `Status` |
| **Prescriptions.csv** | Lists prescribed medicines and dosage information. | `Prescription_ID`, `Patient_ID`, `Doctor_ID`, `Medicine_Name`, `Dosage`, `Frequency`, `Duration`, `Date` |
| **Surgeries.csv** | Contains records of surgical procedures and recovery outcomes. | `Surgery_ID`, `Patient_ID`, `Doctor_ID`, `Surgery_Type`, `Date`, `Outcome`, `Recovery_Days` |
| **Staff.csv** | Includes details of non-doctor hospital staff and their roles. | `Staff_ID`, `Name`, `Role`, `Department`, `Salary`, `Shift`, `Experience_Years`, `Contact` |

---

## 🧹 Data Cleaning Summary

- Null values were intentionally introduced to simulate real-world data.
- Missing data was handled using **Excel**:
  - Replaced blanks in categorical columns with `"Unknown"` or `"Not Provided"`.
  - Filled numeric nulls using **median** or **mean imputation**.
  - Ensured consistent date and ID formats across all tables.

---

## 🔗 Relationships

| Table | Linked With | Common Key |
|--------|--------------|-------------|
| Patients | Appointments, Billing, Prescriptions, Surgeries, Treatments | `Patient_ID` |
| Doctors | Appointments, Treatments, Surgeries, Prescriptions | `Doctor_ID` |
| Appointments | Billing, Treatments | `Appointment_ID` |

---

## 📊 Usage

These datasets were used for:
- **SQL Analysis** (Descriptive, Inferential, A/B Testing)
- **Power BI Dashboards** (KPIs, Charts, Comparative Insights)
- **Excel Cleaning & Preprocessing**
- **Predictive and Exploratory Data Analysis**

---

## ⚙️ Data Source

All datasets are **synthetically generated** for academic and analytical purposes.  
They represent a realistic hospital environment while maintaining privacy and data integrity.

---

📌 *Prepared by: Priyanshu (Data Analytics Project, 2025)*
