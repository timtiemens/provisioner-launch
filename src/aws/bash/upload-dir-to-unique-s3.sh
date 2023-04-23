#!/bin/bash

#
# Usage:
#   $ upload-dir-to-unique-s3.sh ../path/to/directory
#      copies everything from ../path/to/directory/** to s3

#
S3_TOP_DIRECTORY=${S3_TOP_DIRECTORY:-ttautoalloutputs}



SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HELPERS_DIR=$SCRIPT_DIR/../../helpers
PROJECT_DIR=$SCRIPT_DIR/../../..

UNIQUE=$( $HELPERS_DIR/unique-name.sh )

#echo $UNIQUE

if [ $# -lt 1 ]
then
    echo "ERROR: must have directory name argument $#"
    exit 1
fi

INPUT_DIRECTORY=$1

if [ ! -d "$INPUT_DIRECTORY" ]
then
    echo "ERROR: not a directory: $INPUT_DIRECTORY"
    exit 1
fi

S3_TARGET=${S3_TOP_DIRECTORY}/$UNIQUE

echo Input Directory is $INPUT_DIRECTORY
echo S3 target is       $S3_TARGET

# safety checks:
aws s3 ls $S3_TOP_DIRECTORY 1>/dev/null  2>&1
if [ $? -ne 0 ]
then
    echo "Failed to find S3 bucket $S3_TOP_DIRECTORY"
    echo "Attempting make-bucket..."
    aws s3 mb s3://$S3_TOP_DIRECTORY
fi

aws s3 ls $S3_TOP_DIRECTORY 1>/dev/null  2>&1
if [ $? -ne 0 ]
then
    echo "Failed to find S3 bucket $S3_TOP_DIRECTORY"
    echo "Exit."
    exit
fi

echo "s3 sync $INPUT_DIRECTORY s3://$S3_TARGET"
aws s3 sync $INPUT_DIRECTORY s3://$S3_TARGET
ERR=$?
echo "Error code is $ERR"
