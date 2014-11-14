FROM ubuntu:14.04
MAINTAINER Fred Mitchell

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y -q install pdns-backend-sqlite3 sqlite3
RUN mkdir -p /db
COPY etc/ /etc/
RUN sqlite3 /db/pdns.db < /etc/schema

EXPOSE     53
EXPOSE     80

ENTRYPOINT [ "/usr/sbin/pdns_server" ]
CMD        [ "--config-dir", "/etc/", "--master", "--daemon=no"  ]
