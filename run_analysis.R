# This scrip was created by Igor Calado as part of the final programming project
# for Getting and Cleaning Data Course, form Coursera, in January 2017.

# This script works on the Fuci Har Dataset in order to clean and tidy it up. It was written in
# RStudio version 1.0.136 in a Windows 10 Pro operating system.

# Part 1: getting and loading the dataset and libraries
  # Downloading the dataset to our working directory and unzipping it
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url, destfile = "HAR_Dataset")
  unzip("HAR_Dataset")

  if (!"plyr" %in% rownames(installed.packages())) {
    install.packages("plyr")
    }
  
  library(plyr)
    
# Part 2: loading files
  # Of all the files in the unzipped folder, create a list with the paths for the ones
  # we are going to use
  useful_files <- list.files(path = "./UCI HAR Dataset" , recursive = TRUE,
                             full.names = TRUE)[c(1:2, 14:16, 26:28)]
  
  # Let's read all those files. They will become elements of a list
  datasets <- lapply(useful_files, read.table)
  
  # This list has no names, so we'll name each element (data.frame) of the list using the
  # file name. For such, we'll first create a character vector containing the name of the
  # files read. We'll do this by taking the elements in the useful_file vector and splitting 
  # each vector to separate folder from file name. This will create a new list, trimming.
  trimming <- strsplit(useful_files, "/")
  
  # We only want the file names, not the folder names. We know that, in each list contained
  # in the trimming list (each element of the list), if there is more than one element, the
  # file name will be the las one. So we create a for loop that will take only the last
  # element of each element of the trimming list and assign it to this new, empty character
  # vector just created called file.names.
  n <- length(useful_files)
  file.names <- vector(mode = "character", length = n)
  
  for (i in 1:n) {
    y <- max(length(trimming[[i]]))
    file.names[[i]] <- trimming[[i]][y]
  }
  
  # Then we assign the vector names as the names of the elements of the datasets list.
  names(datasets) <- file.names
  
  # We're ready to extract the elements from the list and assign them as objects
  # to our working environment (but first, we make a list of all the objects created so far,
  # so we can remove them later.
  list2env(datasets, environment())
  
  # Let's remove the objects we are not going to need anymore.
  rm("datasets", "file.names", "i", "n", "trimming", "useful_files", "y", "url")
  
  # Now we have all the useful databases loaded as objects into our working
  # environment and nothing else. We are ready to move on.
  
# Part 3: merging data sets
  
  # The data sets are divided between train and test, and for each one we have three
  # different data sets: X, which stores all the variables measured; y, which stores
  # the activity type; and subject, which identifies the subjects. Let's merge these
  # three train and three test data frames into one train data set and one test data
  # set. (Step 1 of the instructions)
  
  train <- cbind(subject_train.txt, X_train.txt, y_train.txt)
  test <- cbind(subject_test.txt, X_test.txt, y_test.txt)
  
  # Now, let's merge the train and test data sets to form one large dataset. We'll call
  # it "HAR".
  HAR <- rbind(train, test)

  # Let's remove the datasets we won't need anymore.
  rm("subject_test.txt", "X_test.txt", "y_test.txt", "subject_train.txt",
     "X_train.txt", "y_train.txt", "train", "test")
  
# Part 4: selecting variables and labeling
  
  # Step 2 says that we are not going to use all measures for all variables: we should
  # retain only the mean and standard deviation for each variable. According to posts
  # from mentors in the forum and other sources, there are differing interpretations 
  # on whether "mean and standard deviation" should apply only to variables with mean()
  # and std() in their names or if meanFreq() or even tBodyAccJerkMean should also been
  # included. Those sources state that this decision is left up for the student and
  # both options should be fine. After careful examination of the features_info.txt file,
  # it seems to me that the narrower interpretation is the most adequate, so I chose 
  # to stick with mean() and std() variables only.
  
  # Moving on. To identify the correct variables, first we split the variable names
  # provided by features.txt and create an array out of it.
  
  variables <- strsplit(as.character(features.txt[,2]), split = "-")
  split_variable_names <- plyr::ldply(variables, rbind)
  
  # Let's select only the variable names with mean() and std() in it. They appear in
  # the second column of our array. We'll create a logical vector of the matches for
  # mean() and std() and store it in keep.
  matches <- c("mean()", "std()")
  keep <- split_variable_names[,2] %in% matches
  
  # Keep will tell us the position of the variables we want to preserve in the feature.txt.
  
  # Before selecting the columns, let's first name all of them in the HAR data set (Step 4). Remember
  # that we added two columns: the first corresponds to the subject and the last one, to the
  # activity. We'll create a vector with the column names and pass it to HAR.
  
  names <- c("subject", as.character(features.txt[,2]), "activity")
  names(HAR) <- names  
  
  # Now, let's use keep to discard the unwanted columns. First, we'll include an extra TRUE
  # at the end and another one at the begnning to make sure the subject and activity columns (which were
  # added later to the features.txt list) will be retained. This completes step 2.
  
  keep <- append(TRUE, append(keep, TRUE))
  HAR <- HAR[,keep]
  
  # We haven't yet executed step 3: to correctly label the activity type (last column) using
  # descriptive names taken from activity_labels.txt instead of numbers. Let's do it now.
 
  # First, let's make all the labels into lower case-only character vector.
  act_names <- tolower(activity_labels.txt[,2])
  
  # Let's use mutate from the to modify the column according to conditions.
  # We'll use nested ifelse functions to match the number and name label.
  HAR <- plyr::mutate(HAR, activity = ifelse(test = activity==1, yes = act_names[1], no =
                                        ifelse(test = activity==2, yes = act_names[2], no =
                                          ifelse(test = activity==3, yes = act_names[3], no =
                                           ifelse(test = activity==4, yes = act_names[4], no =
                                            ifelse(test = activity==5, yes = act_names[5], no =
                                             ifelse(test = activity==6, yes = act_names[6], no = "")
                                             ))))))

  # Good, now we finally have the dataset we wanted. Let's clean up the workspace.
  
  rm("act_names", "activity_labels.txt", "features.txt", "keep", "matches", "names", 
     "split_variable_names", "variables")

# Part 5: creating the final tidy dataset
  # We are about to accomplish the last task, as put in step 5: "From the data set in step 4,
  # creates a second, independent tidy data set with the average of each variable for each
  # activity and each subject."
  
  # The following line will use the ddply function to group the HAR dataset by the columns
  # subject and activity and then run the function numcolwise(mean) to create a mean of the
  # remaining columns. The result will be assigned to a new dataset.
  tidyHAR <- plyr::ddply(HAR, .(subject, activity), numcolwise(mean))

  # tidyHAR is a tidy dataset. It shows us the mean for each of the measurements by groups.
  # We have 30 subjects and 6 different activities; together, they form 180 groups. For each
  # group, tidyHAR presents the mean of 66 variables, in place of the more than 10 thousand
  # entries for different observations.
  
  # tidyHAR conforms to the for rules of tidy data: each measure corresponds to one column;
  # each observation corresponds to a row; all related data is condensed in a single table;
  # we have only one table, so no necessity to link different tables through common columns.
  
  # Let's finish all this by creating a new file out of tidyHAR.
  write.table(tidyHAR, file = "tidyHAR.txt", row.names = FALSE)