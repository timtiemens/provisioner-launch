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


# run the project-specific code in the "-normal" script
sudo -u $(src/helpers/get-normal-user.sh) --login  bash $PROJECT_DIR/src/projects/ml-nst/runml-nst-normal.sh $PROJECT_DIR 

# note: this project (ml-nst) finishes with a "self-terminate.sh"

