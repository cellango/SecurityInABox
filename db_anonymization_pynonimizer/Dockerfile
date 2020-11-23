FROM python:3.6-alpine

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

COPY execute.sh /usr/src/app/

COPY anonymize.yml /usr/src/app/

RUN chmod +x /usr/src/app/execute.sh /usr/src/app/anonymize.yml  &&  pip install pynonymizer && apk add --no-cache postgresql-client

ENTRYPOINT ["/usr/src/app/execute.sh"]
