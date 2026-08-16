"""
CareLake End-to-End Experiment Reproducibility Script:
Regenerates all benchmark tables and figures from raw seeds.
"""
import json
from pathlib import Path
from carelake.benchmarks.run_benchmark import run_benchmarks

def main():
    print("Reproducing CareLake experimental benchmarks...")
    results = run_benchmarks()
    out_file = Path("warehouse/benchmark_results.json")
    out_file.parent.mkdir(parents=True, exist_ok=True)
    out_file.write_text(json.dumps(results, indent=2))
    print(f"Results serialized to {out_file}")

if __name__ == "__main__":
    main()
