#!/bin/bash

#
# NOTE: this script is run by cloud-init
#       which means it is run by root, and $HOME is /root
#

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# SCRIPT_DIR is /root/provisioner-launch/src/projects
#
PROJECT_DIR=$SCRIPT_DIR/../..

              

# severe difficulties arise when either trying
#    * to move /*/provisioner-launcher to a different directory, or
#    * to copy /*/provisioner-launcher to another directory

# So: just change the ownership "to a normal user"
bash $PROJECT_DIR/src/helpers/project-chown.sh


#
# put your project-specific code here
#
