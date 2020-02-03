#!/bin/bash

sourceDir=;
destDir=;
cleanDestDirExtension=;

helpText=$(cat << EOF
    Extract multiple compressed files within a directory to any chosen directory
    Version: 1.0.0
    Usage:  ./extract-compressed.sh   [-h|--help]
            ./extract-compressed.sh   -s|--sourceDir <source directory name> -d|--destDir <destination directory> -c|--cleanDestDir <extension of files to delete in destination directory. Default is csv if option is called without a value>

    Author: Daniel Okwufulueze [https://github.com/DOkwufulueze]
    Date: 03/02/2020

EOF
);

if [ $# -gt 0 ]; then
    while [ "$1" != "" ]; do
        case "$1" in
            -s | --sourceDir )
                shift;
                sourceDir="$1";
            ;;

            -d | --destDir )
                shift;
                destDir="$1";
            ;;

            -c | --cleanDestDir )
                shift;
                if [ -z "$1" ]; then
                    cleanDestDirExtension=csv;
                    break;
                fi

                cleanDestDirExtension="$1";
            ;;

            -h | --help )
                echo "${helpText}" | less +p;
                exit;
            ;;

            * )
                echo ":::Invalid option $1 supplied. Enter ./extract-compressed -h to see help."
                exit;
            ;;
        esac

        shift;
    done
fi

echo $cleanDestDirExtension

if [ -e $destDir ]
then
    if [[ ! -z $cleanDestDirExtension ]]
    then
        $(rm $destDir/*.$cleanDestDirExtension);
    fi
else
    $(mkdir $destDir);
fi

for gzFile in ${sourceDir}/*.gz
do
    gzFileName=$(basename $gzFile);

    gzip -dkc < "$gzFile" > $destDir/${gzFileName%%.gz};
done
