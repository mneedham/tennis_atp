```sql
CREATE OR REPLACE TABLE players1 AS
SELECT * 
FROM read_csv_auto('atp_players.csv', IGNORE_ERRORS=TRUE);
```

```sql
CREATE OR REPLACE TABLE players2 AS
SELECT player_id,
       name_first AS first_name,
       name_last AS  last_name,
       hand, dob, ioc, height, wikidata_id
FROM read_csv_auto('atp_players.csv', IGNORE_ERRORS=TRUE);
```

```sql
CREATE OR REPLACE TABLE players3 AS
SELECT player_id,
       name_first AS first_name,
       name_last AS  last_name,
       hand, dob, ioc, height
FROM read_csv_auto('atp_players.csv', ALL_VARCHAR=TRUE);
```

```sql
COPY players1 TO 'players1.parquet' (FORMAT PARQUET);
COPY players2 TO 'players2.parquet' (FORMAT PARQUET);
COPY players3 TO 'players3.parquet' (FORMAT PARQUET);
```

Extra stuff

```sql
SELECT name, type, 'players1.parquet' AS missingFrom 
FROM parquet_schema('players1.parquet')

EXCEPT

SELECT name, type, 'players1.parquet' AS missingFrom 
FROM parquet_schema('players2.parquet');
```

```sql
(
    SELECT name, type, 'players1.parquet' AS missingFrom 
    FROM parquet_schema('players1.parquet')

    EXCEPT

    SELECT name, type, 'players1.parquet' AS missingFrom 
    FROM parquet_schema('players2.parquet')
)
UNION ALL
(
    SELECT name, type, 'players2.parquet' AS missingFrom 
    FROM parquet_schema('players2.parquet')

    EXCEPT

    SELECT name, type, 'players2.parquet' AS missingFrom 
    FROM parquet_schema('players1.parquet')
);
```

```sql
SELECT file_name, name, type
FROM parquet_schema('players1.parquet');
```


```sql
(
    SELECT name, type
    FROM parquet_schema('players2.parquet')

    EXCEPT

    SELECT name, type
    FROM parquet_schema('players3.parquet')
)
UNION ALL
(
    SELECT name, type
    FROM parquet_schema('players3.parquet')

    EXCEPT

    SELECT name, type
    FROM parquet_schema('players2.parquet')
);
```

```
SELECT * FROM 
(
    SELECT name, type
    FROM parquet_schema('players2.parquet')

    EXCEPT

    SELECT name, type
    FROM parquet_schema('players3.parquet')
)
CROSS JOIN SELECT 'Missing from players2.parquet' AS missing;
```

```
CREATE OR REPLACE TEMP TABLE NotInSchema1 AS
(
    SELECT name, type
    FROM parquet_schema('players2.parquet')

    EXCEPT

    SELECT name, type
    FROM parquet_schema('players3.parquet')
);
```

```sql
WITH notInSchema1 AS (
    (
    SELECT name, type
    FROM parquet_schema('players2.parquet')

    EXCEPT

    SELECT name, type
    FROM parquet_schema('players3.parquet')
    )
), notInSchema2 AS (
    (
    SELECT name, type
    FROM parquet_schema('players3.parquet')

    EXCEPT

    SELECT name, type
    FROM parquet_schema('players2.parquet')
    )
)

SELECT *, 'players2.parquet' AS missingColumn
FROM notInSchema1

UNION ALL 

SELECT *, 'players3.parquet' AS missingColumn
FROM notInSchema2;
```

```sql
SELECT p1Schema.name, p1Schema.type AS p1Type, p2Schema.type AS p2Type
FROM p1Schema
INNER JOIN p2Schema ON p2Schema.name = p1Schema.name
WHERE p1Type <> p2Type;
```

Extra stuff

```sql
SELECT name, type, 'players1.parquet' AS missingFrom 
FROM parquet_schema('players1.parquet')

EXCEPT

SELECT name, type, 'players1.parquet' AS missingFrom 
FROM parquet_schema('players2.parquet');
```

```sql
(
    SELECT name, type, 'players1.parquet' AS missingFrom 
    FROM parquet_schema('players1.parquet')

    EXCEPT

    SELECT name, type, 'players1.parquet' AS missingFrom 
    FROM parquet_schema('players2.parquet')
)
UNION ALL
(
    SELECT name, type, 'players2.parquet' AS missingFrom 
    FROM parquet_schema('players2.parquet')

    EXCEPT

    SELECT name, type, 'players2.parquet' AS missingFrom 
    FROM parquet_schema('players1.parquet')
);
```

```sql
SELECT file_name, name, type
FROM parquet_schema('players1.parquet');
```
