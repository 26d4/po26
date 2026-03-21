FROM ubuntu:22.04 AS build

ENV TZ=Europe/Warsaw

RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get -y install fp-compiler fp-units-fcl

RUN useradd --create-home --shell /bin/bash defaultuser
USER defaultuser

RUN mkdir /home/defaultuser/pascal
WORKDIR /home/defaultuser/pascal
COPY zadanie.pas main.pas test.pas ./
RUN fpc -otest test.pas
RUN ./test -a --format=plain
RUN fpc -ozadanie main.pas

FROM ubuntu:22.04 AS final

RUN useradd --create-home --shell /bin/bash defaultuser
USER defaultuser

RUN mkdir /home/defaultuser/pascal
WORKDIR /home/defaultuser/pascal
COPY --from=build /home/defaultuser/pascal/zadanie ./zadanie

ENTRYPOINT ["./zadanie"]
