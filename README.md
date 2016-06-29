# BrigadeOfMonkeys2
Software Robustness Test Suite, alternative of Netflix Simian Army.

You can run single robustness test or a test suite. Finnaly you can calculate a robustness KPI and report.

## Requires
- R
- BASH
- SSH
- Graphite
- Monit

## Configuration
File: bom.properties, see example folder.

## Run a single robustness test
src/main/bash/startSingleRobustnessTest.sh development_conf.properties ${MICRO_SERVICE}

## Results
Booth result files are in format CSV
- bom-event.log contains all events generated bei BoM2
- bom_v2.log conaitns the results of the robustness test

### Structur of bom_v2.log
Test state, timestamp, Monkey, exceptance rule, server name, easured value, expected value, micro service name

- Test state 
    - 3 - sucessfull test
    - 2 - test failed, but the result is near successfull
    - 1 - test failed
    - 0 - test run terminated in case of an intrenal error, default value

