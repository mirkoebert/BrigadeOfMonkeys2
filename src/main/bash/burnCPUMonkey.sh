#!/bin/bash
# This script will be executed on an agent (remote).


logger -p user.info -s "Burn CPU Monkey"

trap "killall yes; exit" SIGHUP SIGINT SIGTERM

os=`uname`
echo "Execute on $os"
if [[ "$os" == 'Linux' ]]; then
    core=`nproc`
elif [[ "$os" == 'Darwin' ]]; then
    core=`sysctl -n hw.ncpu`
else
    logger -p user.warn -s "Brigades of Monkeys (BoM): Unsupported platform: $os"
    exit
fi

for i in `seq 1 $core`;
do
    #echo core $i
    yes > /dev/null &
done  
echo "Wait some time"
sleep $1
killall yes
