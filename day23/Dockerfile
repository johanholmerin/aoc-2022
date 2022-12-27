FROM schlaubiboy/kotlin:1.7.22-alpine
COPY . /solution
WORKDIR /solution

RUN kotlinc solution.kt -include-runtime -d solution.jar

CMD java -jar solution.jar
