#!/bin/bash

#
# This script runs as "the normal user" (e.g. ec2-user or ubuntu)
#
# Arguments
#   launcer_project_dir aka PROJECT_DIR -
#         e.g. /run/provisioner/provisioner-launch/
#         this directory is expected to be owned by the current $(id)
#
# This is required to get access to the "normal":
#   python
#   aws

PROJECT_DIR=$1

if [ ! -d "$PROJECT_DIR" ]
then
    echo "Programmer error, not a directory: $PROJECT_DIR"
    exit 1
fi

#
# put your project-specific code here
#
#   1 - record stuff  TBD
## script

#   2 - get the project code
git clone https://github.com/timtiemens/ml-style-transfer.git $PROJECT_DIR/ml-style-transfer
#   3 - run the project code
#     Note the "$LOCAL_TEST_ARGS", which will be "" on AWS instances
#          but can be set using:
#          $ export LOCAL_TEST_ARGS="--epochs 11 --saveEveryEpoch 10"
#     Note the name 'input.json' can be changed for a local run with
#          $ export LOCAL_TEST_FILENAME_INPUT=input-local.json
#
echo CD to $PROJECT_DIR/ml-style-transfer
cd $PROJECT_DIR/ml-style-transfer
# sudo -u $(src/helpers/get-normal-user.sh) bash src/projects/ml-nst/runml-nst.sh 

#  ISSUE: when cloud-init runs, it runs as root, and "python" is not
#         in the PATH...
#  ISSUE: and "aws" is not in the path either
#  Being able to just call "python" is why this is in its own script file:

# TEMPORARY: reduce epochs for AWS
# export LOCAL_TEST_ARGS="--epochs 11 --saveEveryEpoch 10"

# DESIGN DECISION: why not allow entire path to be overriden here?
#        Answer: this script is for automation, and any testing should
#                replicate the automation environment as closely as possible,
#                and that means the .json file should be in git.
FILENAME_INPUT_JSON=${LOCAL_TEST_FILENAME_INPUT:-input.json}
PROJECT_INPUT_JSON=$PROJECT_DIR/src/projects/ml-nst/${FILENAME_INPUT_JSON}

echo INPUT_JSON      is $PROJECT_INPUT_JSON
echo LOCAL_TEST_ARGS is $LOCAL_TEST_ARGS
python  nst-standalone.py --inputJson $PROJECT_INPUT_JSON  $LOCAL_TEST_ARGS


#   4 - upload outputs to s3
ls -ld outputs
ls -l outputs
$PROJECT_DIR/src/aws/bash/upload-dir-to-unique-s3.sh outputs

#   5 - self-terminate the instance
bash $PROJECT_DIR/src/aws/bash/self-terminate.sh
