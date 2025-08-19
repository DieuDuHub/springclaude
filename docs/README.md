# Documentation API Person

Cette documentation décrit l'architecture et le fonctionnement de l'API REST pour la gestion des personnes dans l'application Spring Boot.

## Vue d'ensemble

L'API permet de gérer une table `person` dans une base de données PostgreSQL via des endpoints REST standard (CRUD).

## Diagrammes PlantUML

### 1. Diagramme de Classes
- **Fichier :** `class-diagram.puml`
- **Description :** Montre la structure des classes et leurs relations
- **Composants :** PersonController, PersonRepository, Person Entity et table PostgreSQL

### 2. Diagramme de Séquence
- **Fichier :** `sequence-diagram.puml`
- **Description :** Illustre les interactions pour chaque endpoint REST
- **Scénarios couverts :**
  - GET /api/persons (récupérer toutes les personnes)
  - GET /api/persons/{id} (récupérer une personne par ID)
  - POST /api/persons (créer une nouvelle personne)
  - PUT /api/persons/{id} (mettre à jour une personne)
  - DELETE /api/persons/{id} (supprimer une personne)
  - GET /api/persons/search?name=xxx (rechercher par nom)

### 3. Diagramme d'Architecture
- **Fichier :** `architecture-diagram.puml`
- **Description :** Vue d'ensemble de l'architecture en couches
- **Couches :**
  - Presentation Layer (PersonController)
  - Business Layer (PersonRepository)
  - Data Layer (Person Entity + PostgreSQL)

### 4. Diagramme de Composants
- **Fichier :** `component-diagram.puml`
- **Description :** Relations entre les composants Spring Boot et externes
- **Technologies :** Spring Web MVC, Spring Data JPA, Hibernate, HikariCP, PostgreSQL

## Endpoints API

| Méthode | URL | Description | Réponse |
|---------|-----|-------------|---------|
| GET | `/api/persons` | Liste toutes les personnes | 200 + List\<Person\> |
| GET | `/api/persons/{id}` | Récupère une personne | 200 + Person ou 404 |
| POST | `/api/persons` | Crée une personne | 201 + Person ou 400 |
| PUT | `/api/persons/{id}` | Met à jour une personne | 200 + Person ou 404 |
| DELETE | `/api/persons/{id}` | Supprime une personne | 204 ou 404 |
| GET | `/api/persons/search?name=xxx` | Recherche par nom | 200 + List\<Person\> |

## Structure de la table PostgreSQL

```sql
Table "person"
 Column |  Type   | Collation | Nullable |      Default      
--------+---------+-----------+----------+-------------------
 id     | integer |           | not null | nextval('person_id_seq'::regclass)
 name   | text    |           | not null | 
 data   | bytea   |           |          | 
```

## Configuration

L'application se connecte à PostgreSQL via la configuration dans `application.properties` :

```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/md
spring.datasource.username=matthieudebray
spring.datasource.password=Toto2016
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
```

## Génération des diagrammes

Pour générer les images à partir des fichiers PlantUML, utilisez :

```bash
# Installer PlantUML (si nécessaire)
npm install -g plantuml

# Générer tous les diagrammes
plantuml docs/*.puml

# Ou générer un diagramme spécifique
plantuml docs/class-diagram.puml
```

Les images seront générées dans le même répertoire avec l'extension `.png`.
