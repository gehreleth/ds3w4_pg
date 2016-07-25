#Peer reviewed assignment for Getting and Cleaning Data course.

This script 

* Downloads raw data from [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) and unpacks it.
* Merges test and train datasets.
* Extracts mean and std derivation values, give descriptive names for these data.
* Groups data by subject and activity and calculates average value for each subject/activity pair.
* Writes result ti a file named "result.table" using _write.table_ method