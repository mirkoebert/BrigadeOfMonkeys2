#! /bin/bash
source bom.properties
echo "Get servers for service $1"
if [ $dryrun == "true" ]
then 
    echo "Dry run, return localhost"
    echo localhost > server.txt
else
    echo "TODO: use customer specific tool or list""
fi
