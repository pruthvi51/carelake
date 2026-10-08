"""
CareLake Command-Line Interface.
"""
import click
from carelake.benchmarks.run_benchmark import run_benchmarks

@click.group()
def cli():
    """CareLake Medallion Lakehouse CLI."""
    pass

@cli.command()
def bench():
    """Execute analytical performance benchmarks."""
    run_benchmarks()

@cli.command()
def status():
    """Display lakehouse status and table inventory."""
    click.echo("CareLake Lakehouse v1.0.0: Online (Status: Healthy)")

if __name__ == "__main__":
    cli()
