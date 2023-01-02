import polars as pl

(pl.scan_csv("/output/atp_rankings.csv")
    .sink_parquet("/output/polars_atp_rankings.parquet")
)
