FROM rust:1.66.0-alpine3.17
COPY . /solution
WORKDIR /solution

RUN cargo build --release

CMD ./target/release/day24
