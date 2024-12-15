# DevOpsWithJavaAzureCloud

## Prerequisites

- **Java Application**: You should have a Java application (Spring Boot, Java EE, etc.) ready for deployment.
- **Azure Account**: Ensure you have an active Azure account.
- **Azure DevOps Organization**: Create an Azure DevOps account if you haven't already.
- **Docker**: Docker should be installed locally for building images.
- **Kubernetes Cluster on AKS**: You should have an AKS cluster running.
- **Azure Container Registry (ACR)**: Set up ACR to store Docker images.
- **Database**: A database (e.g., Azure SQL, MySQL, etc.) that your Java app connects to.

## 1.Prepare Your Java Application
Ensure your Java application is ready for deployment. If you're using a build tool like Maven or Gradle, make sure your project can be built successfully using:

 mvn clean install (for Maven)<br>
 ./gradlew build (for Gradle)<br>
 If using Spring Boot, ensure your application can run locally with an embedded server like Tomcat or Jetty.

## 2. Dockerize Your Java Application


```dockerfile
# Use a base image with OpenJDK
FROM openjdk:17-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the JAR file from the target directory into the container
COPY target/myapp.jar myapp.jar

# Expose the port your app runs on (usually 8080 for Spring Boot)
EXPOSE 8080

# Define the command to run your app
CMD ["java", "-jar", "myapp.jar"]


## Explanation:
-- "FROM openjdk:11-jre-slim": Base image with Java 11 runtime.
-- "ARG JAR_FILE=target/*.jar:" Specifies the location of the built JAR file.
-- "COPY ${JAR_FILE} app.jar": Copies the JAR into the container.
-- "EXPOSE 8080": Exposes port 8080 where the application runs.
-- "ENTRYPOINT ["java", "-jar", "/app.jar"]": Runs the Java application when the container starts.




