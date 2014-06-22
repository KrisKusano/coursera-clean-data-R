# Get and Clean Data Project
Class project for Coursera class on getting and cleaning data using R

# Short description
This repo contains R code that downloads, reads, and summarizes a dataset.
For details on the dataset and tidy data it outputs (i.e. the `./data/tidy.csv` file), see the `CodeBook.md` file.

# Running script
The script `run_analysis.R` will download the dataset, unzip it, read it in, and ouptut the tidy dataset. 
The script looks for the file `./data/HAR.zip`. 
If the file exists, it unzips it.
If the file does not exist, the script downloads the zip from the web.

The script will read in the necessary data and output the tidy dataset in the file `./data/tidy.csv`.