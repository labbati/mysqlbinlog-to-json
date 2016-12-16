FROM openjdk:8-jre-alpine

RUN apk update && \
    apk upgrade && \
    apk add jq && \
    apk add mysql-client && \
    apk add curl

# Setting default envs
ENV MAXWELL_VERSION=1.5.1
ENV MYSQL_HOST=127.0.0.1
ENV MYSQL_PORT=3306
ENV MYSQL_USER=user
ENV MYSQL_PASSWORD=password
ENV FIX_BINLOG_FORMAT=false
ENV MAXWELL_ARGS=
ENV WAIT_FOR_SERVER_UP=true
ENV TERM=xterm
ENV JSON_COLORS=true

WORKDIR /opt

# Downloading and installing maxwell
RUN curl -sLo - https://github.com/zendesk/maxwell/releases/download/v${MAXWELL_VERSION}/maxwell-${MAXWELL_VERSION}.tar.gz | tar zxvf -
RUN cd maxwell-${MAXWELL_VERSION}

WORKDIR /opt/maxwell-${MAXWELL_VERSION}

COPY app_start.sh /opt/maxwell-${MAXWELL_VERSION}/app_start.sh

CMD ["./app_start.sh"]
