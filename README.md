## dateTimeUpdate.sh

Tool to set the creation date on a bunch of files with obsolete or wrong date.

### Motivation

The followings are the main motivations for the script "dateTimeUpdate.sh"

- This one is the main problem this project solves: Imagine your are working with several files. You have for example a number of video files recorded in MPG format. So one day you edit those files and convert them to mp4. The resulting files will not have the real date of recording but the date when they were converted. You will need a tool that allows you to copy the date from the original files to the new ones. 

- Imagine again you have a bunch of files, named "YYYYMMDD_name_of_the_file.mp4" for example multimedia files. The files have the right filename and YYYYMMDD is ok but they have been saved with a wrong date. You would need a tool that updates the creation date of the file according the filename. If your filenames are not appended with "YYYYMMDD" you will need to rename them first. This project includes this two finctionalities: append a date to a number of files and update date according that appended date in filename.

### Install

- For Unix type systems (MacOS, Linux, Solaris, etc...). Copy the script dateTimeUpdate.sh into a folder in your filesystem. Add that folde to your path if needed or just call the script using the full path to the archive, for example:
```shell

    /home/applications/dateTimeUpdate.sh -e mpg mp4
```
You can add a folder to the path bu editing your .bash_profile file:
```shell
    PATH="/Library/dateTimeUpdate/:${PATH}"
```

- For Windows. The usual solution inthis case is first to install cygwin from https://www.cygwin.com/ and then you do the installation as in any other Unix platform.

### How to use? Give me examples

Here you have some samples of real use:

```shell
    ./dateTimeUpdate.sh -e mpg mp4 # Copy date from the *.mpg files to *.mp4 files of same filename.
    ./dateTimeUpdate.sh -d 20100115 "*.jpg" # Append YYMMDD to all the jpg files in current directory
    ./dateTimeUpdate.sh -t "*.jpg" # Update date of files according filename (yyyymmdd).
```

