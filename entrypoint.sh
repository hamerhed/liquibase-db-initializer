#!/bin/sh

if [ -z "$DISABLE_INIT" ] || [ "$DISABLE_INIT" == "1" ]; then
	echo service disabled. Exit.
	exit 0
fi

if [ -z "$WAIT_FOR_SERVICE" ]; then
	WAIT_FOR_SERVICE=message-broker:5672
fi

if [ -z "$WAIT_FOR_SERVICE_TIMEOUT" ]; then
	WAIT_FOR_SERVICE_TIMEOUT=0
fi

echo "wait for " $WAIT_FOR_SERVICE " and start repository init"

./wait-for-it.sh $WAIT_FOR_SERVICE --timeout=$WAIT_FOR_SERVICE_TIMEOUT -- echo "continue..."

./liquibase-update.sh $DB1_URL \
					$DB1_DRIVER \
					$DB1_CHANGESET \
					$DB1_USERNAME \
					$DB1_PASSWORD
				
./liquibase-update.sh $DB2_URL \
					$DB2_DRIVER \
					$DB2_CHANGESET \
					$DB2_USERNAME \
					$DB2_PASSWORD		