#!/bin/bash

#
# NOTE: this script is run by cloud-init
#       which means it is run by root, and $HOME is /root
# NOTE: our PWD is "/"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# SCRIPT_DIR is /provisioner-launch/src
#
PROJECT_DIR=$SCRIPT_DIR/..

              
OUTFILE=$PROJECT_DIR/out.userdata.txt

echo "this is from src/sample.sh" >$OUTFILE
date >>$OUTFILE

