#!/bin/sh

#  Eprime 3 Data Transfer
#  Daniel Elbich
#
#  Created: 9/27/18
#
#  Searches partition for output files from E-Prime 3.0 (.edat3 and .txt) in a given directory and copies to another location. Script searches for files updated on current day (determined by time of machine) but can be updated or removed.
#
#
#  See links below for informations on locating recently updated files:
#  https://gotofritz.net/blog/howto/finding-recently-changed-files-osx-terminal/index.html
#  https://www.unixtutorial.org/2008/04/atime-ctime-mtime-in-unix-filesystems/
#
#


# Debug Code
#find . -mtime -1
#path=~/Dropbox
#find $path -mtime -1 -type f
#if [ ${file: -4} == "xlsx" ]
#id=$(whoami)

# Find recent files in given directory
datapath=/path/to/data/location

# Output directory
destinationpath=/path/to/data/destination

# Find recently changed files
#change to -1 for most recent
files=$(find $datapath -mtime -1 -type f)

# Search directory
for file in $files
do
echo

# Change number to match right side of equation - currently checks for extension text and E-dat types
if [ ${file: -4} == ".txt" ] || [ ${file: -6} == ".edat3" ]
then

cp $file $destinationpath

fi

echo
done


