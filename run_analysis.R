# getting and cleaning data class project
# 
library(reshape2)

# Download Dataset --------------------------------------------------------
setwd('C:\\get-clean-data\\project')

# create data dir
data_dir = './data'
if (!file.exists(data_dir)) {
  dir.create(data_dir)
}

# download/unzip file, if it doesn't exist
dl_file <- 'HAR.zip'
dl_path <- file.path(data_dir, dl_file)
dl_check <- file.path(data_dir, 'DELETE_ME.txt')

# get file
if (!file.exists(dl_path) && !file.exists(dl_check)) {
  dl_url <- paste0('http://archive.ics.uci.edu/ml/',
                   'machine-learning-databases/00240/UCI HAR Dataset.zip')
  download.file(dl_url,
                destfile=dl_path)
}

# unzip file, move stuff around
if (!file.exists(dl_check)) {
  unzip(dl_path, exdir=data_dir)

  # move files up, get rid of folder/zip
  uz_path <- file.path(data_dir, 'UCI HAR Dataset')
  if (file.exists(uz_path)) {
    # find all files/dirs to move
    dfiles <- list.files(uz_path)
    dfrom <- sapply(dfiles, function(i) file.path(uz_path, i))  
    dto <- sapply(dfiles, function(i) file.path(data_dir, i)) 
    
    # move them
    for (i in 1:length(dfiles)) {
      file.rename(dfrom[i], dto[i])
    }
    
    # clean up
    unlink(uz_path, recursive=TRUE)
    unlink(dl_path)
    
    # signal we have the data (delete to redownload)
    con <- file(dl_check)
    writeLines(
      paste("Delete content of './data' directory and re-run 'run_analysis.R'",
            "Or, place the a zip file name 'HAR.zip' in the './data' directory",
            sep="\n"),
      con=con)
    close(con)
  }
}

# Read in test/train data -------------------------------------------------
# set up lists of file names
files_tt <- c("subject", "X", "y")  # data files read from test and train
names_tt <- c(sapply(files_tt, function(i) paste0(i, "_test"), 
                     USE.NAMES=FALSE),
              sapply(files_tt, function(i) paste0(i, "_train"), 
                     USE.NAMES=FALSE))
dirs_tt <- rep(c(file.path(data_dir, "test"),
                 file.path(data_dir, "train")), each=3)

# store all read in files in a list
lst <- vector("list", length(names_tt))
names(lst) <- names_tt

# loop over all files and read them in
for (i in 1:length(lst)) {
  f <- file.path(dirs_tt[i], paste0(names_tt[i], '.txt'))
  
  lst[[names_tt[i]]] <- read.table(f,
                                   sep="")
}

# Combine Test/Train sets -------------------------------------------------
subject <- rbind(lst[[names_tt[1]]], lst[[names_tt[4]]])
names(subject) <- c("subject")

X <- rbind(lst[[names_tt[2]]], lst[[names_tt[5]]])
Y <- rbind(lst[[names_tt[3]]], lst[[names_tt[6]]])

# Read in features, find mean/std variables -------------------------------
features <- read.table(file.path(data_dir, 'features.txt',
                                 sep=""))
names(features) <- c("colnum", "name")

# feature names with mean/std in the name
fmean <- grepl("mean()", features$name)  # TODO: does meanFreq() count as mean?
fstd <- grepl("std()", features$name)
fkeep <- fmean | fstd

# extract only mean/std columns, add variable names
Xmeanstd <- X[, fkeep]
names(Xmeanstd) <- features$name[fkeep]

# Add descriptive activity names ------------------------------------------
act <- factor(Y$V1, 
              levels=c(1, 2, 3, 4, 5, 6),
              labels=c("Walk", "Walk up stairs", "Walk down stairs", "Sit", "Stand", "Lay"))



# Create tidy summary dataset ---------------------------------------------
# each row should be the average of a variable
# for each subject and each activity
Xcombined <- cbind(Xmeanstd, act, subject)
Xmelt <- melt(Xcombined,
              id=c("act", "subject"),
              measure.vars=names(Xmeanstd))
Xtidy <- dcast(Xmelt, act + subject ~ variable, mean)

# Save data ---------------------------------------------------------------
write.table(Xtidy,
            file=file.path(data_dir, "tidy.csv"),
            sep=",",
            row.names=FALSE)