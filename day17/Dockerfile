FROM ubuntu:kinetic-20221130
COPY . /solution
WORKDIR /solution

RUN apt-get update && apt-get install -y neovim=0.7.2-3

CMD nvim -es -c ':source solution.vim'
