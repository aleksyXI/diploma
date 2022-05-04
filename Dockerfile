FROM maven:3.8.1-jdk-11 AS builder
WORKDIR /app
COPY pom.xml pom.xml
RUN mvn verify clean --fail-never
COPY docker .
RUN mvn package

FROM bellsoft/liberica-openjdk-alpine:11 AS app
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
COPY --from=builder --chown=appuser:appgroup /app/target/*.jar /app.jar
USER appuser
EXPOSE 8080
ENTRYPOINT exec java $JAVA_OPTS -jar /app.jar