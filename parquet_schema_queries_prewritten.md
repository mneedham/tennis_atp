```sql
WITH schema1 AS (
    SELECT name, type FROM parquet_schema('players1.parquet')
), schema2 AS (
    SELECT name, type FROM parquet_schema('players2.parquet')
), notInSchema1 AS (
    SELECT * FROM schema1 EXCEPT SELECT * FROM schema2
), notInSchema2 AS (
    SELECT * FROM  schema2 EXCEPT SELECT * FROM schema1
)

SELECT *, 'Missing in players2.parquet' AS description
FROM notInSchema1
UNION ALL 
SELECT *, 'Missing in players1.parquet' AS description
FROM notInSchema2;
```

```sql
WITH schema1 AS (
    SELECT name, type FROM parquet_schema('players2.parquet')
), schema2 AS (
    SELECT name, type FROM parquet_schema('players3.parquet')
), notInSchema1 AS (
    SELECT * FROM schema1 EXCEPT SELECT * FROM schema2
), notInSchema2 AS (
    SELECT * FROM  schema2 EXCEPT SELECT * FROM schema1
)

SELECT *, 'Missing in players3.parquet' AS description
FROM notInSchema1
UNION ALL 
SELECT *, 'Missing in players2.parquet' AS description
FROM notInSchema2;
```