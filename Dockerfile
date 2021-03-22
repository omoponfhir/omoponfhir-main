#Build the Maven project
FROM maven:3.6.1-alpine as builder
COPY . /usr/src/app
WORKDIR /usr/src/app
RUN mvn clean install

#Build the Tomcat container
FROM tomcat:alpine
#set environment variables below and uncomment the line. Or, you can manually set your environment on your server.
#ENV JDBC_URL=jdbc:postgresql://<host-name>:<db-port>/<db-name>?currentSchema=omop_v5 JDBC_USERNAME=<db-username> JDBC_PASSWORD=<db-password>
#ENV SMART_INTROSPECTURL="http://<host-name>:<web-port>/smart/introspect" SMART_AUTHSERVERURL="http://<host-name>:<web-port>/smart/authorize" SMART_TOKENSERVERURL="http://<host-name>:<web-port>/smart/token" AUTH_BASIC="admin:admin" FHIR_READONLY="False" MEDICATION_TYPE="local"
# for reference: Local example with omop-pgsql running in separate Docker container
#   ENV JDBC_URL=jdbc:postgresql://172.17.0.1:5438/postgres?currentSchema=omop_v5 JDBC_USERNAME=postgres JDBC_PASSWORD=i3lworks
#   ENV SMART_INTROSPECTURL="http://172.17.0.1:8080/smart/introspect" SMART_AUTHSERVERURL="http://172.17.0.1:8080/smart/authorize" SMART_TOKENSERVERURL="http://172.17.0.1:8080/smart/token" AUTH_BASIC="admin:admin" FHIR_READONLY="False" MEDICATION_TYPE="local"

RUN apk update
RUN apk add zip postgresql-client

# Copy GT-FHIR war file to webapps.
COPY --from=builder /usr/src/app/omoponfhir-r4-server/target/omoponfhir-r4-server.war $CATALINA_HOME/webapps/omoponfhir4.war

EXPOSE 8080
