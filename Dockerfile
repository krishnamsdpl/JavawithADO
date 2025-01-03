FROM openjdk:17-jdk-alpine

WORKDIR /app
COPY target/your-app.jar /app/your-app.jar
EXPOSE 8080
CMD ["java", "-jar", "your-app.jar"]
