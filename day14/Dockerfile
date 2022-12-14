FROM ubuntu:kinetic-20221130
COPY . /solution
WORKDIR /solution

RUN apt-get update && apt-get install -y llvm-11 clang git make
RUN git clone https://github.com/odin-lang/Odin.git && cd Odin && make

RUN ./Odin/odin build solution.odin -file

CMD ./solution.bin
