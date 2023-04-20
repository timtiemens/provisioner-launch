Provisioner-Launch
===================================

Intended as the lightweight solution to the problem of running
code at the launch (first boot) of a virtual machine.

Specifically intended to solve the problem of launching "Spot" p3.2xlarge
instances that need to run the machine learning code as soon as the
launch of the spot instance completes.

The goals:
1.  Keep the "paste into user data" section as small as possible
2.  Still be reasonably easy to configure for different problems
3.  Have easy "per-project" configurations


### User Data contents

user-data contents - aka cloud-init, aka cloud-config, working, 
 * the version puts the git (clone) directory in /provisioner-launch and
 * writes to /provisioner-launch/out.userdata.txt
 * everything is owned by root
 * some AMIs don't have git installed, so use 2 lines to make sure it is installed

```
#cloud-config
packages:
 - git
runcmd:
 - [ git, clone, 'https://github.com/timtiemens/provisioner-launch.git' ]
 - [ bash, '/provisioner-launch/src/sample.sh' ]
```

### Notes on cloud-config syntax

[cloudinit](https://cloudinit.readthedocs.io/en/latest/reference/examples.html#run-commands-on-first-boot)
 * if a list, i.e uses [ and ], then passed to execve(3)
 * if a string, then written to tmpfile.sh, run by 'sh tmpfile.sh'

In the above example, everything could have been written as a simple string.

### Another cloud-config

A note about not using /tmp to keep files during cloud-init processing:

```
#cloud-config
runcmd:
 # Note: Don't write files to /tmp from cloud-init use /run/somedir instead.
 # Early boot environments can race systemd-tmpfiles-clean LP: #1707222.
 - mkdir /run/mydir
 - [ wget, "http://slashdot.org", -O, /run/mydir/index.html ]
```




## Research References

[cloudsigma](https://github.com/cloudsigma/cloud-init/tree/master/doc/examples)
contains tons of examples of how not to do user-data

Some possibly legitimate examples of complicated scripts:
 * cloud-config-ca-certs.txt - add certificates, which you might need if you can't get to your git repository at launch
 * cloud-config-add-apt-repos.tx - you might need if the default apt/yum repositories are blocked by security policy

[gcgists](https://gist.github.com/gcgists/6466707)
super complicated set of cloud-init-*.txt -- there is almost no legitimate reason to put so much code into the cloud-init.


## Self Terminate from Inside Instance

Research on "self terminate from inside instance".

Instance Id == curl -s http://169.254.169.254/latest/meta-data/instance-id

This command needs another tool installed:
ec2-terminate-instances $(curl -s http://169.254.169.254/latest/meta-data/instance-id)

This command just works on most built-for-AWS images, because "aws" is already
installed.  And, for instance-profiles, the credentials are automatically
read from metadata.  Caveat: "aws ec2" seems to work, "aws s3" does not seem to work.

```
aws ec2 terminate-instances --instance-ids $(curl -s http://169.254.169.254/latest/meta-data/instance-id)
```

Other commands to test whether or not "aws ec2 ..." is configured properly:
```
aws ec2 describe-instances
aws ec2 report-instance-status
aws ec2 terminate-instances
```

### Create Instance Profile Role

https://docs.aws.amazon.com/sdk-for-java/latest/developer-guide/ec2-iam-roles.html

```
IAM console -> roles -> create role -> select trust entity -> AWS service
   use case: choose EC2, next
   Add Permissions page, choose
     AmazonEC2FullAccess
     AmazonS3FullAccess
```
when you launch the EC2 insance, then specify the IAM role


### AWS Console Launch dialog information

AMI for Deep Learning AMI [DLAMI](https://docs.aws.amazon.com/dlami/latest/devguide/options.html)

[ami-0649417d1ede3c91a](https://aws.amazon.com/releasenotes/aws-deep-learning-ami-gpu-tensorflow-2-12-ubuntu-20-04/)

[Inf1](https://aws.amazon.com/ec2/instance-types/inf1/)
inf1.xlarge, 4 vCPU 8GB, $0.228/hour


Launch Dialog
  name   --    
  Image  --   ami-0649417d1ede3c91a


Advanced
  IAM instance profile - launcherterminatorprovisioner
  instance type        - 52.small
  key pair name        - for ssh
  allow SSH traffic    - from MyIP
  User data            - see above

To create that IAM instance profile, follow these instructions
[iam-roles-ec2](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html)



Then, after instance is launched,
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html#instance-metadata-security-credentials

TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`


curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/iam/security-credentials/s3access

 
curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/iam/security-credentials/launcherterminatorprovisioner

Then, after instances is launched,
  SOLVE:  set default region
  aws ec2 describe-instances --region us-east-1 >a.ec2.describe-instances.json
  

NOTE: aws ec2 ... works
      aws s3  ...  still says "unable to locate credentials"

### Get TOKEN for our instance-profile (launcherterminatorprovisioner)

TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`

curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/iam/security-credentials/launcherterminatorprovisioner



That failed, try
https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_temp_use-resources.html

aws sts assume-role --role-arn
aws sts assume-role --role-arn arn:aws:iam::123456789012:role/role-name --role-session-name "RoleSession1" --profile IAM-user-name > assume-role-output.txt

ROLE_ARN=arn:aws:iam::802472656052:role/launcherterminatorprovisioner
ROLE_PROFILE=launcherterminatorprovisioner
