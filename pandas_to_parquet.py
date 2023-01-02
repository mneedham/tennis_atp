import pandas as pd

(pd.read_csv("/output/atp_rankings.csv")
    .to_parquet("/output/pandas_atp_rankings.parquet")
)