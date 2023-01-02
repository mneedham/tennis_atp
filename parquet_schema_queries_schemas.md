```sql
SELECT file_name, name, type
FROM parquet_schema('players*.parquet')
ORDER BY file_name;
```

`kd:cmd kp:arrow-up_10 ku:cmd`