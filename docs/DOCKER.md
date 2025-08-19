# Docker Documentation

Ce document explique comment construire et déployer l'application Spring Boot avec Docker.

## Fichiers Docker

- `Dockerfile` - Image Docker multi-stage pour l'application
- `docker-compose.yml` - Orchestration avec PostgreSQL
- `.dockerignore` - Fichiers à exclure du build
- `application-docker.properties` - Configuration pour l'environnement Docker

## Construction de l'image

### Build simple
```bash
docker build -t demo-spring-app .
```

### Build avec tag de version
```bash
docker build -t demo-spring-app:1.0.0 .
```

## Exécution avec Docker

### Avec PostgreSQL local existant
```bash
docker run -p 8080:8080 \
  -e DB_HOST=host.docker.internal \
  -e DB_PORT=5432 \
  -e DB_NAME=md \
  -e DB_USERNAME=matthieudebray \
  -e DB_PASSWORD=Toto2016 \
  demo-spring-app
```

### Avec docker-compose (recommandé)
```bash
# Démarrer tous les services
docker-compose up -d

# Voir les logs
docker-compose logs -f

# Arrêter les services
docker-compose down

# Arrêter et supprimer les volumes
docker-compose down -v
```

## Variables d'environnement

| Variable | Description | Valeur par défaut |
|----------|-------------|-------------------|
| `DB_HOST` | Hôte PostgreSQL | localhost |
| `DB_PORT` | Port PostgreSQL | 5432 |
| `DB_NAME` | Nom de la base | md |
| `DB_USERNAME` | Utilisateur DB | matthieudebray |
| `DB_PASSWORD` | Mot de passe DB | Toto2016 |
| `SERVER_PORT` | Port de l'app | 8080 |
| `SHOW_SQL` | Afficher SQL | false |
| `JAVA_OPTS` | Options JVM | -Xmx512m -Xms256m |

## Healthcheck

L'application expose un endpoint de santé accessible via :
```bash
curl http://localhost:8080/actuator/health
```

## Optimisations Docker

### Build multi-stage
- Étape 1 : Compilation avec JDK complet
- Étape 2 : Exécution avec JRE léger (Alpine)

### Sécurité
- Utilisateur non-root (`spring:spring`)
- Image Alpine (plus petite surface d'attaque)

### Performance
- Cache des dépendances Maven optimisé
- Image finale minimale (JRE seulement)

## Volumes persistants

Le docker-compose crée un volume `postgres_data` pour persister les données PostgreSQL.

## Réseau

Les conteneurs communiquent via un réseau bridge `demo-network`.

## Commandes utiles

```bash
# Voir les conteneurs en cours
docker-compose ps

# Accéder au conteneur de l'app
docker-compose exec demo-app sh

# Accéder à PostgreSQL
docker-compose exec postgres-db psql -U matthieudebray -d md

# Rebuild et redémarrage
docker-compose up --build -d

# Supprimer tout (conteneurs, volumes, réseau)
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
