#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f -- "$BASH_SOURCE")")"
source "$SCRIPT_DIR/.awsenvrc"

showHelp() {
  echo "Syntax: ./init_jump_box.sh <jump_box_dns_name> <path-to-key-file>"
  echo
  echo "This helper script will send using scp command a given key file to the jump-box"
}

if [ $# -lt 2 ]; then
  showHelp
  exit 1
else
  JUMP_BOX_DNS_NAME="$1"
  JUMP_BOX_FILE="$(readlink -f $2)"

  if [ -z $JUMP_BOX_FILE ]; then
    echo "Unable to find jump box key file name"
    exit 1
  fi

  COMMAND="scp -i $JUMP_BOX_FILE $JUMP_BOX_FILE ec2-user@$JUMP_BOX_DNS_NAME:~/"
fi

showConnection() {
  echo "To access jump box use: ssh -i $JUMP_BOX_FILE ec2-user@$JUMP_BOX_DNS_NAME"
}

echo "About to send key file to jump box using command: $COMMAND"
echo
$COMMAND && showConnection
