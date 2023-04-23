#!/bin/bash

#
# CAUTION -- this script will completely destroy the AWS EC2 instance
#         --  that it is running in (aka "terminate")
#

#
# IMPORTANT - this script requires permissions
#           - you can (partially) test your permissions with this command
#                 $ aws ec2 describe-instances
#

# NOTE: IMDSv2 requires a TOKEN to talk to metadata endpoint

echo Attempting to get TOKEN from metadata

TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
if [  "x$TOKEN" != "x" ]
then
    INSTANCE_ID=`curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id` 

    echo Attempting terminate-instances on $INSTANCE_ID
    aws ec2 terminate-instances --instance-ids $INSTANCE_ID
fi


