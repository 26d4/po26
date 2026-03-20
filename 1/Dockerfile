FROM ubuntu:22.04 AS build

ENV TZ=Europe/Warsaw

RUN apt-get update
RUN apt-get -y install fp-compiler

RUN useradd --create-home --shell /bin/bash defaultuser
USER defaultuser

RUN mkdir /home/defaultuser/pascal
WORKDIR /home/defaultuser/pascal
COPY zadanie.pas ./zadanie.pas
RUN fpc -ozadanie zadanie.pas

FROM ubuntu:22.04 AS final

RUN useradd --create-home --shell /bin/bash defaultuser
USER defaultuser

RUN mkdir /home/defaultuser/pascal
WORKDIR /home/defaultuser/pascal
COPY --from=build /home/defaultuser/pascal/zadanie ./zadanie

ENTRYPOINT ["./zadanie"]
