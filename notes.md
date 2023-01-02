
```
docker build -t python-tennis:0.0.1 .
```

```
docker run -it \
  -v $PWD/output:/output \
  -m 100m \
  python-tennis:0.0.1
```

```sql
SELECT count(distinct row_group_id) AS rowGroups
FROM parquet_metadata('output/pl_atp_rankings.parquet');

SELECT count(distinct row_group_id) AS rowGroups
FROM parquet_metadata('output/duck_atp_rankings.parquet');
```

```sql
SELECT row_group_id, column_id, num_values, compression, encodings
FROM parquet_metadata('output/duck_atp_rankings.parquet')
WHERE row_group_id = 0;

SELECT row_group_id, column_id, num_values, compression, encodings
FROM parquet_metadata('output/pl_atp_rankings.parquet')
WHERE row_group_id = 0;

 ```