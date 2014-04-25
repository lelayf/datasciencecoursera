#
#   This script uses data from the UCI Machine Learning Repository :
#   Human Activity Recognition Using Smartphones Data Set 
#   http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#
#
#   Associated research :
#   Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. 
#   "Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support 
#   Vector Machine." International Workshop of Ambient Assisted Living (IWAAL 2012). 
#   Vitoria-Gasteiz, Spain. Dec 2012
#

features <- read.table("features.txt", header=FALSE, stringsAsFactors=FALSE)
names(features) <- c("id","name")

# load test sets
xtest <- read.table("test/X_test.txt")
names(xtest) <- features$name
ytest <- read.table("test/y_test.txt")
names(ytest) <- c("activity_id")
stest <- read.table("test/subject_test.txt")
names(stest) <- c("subject_id")
# merge test sets side by side
test <- cbind(stest, xtest, ytest)
str(test)

# load training sets
xtrain <- read.table("train/X_train.txt")
names(xtrain) <- features$name
ytrain <- read.table("train/y_train.txt")
names(ytrain) <- c("activity_id")
strain <- read.table("train/subject_train.txt")
names(strain) <- c("subject_id")
# merge training sets side by side
train <- cbind(strain, xtrain, ytrain)
str(train)

# append training and test sets together (on top of each other, by rows)
full <- rbind(train,test)
str(full)

library(gdata)

# match features associated to mean() and std() computation 
meanstdcols <- matchcols(full, with=c("mean\\(\\)|std\\(\\)"))

# build dataset with subject, activity, mean and std features
sams <- full[,c("subject_id", "activity_id", meanstdcols)]

# load activty labels from file
activity <- read.table("activity_labels.txt", stringsAsFactors=FALSE)
names(activity) <- c("activity_id","activity_label")

# include explicit activity labels in dataset by merging on activity id
samsExplicit <- merge(sams, activity, by="activity_id")

# Loop over feature names to make them more explicit

originalNames <- names(samsExplicit)
newNames <- vector('character')
dontTouch <- c("activity_id","subject_id","activity_label")

for( i in 1:length(originalNames) ){
  name <- originalNames[i]
  # tidy up only if current column name is a feature column name
  # use naive regular expressions to perform substitutions
  if( ! name %in% dontTouch ) {
      a <- gsub("^t", "Time Domain ", name )
      a <- gsub("^f", "Frequency Domain ", a)
      a <- gsub("std\\(\\)", "Standard Deviation ", a)
      a <- gsub("mean\\(\\)", "Mean ", a)
      a <- gsub("-", "", a)
      a <- gsub("Acc", "Linear Acceleration ", a)
      a <- gsub("Jerk", "Jerk ", a)
      a <- gsub("Gyro", "Angular Velocity ", a)
      a <- gsub("Mag","Magnitude ", a)
      a <- gsub("Body", "Body ", a)
      a <- gsub("Gravity", "Gravity ", a)
      newNames <- c(newNames,a)
  }
}

colnames(samsExplicit) <- c("activity_id","subject_id",newNames,"activity_label")
names(samsExplicit)

# create new dataset showing means of all feature columns grouped by subject_id, activity
# specify feature colums with robust named exclusion rather than specific indices inclusion

samsAggregate <- aggregate( samsExplicit[,-which(names(samsExplicit) %in% dontTouch)], 
                            by=list(samsExplicit$activity_id, samsExplicit$subject_id),
                            FUN=mean)
# check row count
nrow(samsAggregate)
# check column names
names(samsAggregate)

# ach, aggregate renamed our grouped by cols, let's fix this
names(samsAggregate)[names(samsAggregate)=="Group.1"] <- "activity_id"
names(samsAggregate)[names(samsAggregate)=="Group.2"] <- "subject_id"
head(names(samsAggregate))

# write tidy aggregates to text file
write.table(samsAggregate,file="tidyAggregates.txt",sep=" ",col.names=TRUE,row.names=FALSE)




