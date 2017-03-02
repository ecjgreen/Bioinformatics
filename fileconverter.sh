#!/bin/bash

# Script checks FILE or all files in DIRECTORY for Windows- or Mac OS-style line breaks.
# Script converts non-Linux file(s) to Linux format, using dos2unix command.
# Script accepts one argument: FILE or DIRECTORY name

entry=
declare -i tally
declare -i exec
declare -i dir
declare -i total
declare -i unknown
declare -a dirlist
loop="y"

while [ "$loop" = "y" ]
do

# Display usage and get $entry.
if [ "$1" = "-h" ]; then
        echo "Usage: "
        printf "\t%s %s\n" check_n_format_EG.sh FILE
        printf "\t%s %s\n" check_n_format_EG.sh DIRECTORY
        echo "Converts file FILE or files in DIRECTORY to Linux format using dos2unix command, and tallies converted files."
        echo ""
        exit
elif [ "$1" = "" ]; then
        read -p "Enter file or directory to be checked: " entry
else
        entry=$1
fi

# Reset tally.
tally=0; exec=0; dir=0; total=0; unknown=0;

# Check if $entry is an executable, a file, a directory, or something else.
type=$(file -b $entry)
if [ -f $entry ]
then
        if [ "$type" = "Bourne-Again shell script, ASCII text executable" ]
        then
                echo "$entry is an executable. "
#               exec+=1; total+=1;

        #if [[ ("$type" = "ASCII text" || "$type" = "ASCII text, with CRLF line terminators") ]];

        elif [ "$type" = "ASCII text, with CRLF line terminators" ]
        then
                echo "$entry is a non-Linux file of type: $type"
                dos2unix ${entry}
#               tally+=1; total+=1;

        elif [ "$type" = "ASCII text, with very long lines, with CRLF line terminators" ]
        then
                echo "$entry is a non-Linux file of type: $type"
                dos2unix ${entry}
#               tally+=1; total+=1;

        elif [ "$type" = "ASCII English text, with CRLF line terminators" ]
        then
                echo "$entry is a non-Linux file of type: $type"
                dos2unix ${entry}
#               tally+=1; total+=1;

        else
                echo "File $entry was not changed."
                unknown+=1; total+=1;
                # It wouldn't hurt to just try to change the file anyway. An option for that could be included.
        fi
elif [ -d "$entry" ]
then
        echo "$entry is a directory"

        dirlist=$(ls -1 $entry)
        echo "Directory $entry expands to: "
        echo "${dirlist[@]} "
        echo ""

        cd $entry

# Loop through DIRECTORY and check each item.
        for i in ${dirlist[@]}
        do
                type=$(file -b $i)
                if [ -f $i ]
                then
                        if [ "$type" = "Bourne-Again shell script, ASCII text executable" ]
                        then
                                echo "$entry/$i is an executable. "
                                exec+=1; total+=1;

                        elif [ "$type" = "ASCII text, with CRLF line terminators" ]
                        then
                                echo "$entry/$i is a non-Linux file of type: $type"
                                dos2unix ${i}
                                tally+=1; total+=1;

                        elif [ "$type" = "ASCII text, with very long lines, with CRLF line terminators" ]
                        then
                                echo "$entry/$i is a non-Linux file of type: $type"
                                dos2unix ${i}
                                tally+=1; total+=1;

                        elif [ "$type" = "ASCII English text, with CRLF line terminators" ]
                        then
                                echo "$entry/$i is a non-Linux file of type: $type"
                                dos2unix ${i}
                                tally+=1; total=1;

                        else
                        echo "File $entry/$i was not changed."
                        unknown+=1; total+=1;
                        fi
                elif [ -d $i ]
                then
                        echo "$entry/$i is a subdirectory."
                        dir+=1; total+=1;
                else
                        echo "$entry/$i does not appear to be a file or subdirectory. It is type: $type"
                        unknown+=1; total+=1;
                fi
                done
                cd ..
                echo ""
                echo "Number of files converted to Linux format: ${tally}"
                echo "Number of executables: ${exec}"
                echo "Number of subdirectories: ${dir}"
                echo "Number of other unconverted items: ${unknown}"
                echo "Total number of items in directory ${entry}: ${total}"
else
        #$entry is neither a file nor a directory
        echo "$entry does not appear to be a file or directory. No actions taken. It is type: $type"
fi
echo ""
echo "All done."
echo ""
read -p "Try another? 'y' or 'n' " loop
done
# echo "See you later. I'll be here when you need me."
