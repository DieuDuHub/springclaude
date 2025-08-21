# Docker Documentation

This document explains how to build and deploy the Spring Boot application with Docker.

## Docker Files

- `Dockerfile` - Multi-stage Docker image for the application
- `docker-compose.yml` - Orchestration with PostgreSQL
- `.dockerignore` - Files to exclude from build
- `application-docker.properties` - Configuration for Docker environment

## Image Building

### Simple build
```bash
docker build -t demo-spring-app .
```

### Build with version tag
```bash
docker build -t demo-spring-app:1.0.0 .
```

## Running with Docker

### With existing local PostgreSQL
```bash
docker run -p 8080:8080 \
  -e DB_HOST=host.docker.internal \
  -e DB_PORT=5432 \
  -e DB_NAME=md \
  -e DB_USERNAME=matthieudebray \
  -e DB_PASSWORD=Toto2016 \
  demo-spring-app
```

### With docker-compose (recommended)
```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

## Environment Variables

| Variable | Description | Default Value |
|----------|-------------|-------------------|
| `DB_HOST` | PostgreSQL host | localhost |
| `DB_PORT` | PostgreSQL port | 5432 |
| `DB_NAME` | Database name | md |
| `DB_USERNAME` | DB username | matthieudebray |
| `DB_PASSWORD` | DB password | Toto2016 |
| `SERVER_PORT` | App port | 8080 |
| `SHOW_SQL` | Show SQL | false |
| `JAVA_OPTS` | JVM options | -Xmx512m -Xms256m |

## Healthcheck

The application exposes a health endpoint accessible via:
```bash
curl http://localhost:8080/actuator/health
```

## Docker Optimizations

### Multi-stage build
- Stage 1: Compilation with full JDK
- Stage 2: Execution with lightweight JRE (Alpine)

### Security
- Non-root user (`spring:spring`)
- Alpine image (smaller attack surface)

### Performance
- Optimized Maven dependency cache
- Minimal final image (JRE only)

## Persistent Volumes

Docker-compose creates a `postgres_data` volume to persist PostgreSQL data.

## Network

Containers communicate via a bridge network `demo-network`.

## Useful Commands

```bash
# View running containers
docker-compose ps

# Access app container
docker-compose exec demo-app sh

# Access PostgreSQL
docker-compose exec postgres-db psql -U matthieudebray -d md

# Rebuild and restart
docker-compose up --build -d

# Remove everything (containers, volumes, network)
docker-compose down -v --rmi all
```

## Test de l'API

Une fois déployé, testez l'API :

```bash
# Health check
curl http://localhost:8080/actuator/health

# Lister les personnes
curl http://localhost:8080/api/persons

# Créer une personne
curl -X POST http://localhost:8080/api/persons \
  -H "Content-Type: application/json" \
  -d '{"name":"John Doe"}'
```
