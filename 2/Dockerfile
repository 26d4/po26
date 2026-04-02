FROM ubuntu:24.04

ENV TZ=Europe/Warsaw
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get -y install php php-sqlite3 php-xml php-dom curl sqlite3
RUN apt-get -y install 7zip php-intl jq php-curl

RUN curl -1sSLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.deb.sh' | bash
RUN apt-get -y install symfony-cli

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

EXPOSE 80/tcp
EXPOSE 8000/tcp

#RUN useradd --create-home --shell /bin/bash defaultuser
USER ubuntu

RUN mkdir -p /home/ubuntu/php/var
#VOLUME /home/defaultuser/php/var
WORKDIR /home/ubuntu/php
#COPY --chown=defaultuser composer.json composer.lock ./
#RUN env APP_ENV=prod composer install --no-interaction --no-dev --optimize-autoloader
#RUN composer install --no-interaction --no-scripts --no-autoloader
#COPY --chown=defaultuser ./ ./
#RUN composer dump-autoload --optimize
#RUN composer run-script post-install-cmd
#RUN composer dump-env prod
#RUN chmod +x entrypoint.sh

#ENTRYPOINT ["./entrypoint.sh"]
ENTRYPOINT ["/usr/bin/bash", "./entrypoint.sh"]
