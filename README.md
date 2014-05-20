## Load data

A zip file was downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip. It was unzipped and placed in the current working directory. 

The training data are originally stored in three separate files. X_train.txt under the "Train" folder saves feature values, one line per measurement sampling. Each line contains 561 floating-point numbers, one for each feature. There are 7352 lines in total. y_train.txt and subject_train under the same folder store activity codes and subject codes, one line per measurement sampling, respectively. In other words, each measurement sampling records measurements on a specific subject for a specific activity.

These three files were read into R data frames, and then combined into a single data frame with cbind function call.

Similarly, the test data are originally stored in three separate files under the "Test" folder, in the same formats as training data. Files were read and aggregated into a single data frame.

  

## Merge the training and the test sets

At the end of the last phase, two data frames were resulted, one for training data, and the other for test data. Combining them into a single data frame is straightforward by using rbind in R.

The first and second columns of the merged data frame were named as "subject" and "activity." All other columns were assigned names specified in the file "features.txt" in the same order. 



## Extract interesting measurments

The requirement was interpreted as concerning only those "features" that have records for both mean and standard deviation. For example, we are interested in tBodyAccX because it has both mean and standard deviation values. On the other hand, since fBodyAccFreq only records mean values, it should be excluded.

With this interpretation, all "features" were read out from the provided file "features.txt" and then were searched against a corresponding regular expression. A mask was computed and used to extract those columns of the above data frame representing the combined training and testing data. The data frame was thus shrunk to contain only 68 columns from the original 239 columns.


## Use descriptive activity

Activity codes were used in the original data sets, and a look-up table was provided in the file "activity_labels.txt."  It is desirable to employ activity names directly in the new dataset. For this purpose, the second column of the new data set (i.e., the "activity" column) was coerced as a factor, containing six levels, one for each activity name.


## Relabel the data set with descriptive names

The feature names in the original dataset are somewhat awkward. For example, notations on function calls such as mean() are included in feature names. Besides, hyphens within column names were deemed as distracting because of connotations of arithmetic minus. As such, those hyphens and parentheses were removed. In addition, substrings of "mean" and "std" were converted to "Mean" and "Std."



## Creates a second, independent tidy data set

The above data frame was converted to a data.table object for facilitating the computations of the average of each variable for each activity and each subject. It is convenient to use the data.table utilities to compute statistics on multiple partition criteria. The resulting tidy data set contains only 180 rows, since there are only 180 combinations of subject and activity from available 30 subjects and 6 activities.  

Finally, such new data set was written to a local file via write.table function call.


