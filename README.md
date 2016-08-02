# BrigadeOfMonkeys2
Software Robustness Test Suite, an alternative to Netflix Simian Army.

You can run single robustness test or a test suite. Finnaly you can calculate a robustness KPI and report.

## Requirements
- BASH
- SSH
- R
- [Graphite](https://graphite.readthedocs.io/en/latest/index.html)
- [Monit](https://mmonit.com/monit/)

## Configuration

The configuration file is in a key-value format. To work correctly,
the file must be also importable to a bash script using `source`.
Note that the configuration file is not (yet) validated!

An example can be found in `example/bom2.properties`

The following keys are mandatory and must be set:

* graphite (Link to graphite, e.g. `http://graphite/`)
* ssh (SSH host address, e.g. `deploy@`)
* r (The path to the R scripts, e.g. `src/main/r`)
* logdir (The log directory, e.g. `"."` or `"/var/log"`)
* eventlog (Name of the log file where events are stored)
* resultslog (Name of the csv file where data is stored)
* agents4monkey (Path to a file where available agents, e.g. `localhost` are stored)
* agents4analysis (Path to a file where agents for the analysis step are stored)
* NormalWorkingPhaseDurationSec (Seconds to work during normal working phases)
* DisturbancePhaseDurationSec (Seconds to work during disruption phases)


## Run a single robustness test

Run `bash src/main/bash/startSingleRobustnessTest.sh path/to/config microservic

## Results

The single test generates two result files which are stored in CSV format.
These are

* `bom-event.log` which contains all events generated bei BoM2
* `bom_v2.log` which contains the results of the robustness test

### Result file structure

The header of the `bom_v2.log` is the following:

* test state
* test type
* timestamp
* monkey type
* exceptance rule
* server name
* measured value
* expected value
* micro service
* vertical name

#### Test States

- 3 - sucessful test
- 2 - test failed, but the result is near successful
- 1 - test failed
- 0 - test run terminated in case of an internal error, default value

