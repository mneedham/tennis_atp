import duckdb
con = duckdb.connect(database=':memory:')

con.execute("""
SELECT * FROM 'atp_rankings_*.csv'
UNION ALL
SELECT * FROM 'atp_rankings_*.csv'
UNION ALL
SELECT * FROM 'atp_rankings_*.csv'
UNION ALL
SELECT * FROM 'atp_rankings_*.csv'
""")

df = con.fetch_df()

con.execute("""
COPY (
    SELECT * FROM 'atp_rankings_*.csv'
    UNION ALL
    SELECT * FROM 'atp_rankings_*.csv'
    UNION ALL
    SELECT * FROM 'atp_rankings_*.csv'
    UNION ALL
    SELECT * FROM 'atp_rankings_*.csv'
)
TO '/output/atp_rankings.csv' (HEADER, DELIMITER ',');
""")