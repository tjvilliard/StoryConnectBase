FROM python:3.11

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /config
ADD /config/requirements.txt /config/

RUN pip install -r /config/requirements.txt
RUN pip install requests
RUN mkdir /src;
WORKDIR /src

