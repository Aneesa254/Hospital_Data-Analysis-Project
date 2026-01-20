-- Create Database
CREATE DATABASE HospitalRecords;

USE HospitalRecords;

-- Create table ONLY ONCE
CREATE TABLE IF NOT EXISTS Hospital_Data (
    Hospital_Name VARCHAR(100),
    Location VARCHAR(100),
    Department VARCHAR(100),
    Doctors_Count INT,
    Patients_Count INT,
    Admission_Date DATE,
    Discharge_Date DATE,
    Medical_Expenses DOUBLE
);

-- Check table
SELECT * FROM Hospital_Data;


-- 1. Total Number of Patients
SELECT SUM(Patients_count) AS total_patients
FROM hospital_data;

-- 2. Average Number of Doctors per Hospital
SELECT AVG(Doctors_Count) AS Avg_Doctors_per_Hospital
FROM hospital_data;

-- 3. Top 3 Departments with the Highest Number of Patients
SELECT Department, 
       SUM(Patients_count) AS total_patients
FROM hospital_data
GROUP BY Department
ORDER BY total_patients DESC
LIMIT 3;

-- 4. Hospital with the Maximum Medical Expenses
SELECT Hospital_Name, 
		SUM(Medical_Expenses) AS Max_Medical_Expenses
FROM hospital_data
GROUP BY Hospital_Name
ORDER BY Max_Medical_Expenses DESC
LIMIT 1;

-- 5. Daily Average Medical Expenses
-- Calculate the average medical expenses per day for each hospital.
SELECT Hospital_Name,
       Admission_Date,
       AVG(Medical_Expenses) AS avg_daily_expenses
FROM hospital_data
GROUP BY Hospital_Name, Admission_Date
ORDER BY Hospital_Name, Admission_Date;

-- 6. Longest Hospital Stay
-- Find the patient with the longest stay by calculating the difference between Discharge Date and Admission Date.
SELECT Hospital_Name,
       Department,
       Admission_Date,
       Discharge_Date,
       DATEDIFF(Discharge_Date, Admission_Date) AS stay_days
FROM hospital_data
ORDER BY stay_days DESC
LIMIT 1;

-- 7. Total Patients Treated Per City
-- Count the total number of patients treated in each city
SELECT Location,
		COUNT(Patients_Count) AS Total_Patients
FROM hospital_data
GROUP BY Location
ORDER BY Total_Patients DESC;

-- 8. Average Length of Stay Per Department
-- Calculate the average number of days patients spend in each department.
SELECT Department,
		AVG(DATEDIFF(Discharge_Date, Admission_Date)) AS Avg_Days
FROM hospital_data
WHERE 
    Discharge_Date >= Admission_Date
GROUP BY Department
ORDER BY Avg_Days DESC;

-- 9. Identify the Department with the Lowest Number of Patients
WITH patient_counts AS (
    SELECT Department, COUNT(*) AS total_patients
    FROM hospital_data
    GROUP BY Department
)
SELECT Department, total_patients
FROM patient_counts
WHERE total_patients = (SELECT MIN(total_patients) FROM patient_counts);

-- 10. Monthly Medical Expenses Report
-- Group the data by month and calculate the total medical expenses for each month.
SELECT DATE_FORMAT(Admission_Date, '%Y,%m') AS Month,
		SUM(Medical_Expenses) AS Total_med_Expenses
FROM hospital_data
GROUP BY Month
ORDER BY Total_med_Expenses;