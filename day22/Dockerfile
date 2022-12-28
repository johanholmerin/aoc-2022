FROM ballerina/ballerina:2201.3.0
COPY . /solution
WORKDIR /solution

USER root

RUN bal build

CMD bal run target/bin/day22.jar
