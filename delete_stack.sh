#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f -- "$BASH_SOURCE")")"
source "$SCRIPT_DIR/.awsenvrc"

showHelp() {
  echo "Syntax: ./delete_stack.sh <stack-name>"
  echo "Script rely on sourcing .awsenvrc file which configures reasonable defaults for CLI profile, region etc."
}

showProps() {
  echo " Script: $SCRIPT_DIR"
}

if [ $# -lt 1 ]; then
  showHelp
  exit 1
else
  STACK_NAME="--stack-name $1"

  AWS_STACK_OPERATION=$(aws cloudformation describe-stacks $STACK_NAME $COMMON_CMD_PARAMS > /dev/null 2>&1 && echo 'delete-stack')
  if [ -z "$AWS_STACK_OPERATION" ]; then
    echo "Unable to delete stack, reason: stack not found";
    exit 1
  fi

  AWS_COMMAND="aws cloudformation $AWS_STACK_OPERATION $STACK_NAME $COMMON_CMD_PARAMS"

  echo "About to use following parameters:"
  echo "         Profile: $PROFILE"
  echo "          Region: $REGION"
  echo " Stack operation: $AWS_STACK_OPERATION"
  echo
  echo "Full AWS command: $AWS_COMMAND"
fi

echo "About to call: $AWS_COMMAND"
echo
$AWS_COMMAND
