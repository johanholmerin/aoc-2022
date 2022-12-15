FROM ponylang/ponyc:0.52.2-alpine
COPY . /solution
WORKDIR /solution

RUN ponyc -b solution

CMD ./solution
