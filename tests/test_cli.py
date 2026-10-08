from click.testing import CliRunner
from carelake.cli import cli

def test_cli_status():
    runner = CliRunner()
    result = runner.invoke(cli, ["status"])
    assert result.exit_code == 0
    assert "CareLake Lakehouse" in result.output
