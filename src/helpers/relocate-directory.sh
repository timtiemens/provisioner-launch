#!/bin/bash

# Moves the directory (default "/provisioner-launch") to the
#  $HOME directory, and set chown to the user
# Does nothing if $HOME/$(basename $SOURCE_DIR) is already a directory


SOURCE_DIR=${1:-/provisioner-launch}

if [ ! -d "$SOURCE_DIR" ]
then
    echo "ERROR: not a directory: $SOURCE_DIR"
    exit 1
fi

TARGET_DIR="$HOME/$(basename $SOURCE_DIR)"

if [ -d "$TARGET_DIR" ]
then
    echo "NOTE: already a directory $TARGET_DIR"
    echo "Doing nothing"
    exit 1
fi


echo SOURCE_DIR is $SOURCE_DIR
echo TARGET_DIR is $TARGET_DIR

sudo mv $SOURCE_DIR $TARGET_DIR

sudo chown -R $(id -u):$(id -g) $TARGET_DIR

echo Moved $SOURCE_DIR to $TARGET_DIR
