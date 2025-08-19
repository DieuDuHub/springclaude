#!/bin/bash

# Script pour lancer l'application Docker avec la base de données locale

echo "🚀 Lancement de l'application Spring Boot avec PostgreSQL local"

# Vérifier que PostgreSQL local est accessible
if ! nc -z localhost 5432; then
    echo "❌ PostgreSQL n'est pas accessible sur localhost:5432"
    echo "   Veuillez démarrer votre serveur PostgreSQL local"
    exit 1
fi

echo "✅ PostgreSQL local détecté sur localhost:5432"

# Arrêter le conteneur s'il existe déjà
docker rm -f demo-spring-app 2>/dev/null || true

echo "🐳 Lancement du conteneur..."

# Lancer le conteneur avec connexion à la base locale
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

echo "⏳ Attente du démarrage de l'application..."

# Attendre que l'application soit prête
for i in {1..30}; do
    if curl -s http://localhost:8080/actuator/health > /dev/null 2>&1; then
        echo "✅ Application démarrée avec succès!"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "❌ Timeout: L'application n'a pas démarré dans les temps."
        echo "📋 Logs du conteneur:"
        docker logs demo-spring-app
        exit 1
    fi
    echo -n "."
    sleep 2
done

echo ""
echo "🎉 Déploiement terminé!"
echo ""
echo "📋 Informations de l'application:"
echo "  • URL: http://localhost:8080"
echo "  • Health: http://localhost:8080/actuator/health"
echo "  • API: http://localhost:8080/api/persons"
echo ""
echo "📊 Commandes utiles:"
echo "  • Voir les logs: docker logs -f demo-spring-app"
echo "  • Arrêter: docker stop demo-spring-app"
echo "  • Supprimer: docker rm -f demo-spring-app"
echo ""

# Test rapide de l'API
echo "🧪 Test rapide de l'API..."
if curl -s http://localhost:8080/api/persons > /dev/null; then
    echo "✅ API accessible"
else
    echo "⚠️  API non accessible"
fi
