#!/bin/bash

./liquibase-update.sh jdbc:postgresql://localhost:5434/test1 \
					org.postgresql.Driver \
					./changesets/test1/master.xml \
					test1 \
					pass
					
./liquibase-update.sh jdbc:postgresql://localhost:5434/test2 \
					org.postgresql.Driver \
					./changesets/test2/master.xml \
					test2 \
					pass				
			