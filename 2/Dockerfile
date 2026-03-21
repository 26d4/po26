FROM ubuntu:24.04

ENV TZ=Europe/Warsaw
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get -y install php php-sqlite3 curl

RUN curl -1sSLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.deb.sh' | bash
RUN apt-get -y install symfony-cli

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

EXPOSE 80/tcp
EXPOSE 45173/tcp

RUN useradd --create-home --shell /bin/bash defaultuser
USER defaultuser

RUN mkdir /home/defaultuser/php
WORKDIR /home/defaultuser/php

ENTRYPOINT ["/usr/bin/bash"]
