FROM nimlang/nim:1.6.10-alpine-slim
COPY . /solution
WORKDIR /solution
RUN nim c -d:release solution.nim

CMD ./solution
