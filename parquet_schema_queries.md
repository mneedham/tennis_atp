```sql
CREATE OR REPLACE TEMP TABLE p1Schema AS 
SELECT * FROM parquet_schema('players1.parquet');
CREATE OR REPLACE TEMP TABLE p2Schema AS 
SELECT * FROM parquet_schema('players2.parquet');
CREATE OR REPLACE TEMP TABLE p3Schema AS 
SELECT * FROM parquet_schema('players3.parquet');
```

`w:1000`

```sql
SELECT name, type FROM p1Schema
EXCEPT
SELECT name, type FROM p2Schema;
```

`w:3000`

```sql
SELECT name, type FROM p2Schema
EXCEPT
SELECT name, type FROM p1Schema;
```

`w:3000`