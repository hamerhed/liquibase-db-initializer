FROM postgres:10.6

MAINTAINER hamerhed@o2.pl

ADD ./create_users_and_dbs.sh  /docker-entrypoint-initdb.d/create_users_and_dbs.sh

RUN chmod 755 /docker-entrypoint-initdb.d/create_users_and_dbs.sh