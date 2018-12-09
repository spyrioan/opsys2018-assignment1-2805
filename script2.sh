#!/bin/bash

if [ ! -r $1 ]; then #check existance of file
    exit 1;
fi

registers=$( tar xvf $1 )

IFS='
'

#Creation of dir
if [ ! -d assignments ]; then
    mkdir assignments
fi

for filename in $registers
do
    #Check if file .txt and readable
    if [ ${filename: -4} == ".txt" -a -r $filename ]; then
        content=$( cat $filename )

        for line in $content
        do
            #Check for correct links
            if [[ $line == "https"* ]]; then
                #Keeps only the rep
                dir_name=$( echo "$line" | cut -d'/' -f 5 | cut -d'.' -f 1 )
                git clone $line "assignments/$dir_name" > /dev/null 2> /dev/null
                #Checks cloning
                if [ $? -eq 0 ]; then
                    echo "$line: Cloning OK"
                else
                    >&2 echo "$line: Cloning FAILED"
                fi
                break
            fi

        done

    fi

done


for file in assignments/*
do
    registers=$(find $file -name ".git" -prune -o -print)
    directories=-1
    txtfiles=0
    otherfiles=0

    for line in $registers
    do
        if [ -d $line ]; then
            ((directories++))
        elif [[ ${line: -4} == ".txt" ]]; then
            ((txtfiles++))
        else
            ((otherfiles++))
        fi
    done

    reponame=$( echo $file | cut -d'/' -f 2 )
    echo "$reponame:"
    echo "Number of directories: $directories"
    echo "Number of txt files: $txtfiles"
    echo "Number of other files: $otherfiles"
    #Checks dir structure
    if [ -f $file/dataA.txt -a -d $file/more -a -f $file/more/dataB.txt -a -f $file/more/dataC.txt -a $txtfiles -eq 3 -a $otherfiles -eq 0 -a $directories -eq 1 ]; then
        echo "Directory structure is OK"
    else
        echo "Directory structure is not OK"
    fi

done

rm -rf assignments
exit 0
