#!/bin/bash

#
# change the owner of this entire (git) project directory
#  to a "normal" user
#
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR=$SCRIPT_DIR/../..

SCRIPT_GET_NORMAL_USER=$SCRIPT_DIR/get-normal-user.sh)

NORMAL_USER=$(bash $SCRIPT_GET_USER)

TARGET_DIR=$PROJECT_DIR
#chown -R $(id -u):$(id -g) $TARGET_DIR

U=$(id -u $NORMAL_USER)
G=$(id -g $NORMAL_USER)
chown -R $U:$G $TARGET_DIR


#
# Another issue: our parent directories may be locked down
#  (currently, the git clone is going to /run/provisioner/provisioner-launch)
#
chmod 777 $TARGET_DIR/..
