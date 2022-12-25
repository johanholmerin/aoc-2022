FROM crystallang/crystal:1.6.2-alpine
COPY . /solution
WORKDIR /solution

RUN crystal build --release solution.cr

CMD ./solution
