Provisioner-Launch
===================================

Intended as the lightweight solution to the problem of running
code at the launch (first boot) of a virtual machine.

Specifically intended to solve the problem of launching "Spot" p3.2xlarge
instances that need to run the machine learning code ASAP.

The goals:
1.  Keep the "paste into user data" section as small as possible
2.  Still be reasonably easy to configure for different problems
3.  Have easy "per-project" configurations


user-data contents - simple

```
#!/bin/bash
cd
git clone https://github.com/timtiemens/provisioner-launch.git
cd provisioner-launch
bash src/sample.sh
```

user-data contents - cloud-init :

```
#cloud-config
bootcmd:
 - echo 1.2.3.4 >test-ip.txt
 - [ cloud-init-per, once, ls, -l ]
runcmd:
 - [ mkdir, '-p', user-data-dir ]
 - git clone https://github.com/timtiemens/
```

If you see "config profile (default) could not be found"

```
git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true
```

Research References
[cloudsigma](https://github.com/cloudsigma/cloud-init/tree/master/doc/examples)
contains tons of examples of how not to do user-data
some possibly legitimate scripts:
 * cloud-config-ca-certs.txt - add certificates, which you might need if you can't get to your git repository at launch
 * cloud-config-add-apt-repos.tx - you might need if 'git' isn't already installed in your image

[gcgists](https://gist.github.com/gcgists/6466707)
super complicated set of cloud-init-*.txt -- why would you put so much
code into the cloud-init?
```
wget https://gist.github.com/tsmithgc/5223747/raw/cloud-init-clone.txt
```

[lucd](wget https://gist.github.com/tsmithgc/5223747/raw/cloud-init-clone.txt)
```
runcmd:
  - wget https://raw.githubusercontent.com/PowerShell/PowerShell/master/tools/install-powershell.sh
  - chmod 755 install-powershell.sh
```


