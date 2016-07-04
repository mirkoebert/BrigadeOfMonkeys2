#!/bin/bash
# This script (monkey) will be executed on an agent (remote).



switchOffWaitOn(){
    sudo /usr/bin/monit stop $2
    echo "Wait some time"
    sleep $1
    sudo /usr/bin/monit start $2
}

burnCPU(){
    logger -p user.info -s "Burn CPU"

    trap "killall yes; exit" SIGHUP SIGINT SIGTERM

    os=`uname`
    echo "Execute on: $os"
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

}

# for testing only
#cat MonitMock.txt | grep tomcat > /dev/null
t=-1
if [ -e /usr/bin/monit ] 
then
    sudo /usr/bin/monit summary | grep tomcat > /dev/null
    t=$?
fi



if (( $t == 0)); then
    switchOffWaitOn $1 localhost-tomcat
    #elif (( $m == 0)); then
    #    switchOffWaitOn $1 mongod
else
    burnCPU $1
fi





