#!/bin/bash

tmp="tmp.txt"
status="results.txt"

#Create the empty .txt file for the website status
touch $status

#### FUNCTIONS

checkPage()
{
	  wget -q $1 -O $2 #md5sum of the page

	  if [ $? -ne 0 ]; then #If page could not be downloaded
	    echo $i FAIL >&2
	    echo $i FAIL >> $tmp
	  else #If page downloads normally
	    md5=($(md5sum $2))
	    sum=($(cat $status | grep $1))

	    if [ "${sum[1]}" == "" ]; then #INITiation
	      echo $i INIT
	    elif [ "$md5" != "${sum[1]}" ]; then #Check for updates
	      echo $1
	    fi

	    echo $1 $md5 >> $tmp
	  fi

	  rm -f $2
}

#### MAIN

COUNTER=0

for i in `cat "$1" | grep "^[^#]"`; do
	   checkPage $i $COUNTER
	   ((COUNTER++))
done

rm -f $status
mv $tmp $status
rm -f $tmp
echo "------END------"
