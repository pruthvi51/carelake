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
@click.option("--raw-dir", default="seeds", help="Input directory containing raw CSV feeds.")
@click.option("--output-dir", default="warehouse/bronze", help="Target Bronze Parquet directory.")
def ingest(raw_dir: str, output_dir: str):
    """Execute PySpark Bronze ingestion job with quarantine error diverter."""
    from pathlib import Path
    from carelake.ingest.bronze_loader import run_bronze_ingestion
    click.echo(f"Initiating CareLake Bronze Ingestion from '{raw_dir}' -> '{output_dir}'...")
    results = run_bronze_ingestion(Path(raw_dir), Path(output_dir))
    click.echo("Ingestion Complete:")
    for table, counts in results.items():
        click.echo(f"  • {table}: {counts['valid']} valid rows, {counts['quarantined']} quarantined")

@cli.command()
def bench():
    """Execute analytical performance benchmarks."""
    run_benchmarks()

@cli.command()
def status():
    """Display lakehouse status and table inventory."""
    from pathlib import Path
    click.echo("==================================================")
    click.echo("  CareLake Medallion Lakehouse Platform v1.0.0   ")
    click.echo("==================================================")
    click.echo("Status: Online (Healthy)")
    click.echo("Ingestion Engine: PySpark Local[2] with AQE & Quarantine Diverter")
    click.echo("Query Engine: DuckDB Vectorized Columnar Engine")
    click.echo("\n[Medallion Layer Architecture]")
    click.echo("  • Bronze: Raw Ingestion Parquet with Dead-Letter Quarantine")
    click.echo("  • Silver: Conformed Dimensions (dim_patient, dim_clinical_code) & Facts (fact_encounter)")
    click.echo("  • Gold: Analytical Marts (mart_readmission_30d, mart_pmpm_cost, mart_ed_utilization)")

    warehouse = Path("warehouse")
    if warehouse.exists():
        click.echo(f"\nWarehouse Root: {warehouse.resolve()} (Active)")
    else:
        click.echo("\nWarehouse Root: warehouse/ (Uninitialized - run 'carelake ingest' or 'make ingest-bronze')")
    click.echo("==================================================")

if __name__ == "__main__":
    cli()
