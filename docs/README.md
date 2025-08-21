# Person API Documentation

This documentation describes the architecture and operation of the REST API for person management in the Spring Boot application.

## Overview

The API allows managing a `person` table in a PostgreSQL database via standard REST endpoints (CRUD).

## PlantUML Diagrams

### 1. Class Diagram
- **File:** `class-diagram.puml`
- **Description:** Shows the structure of classes and their relationships
- **Components:** PersonController, PersonRepository, Person Entity and PostgreSQL table

### 2. Sequence Diagram
- **File:** `sequence-diagram.puml`
- **Description:** Illustrates interactions for each REST endpoint
- **Covered scenarios:**
  - GET /api/persons (retrieve all persons)
  - GET /api/persons/{id} (retrieve a person by ID)
  - POST /api/persons (create a new person)
  - PUT /api/persons/{id} (update a person)
  - DELETE /api/persons/{id} (delete a person)
  - GET /api/persons/search?name=xxx (search by name)

### 3. Architecture Diagram
- **File:** `architecture-diagram.puml`
- **Description:** Overview of the layered architecture
- **Layers:**
  - Presentation Layer (PersonController)
  - Business Layer (PersonRepository)
  - Data Layer (Person Entity + PostgreSQL)

### 4. Component Diagram
- **File:** `component-diagram.puml`
- **Description:** Relationships between Spring Boot and external components
- **Technologies:** Spring Web MVC, Spring Data JPA, Hibernate, HikariCP, PostgreSQL

## API Endpoints

| Method | URL | Description | Response |
|---------|-----|-------------|---------|
| GET | `/api/persons` | Lists all persons | 200 + List\<Person\> |
| GET | `/api/persons/{id}` | Retrieves a person | 200 + Person or 404 |
| POST | `/api/persons` | Creates a person | 201 + Person or 400 |
| PUT | `/api/persons/{id}` | Updates a person | 200 + Person or 404 |
| DELETE | `/api/persons/{id}` | Deletes a person | 204 or 404 |
| GET | `/api/persons/search?name=xxx` | Search by name | 200 + List\<Person\> |

## PostgreSQL Table Structure

```sql
Table "person"
 Column |  Type   | Collation | Nullable |      Default      
--------+---------+-----------+----------+-------------------
 id     | integer |           | not null | nextval('person_id_seq'::regclass)
 name   | text    |           | not null | 
 data   | bytea   |           |          | 
```

## Configuration

The application connects to PostgreSQL via the configuration in `application.properties`:

```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/md
spring.datasource.username=matthieudebray
spring.datasource.password=Toto2016
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
```

## Diagram Generation

To generate images from PlantUML files, use:

```bash
# Install PlantUML (if necessary)
npm install -g plantuml

# Generate all diagrams
plantuml docs/*.puml

# Or generate a specific diagram
plantuml docs/class-diagram.puml
```

Images will be generated in the same directory with the `.png` extension.
