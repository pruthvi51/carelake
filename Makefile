.PHONY: help setup ingest-bronze test demo bench paper clean

help:
	@echo "CareLake Medallion Lakehouse Commands:"
	@echo "  make setup          Install dependencies with uv"
	@echo "  make ingest-bronze  Execute PySpark Bronze ingestion job"
	@echo "  make test           Run unit and data quality test suite"
	@echo "  make demo           Launch Streamlit clinical data product explorer"
	@echo "  make bench          Run query latency benchmark (naive views vs star schema)"
	@echo "  make paper          Compile LaTeX research technical report with tectonic"

setup:
	uv pip install -e ".[dev]"

ingest-bronze:
	python3 -m carelake.ingest.bronze_loader --raw-dir ../healthdata-platform-infra/data/output/small --output-dir warehouse/bronze

test:
	pytest -v tests/

demo:
	streamlit run app/streamlit_app.py

bench:
	python3 -m carelake.benchmarks.run_benchmark

paper:
	cd paper && tectonic carelake_technical_report.tex

clean:
	rm -rf target/ dbt_packages/ warehouse/ .pytest_cache
