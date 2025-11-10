🧩 ETL Data Integration (Pentaho PDI)

This part of the project shows how I built an ETL pipeline using Pentaho Data Integration (Spoon) to bring together data from multiple file formats like CSV, Excel, JSON, and Text into one clean dataset.
The ETL process includes both a Job (for overall control and automation) and a Transformation (for the actual data merging and cleaning).

🚀 ETL Job – “Job 3”
<img width="2160" height="1362" alt="Screenshot 2025-11-10 094349" src="https://github.com/user-attachments/assets/c50292f4-9358-43b7-b719-644e4f391da6" />

This job acts as the main controller for the ETL process.
It’s designed to check if all input files exist, run the data transformation, and send an email notification when the process completes successfully.

Here’s what happens step-by-step:

Start:
Begins the ETL process.

Checks if files exist:
Confirms all input files (CSV, Excel, JSON, Text) are available before continuing.

✅ If files exist → move to the next step.

❌ If files are missing → trigger the Abort Job step.

Transformation:
Runs the main transformation workflow to clean and merge the data.

Mail:
Sends an automatic email notification when the process finishes successfully.

Abort Job:
Stops execution and alerts the user if any issue or missing file is found.

This setup ensures that the ETL pipeline is error-resistant, automated, and self-monitoring.

⚙️ ETL Transformation – “Transformation 7”
<img width="2130" height="1353" alt="Screenshot 2025-11-10 094338" src="https://github.com/user-attachments/assets/7386c24a-d9dc-4618-aabb-4c2973613164" />

The transformation is where the actual data processing happens.
Here, multiple input files are cleaned, sorted, merged, and finally exported into a single Excel file.

Main steps included:

File Inputs:
Reads data from four sources — Text, CSV, Excel, and JSON files.

Sort Rows:
Sorts each dataset so that merging can be done correctly.

Select Values:
Picks only the required columns from each file, making sure all datasets have a common structure.

Sorted Merge:
Combines all the files into one continuous stream of data.

Unique Rows:
Removes duplicate records to keep the final dataset clean.

Excel Output:
Exports the final, merged data into a single Excel file for easy use in Power BI and MySQL.

Execution Summary:

All files were processed successfully (no errors).

Total of 749 unique records after merging and cleaning.

Logs confirm each step executed correctly.
