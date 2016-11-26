FROM openjdk:8

RUN apt-get update && \
    apt-get install -y jq && \
    apt-get install -y mysql-client

# Setting default envs
ENV MAXWELL_VERSION=1.5.1
ENV MYSQL_HOST=127.0.0.1
ENV MYSQL_PORT=3306
ENV MYSQL_USER=user
ENV MYSQL_PASSWORD=password
ENV FIX_BINLOG_FORMAT=false

WORKDIR /opt

# Downloading and installing maxwell
RUN curl -sLo - https://github.com/zendesk/maxwell/releases/download/v${MAXWELL_VERSION}/maxwell-${MAXWELL_VERSION}.tar.gz | tar zxvf -
RUN cd maxwell-${MAXWELL_VERSION}

WORKDIR /opt/maxwell-${MAXWELL_VERSION}

# If (and only if) the env FIX_BINLOG_FORMAT=true we also set binlogformat to ROW (required by maxwell)
# otherwise we just startup maxwell as is
CMD [ "$FIX_BINLOG_FORMAT" = "true" ] && \
    mysql -u${MYSQL_USER} -h${MYSQL_HOST} -P${MYSQL_PORT} --password=${MYSQL_PASSWORD} -e "SET GLOBAL binlog_format = 'ROW';" ; \
    bin/maxwell --user=$MYSQL_USER --password=$MYSQL_PASSWORD --host=$MYSQL_HOST --port=$MYSQL_PORT --producer=stdout | jq .
