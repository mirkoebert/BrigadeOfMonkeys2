#1 /bin/sh

eventlog="bom-event.log"
resultlog="bom_v2.log"
logdir="/var/opt/log/jenkins"
r="src/main/r"

function log {
    loadstart=`date  "+%s"`
    echo $loadstart,\"BoM: $1\" | tee -a $eventlog
}
