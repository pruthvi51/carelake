PYTHON ?= $(shell if [ -f ../.venv/bin/python3 ]; then echo ../.venv/bin/python3; elif [ -f .venv/bin/python3 ]; then echo .venv/bin/python3; else which python3; fi)
PYTEST ?= $(shell if [ -f ../.venv/bin/pytest ]; then echo ../.venv/bin/pytest; elif [ -f .venv/bin/pytest ]; then echo .venv/bin/pytest; else which pytest; fi)
STREAMLIT ?= $(shell if [ -f ../.venv/bin/streamlit ]; then echo ../.venv/bin/streamlit; elif [ -f .venv/bin/streamlit ]; then echo .venv/bin/streamlit; else which streamlit; fi)

.PHONY: help setup ingest-bronze test demo bench clean

help:
	@echo "CareLake Medallion Lakehouse Commands:"
	@echo "  make setup          Install dependencies with uv"
	@echo "  make ingest-bronze  Execute PySpark Bronze ingestion job"
	@echo "  make test           Run unit and data quality test suite"
	@echo "  make demo           Launch Streamlit clinical data product explorer"
	@echo "  make bench          Run query latency benchmark (naive views vs star schema)"

setup:
	uv pip install -e ".[dev]"

ingest-bronze:
	$(PYTHON) -m carelake.ingest.bronze_loader --raw-dir seeds --output-dir warehouse/bronze

test:
	$(PYTEST) -v tests/

demo:
	$(STREAMLIT) run app/streamlit_app.py

bench:
	$(PYTHON) -m carelake.benchmarks.run_benchmark

clean:
	rm -rf target/ dbt_packages/ warehouse/ .pytest_cache
