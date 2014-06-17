#0 setwd
#1. read test files
#2. read train files 
#3  Add rows of the files (*train & *test) into single using rbind as you would need to process the same steps to each file.
#4  
#5  read features.txt into a column & lanel each column with a feature name
#6  Put activity into activity number column of the data 
#7  assign activity labels by activity number
#8  assemble a vecotor of acvity labels and put it in activity table
#9  Assemble the 1st three columns (subjects, activity, and activity_num) of data
#10 loop over columns to pattern match foro mean and std; save columns with mtach
#11 sort the columns by your choice of column
#12 write mean by actitiy and subject for each column to file called output.csv



# set root working directory
setwd("C:\\Users\\Aizaz\\Documents\\Coursera R Stuff\\R-wd\\UCI HAR Dataset")

# load all data
# row join the data sets together
subjects <- rbind(read.table(".\\test\\subject_test.txt"), read.table(".\\train\\subject_train.txt"))
data     <- rbind(read.table(".\\test\\x_test.txt"), read.table(".\\train\\x_train.txt"))
activity <- rbind(read.table(".\\test\\y_test.txt"), read.table(".\\train\\y_train.txt"))


#read features data and label columns to the corresponding values
features <- read.table(".\\features.txt")
colnames(data) <- as.vector(features$V2) # assign features as column names

#read in activity values, build and append activity codes and labels
data["activity_num"] <- activity                            #store the activity code in main data files
activity_labels <- read.table(".\\activity_labels.txt")     #read in activity. labels
activity <- activity_labels[strtoi(activity$V1) ,2]         #build out a vector of act. labels
data["activity"] <- as.vector(activity)                     #append the vector column to the master data

#append subjects column to data
data["subjects"] <- as.vector(subjects)

#lay in the first three columns of the a data set
data_4_agg <- subset(data, select = c(subjects, activity, activity_num)) # from data using subset to keep subjeect, activity, and activity number and dumping all else
#copy only the remaining columns we want from the master data set to the new one
for(i in names(data)){  #across the columns in data
  if(grepl("mean()", i, fixed=TRUE) | grepl("std()", i, fixed=TRUE)){ # pattern match for mean() and std()
    data_4_agg[i] <- data[i]     # keep the match columng
  }
}

#sort data - not necessary, but cleaner for validation
data_4_agg <- data_4_agg[order(data_4_agg[, 1], data_4_agg[, 2]), ]

#summarize data by subject, activity and measure(features)
output <- aggregate(data_4_agg[4:ncol(data_4_agg)], by=data_4_agg[c("activity", "subjects")], FUN=mean)

#write the output file
write.csv(output, file = "output.csv")
