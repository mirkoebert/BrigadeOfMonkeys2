#!/bin/bash
echo "Read config file: $1" 
source $1

source src/main/bash/setup.sh
log "BoM: Start Brigade of Monkey: Single Tests"

echo "BoM: Normal working phase" 
sleep 300

echo "Read server names from file: $agentsi4monkeys $agents4analysis "
fileItemString=$(cat $agentsi4monkeys |tr "\n" " ")
fileItemArray=($fileItemString)
analyzeFileItemString=$(cat $agents4analysis |tr "\n" " ")
analyzeFileItemArray=($analyzeFileItemString)

log "Disturbance phase target micro service: $2" 
for agent in "${fileItemArray[@]}"
do
    echo "Run Monkey on: $i"
    if [[ "$agent" == 'localhost' ]]; then
        src/main/bash/burnCPUMonkey.sh
     else
        scp disruption_services.txt $ssh$agent:/tmp 
        (ssh $ssh$agent 'bash -s' < src/main/bash/serviceOffOnMonkey.sh)&
        echo "Link: $displayServerLinkPre$agent$displayServerLinkPost"
     fi
done
wait

normalizationstart=`date  "+%s"`
log "Normaization phase"
sleep 300

normalizationend=`date  "+%s"`
log "Analyze phase"
minutes=`$r/minutesDiffHelper.R $normalizationstart $normalizationend`
for agent in "${analyzeFileItemArray[@]}"
do
    echo "Analyze: $agent"
    cores=`(ssh $ssh$agent 'bash -s' < src/main/bash/getCores.sh)`
    if [[ "$agent" == 'localhost' ]]; then
        echo "Not supported on localhost"
    else
        $r/GraphiteCPUUsageRule.R       $graphite $agent $cores $minutes $2
        if [[ $agent == ib-proxy* ]] || [[ $agent == pa-proxy* ]]; then
            $r/GraphiteErrorRatioRule.R $graphite $agent        $minutes $2
            $r/GraphiteRuntimeRule.R    $graphite $agent        $minutes $2
        else 
            $r/GraphiteRuntimeAppServerRule.R    $graphite $agent $minutes $2
            $r/GraphiteErrorRatioAppServerRule.R $graphite $agent $minutes $2
        fi
    fi
done
wait

log "BoM: Ends"

cat $resultlog >> $logdir/$resultlog &
cat $eventlog  >> $logdir/$eventlog  &
wait
