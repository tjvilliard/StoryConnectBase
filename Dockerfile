FROM python:3.11

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client \
    && apt-get install -y cron \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /config
ADD /config/requirements.txt /config/

RUN pip3 install -r /config/requirements.txt
RUN mkdir /src;
WORKDIR /src

