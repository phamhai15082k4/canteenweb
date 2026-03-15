# Stage 1: Build code bang Maven
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY . .

RUN cd canteensystem && mvn clean package -DskipTests

# Stage 2: Chay server Spring Boot
FROM eclipse-temurin:21-jdk
WORKDIR /app

COPY --from=build /app/canteensystem/target/*.war app.war

ENTRYPOINT ["java", "-jar", "app.war"]
