#!/bin/sh

usage() {
    echo "usage: pipeline.sh <path_to_dataset> <vertical_name> [date]"
    echo ""
    echo "path_to_dataset: Path to the main raw dataset"
    echo "vertical_name: One valid vertical"
    echo "date: The date to use for analysis, default is the whole dataset"
}

if [ $# -lt 2 ]; then
    usage
    exit 0
fi

DATASET=$1
VERTICAL=$2
DATE=$3

PIPELINE_END=2

echo "Starting data processing pipeline"

echo "(1/${PIPELINE_END})\tSeperating of shop and ${VERTICAL}"
python src/make_datasets.py ${DATASET} ${VERTICAL} --date ${DATE}

echo "(2/${PIPELINE_END})\tGenerating HTML report of ${VERTICAL}"
python src/html.py ${DATASET} ${VERTICAL}
