#!/bin/bash

# file filename --> result
# our program should handle a file or directory
# if its a mac or win file, change to unix
# if its a directory, check its files, and if theyre mac or win, change to unix

# you need a function to check format
# you need a function to convert format

# grep " CR " or " CRLF " or cut the fifth field

if [ $# -lt 1 ]; then
   echo "USAGE"
   echo "$0 file_or_dir_name"
fi

if [ $1 = "-h" ]; then
   echo "HELP"
   echo "I am going to provide you with help ..."
   echo "$0 file_or_dir_name"
   echo "More instructions here"
fi

convert ()
{
   frif=$1
#Would this take $fn
   testM=$( file $frif | grep " CR " )
   testD=$( file $frif | grep " CRLF " )
   if [[ $testM ]]; then
        echo "A Mac OS formatted file"
#       dos2unix -c mac $frif
   elif [[ $testD ]]; then
        echo "A DOS formatted file"
#       dos2unix $frif
   else
        echo "File is linux friendly"
   fi
}

in_file=$1
if [ -f $in_file ]; then
   convert $in_file
elif [ -d $in_file ]; then
   echo "This is a directory."
#   file $in_file/*
   lofn=$( ls -l $in_file)
   cd $in_file

   for fn in ${lofn[@]}
   do
        convert $fn
   done

else
   echo "Neither file nor directory."
fi
