FROM ubuntu:14.04
MAINTAINER Fred Mitchell

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y -q install pdns-backend-sqlite3 sqlite3 ruby2.0 ruby2.0-dev ruby-dev supervisor make libsqlite3-dev g++
RUN mkdir -p /db /rcmd

COPY etc/ /etc/
COPY rcmd/ /rcmd/

RUN sqlite3 /db/pdns.db < /etc/schema

RUN gem install sinatra thin sqlite3 --no-ri --no-rdoc

EXPOSE     53
EXPOSE     2001

ENTRYPOINT [ "/usr/bin/supervisord" ]
CMD        [  ]
