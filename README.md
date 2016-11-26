Using the `mysql-to-json` docker image you can look at the mysqlbinlog output in a pretty printed json format.

## What it does

Given a table:

```
CREATE TABLE people (
	id integer primary key,
	name varchar(32),
	age integer
)
```

Executing the statement `INSERT INTO people VALUES (1, "Luca Abbati", 36);` will result in the following output
```
{
  "database": "my_database_name",
  "table": "people",
  "type": "insert",
  "ts": 1480173138,
  "xid": 10854,
  "commit": true,
  "data": {
    "id": 1,
    "name": "Luca Abbati",
    "age": 36
  }
}
```

Executing the statement `UPDATE people SET age=37 WHERE id=1;` will result in the following output
```
{
  "database": "my_database_name",
  "table": "people",
  "type": "update",
  "ts": 1480173243,
  "xid": 10872,
  "commit": true,
  "data": {
    "id": 1,
    "name": "Luca Abbati",
    "age": 37
  },
  "old": {
    "age": 36
  }
}
```

Executing the statement `DELETE FROM people WHERE id=1;` will result in the following output
```
{
  "database": "my_database_name",
  "table": "people",
  "type": "delete",
  "ts": 1480173311,
  "xid": 10884,
  "commit": true,
  "data": {
    "id": 1,
    "name": "Luca Abbati",
    "age": 37
  }
}
```

## Getting Started

You can connect `mysql-to-json` to a mysql instance running on the host (note the `--net="host"` command line argument to the docker run command):

`docker run -ti -e "MYSQL_USER=username" -e "MYSQL_PASSWORD=password" --net="host" labbati/mysqlbinlog-to-json`.

Alternatively, you can add this image to any `docker-compose.yml` file and later on attach to its stdout:

`docker attach <container_name_here>`.

## Configuration

* `MYSQL_HOST`: The mysql host (default to `127.0.0.1`)
* `MYSQL_PORT`: The mysql port (default to `3306`)
* `MYSQL_USER`: The mysql user (default to `user`)
* `MYSQL_PASSWORD`: The mysql host (default to `password`)
* `FIX_BINLOG_FORMAT`: Whether or not the image should convert the mysql server log format to `ROW` (default to `false`). Maxwell requires `ROW` binlog format. *WARNING* do not pass the option `FIX_BINLOG_FORMAT=true` in production as it *WILL CHANGE* the server replication format.




