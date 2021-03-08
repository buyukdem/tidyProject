library(dplyr) 

# read train data
X_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./data/UCI HAR Dataset/train/Y_train.txt")
Sub_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# read test data
X_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./data/UCI HAR Dataset/test/Y_test.txt")
Sub_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# read data description
variable_names <- read.table("./data/UCI HAR Dataset/features.txt")

# read activity labels
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

# 1. Merging training and test sets
X_tot <- rbind(X_train, X_test)
Y_tot <- rbind(Y_train, Y_test)
Sub_tot <- rbind(Sub_train, Sub_test)

# 2. Extracting mean and sd info.
selected_var <- variable_names[grep("mean\\(\\)|std\\(\\)",variable_names[,2]),]
X_tot <- X_tot[,selected_var[,1]]

# 3. Using descriptive activity names to name the activities in the data set
colnames(Y_tot) <- "activity"
Y_tot$activitylabel <- factor(Y_tot$activity, labels = as.character(activity_labels[,2]))
activitylabel <- Y_tot[,2]

# 4. Labeling the data set with descriptive variable names.
colnames(X_tot) <- variable_names[selected_var[,1],2]

# Creating a tidy data set.
colnames(Sub_tot) <- "subject"
total <- cbind(X_tot, activitylabel, Sub_tot)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_all(funs(mean))
write.table(total_mean, file = "./data/UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)
