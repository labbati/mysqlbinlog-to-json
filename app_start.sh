#!/bin/sh

# If (and only if) the env FIX_BINLOG_FORMAT=true we also set binlogformat to ROW (required by maxwell)
# otherwise we just startup maxwell as is
if [ "$FIX_BINLOG_FORMAT" = "true" ]; then
    mysql -u${MYSQL_USER} -h${MYSQL_HOST} -P${MYSQL_PORT} --password=${MYSQL_PASSWORD} -e "SET GLOBAL binlog_format = 'ROW';" ;
    echo "Changed the mysqlbinlog format to 'ROW' on the server"
fi

/bin/sh bin/maxwell --user=$MYSQL_USER --password=$MYSQL_PASSWORD --host=$MYSQL_HOST --port=$MYSQL_PORT --producer=stdout $MAXWELL_ARGS | jq .
