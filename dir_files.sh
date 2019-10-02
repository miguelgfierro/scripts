#!/bin/bash
#
# This script count all files of a given type in the specified path
#
# @author Wojciech Lesniewski
#
DIRECTORY=$1

if [ $# -eq 0 ]; then
  echo "Usage /path/to/script directory"
  exit 3
elif [ ! -d "$DIRECTORY" ]; then
  echo "ERROR: /path/to/dir/ is not directory"
else
  DIR_COUNT=$(ls -l $DIRECTORY | grep -e '^d' | wc -l)
  FILE_COUNT=$(ls -l $DIRECTORY | grep -e '^-' | wc -l)
  SIM_COUNT=$(ls -l $DIRECTORY | grep '^l' | wc -l)
  BD_COUNT=$(ls -l $DIRECTORY| grep '^b' | wc -l) 
  echo -e "Regular file:\t$FILE_COUNT\nDirectory:\t$DIR_COUNT\nSpecialFile:\t$SIM_COUNT\nBlock Devices:\t$BD_COUNT\n"
  echo -e "Regular file $FILE_COUNT | Directory $DIR_COUNT | Special File $SIM_COUNT | Block devices $BD_COUNT"
fi
exit $?
