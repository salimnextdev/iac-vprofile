# Build stage
FROM eclipse-temurin:11-jdk-alpine AS build

WORKDIR /app

# Copy source code
COPY . .

# Build application
RUN ./mvnw clean package -DskipTests

# Runtime stage
FROM tomcat:9.0-jdk17-temurin-alpine

LABEL maintainer="vprofile"

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR from build stage
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Set environment variables
ENV CATALINA_OPTS="-Xms512m -Xmx1024m"
ENV JAVA_OPTS="-Djava.security.egd=file:/dev/./urandom"

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/ || exit 1

# Start Tomcat
CMD ["catalina.sh", "run"]