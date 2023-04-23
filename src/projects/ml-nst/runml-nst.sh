#!/bin/bash

#
# NOTE: this script is run by cloud-init
#       which means it is run by root, and $HOME is /root
#

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# SCRIPT_DIR is /root/provisioner-launch/src/projects
#
PROJECT_DIR=$SCRIPT_DIR/../../..

              

# severe difficulties arise when either trying
#    * to move /*/provisioner-launcher to a different directory, or
#    * to copy /*/provisioner-launcher to another directory

# So: just change the ownership "to a normal user"
bash $PROJECT_DIR/src/helpers/project-chown.sh


#
# put your project-specific code here
#
#   1 - record stuff  TBD
## script

#   2 - get the project code
git clone https://github.com/timtiemens/ml-style-transfer.git $PROJECT_DIR/ml-style-transfer
#   3 - run the project code
#     Note the "$LOCAL_TEST_ARGS", which will be "" on AWS instances
#          but can be set to $ EXPORT LOCAL_TEST_ARGS="--epochs 10"
echo CD to $PROJECT_DIR/ml-style-transfer
echo LOCAL_TEST_ARGS is $LOCAL_TEST_ARGS
cd $PROJECT_DIR/ml-style-transfer
python  nst-standalone.py $LOCAL_TEST_ARGS
#   4 - upload outputs to s3
ls -ld outputs
ls -l outputs
$PROJECT_DIR/src/aws/bash/upload-dir-to-unique-s3.sh outputs

