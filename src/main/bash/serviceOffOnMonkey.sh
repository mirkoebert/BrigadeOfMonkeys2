#!/bin/bash
# This script will be executed on an agent (remote).

echo "Read service names from file: services.txt"
fileItemString=$(cat /tmp/disruption_services.txt |tr "\n" " ")
fileItemArray=($fileItemString)

switchOff() {
    sudo /usr/bin/monit stop $1
}

switchOn() {
    sudo /usr/bin/monit start $1
}

echo "Switch service off, wait, switch on"
os=`uname`
echo "Service $fileItemArray]"
if [[ "$os" == 'Linux' ]]; then
    switchOff $fileItemArray
    echo "Wait some time"
    sleep $1
    switchOn $fileItemArray
else
    logger -s  "BoM: Error: Unsupported platform: $os"
    exit
fi

