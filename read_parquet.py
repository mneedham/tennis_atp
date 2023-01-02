import duckdb
con = duckdb.connect(database=':memory:')

con.execute("""
SELECT *
FROM '/output/pd_atp_rankings.parquet'
""")

df1 = con.fetch_df()


con.execute("""
SELECT *
FROM '/output/pl_atp_rankings.parquet'
""")

df2 = con.fetch_df()
