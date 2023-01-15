# Project Overview

Purpose of this repository is to submit final project in Udacity nanodegree program.

* Nanodegree Program: **Cloud DevOps Engineer**
* Project: **Deploy a high-availability web app using CloudFormation**

# Howto Guide

This project will provide Infrastructure as Code (IaC) using AWS CloudFormation (CF) scripts. To run the scripts
in AWS CLI use helper shell scripts described in next section.

## AWS CLI Scripts

In repository root there are 2 helper shell scripts simplifying creation, updates and deletion of AWS CF stacks.

For create/update operation use `create_or_update.sh` while for deletion use `delete_stack.sh`. Both scripts sources
file `.awsenvrc` which defines common parameters for all AWS CLI commands like profile or region. To get some hints about
individual script, try to run them without parameters what will automatically show help. 

## How to provision IaC with Servers

Prerequisites:
- You're in repository root with correct AWS CLI setting
- You've updated `.awsenvrc` file accordingly - i.e. you've added right region, CLI profile etc.
- You've selected some reasonable infrastructure stack name - in example below `fpinfra`
- You've selected some reasonable server's stack name - in example below `fpservers`
- You've created KMS key to access jump box for easier troubleshooting. Appropriate key name was set in server.json. 

```shell
# 1. create infrastructure stack
$ ./create_or_update_stack.sh fpinfra ./infra.yml ./infra.json

# 2. create server's stack
$ ./create_or_update_stack.sh fpservers servers.yml servers.json
```

After these two steps you should have provisioned infrastructure & servers including jump box. To make jump box
usable to access other private EC2 instances in your VPC, you should:

* Wait for CREATE_COMPLETED status for both stacks
* Send a private pem key to jump box in order to use it for accessing private EC2 instances inside you VPC
* Be aware of fact, that jump box post configuration is needed only once unless you terminante it's instance and recreate it again

```shell
# when you run ./init_jump_box.sh without parameters it will give you hints about params
# first param is jump box DNS name which you can get from console, second one should point to the key file
$  ./init_jump_box.sh ec2-54-227-45-186.compute-1.amazonaws.com ../../jump-box-key.pem

# previous command shown how to access your jump box where you need to do one more step, so let's connect
ssh -i <some-path>/jump-box-key.pem ec2-user@ec2-54-227-45-186.compute-1.amazonaws.com

# this will happen on remote jump-box machine in AWS
[ec2-user@ip-10-0-0-4 ~]$ chmod 400 ./jump-box-key.pem
```

After this step you should be able to ssh to your jump box and go to given private EC2 instance as follow:

```shell
# assuming one of your EC2 instance is running on IP 10.0.1.158
# user ubuntu is here because this instance uses Ubuntu based AMI as opposed to jump-box AMI
[ec2-user@ip-10-0-0-4 ~]$ ssh -i ./jump-box-key.pem ubuntu@10.0.1.158
```

## Troubleshooting

In project were used 2 types of AMIs:

- Amazon Linux 2 (ami-0b5eea76982371e91) - used for JumpBox
- Ubuntu 18.04 (ami-08fdec01f5df9998f) - used for autoscaling group and webservers inside

For different AMIs there's different user. Amazon Linux AMI uses `ec2-user` while Ubuntu based AMI uses `ubuntu`, what must be
reflected in given ssh/scp commands.


# Results & Functional Test

* [Diagram](./IaC_FinalProject_Diagram.jpeg)
* Screenshots:
  * [Created CF stacks](./scrshots/cf_stacks.png)
  * [Auto scaling group detail](./scrshots/autoscaling_group_details.png)
  * [Load Balancer detail with public URL](./scrshots/lb_detail_showing_url.png)
  * [EC2 Instances after provisioning](./scrshots/ec2_instances.png)
  * [Private EC2 instance detail](./scrshots/private_ec2_instance_detail.png) - to prove it has no public IP/DNS name

Functional URLs via LoadBalancer:

* [Apache2 default page](http://fpser-webap-1ra7lkvfpty6o-1925703401.us-east-1.elb.amazonaws.com)
* [Health check created during provisioning](http://fpser-webap-1ra7lkvfpty6o-1925703401.us-east-1.elb.amazonaws.com/health.html)


