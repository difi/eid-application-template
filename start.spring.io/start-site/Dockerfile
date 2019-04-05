FROM java:8-jdk-alpine

COPY ./target/start-site.jar /usr/app/

WORKDIR /usr/app


ENTRYPOINT ["java","-jar","start-site.jar"]  
