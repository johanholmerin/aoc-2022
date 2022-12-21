FROM gcc:12.2.0-bullseye
COPY . /solution
WORKDIR /solution

RUN gcc -static -o solution -O3 -Wall solution.c

CMD ./solution
