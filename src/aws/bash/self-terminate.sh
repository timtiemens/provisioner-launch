#!/bin/bash

#
# IMPORTANT - this script requires permissions
#
# you can test your permissions with
#   $ aws ec2 describe-instances
#

aws ec2 terminate-instances --instance-ids $(curl -s http://169.254.169.254/latest/meta-data/instance-id)
