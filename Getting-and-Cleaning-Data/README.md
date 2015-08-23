#Getting and Cleaning Data R script does the following:
1. Download the dataset if it does not already exist in the working directory
2. Load the activity and feature details
3. Loads training dataset (only Mean, Std columns), activities and subjects. Column bind these datasets
4. Loads test dataset (only Mean, Std columns), activities and subjects. Column bind these datasets
5. Merges the two datasets
6. Converts the `activity` and `subject` columns into factors
7. Creates a tidy dataset as mean of each variable by each subject and activity

Save end result in the file `tidy.txt`.
