#!/bin/bash
# This script (monkey) will be executed on an agent (remote).



switchOffWaitOn(){
    sudo /usr/bin/monit stop $2
    echo "Wait some time"
    sleep $1
    sudo /usr/bin/monit start $2
}

cat MonitMock.txt | grep tomcat > /dev/null
t=$?

cat MonitMock.txt | grep mongo > /dev/null
m=$?


if (( $t == 0)); then
    switchOffWaitOn $1 localhost-tomcat
elif (( $m == 0)); then
    switchOffWaitOn $1 mongod
else
    echo burn

fi





