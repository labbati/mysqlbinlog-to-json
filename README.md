Using the `mysqlbinlog-to-json` docker image you can look at the mysqlbinlog output in a pretty printed json format.

This image is available form the docker hub https://hub.docker.com/r/labbati/mysqlbinlog-to-json/.

Under the hood, it uses [Maxwell](http://maxwells-daemon.io) to attach to the mysqlbinlog and export json output.

## Examples

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

You can connect `mysqlbinlog-to-json` to any mysql instance (for example, here I add the `--net="host"` command line argument to the docker run command in order to connect it to a mysql server running on the host):

`docker run -ti -e "MYSQL_USER=username" -e "MYSQL_PASSWORD=password" --net="host" labbati/mysqlbinlog-to-json`.

Alternatively, you can add this image to any `docker-compose.yml` file and later on attach to its logs:

`docker logs <container_name_here> -f --tail 0`.

## Configuration

* `MYSQL_HOST`: The mysql host (default to `127.0.0.1`)
* `MYSQL_PORT`: The mysql port (default to `3306`)
* `MYSQL_USER`: The mysql user (default to `user`)
* `MYSQL_PASSWORD`: The mysql host (default to `password`)
* `FIX_BINLOG_FORMAT`: Whether or not the image should convert the mysql server log format to `ROW` (default to `false`). Maxwell requires `ROW` binlog format. *WARNING* do not pass the option `FIX_BINLOG_FORMAT=true` in production as it *WILL CHANGE* the server replication format.
* `MAXWELL_ARGS`: Additional maxwell arguments that can be passed when invoking the tool from the command line (e.g. `MAXWELL_ARGS=--exclude_tables=people,addresses`), see [Maxwell's configuration page](http://maxwells-daemon.io/config/) for more details. (default to `''`). Note the the following arguments are reserved and setting them will result in an unpredictable behavior: `--user `, `--password`, `--host`, `--port` and `--producer`.
* `JSON_COLORS`: Whether or not the the outputted json should use the jq color scheme or not (default to `true`). Tip: use `false` if you are dumping the stdout into a text file, e.g. `docker .... > some-text-file.txt` as otherwise plain text color codes would make the file very hard to read.
