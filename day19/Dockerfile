FROM dart:2.18.6
COPY . /solution
WORKDIR /solution

RUN dart compile exe solution.dart -o solution

CMD ./solution
