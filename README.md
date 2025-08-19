# Spring Boot Demo Application

Application Spring Boot de démonstration avec API REST pour la gestion des personnes, connectée à PostgreSQL et conteneurisée avec Docker.

## 🚀 Fonctionnalités

- **API REST CRUD** pour la gestion des personnes
- **Base de données PostgreSQL** avec table existante
- **Conteneurisation Docker** complète
- **Documentation PlantUML** de l'architecture
- **Health checks** avec Spring Boot Actuator
- **Déploiement automatisé** avec docker-compose

## 📋 Prérequis

- Java 17+
- Docker & Docker Compose
- PostgreSQL (pour le développement local)

## 🛠️ Structure du projet

```
springclaude/
├── src/
│   ├── main/
│   │   ├── java/com/debray/demo/
│   │   │   ├── DemoApplication.java       # Point d'entrée
│   │   │   ├── controller/
│   │   │   │   └── PersonController.java  # API REST
│   │   │   ├── entity/
│   │   │   │   └── Person.java           # Entité JPA
│   │   │   └── repository/
│   │   │       └── PersonRepository.java # Repository Spring Data
│   │   └── resources/
│   │       ├── application.properties     # Config par défaut
│   │       └── application-docker.properties # Config Docker
├── docs/
│   ├── *.puml                            # Diagrammes PlantUML
│   ├── README.md                         # Doc architecture
│   └── DOCKER.md                         # Doc Docker
├── Dockerfile                            # Image Docker
├── docker-compose.yml                    # Orchestration
├── deploy.sh                            # Script de déploiement
└── pom.xml                              # Dépendances Maven
```

## 🗄️ Base de données

L'application se connecte à une table PostgreSQL existante :

```sql
Table "person"
 Column |  Type   | Nullable |      Default      
--------|---------|----------|-------------------
 id     | integer | not null | nextval('person_id_seq')
 name   | text    | not null | 
 data   | bytea   |          | 
```

## 🔧 Installation et démarrage

### Méthode 1: Script automatisé (recommandé)

```bash
./deploy.sh
```

### Méthode 2: Docker Compose manuel

```bash
# Construction et démarrage
docker-compose up --build -d

# Vérification
curl http://localhost:8080/actuator/health
```

### Méthode 3: Développement local

```bash
# Compilation
mvn clean compile

# Tests
mvn test

# Démarrage (avec PostgreSQL local)
mvn spring-boot:run
```

## 📡 API Endpoints

| Méthode | URL | Description |
|---------|-----|-------------|
| `GET` | `/api/persons` | Liste toutes les personnes |
| `GET` | `/api/persons/{id}` | Récupère une personne par ID |
| `POST` | `/api/persons` | Crée une nouvelle personne |
| `PUT` | `/api/persons/{id}` | Met à jour une personne |
| `DELETE` | `/api/persons/{id}` | Supprime une personne |
| `GET` | `/api/persons/search?name=xxx` | Recherche par nom |
| `GET` | `/actuator/health` | Health check |

## 💾 Exemples d'utilisation

### Créer une personne
```bash
curl -X POST http://localhost:8080/api/persons \
  -H "Content-Type: application/json" \
  -d '{"name":"John Doe"}'
```

### Lister toutes les personnes
```bash
curl http://localhost:8080/api/persons
```

### Rechercher par nom
```bash
curl "http://localhost:8080/api/persons/search?name=john"
```

## 🐳 Docker

### Images utilisées
- **Base**: Amazon Corretto 17 Alpine
- **Build**: Multi-stage pour optimiser la taille
- **Sécurité**: Utilisateur non-root

### Variables d'environnement
```bash
DB_HOST=postgres-db          # Hôte PostgreSQL
DB_PORT=5432                 # Port PostgreSQL  
DB_NAME=md                   # Nom de la base
DB_USERNAME=matthieudebray   # Utilisateur DB
DB_PASSWORD=Toto2016         # Mot de passe DB
SERVER_PORT=8080             # Port application
```

## 📊 Monitoring

- **Health Check**: `/actuator/health`
- **Logs Docker**: `docker-compose logs -f`
- **Métriques**: Disponibles via Spring Boot Actuator

## 🏗️ Architecture

L'application suit une architecture en couches :

1. **Presentation Layer**: PersonController (REST API)
2. **Business Layer**: PersonRepository (Spring Data JPA)  
3. **Data Layer**: Person Entity + PostgreSQL

Voir `/docs/` pour les diagrammes PlantUML détaillés.

## 🔧 Configuration

### Développement local
Fichier: `application.properties`

### Production Docker
Fichier: `application-docker.properties`
- Variables d'environnement externalisées
- Logs optimisés pour conteneurs
- Health checks activés

## 🚀 Déploiement

### Local
```bash
./deploy.sh
```

### Production
1. Modifier `docker-compose.yml` pour l'environnement cible
2. Configurer les variables d'environnement
3. Déployer avec `docker-compose up -d`

## 🛠️ Développement

### Ajout de nouvelles fonctionnalités
1. Créer/modifier les entités dans `entity/`
2. Ajouter les repositories dans `repository/`
3. Implémenter les contrôleurs dans `controller/`
4. Mettre à jour la documentation PlantUML

### Tests
```bash
mvn test                    # Tests unitaires
docker-compose up -d        # Tests d'intégration
```

## 📝 Documentation

- **Architecture**: `/docs/README.md`
- **Docker**: `/docs/DOCKER.md`  
- **Diagrammes**: `/docs/*.puml`

## 🤝 Contribution

1. Fork le projet
2. Créer une branche (`git checkout -b feature/nouvelle-fonctionnalite`)
3. Commit (`git commit -am 'Ajouter nouvelle fonctionnalité'`)
4. Push (`git push origin feature/nouvelle-fonctionnalite`)
5. Créer une Pull Request

---

**Créé avec ❤️ et Spring Boot**
