#FROM gradle:jdk17-alpine AS build
#RUN mkdir /app
#WORKDIR /app
#COPY ./ ./
#RUN gradle build
#CMD ["/bin/sh"]
#
#FROM ubuntu/jre:17-24.04_stable
#COPY --from=build /app/build/libs/po26.jar ./app.jar
#CMD ["exec", "java", "-jar", "app.jar"]

FROM ubuntu:24.04

ENV TZ=Europe/Warsaw
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get -y install openjdk-17-jdk

USER ubuntu

RUN mkdir -p /home/ubuntu/.gradle
RUN mkdir -p /home/ubuntu/app
WORKDIR /home/ubuntu/app
#COPY --chown=ubuntu ./ ./

ENTRYPOINT ["/usr/bin/bash"]
