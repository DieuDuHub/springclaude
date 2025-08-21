#!/bin/bash

# Deployment script for Spring Boot Demo application

set -e  # Stop on error

echo "🚀 Deploying Spring Boot Demo application"

# Colors for messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to display messages
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check that Docker is installed
if ! command -v docker &> /dev/null; then
    log_error "Docker is not installed. Please install it first."
    exit 1
fi

# Check that docker-compose is installed
if ! command -v docker-compose &> /dev/null; then
    log_error "docker-compose is not installed. Please install it first."
    exit 1
fi

# Clean existing containers
log_info "Cleaning existing containers..."
docker-compose down 2>/dev/null || true

# Build the image
log_info "Building Docker image..."
docker build -t demo-spring-app .

# Start services
log_info "Starting services with docker-compose..."
docker-compose up -d

# Wait for application to be ready
log_info "Waiting for application startup..."
for i in {1..30}; do
    if curl -s http://localhost:8080/actuator/health > /dev/null 2>&1; then
        log_info "✅ Application started successfully!"
        break
    fi
    if [ $i -eq 30 ]; then
        log_error "❌ Timeout: Application failed to start within time limit."
        docker-compose logs
        exit 1
    fi
    echo -n "."
    sleep 2
done

# Display deployment information
echo ""
log_info "🎉 Deployment completed!"
echo ""
echo "📋 Application information:"
echo "  • URL: http://localhost:8080"
echo "  • Health: http://localhost:8080/actuator/health"
echo "  • API: http://localhost:8080/api/persons"
echo ""
echo "📊 Service status:"
docker-compose ps

echo ""
log_info "Useful commands:"
echo "  • View logs: docker-compose logs -f"
echo "  • Stop: docker-compose down"
echo "  • Restart: docker-compose restart"
echo ""

# Quick API test
log_info "Quick API test..."
if curl -s http://localhost:8080/api/persons > /dev/null; then
    log_info "✅ API accessible"
else
    log_warning "⚠️  API not accessible"
fi
