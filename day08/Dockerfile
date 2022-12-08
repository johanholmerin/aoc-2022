FROM dlangchina/dlang-gdc:9.4.0-1
COPY . /solution
WORKDIR /solution
RUN gdc -o solution solution.d

CMD ./solution
