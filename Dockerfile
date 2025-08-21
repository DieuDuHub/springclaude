# Dockerfile for Spring Boot Demo application
FROM amazoncorretto:17-alpine AS builder

# Install Maven
RUN apk add --no-cache maven

# Set working directory
WORKDIR /app

# Copy POM file to optimize Docker cache
COPY pom.xml .

# Download dependencies (to optimize Docker cache)
RUN mvn dependency:go-offline -B

# Copy source code
COPY src src

# Build application
RUN mvn clean package -DskipTests

# Lighter final image
FROM amazoncorretto:17-alpine

# Create non-root user for security
RUN addgroup -g 1001 -S spring && \
    adduser -u 1001 -S spring -G spring

# Set working directory
WORKDIR /app

# Copy JAR from build stage
COPY --from=builder /app/target/demo-*.jar app.jar

# Change file ownership
RUN chown spring:spring app.jar

# Switch to non-root user
USER spring:spring

# Default environment variables
ENV SPRING_PROFILES_ACTIVE=docker
ENV JAVA_OPTS="-Xmx512m -Xms256m"

# Expose port 8080
EXPOSE 8080

# Entry point with signal handling
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]

# Healthcheck for Docker
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1
