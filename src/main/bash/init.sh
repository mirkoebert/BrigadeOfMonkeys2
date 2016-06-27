#!/bin/bash
echo "BoM.init"
script_dir="$(dirname "$0")"
echo "Read agent names from file: agent.txt"
fileItemString=$(cat agent_names.txt |tr "\n" " ")
fileItemArray=($fileItemString)

echo "Read config file: $1"
source $1
