#!/bin/bash
source src/main/bash/setup.sh
log "BoM: Start Brigade of Monkey: Single Tests"

echo "BoM: Normal working phase" 
sleep 300

echo "Read server names from file: server_names.txt"
fileItemString=$(cat disruption_agent_names.txt |tr "\n" " ")
fileItemArray=($fileItemString)
analyzeFileItemString=$(cat analyze_agent_names.txt |tr "\n" " ")
analyzeFileItemArray=($analyzeFileItemString)

echo "Read config file: $1" 
source $1

log "Disturbance phase target micro service: $2" 
for agent in "${fileItemArray[@]}"
do
    echo "Run Monkey on: $i"
    if [[ "$agent" == 'localhost' ]]; then
        src/main/bash/chaosmonkey.sh
     else
        scp disruption_services.txt $ssh$agent:/tmp 
        (ssh $ssh$agent 'bash -s' < src/main/bash/serviceOffOnMonkey.sh)&
        src/main/bash/displayServerLink.sh $displayServerLinkPre $agent $displayServerLinkPost
     fi
done
wait

normalizationstart=`date  "+%s"`
log "Normaization phase"
sleep 300

normalizationend=`date  "+%s"`
log "Analyze phase"
minutes=`src/main/R/minutesDiffHelper.R $normalizationstart $normalizationend`
for agent in "${analyzeFileItemArray[@]}"
do
    echo "Analyze: $agent"
    cores=`(ssh $ssh$agent 'bash -s' < src/main/bash/getCores.sh)`
    if [[ "$agent" == 'localhost' ]]; then
        echo "Not supported on localhost"
    else
        src/main/R/GraphiteCPUUsageRule.R   $graphite $agent $cores $minutes $2
        if [[ $agent == ib-proxy* ]] || [[ $agent == pa-proxy* ]]; then
            src/main/R/GraphiteErrorRatioRule.R $graphite $agent        $minutes $2
            src/main/R/GraphiteRuntimeRule.R    $graphite $agent        $minutes $2
        else 
            src/main/R/GraphiteRuntimeAppServerRule.R    $graphite $agent $minutes $2
            src/main/R/GraphiteErrorRatioAppServerRule.R $graphite $agent $minutes $2
        fi
    fi
done
wait

log "BoM: Ends"

cat $resultlog >> $logdir/$resultlog &
cat $eventlog >> $logdir/$eventlog &
wait
