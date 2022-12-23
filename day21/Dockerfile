FROM ghcr.io/gleam-lang/gleam:v0.25.3-erlang-alpine
COPY . /solution
WORKDIR /solution

RUN gleam export erlang-shipment

CMD ./build/erlang-shipment/entrypoint.sh run
