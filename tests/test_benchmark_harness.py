from carelake.benchmarks.run_benchmark import run_benchmarks

def test_benchmark_runs():
    res = run_benchmarks()
    assert res["dataset_rows"] == 100000
    assert res["duckdb_aggregation_query_ms"] > 0
    assert res["speedup_vs_sqlite"] > 1.0
