#Build the Maven project
FROM maven:3.6.1-alpine as builder
COPY . /usr/src/app
WORKDIR /usr/src/app
RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh

RUN git clone https://github.com/omoponfhir/omoponfhir-omopv5-jpabase.git
RUN git clone https://github.com/omoponfhir/omoponfhir-omopv5-stu3-mapping.git
RUN git clone https://github.com/omoponfhir/omoponfhir-stu3-server.git

RUN mvn -f pom-docker.xml clean install

#Build the Tomcat container
FROM tomcat:alpine
#set environment variables below and uncomment the line. Or, you can manually set your environment on your server.
#ENV JDBC_URL=jdbc:postgresql://<host>:<port>/<database> JDBC_USERNAME=<username> JDBC_PASSWORD=<password>
RUN apk update
RUN apk add zip postgresql-client

# Copy GT-FHIR war file to webapps.
COPY --from=builder /usr/src/app/omoponfhir-stu3-server/target/omoponfhir-stu3-server.war $CATALINA_HOME/webapps/gt-fhir.war

EXPOSE 8080