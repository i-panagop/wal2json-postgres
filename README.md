# wal2json-postgres
Dockerfile to create a postgres image which will contain the wal2json plugin

# Create the image

```
$ docker build -t debpostgres:1 --progress=plain .
```

# Run Docker Container

```
docker run --name debpostgres -e POSTGRES_PASSWORD=pgpassword -p 5432:5432 -d debpostgres:1
```

# SQL Commands

```
# Create new table 

create table user_table(
	user_id serial primary KEY,
	user_name VARCHAR,
	user_email VARCHAR
)

# Create the replication slot

SELECT * FROM pg_create_logical_replication_slot('repl_slot_1', 'wal2json');

# Create publication for all tables

CREATE PUBLICATION publication_1 FOR ALL tables;

# Insert values

insert into user_table values(1, 'takis', 'takis@a.com');

# Read changes

SELECT * FROM pg_logical_slot_get_changes('repl_slot_1', NULL, NULL);
```
