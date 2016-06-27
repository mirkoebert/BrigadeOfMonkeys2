# Report generation from robustness tests

    Usage: sh pipeline.sh dataset vertical date
    
Date must be in format `YEAR-MONTH-DAY`. 
Valid verticals can be checked with `sh valid_verticals.sh datafile`

Example usage: sh pipeline.sh data/raw/myfile.csv xy 2015-12-17

## Organization

    |-- data
        |-- raw             <-- contains raw immutable data files
        |-- interm          <-- intermediate, transformed data
        |-- processed       <-- final data
    |-- reports             <-- contains the reports as folders
    |-- src                 <-- holds all code
        |-- __init__.py
        |-- html.py         <-- HTML report main script
        |-- make_datasets.py<-- main script for dataset generation
        |-- common.py       <-- common functions and constants
    |-- Makefile            <-- Makefile for automation
    |-- valid_verticals.sh  <-- Sanity check 
    |-- requirements.txt    <-- dependencies

## Automation

Automation is provided by the Makefile and eventually in the future some setup
script.

Targets can be displayed with `make help`.

## Todo

- Better configuration
