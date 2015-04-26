# Extract features names
# features <- as.vector(sapply(readLines("features.txt"), function (e) strsplit(e, " ")[[1]][2]))

# Load sets
# training_set <- read.table("train/X_train.txt", col.names = features, colClasses = c("numeric"))
# test_set <- read.table("test/X_test.txt", col.names = features, colClasses = c("numeric"))

# Merge sets
# total_set <- rbind(training_set, test_set)

# Extract mean/std for each measurements
library(dplyr)
extracted_set <- select(total_set, matches("mean|std"))

# Activity names
# activities <- as.vector(sapply(readLines("activity_labels.txt"), function (e) strsplit(e, " ")[[1]][2]))

# Load activity column
# training_activity <- read.table("train/y_train.txt")
# test_activity <- read.table("test/y_test.txt")

# Convert to factor
# total_activity <- rbind(training_activity, test_activity)
# total_activity$V1 <- factor(total_activity$V1)
# levels(total_activity$V1) <- activities

# Add to extracted set
extracted_set$Activity <- total_activity$V1

# Load subject column & add
# training_subject <- read.table("train/subject_train.txt")
# test_subject <- read.table("test/subject_test.txt")
# total_subject <- rbind(training_subject, test_subject)
extracted_set$Subject <- total_subject$V1

# Group by 
tidy_set <- group_by(extracted_set, Activity, Subject)
tidy_set <- summarise_each(tidy_set, funs(mean))

# Tidy columns name
names(tidy_set) <- sapply(names(tidy_set), function(e) gsub("\\.", "", e))
names(tidy_set) <- sapply(names(tidy_set), function(e) gsub("Acc", ".Accelerator", e))
names(tidy_set) <- sapply(names(tidy_set), function(e) gsub("[tf](Body|Gravity)", "\\1", e))
names(tidy_set) <- sapply(names(tidy_set), function(e) gsub("Mean", "mean", e))
names(tidy_set) <- sapply(names(tidy_set), function(e) gsub("mean", ".Mean", e))
names(tidy_set) <- sapply(names(tidy_set), function(e) gsub("std", ".Std", e))
names(tidy_set) <- sapply(names(tidy_set), function(e) gsub("([XYZ])$", ".\\1", e))
names(tidy_set) <- sapply(names(tidy_set), function(e) gsub("Jerk", ".Jerk", e))
names(tidy_set) <- sapply(names(tidy_set), function(e) gsub("Freq", ".Freq", e))
names(tidy_set) <- sapply(names(tidy_set), function(e) gsub("Mag", ".Magnitude", e))
names(tidy_set) <- sapply(names(tidy_set), function(e) gsub("Gyro", ".Gyroscope", e))
names(tidy_set) <- sapply(names(tidy_set), function(e) gsub("BodyBody", "Body.Body", e))
names(tidy_set) <- sapply(names(tidy_set), function(e) gsub("angle", "Angle.", e))
names(tidy_set) <- sapply(names(tidy_set), function(e) gsub("gravity", ".Gravity", e))

# Save the tidy data set
write.table(tidy_set, "tidy.txt", row.name = F)