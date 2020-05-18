# Import data from each file
X_test <- read.table("./raw_data/test/X_test.txt")
Y_test <- read.table("./raw_data/test/Y_test.txt")
subj_test <- read.table("./raw_data/test/subject_test.txt")
X_train <- read.table("./raw_data/train/X_train.txt")
Y_train<- read.table("./raw_data/train/Y_train.txt")
subj_train <- read.table("./raw_data/train/subject_train.txt")

# Concatenate the 'test' and 'train' datasets.
X <- rbind(X_test, X_train)
Y <- rbind(Y_test, Y_train)
subj <- rbind(subj_test, subj_train)

# Get the descriptive feature names from 'features.txt'.
features <- read.table("./raw_data/features.txt")
features <- features[, 2]

# Label the columns of 'X' with the descriptive feature names.
colnames(X) <- features

# Create a subset of 'X' columns with names containing "mean()" or "std()".

library(stringr)
feature_subset <- str_subset(colnames(X), "(mean\\(|std\\()")
X_subset <- X[feature_subset]

# Get descriptive activity labels from 'activity_labels.txt'.
activity <- read.table("./raw_data/activity_labels.txt")

# Replace the numbers in 'Y' with the corresponding descriptive activity names.
for (i in Y) {
        label_Y <- str_replace(i, "[0-9]", activity[i,2])
}

# Join the three data frames, rename the subj/Y columns with descriptive labels.
combined_data <- cbind(subj, label_Y, X_subset)
colnames(combined_data)[1:2] <- c("subject", "activity")

# Group the resulting data set by subject, then activity. Then get the mean
# of each numeric variable and write this all into a new data set.

library(dplyr)
new_data <- combined_data %>%
        group_by(subject, activity) %>%
        summarise_all(mean)
write.csv(new_data, file = "./new_data.txt", row.names = FALSE)