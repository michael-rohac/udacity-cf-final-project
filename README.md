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


