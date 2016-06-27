#! /bin/sh

source src/main/bash/setup.sh
source bom.properties

for s in "${disruptionTarget[@]}"
do
    # writes the names into file disruption_agent_names.txt
    src/main/bash/getServerNamesForService.sh $s
    cp server.txt disruption_agent_names.txt
    cp server.txt analyze_agent_names.txt
    rm server.txt
    
    if [ $dryrun == "true" ]
    then 
        echo "Dry run: $s"
    else
        src/main/bash/startRobustnessTest.sh  bom.properties $s 
    fi

done


