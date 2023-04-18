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

