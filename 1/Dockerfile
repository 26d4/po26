FROM ubuntu:22.04

ENV TZ=Europe/Warsaw

RUN apt-get update
RUN apt-get -y install fp-compiler

WORKDIR /app
COPY zadanie.pas ./zadanie.pas
RUN fpc -ozadanie zadanie.pas
ENTRYPOINT ["./zadanie"]
