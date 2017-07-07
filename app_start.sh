#!/bin/sh

# If the corresponding option is set, then we wait for the mysql server to be up and running
if [ "$WAIT_FOR_SERVER_UP" = "true" ]; then
    echo "Waiting for mysql server to be up and running"
    while ! mysqladmin ping -h"$MYSQL_HOST" --silent; do
        echo "."
        sleep 1
    done
    echo "Mysql server is up and running, can proceed"
fi

# If (and only if) the env FIX_BINLOG_FORMAT=true we also set binlogformat to ROW (required by maxwell)
# otherwise we just startup maxwell as is
if [ "$FIX_BINLOG_FORMAT" = "true" ]; then
    mysql -u${MYSQL_USER} -h${MYSQL_HOST} -P${MYSQL_PORT} --password=${MYSQL_PASSWORD} -e "SET GLOBAL binlog_format = 'ROW';" ;
    echo "Changed the mysqlbinlog format to 'ROW' on the server"
fi

# A user may want or not to disable colors in the output json, as they may make the output not readable (e.g. from vi)
# if dumped to a text file.
[[ $JSON_COLORS = "true" ]] && color_option="-C" || color_option="-M"

/bin/sh bin/maxwell --user=$MYSQL_USER --password=$MYSQL_PASSWORD --host=$MYSQL_HOST --port=$MYSQL_PORT --producer=stdout $MAXWELL_ARGS | jq $color_option --sort-keys --unbuffered '.'
