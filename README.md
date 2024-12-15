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
```

## Explanation:
- **FROM openjdk:11-jre-slim**: Base image with Java 11 runtime.
- **ARG JAR_FILE=target/*.jar**: Specifies the location of the built JAR file.
- **COPY ${JAR_FILE} app.jar**: Copies the JAR into the container.
- **EXPOSE 8080**: Exposes port 8080 where the application runs.
- **ENTRYPOINT ["java", "-jar", "/app.jar"]**: Runs the Java application when the container starts.

## Build Docker Image Locally
To test your Dockerfile locally, run:
   
  ```
docker build -t <your-docker-image-name> .
 docker run -p 8080:8080 <your-docker-image-name>
```
## 3. Push the Docker Image to Azure Container Registry (ACR)
Step 1: Log into Azure CLI and ACR
```
az login
az acr login --name <your-acr-name>
```
Step 2: Build the Docker image locally (if not already built) and tag it for ACR
```
docker build -t <your-acr-name>.azurecr.io/<your-image-name>:<tag> .
```
Step 3: Push the Docker image to ACR
```
docker push <your-acr-name>.azurecr.io/<your-image-name>:<tag>
```
Now your Docker image is stored in Azure Container Registry.

## 4. Set Up Azure Kubernetes Service (AKS)
Step 1: Create AKS Cluster
If you don't already have an AKS cluster, create one using the Azure CLI:
```
az aks create --resource-group <your-resource-group> --name <aks-cluster-name> --node-count 3 --enable-addons monitoring --generate-ssh-keys
```
Step 2: Get AKS Credentials
```
To access the AKS cluster, configure kubectl to use the credentials:
```
az aks get-credentials --resource-group <your-resource-group> --name <aks-cluster-name>
```
Step 3: Set up Kubernetes Deployment YAML File

Create a Kubernetes deployment and service YAML file (e.g., deployment.yaml):

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: java-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: java-app
  template:
    metadata:
      labels:
        app: java-app
    spec:
      containers:
        - name: java-app
          image: <your-acr-name>.azurecr.io/<your-image-name>:<tag>
          ports:
            - containerPort: 8080
```
```
apiVersion: v1
kind: Service
metadata:
  name: java-app-service
spec:
  selector:
    app: java-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
  type: LoadBalancer


```
