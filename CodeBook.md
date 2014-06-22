# Data Code Book
This document describes the tidy output dataset contained in the directory
`./data/tidy.csv`. 

## Data origin
The original data set is the "Human Activity Recognition Using Smartphones Dataset",
which is available for download from [the UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).
A detailed description of the original dataset can be found in the README that accompanies the data.

The feature vectors, activity codes, and subject names were used to create the tidy data.
All raw inertial signal data was not used (i.e. all data in `./data/test/Inertial Signals` and
`./data/train/Inertial Signals` folders).

## Tidy Data Transformations
The following transformations were done on the origin dataset described above to create the tidy dataset.
1. The `test` and `train` data were combined together
2. Columns with `mean()` and `std()` were retained. All other columns were discarded.
3. The `mean()` and `std()` columns were averaged over all participants and activities. This averaging was accomplished using the `melt` and `dcast` functions from the `reshape2` library.
The resulting tidy dataset contains one row for each unique combination of participant and activity.