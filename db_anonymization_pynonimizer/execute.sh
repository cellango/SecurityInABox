#!/bin/sh

#set -ex

if  [ -z $source_db_host ] || [ -z $source_db_username ] || [ -z $source_db_pasword ] || [ -z $source_db ] ||  \
    [ -z $destination_db_host ] || [ -z $destination_db_username ] || [ -z $db_type ] || [ -z $destination_db_pasword ]
then
    echo "Variable missing!!!!!!!!. Please set all the mandatory environment variables during run. "
    exit 1
fi

echo "Started taking dump"
export PGPASSWORD=$source_db_pasword
echo "Running pg_dump to get dump --------->"
pg_dump -h $source_db_host -p 5432 -U $source_db_username $source_db -f dump.sql
echo "Done taking Dump"

if [ -z $destination_new_db ]
then
    timestamp=$(date +%s)
    export destination_new_db=db_$timestamp
else
    if [ "$( psql -tA -h $destination_db_host -U $destination_db_username -p 5432 -c "SELECT 1 FROM pg_database WHERE datname='$destination_new_db'" )" = '1' ]
    then
        echo "Database already exists..!!!!"
        timestamp=$(date +%s)
        export destination_new_db=db_$timestamp
        echo "Creating new database ---> $destination_new_db"
    fi
fi

pynonymizer -d $destination_db_host \
            -s anonymize.yml \
            -n $new_db \
            -u $destination_db_username \
            -p $destination_db_pasword \
            -P 5432 \
            -i dump.sql \
            -t $db_type \
            -o output.sql \
            --stop-at 'DUMP_DB'

echo "Anonymization Done...."
echo "Anonymized DB ---------------->>> $destination_new_db"
rm -rf output.sql dump.sql
