#!/bin/sh
IFS_orig=$IFS

#
# Author: Jonatan Morales <jonatan.mv@gmail.com>
#
# Summary: Updates the file creation date of for example multimedia files (photo, video)
#          with the created date extracted by means of the exiftool (photo creation datetime)

# TODO
# -d functionality implementation

#
# 2013-04-08 Reviewed and testet -t functionality
# 2012-12-13 Supported arbitrary length for -e option file extensions
# 2012-12-13 Added support to filenames with blank spaces
#

usage() {
    echo
    echo "$0 [-d <filaname pattern>] [-t <\"yyyymmdd filaname pattern\">] [-e \"<file extension1 (3 chars)> <file extension2 (3 chars)>\"]"
    echo
    echo "Examples:"
    echo "    $0 -d 20100115 \"*.jpg\" --> Append YYMMDD to all the jpg files in current directory"
    echo "    $0 -t \"2007*\" ==> Update date of files according the 8 initial characteres in their filename (yyyymmdd pattern). It wil use 00:00 as time"
    echo "    $0 -e \"MPG mp4\" ==> Update date in files with extension mp4 taking the date from files with same filename and extension MPG"
    echo
    exit -1
}

if [ $# -eq 0 ]
then
    usage
    exit -1
fi

flags=d:t:e:
error=0
pattern=-1
ext1=-1
ext2=-1
date=-1

while getopts $flags flag
do
    case $flag in
	d)
	    args=$OPTARG
	    yymmdd=${args[0]}
	    pattern=${args[1]}
	    echo "Appending $yymmdd to filenames..."
	    echo "pattern=$pattern"
	    exit
	    for filename in *.jpg
	    do
	    	mv "$filename" "${yymmdd}_${filename}"
	    done
	    ;;
	t)
	    pattern=$OPTARG
	    echo "Updating file date with YYMMDD from filename..."
	    echo "pattern=$pattern"
	    if [ '$pattern' != '-1' ]
	    then
		IFS="$(printf '\n\t')"
		for filename in $(ls -1 $pattern)
		do
		    echo "filenameaneme=$filename"
                    yyyymmdd=$(echo $filename | cut -c1-8)
	            timestamp=$yyyymmdd"0000"
		    echo "timestamp=$timestamp"
                    #echo  "touch -t $timestamp $filename ... (done)"
                    touch -t $timestamp $filename
		done
		IFS=IFS_orig
	    fi
	    ;;
	e)
		echo "Updating file date from original files"
	    args=($OPTARG)
	    ext1=${args[0]}
	    ext2=${args[1]}
	    ext1_length=$(expr ${#ext1} + 1)
	    ext2_length=$(expr ${#ext2} + 1)
	    echo "Extensions: $ext1 and $ext2"
	    #echo "ext1=$ext1 (length $ext1_length)"
	    #echo "ext2=$ext2 (length $ext2_length)"
	    IFS="$(printf '\n\t')"
	    for file in $(ls *.$ext1)
	    do
		echo "Processing \"$file\""
		filename=$(echo $file | cut -c1-$(expr ${#file} - $ext1_length))
      		echo "    touch -r \"$filename.$ext1\" \"$filename.$ext2\""
		echo
                touch -r $filename.$ext1 $filename.$ext2
	    done
	    IFS=IFS_orig
	    exit
	    ;; 
        *)
	    error=1
	    usage
	    exit -1
	    ;;
    esac
done

if [ $pattern == -1 ]
then
    echo "\n Please, enter at least one of the options. -d , -t, or -e"
    usage
else
    IFS="$(printf '\n\t')"
fi

exit

