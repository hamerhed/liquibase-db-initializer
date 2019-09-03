#!/bin/sh

DB_URL=$1
DB_DRIVER=$2
DB_CHANGELOG_FILE=$3
DB_USERNAME=$4
DB_PASS=$5

echo execute update for $DB_URL

TAG_NAME=$(date +%s)
echo tag name $TAG_NAME

./liquibase-bin/liquibase --url=$DB_URL \
						  --driver=$DB_DRIVER \
						  --changeLogFile=$DB_CHANGELOG_FILE\
						  --username=$DB_USERNAME \
						  --password=$DB_PASS \
						  tag $TAG_NAME

RESULT=$?
if [ $RESULT -ne 0 ]; then
	echo tag operation failed
	exit $RESULT
fi

./liquibase-bin/liquibase --logLevel=DEBUG \
						  --url=$DB_URL \
						  --driver=$DB_DRIVER \
						  --changeLogFile=$DB_CHANGELOG_FILE\
						  --username=$DB_USERNAME \
						  --password=$DB_PASS \
						  update

RESULT=$?
#echo update res $RESULT
if [ $RESULT -ne 0 ]; then
	echo execute rollback for $DB_URL
	./liquibase-bin/liquibase --logLevel=DEBUG \
							  --url=$DB_URL \
						  	  --driver=$DB_DRIVER \
						  	  --changeLogFile=$DB_CHANGELOG_FILE\
						  	  --username=$DB_USERNAME \
						  	  --password=$DB_PASS \
							  rollback $TAG_NAME 
fi	
#./liquibase-bin/liquibase --logLevel=DEBUG --url=jdbc:postgresql://localhost:5434/events_store_dev --driver=org.postgresql.Driver --changeLogFile=./changesets/event-store-db/master.xml --username=events_store --password=pass rollback 