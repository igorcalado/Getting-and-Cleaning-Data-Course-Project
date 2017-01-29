---
Title: "ReadMe for tidyHAR"
Author: "Igor Calado"
Date: "January 29, 2017"
---

## Description
This README file describes the tidyHAR dataset. tidyHAR provides summarized data on a set of variables that describe human movement while performing different activites. It was created as part of the final project for the Getting and Cleaning Data Course from
Coursera.

## Original data
The original dataset was donated by Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto and Xavier Parra, who made it 
[available online](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

Full citation as requested:
> Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity
> Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning,
> ESANN 2013. Bruges, Belgium 24-26 April 2013.

It consists of a human activity recognition (HAR) database built from the recordings of 30 subjects performing six different activities
of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors. Additional processing was applied to the
raw signal and is described in the files accompanying the data in the original dataset. 

The original dataset comprised 10299 observations across 561 variables, besides the identification on the subject and activity perfomed.

## Creating the tidy datafile
We downloaded the original database and unzipped the files. The observations came split into two groups: train and test. The train data had 70% of the total entries (21 of the 30 subjects) and was used as source for the main analysis; the other 30%, or 9 remaining subjects, were used for testing. Also, each set (train and test) had data stored in three different files: one for the measurements, another for the type of activity performed and a third for the subject. There was no common column between them, observations were match by position.

In the process of cleaning the dataset, we merged both sets (train and test) and all six files (features, activity and subjects). This resulted in one single array of data. Then, out of the 561 original measurements, we extracted only those pertaining to the mean and standard deviation for each variable, which resulted in a total of 66 columns being kept. The original datasets did not have descriptive column names; the names for the variables came in still another file, so we matched them in order to name each column with the aide of the features.txt file. Names were also assigned for the subject and activity columns. The activity labels were also kept in another file while numbers were used to represent each factor; they were also matched and changed for the self-descriptive labels also provided in the original dataset.

After discarding variables and naming columns and factors, observations were split into groups by both subject and activity type. This created 180 groups of data, where each group represents all the observations made for a given subject performing one of the activities (30 subjects times 6 activities). All the observations were then averaged by each variable, creating a single entry for each group, which were in turn put together again.

At the end, the resulting data was called tidyHAR. It consists of 180 entries containing the average for all the observations for each group (subject by activity) across the 66 variables chosen, and two more columns identifying subject and activity.

An R script called run_analysis.R has been included in this repository. It contains all the code used to run the process described above. It also includes detailed step-by-step commentary on its functioning.

## Summary of dataset
* Class: data.frame
* Number of observations: 180
* Number of variables: 68
* Memory size: 106.776 bytes
