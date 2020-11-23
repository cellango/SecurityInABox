# db-anonymization
db-anonymization


# How to use

1. clone this repo

2. Within the cloned repo, build the Dockerfile to create a docker image using below command:

    `docker build -t <tag_name> .`

3. Run a docker container from the image created in above step.
```
docker run \
  -e source_db_host=<source_db_host> \
  -e source_db_username=<source_db_username> \
  -e source_db_pasword=<source_db_pasword> \
  -e source_db=<source_db> \
  -e destination_db_host=<destination_db_host> \
  -e destination_db_username=<destination_db_username> \
  -e destination_db_pasword=<destination_db_pasword> \
  -e destination_new_db=sibin_dev \
  -e db_type=<db_type> \
  <tag_name>
```
      where,
        - source_db_host -> host where the source database (from which dump needs to be taken) is located.
        - source_db_username -> username of the source database.
        - source_db_pasword -> password of the source database.
        - source_db -> name of the souce database
        - destination_db_host -> host where the destination database (into which the dump needs to be restored) is located.
        - destination_db_username -> username of the destination database.
        - destination_db_pasword -> password of the destination database.
        - destination_new_db (optional) -> name to be given ti the anonymised db
        - db_type -> the type of database that is to be anonymized





# anonymize.yml
This is the [strategy](https://github.com/jerometwell/pynonymizer/blob/master/doc/strategyfiles.md) file. It constitutes the configurations that define the "What" and the "How" of the anonymization process for a database. This file needs to be changed as per requirement.
