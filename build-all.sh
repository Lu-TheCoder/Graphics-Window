#!/bin/bash
# Build Script for Cleaning or Builiding everything.

PLATFORM="$1"
ACTION="$2"
TARGET="$3"

set echo off

txtgrn=$(echo -e '\e[0;32m')
txtred=$(echo -e '\e[0;31m')
txtrst=$(echo -e '\e[0m')

if [ $ACTION = "all" ] || [ $ACTION = "build" ]
then
    ACTION="all"
    ACTION_STR="Building"
    ACTION_PAST="Built"
elif [ $ACTION = "cleam" ]
then
    ACTION="clean"
    ACTION_STR="cleaning"
    ACTION_PAST="cleaned"
else
    echo "Unknown action $ACTION. Aborting" && exit
fi

echo "$ACTION_STR everything on $PLATFORM ($TARGET)..."

#BUILD PLATFORM LAYER
make -f Makefile.Platform_Layer.mak $ACTION TARGET=$TARGET ASSEMBLY=src
ERRORLEVEL=$?
if [ $ERRORLEVEL -ne 0 ]
then
echo "error:"$errorlevel | sed -e "s/error/${txtred}error${txtrst}/g" && exit
fi
