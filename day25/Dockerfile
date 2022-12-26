FROM swift:5.7.2-jammy
COPY . /solution
WORKDIR /solution

RUN swift build -c release

CMD ./.build/release/day25
