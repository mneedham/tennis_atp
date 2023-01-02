import duckdb

con = duckdb.connect(database=':memory:')

con.execute("""
COPY (
    SELECT * FROM '/output/atp_rankings.csv'
)
TO '/output/duck_atp_rankings.parquet';
""")