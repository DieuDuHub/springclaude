#!/bin/bash

# Script de déploiement pour l'application Spring Boot Demo

set -e  # Arrêter en cas d'erreur

echo "🚀 Déploiement de l'application Spring Boot Demo"

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Fonction pour afficher les messages
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Vérifier que Docker est installé
if ! command -v docker &> /dev/null; then
    log_error "Docker n'est pas installé. Veuillez l'installer d'abord."
    exit 1
fi

# Vérifier que docker-compose est installé
if ! command -v docker-compose &> /dev/null; then
    log_error "docker-compose n'est pas installé. Veuillez l'installer d'abord."
    exit 1
fi

# Nettoyer les conteneurs existants
log_info "Nettoyage des conteneurs existants..."
docker-compose down 2>/dev/null || true

# Construire l'image
log_info "Construction de l'image Docker..."
docker build -t demo-spring-app .

# Démarrer les services
log_info "Démarrage des services avec docker-compose..."
docker-compose up -d

# Attendre que l'application soit prête
log_info "Attente du démarrage de l'application..."
for i in {1..30}; do
    if curl -s http://localhost:8080/actuator/health > /dev/null 2>&1; then
        log_info "✅ Application démarrée avec succès!"
        break
    fi
    if [ $i -eq 30 ]; then
        log_error "❌ Timeout: L'application n'a pas démarré dans les temps."
        docker-compose logs
        exit 1
    fi
    echo -n "."
    sleep 2
done

# Afficher les informations de déploiement
echo ""
log_info "🎉 Déploiement terminé!"
echo ""
echo "📋 Informations de l'application:"
echo "  • URL: http://localhost:8080"
echo "  • Health: http://localhost:8080/actuator/health"
echo "  • API: http://localhost:8080/api/persons"
echo ""
echo "📊 État des services:"
docker-compose ps

echo ""
log_info "Commandes utiles:"
echo "  • Voir les logs: docker-compose logs -f"
echo "  • Arrêter: docker-compose down"
echo "  • Redémarrer: docker-compose restart"
echo ""

# Test rapide de l'API
log_info "Test rapide de l'API..."
if curl -s http://localhost:8080/api/persons > /dev/null; then
    log_info "✅ API accessible"
else
    log_warning "⚠️  API non accessible"
fi
