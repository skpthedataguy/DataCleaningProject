# DataCleaningProject
Used Microsoft SQL Server for data cleaning of a dataset.
---------------------------------------------------------------
The main aim of this Project is to clean,modify the available dataset for make it ready for data analysis.

Step1: First we checked for Date column i.e. SaleDate where we found some error in the date format. So, that date format correction was our first task.
Step2: Second task was Populate the Property address, where we found that some null values are in the column. So, for that we observed & considered that for same ParcelID 
       the address will also be the same, so we fetched the address for the same parcelid and replaced with the null values.
Step3: Breaking the whole address column into three different columns Address, City,State for ease of analysis and filtering purpose . With the help of the delimitors present
       in the address values, we had performed the separation.
Step4: Step 3 repeated for owneraddress column.
step5: In the SoldAsVacant column we found 4 types of values: Yes, No,Y,N........So here we considered to keep only two variables Yes and No, so we performed that replacement.
Step6: Checked for the duplicate values and removed them.
Step7: Removed the unnecessary data columns which are not at all required for our analysis purpose.
---------------------------------------------------------------
This was just a beginner level project, It took around 45 minutes to finish this whole process.
