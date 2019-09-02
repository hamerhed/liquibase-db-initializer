#!/bin/bash
set -e
set -u

INIT_DATA_DIR="/docker_init_data/"

function create_user_and_db() {
    local username=$1
    local password=$2
    local database=$3
    
    echo "$0: creating db user '$username' and pass '$password' db '$database'"
    
    POSTGRES="psql -v ON_ERROR_STOP=1 --username ${POSTGRES_USER}"

    $POSTGRES <<-EOSQL
        CREATE USER $username WITH CREATEDB PASSWORD '$password';
        CREATE DATABASE $database;
        GRANT ALL PRIVILEGES ON DATABASE $database TO $username;
EOSQL
echo "$0: database '$database' created"
}

function init_db() {
    local username=$1
    local password=$2
    local database=$3
    
    echo "$0: initialization of database '$database' content started"
    
    export PGPASSWORD="${PGPASSWORD:-$POSTGRES_PASSWORD}"
    psql=( psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --no-password )
    psql+=( --dbname "$database" )

    echo
    if [ -d "$INIT_DATA_DIR" ]; then
        IN_FILES=`find $INIT_DATA_DIR -name "${database}_*"`
        echo po in files $IN_FILES
        for f in $IN_FILES; do
            case "$f" in
                *.sql)
                    echo "$0: running $f"; "${psql[@]}" -f "$f"; echo
                     ;;
                #*.sql.gz) echo "$0: running $f"; gunzip -c "$f" | "${psql[@]}"; echo ;;
                *)        echo "$0: ignoring $f" ;;
            esac
            echo
        done
    fi
    echo "$0: initialization of database '$database' content ended"
}

echo "$0: Multiple database creation requested: $DB_USERNAMES"

username_tab=($(echo $DB_USERNAMES | tr ',' ' '))
pass_tab=($(echo $DB_PASSWORDS | tr ',' ' '))
db_tab=($(echo $DB_DATABASES | tr ',' ' '))

if [ ${#username_tab[@]} -ne ${#pass_tab[@]} ]; then
    echo "$0: pass correct number of db username and passwords"
    exit;
fi

if [ ${#username_tab[@]} -ne ${#db_tab[@]} ]; then
    echo "$0: pass correct number of db username and databases"
    exit;
fi

length=${#username_tab[@]}

for ((i=0;i<$length;i++));
do
        create_user_and_db ${username_tab[$i]} ${pass_tab[$i]} ${db_tab[$i]}
        init_db ${username_tab[$i]} ${pass_tab[$i]} ${db_tab[$i]}
done

echo "$0: Multiple databases created"