# Data directory
data_dir=data
data_raw=$(data_dir)/raw
data_interm=$(data_dir)/interm
data_processed=$(data_dir)/processed

# Reports
report_dir=reports

# Project
project_dir=src

# Tests
test_cmd=nosetests
test_flags=-w $(project_dir)

# ------------ Targets -----------------

.PHONY: help

# Display a help message
help:
	@echo "usage: Make <option>"
	@echo ""
	@echo "clean -- clean intermediate files"
	@echo "clean-py -- clean python artifacts"
	@echo "clean-data -- clean intermediate data"
	@echo "test -- run tests"

# Run tests
test:
	$(test_cmd) $(test_flags)

# Lint the python files
lint:
	find . -name '*.py' -exec pylint -r n -f colorized {} +

# Clean intermediate files and artifacts
clean: clean-py clean-data clean-report

clean-py:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -rf {} +

clean-data:
	@rm $(data_interm)/* -f
	@rm $(data_processed)/* -f

clean-report:
	find . -name '*.png' -exec rm -f {} +
	@rm $(report_dir)/*html
