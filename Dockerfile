FROM python:3.7-alpine
MAINTAINER Sandeep Gupta

# It does not allow python to buffer the output, recommended when running python in docker container.
ENV PYTHONUNBUFFERED 1 

COPY ./requirements.txt /requirements.txt
RUN apk add --update --no-cache postgresql-client
RUN apk add --update --no-cache --virtual .tmp-build-deps \
      gcc libc-dev linux-headers postgresql-dev
RUN pip install -r /requirements.txt
RUN apk del .tmp-build-deps

RUN mkdir /app

# This sets the default work dir as /app in the docker
WORKDIR /app
COPY ./app /app

# Create an user called 'user' to run the app. '-D' creates a user to run apps only. 
RUN adduser -D user
# To switch to user 'user'. This is done to secure the env as by default the docker would be ran using 'root'
USER user