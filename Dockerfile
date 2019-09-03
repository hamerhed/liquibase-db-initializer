FROM openjdk:14-jdk-alpine3.10

MAINTAINER hamerhed@o2.pl

RUN apk update && apk upgrade && apk add bash

RUN addgroup -g 1000 user \
	&& adduser -h /home/user -D -G user -u 1000 user

WORKDIR /home/user

RUN mkdir changesets

ADD ./entrypoint.sh entrypoint.sh
ADD ./liquibase-update.sh liquibase-update.sh
ADD ./run.sh run.sh
ADD ./wait-for-it.sh wait-for-it.sh
ADD ./liquibase-bin liquibase-bin

RUN chmod 755 entrypoint.sh && chmod 755 liquibase-update.sh && chmod 755 run.sh && chmod 755 wait-for-it.sh

VOLUME /home/user/changesets

WORKDIR /home/user
ENTRYPOINT ["./entrypoint.sh"]