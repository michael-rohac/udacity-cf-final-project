#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f -- "$BASH_SOURCE")")"
source "$SCRIPT_DIR/.awsenvrc"

showHelp() {
  echo "Syntax: ./create_or_update_stack.sh <stack-name> <template-body-file> <param-file>"
  echo
  echo "Script will use 'aws describe-stacks' to detect if stack already exists in order to use either create-stack or update-stack operation."
  echo "Required parameters uses <> while optional uses [] parenthesis which encloses logical name inside. There's no validation logic for given params!"
  echo
  echo "Script rely on sourcing .awsenvrc file which configures reasonable defaults for CLI profile, region etc."
}

showProps() {
  echo " Script: $SCRIPT_DIR"
}

if [ $# -lt 3 ]; then
  showHelp
  exit 1
else
  STACK_NAME="--stack-name $1"
  TEMPLATE_BODY="--template-body file://$2"
  PARAMETERS="--parameters file://$3"

  AWS_STACK_OPERATION=$(aws cloudformation describe-stacks $STACK_NAME $COMMON_CMD_PARAMS > /dev/null 2>&1 && echo 'update-stack')
  if [ -z "$AWS_STACK_OPERATION" ]; then AWS_STACK_OPERATION='create-stack'; fi

  AWS_COMMAND="aws cloudformation $AWS_STACK_OPERATION $STACK_NAME $TEMPLATE_BODY $PARAMETERS $COMMON_CMD_PARAMS"

  echo "About to use following parameters:"
  echo "         Profile: $PROFILE"
  echo "          Region: $REGION"
  echo " Stack operation: $AWS_STACK_OPERATION"
  echo
  echo "Full AWS command: $AWS_COMMAND"
fi

echo "About to call AWS..."
echo
$AWS_COMMAND
