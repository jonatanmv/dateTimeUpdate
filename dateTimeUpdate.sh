#!/bin/sh
IFS_orig=$IFS # Internal field separator original

#
# Author: Jonatan Morales <jonatan.mv@gmail.com>
#
# Summary: Updates the file creation date of for example a bunch of multimedia files.
#

usage() {
    echo
    echo "$0 [-d <date> \"<pattern1>\"] [-e \"<ext1> <ext2>\"] [-t \"<pattern2>\"]"
    echo
    echo "Where:"
    echo
    echo "    -d: Script will append <date> to files from pattern <pattern>"
    echo "        <date>: Date as YYYYMMDD (useful for use later with \"-t\" option)."
    echo "        <pattern1>: Filename pattern. Please use \"<pattern>\"."
    echo
    echo "    -e: Script will copy dates from *.ext1 files to *ext2 files."
    echo " 	      <ext1>: Filename extension."
    echo "        <ext2>: Filename extension."
    echo
    echo "    -t: Script will update date in files from the 8 first chars as date (format YYYYMMDD)."
    echo "        <pattern2>: Filename pattern that should start with yyyymmdd to be used as date."
    echo
    echo "Examples:"
    echo
    echo "    $0 -e \"mpg mp4\" ==> Copy date from the *.mpg files to *.mp4 files of same filename."
    echo "    $0 -d 20100115 \"*.jpg\" --> Append YYMMDD to all the jpg files in current directory"
    echo "    $0 -t \"*.jpg\" ==> Update date of files according filename (yyyymmdd)."
    echo
    exit -1
}

if [ $# -eq 0 ]
then
    usage
    exit -1
fi

opts=hd:e:t:
error=0

while getopts $opts opt
do
    case ${opt} in
	d)
	    arg1="${OPTARG}"
	    arg2="${!OPTIND}"; # $OPTIND is an integer, index of next command line argument
	    OPTIND=$(( $OPTIND + 1 ))
	    if [ -z $arg2 ]
	    then
	    	echo "Missing argument. Please read help."
	    	usage
	    	exit -1
	    fi
	    if [ ${arg2:0:1} == "-" ]
	    then
	    	echo "Wrong argument. Please read help."
	    	usage
	    	exit -1
	    fi
	    date=$arg1
	    pattern=$arg2	
	    #echo "Parameter: -$opt. Append $date to filenames $pattern."   
	    IFS="$(printf '\n\t')"
		for filename in $(ls -1 $pattern)
	    do
	    	echo "Command: mv \"$filename\" \"${date}_${filename}\""
	    	#mv "$filename" "${date}_${filename}"
	    done
	    IFS=IFS_orig
	    exit
	    ;;
	e)
	    arg1="${OPTARG}"
	    arg2="${!OPTIND}"; # $OPTIND is an integer, index of next command line argument
	    if [ -z $arg2 ]
	    then
	    	echo "Missing argument"
	    	usage
	    	exit -1
	    fi
	    if [ ${arg2:0:1} == "-" ]
	    then
	    	echo "Wrong argument. Please read help."
	    	usage
	    	exit -1
	    fi
	    OPTIND=$(( $OPTIND + 1 ))
	    ext1=$arg1
	    ext2=$arg2
	    ext1_length=$(expr ${#ext1} + 1)
	    ext2_length=$(expr ${#ext2} + 1)
		echo "Parameter: -$opt. Copying date from $ext1 to $ext2"
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
	t)
	    arg1=$OPTARG
	    pattern=$arg1
	    echo "Updating file date with YYMMDDYYMMDD date from filename first 8 chars..."
	    echo "pattern=$pattern"
	    if [[ '$pattern' != -1 ]]
	    then
		IFS="$(printf '\n\t')"
		for filename in $(ls -1 $pattern)
		do
            yyyymmdd=$(echo $filename | cut -c1-8)
            timestamp=$yyyymmdd"0000"
            echo  "Command: touch -t $timestamp $filename ... (done)"
            touch -t $timestamp $filename
		done
		IFS=IFS_orig
	    fi
	    exit
	    ;;
     *)
	    error=1
	    usage
	    exit -1
	    ;;
    esac
done

exit

