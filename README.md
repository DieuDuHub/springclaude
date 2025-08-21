# Spring Boot Demo Application

Spring Boot demonstration application with REST API for person management, connected to PostgreSQL and containerized with Docker.

## 🚀 Features

- **CRUD REST API** for person management
- **PostgreSQL database** with existing table
- **Complete Docker containerization**
- **PlantUML documentation** of the architecture
- **Health checks** with Spring Boot Actuator
- **Automated deployment** with docker-compose

## 📋 Prerequisites

- Java 17+
- Docker & Docker Compose
- PostgreSQL (for local development)

## 🛠️ Project Structure

```
springclaude/
├── src/
│   ├── main/
│   │   ├── java/com/debray/demo/
│   │   │   ├── DemoApplication.java       # Entry point
│   │   │   ├── controller/
│   │   │   │   └── PersonController.java  # REST API
│   │   │   ├── entity/
│   │   │   │   └── Person.java           # JPA Entity
│   │   │   └── repository/
│   │   │       └── PersonRepository.java # Spring Data Repository
│   │   └── resources/
│   │       ├── application.properties     # Default config
│   │       └── application-docker.properties # Docker config
├── docs/
│   ├── *.puml                            # PlantUML diagrams
│   ├── README.md                         # Architecture doc
│   └── DOCKER.md                         # Docker doc
├── Dockerfile                            # Docker image
├── docker-compose.yml                    # Orchestration
├── deploy.sh                            # Deployment script
└── pom.xml                              # Maven dependencies
```

## 🗄️ Database

The application connects to an existing PostgreSQL table:

```sql
Table "person"
 Column |  Type   | Nullable |      Default      
--------|---------|----------|-------------------
 id     | integer | not null | nextval('person_id_seq')
 name   | text    | not null | 
 data   | bytea   |          | 
```

## 🔧 Installation and Startup

### Method 1: Automated script (recommended)

```bash
./deploy.sh
```

### Method 2: Manual Docker Compose

```bash
# Build and start
docker-compose up --build -d

# Verification
curl http://localhost:8080/actuator/health
```

### Method 3: Local development

```bash
# Compilation
mvn clean compile

# Tests
mvn test

# Startup (with local PostgreSQL)
mvn spring-boot:run
```

## 📡 API Endpoints

| Method | URL | Description |
|---------|-----|-------------|
| `GET` | `/api/persons` | List all persons |
| `GET` | `/api/persons/{id}` | Retrieve a person by ID |
| `POST` | `/api/persons` | Create a new person |
| `PUT` | `/api/persons/{id}` | Update a person |
| `DELETE` | `/api/persons/{id}` | Delete a person |
| `GET` | `/api/persons/search?name=xxx` | Search by name |
| `GET` | `/actuator/health` | Health check |

## 💾 Usage Examples

### Create a person
```bash
curl -X POST http://localhost:8080/api/persons \
  -H "Content-Type: application/json" \
  -d '{"name":"John Doe"}'
```

### List all persons
```bash
curl http://localhost:8080/api/persons
```

### Search by name
```bash
curl "http://localhost:8080/api/persons/search?name=john"
```

## 🐳 Docker

### Images used
- **Base**: Amazon Corretto 17 Alpine
- **Build**: Multi-stage to optimize size
- **Security**: Non-root user

### Environment variables
```bash
DB_HOST=postgres-db          # PostgreSQL host
DB_PORT=5432                 # PostgreSQL port  
DB_NAME=md                   # Database name
DB_USERNAME=matthieudebray   # DB username
DB_PASSWORD=Toto2016         # DB password
SERVER_PORT=8080             # Application port
```

## 📊 Monitoring

- **Health Check**: `/actuator/health`
- **Docker Logs**: `docker-compose logs -f`
- **Metrics**: Available via Spring Boot Actuator

## 🏗️ Architecture

The application follows a layered architecture:

1. **Presentation Layer**: PersonController (REST API)
2. **Business Layer**: PersonRepository (Spring Data JPA)  
3. **Data Layer**: Person Entity + PostgreSQL

See `/docs/` for detailed PlantUML diagrams.

## 🔧 Configuration

### Local development
File: `application.properties`

### Docker production
File: `application-docker.properties`
- Externalized environment variables
- Optimized logs for containers
- Health checks enabled

## 🚀 Deployment

### Local
```bash
./deploy.sh
```

### Production
1. Modify `docker-compose.yml` for target environment
2. Configure environment variables
3. Deploy with `docker-compose up -d`

## 🛠️ Development

### Adding new features
1. Create/modify entities in `entity/`
2. Add repositories in `repository/`
3. Implement controllers in `controller/`
4. Update PlantUML documentation

### Testing
```bash
mvn test                    # Unit tests
docker-compose up -d        # Integration tests
```

## 📝 Documentation

- **Architecture**: `/docs/README.md`
- **Docker**: `/docs/DOCKER.md`  
- **Diagrams**: `/docs/*.puml`

## 🤝 Contributing

1. Fork the project
2. Create a branch (`git checkout -b feature/new-feature`)
3. Commit (`git commit -am 'Add new feature'`)
4. Push (`git push origin feature/new-feature`)
5. Create a Pull Request

---

**Created with ❤️ and Spring Boot**
