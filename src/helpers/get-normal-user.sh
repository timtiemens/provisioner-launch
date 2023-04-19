#!/bin/bash

# intended to be run as a non-sudo'd root, i.e. has no access to
#   any "normal" user
CANDIDATE_USER=errornotfound

FIRST_IN_HOME=$(ls /home | head -1)
CANDIDATES="ec2-user ubuntu centos $FIRST_IN_HOME"
for i in $CANDIDATES
do
    if [ -d /home/$i ]
    then
        CANDIDATE_USER=$i
        break
    fi
done

# at this point, CANDIDATE_USER is set to the 'normal' username
#  e.g. ec2-user or ubuntu or ...
echo $CANDIDATE_USER

