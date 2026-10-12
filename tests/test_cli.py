from click.testing import CliRunner
from carelake.cli import cli

def test_cli_status():
    runner = CliRunner()
    result = runner.invoke(cli, ["status"])
    assert result.exit_code == 0
    assert "CareLake Medallion Lakehouse Platform" in result.output
    assert "Healthy" in result.output

def test_cli_bench():
    runner = CliRunner()
    result = runner.invoke(cli, ["bench"])
    assert result.exit_code == 0
    assert "Benchmark Results" in result.output

def test_cli_ingest():
    runner = CliRunner()
    result = runner.invoke(cli, ["ingest", "--raw-dir", "seeds", "--output-dir", "warehouse/bronze_test"])
    assert result.exit_code == 0
    assert "Ingestion Complete" in result.output
    assert "patients" in result.output
