#1 /bin/sh


function log {
    loadstart=`date  "+%s"`
    echo $loadstart,\"BoM: $1\" | tee -a $eventlog
}
