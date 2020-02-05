#!/bin/bash

# declare variables
sourceDir=;
destDir=;
cleanDestDirExtension=;

# help text to be displayed when
# script is run with the -h option
helpText=$(cat << EOF
    Extract multiple compressed files within a directory to any chosen directory
    Version: 1.0.0
    Usage:  ./extract-compressed.sh   [-h|--help]
            ./extract-compressed.sh   -s|--sourceDir <source directory name> -d|--destDir <destination directory> -c|--cleanDestDir <extension of files to delete in destination directory. Default is csv if option is called without a value>

    Author: Daniel Okwufulueze [https://github.com/DOkwufulueze]
    Date: 03/02/2020

EOF
);

# check if the call to this script was followed by additional tokens
if [ $# -gt 0 ]; then

    # loop through the tokens [options and their values]
    while [ "$1" != "" ]; do
        case "$1" in

            # check if the -s or --sourceDir option was supplied,
            # shift if it was and read next token as value
            -s | --sourceDir )
                shift;
                sourceDir="$1";
            ;;

            # check if the -d or --destDir option was supplied,
            # shift if it was and read next token as value
            -d | --destDir )
                shift;
                destDir="$1";
            ;;

            # check if the -c or --cleanDestDir option was supplied,
            # shift if it was and read next token as value
            # or set its value to csv if no next token
            -c | --cleanDestDir )
                shift;
                if [ -z "$1" ]; then
                    cleanDestDirExtension=csv;
                    break;
                fi

                cleanDestDirExtension="$1";
            ;;

            # check if the -h or --help option was supplied,
            # display the help text if it was
            -h | --help )
                echo "${helpText}" | less +p;
                exit;
            ;;

            # show generic instruction if command was badly formed
            * )
                echo ":::Invalid option $1 supplied. Enter ./extract-compressed -h to see help."
                exit;
            ;;
        esac

        # move to the next token in the command
        shift;
    done
fi

# check if the destination directory exists
if [ -e $destDir ]
then

    # check if the file extension to clear from the destination
    # directory was supplied in the script invocation
    if [[ ! -z $cleanDestDirExtension ]]
    then

        # remove all files matching the supplied extension
        $(rm $destDir/*.$cleanDestDirExtension);
    fi
else

    # create the destination directory if it does not already exist
    $(mkdir $destDir);
fi

# uncompress each compressed file within the
# source directory into the destination directory
for gzFile in ${sourceDir}/*.gz
do
    gzFileName=$(basename $gzFile);

    gzip -dkc < "$gzFile" > $destDir/${gzFileName%%.gz} &&
    echo ":::Successfully extracted ${gzFileName} into ${destDir}" ||
    "<<<Failure - Unable to extract ${gzFileName} into ${destDir}";
done
