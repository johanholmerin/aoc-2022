FROM alpine:3.17.0
COPY . /solution
WORKDIR /solution

CMD awk -F '\n' -f solution.awk input.txt
