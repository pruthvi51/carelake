# ADR 0005: Strict dbt Model Contracts on Gold Analytical Marts

## Status: Accepted
## Context
Downstream clinical dashboards and machine learning pipelines broke when upstream schema changes silently altered datatypes or added nulls.

## Decision
Enforce strict `contract: {enforced: true}` on all Gold mart tables with column-level datatype locks.
