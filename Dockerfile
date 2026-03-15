# Stage 1: Build code bang Maven
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY . .
RUN cd canteensystem && mvn clean package -DskipTests

# Stage 2: Chay server Tomcat
FROM tomcat:10.1-jdk21

# Xoa cac app mac dinh cua Tomcat de tranh xung dot
RUN rm -rf /usr/local/tomcat/webapps/*


COPY --from=build /app/canteensystem/target/*.war /usr/local/tomcat/webapps/ROOT.war

