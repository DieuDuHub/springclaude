#!/bin/bash

# Script to run Docker application with local database

echo "🚀 Starting Spring Boot application with local PostgreSQL"

# Check if local PostgreSQL is accessible
if ! nc -z localhost 5432; then
    echo "❌ PostgreSQL is not accessible on localhost:5432"
    echo "   Please start your local PostgreSQL server"
    exit 1
fi

echo "✅ Local PostgreSQL detected on localhost:5432"

# Stop container if it already exists
docker rm -f demo-spring-app 2>/dev/null || true

echo "🐳 Starting container..."

# Run container with connection to local database
docker run -d \
  --name demo-spring-app \
  -p 8080:8080 \
  -e SPRING_PROFILES_ACTIVE=docker \
  -e DB_HOST=host.docker.internal \
  -e DB_PORT=5432 \
  -e DB_NAME=md \
  -e DB_USERNAME=matthieudebray \
  -e DB_PASSWORD=Toto2016 \
  -e SHOW_SQL=false \
  demo-spring-app

echo "⏳ Waiting for application startup..."

# Wait for application to be ready
for i in {1..30}; do
    if curl -s http://localhost:8080/actuator/health > /dev/null 2>&1; then
        echo "✅ Application started successfully!"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "❌ Timeout: Application failed to start within time limit."
        echo "📋 Container logs:"
        docker logs demo-spring-app
        exit 1
    fi
    echo -n "."
    sleep 2
done

echo ""
echo "🎉 Deployment completed!"
echo ""
echo "📋 Application information:"
echo "  • URL: http://localhost:8080"
echo "  • Health: http://localhost:8080/actuator/health"
echo "  • API: http://localhost:8080/api/persons"
echo ""
echo "📊 Useful commands:"
echo "  • View logs: docker logs -f demo-spring-app"
echo "  • Stop: docker stop demo-spring-app"
echo "  • Remove: docker rm -f demo-spring-app"
echo ""

# Quick API test
echo "🧪 Quick API test..."
if curl -s http://localhost:8080/api/persons > /dev/null; then
    echo "✅ API accessible"
else
    echo "⚠️  API not accessible"
fi
