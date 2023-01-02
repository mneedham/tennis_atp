```sql
SELECT schema1.name AS s1Name, schema1.type AS s1Type, schema2.type AS s2Type, 
schema1.file_name AS s1File, schema2.file_name AS s2File
FROM p2Schema AS schema1
INNER JOIN p3Schema AS schema2 ON schema2.name = schema1.name
WHERE s1Type <> s2Type;
```

`w:2000`