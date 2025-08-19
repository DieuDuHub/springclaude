# Dockerfile pour l'application Spring Boot Demo
FROM amazoncorretto:17-alpine AS builder

# Installer Maven
RUN apk add --no-cache maven

# Définir le répertoire de travail
WORKDIR /app

# Copier le fichier POM pour optimiser le cache
COPY pom.xml .

# Télécharger les dépendances (pour optimiser le cache Docker)
RUN mvn dependency:go-offline -B

# Copier le code source
COPY src src

# Construire l'application
RUN mvn clean package -DskipTests

# Image finale plus légère
FROM amazoncorretto:17-alpine

# Créer un utilisateur non-root pour la sécurité
RUN addgroup -g 1001 -S spring && \
    adduser -u 1001 -S spring -G spring

# Définir le répertoire de travail
WORKDIR /app

# Copier le JAR depuis l'étape de build
COPY --from=builder /app/target/demo-*.jar app.jar

# Changer le propriétaire du fichier
RUN chown spring:spring app.jar

# Basculer vers l'utilisateur non-root
USER spring:spring

# Variables d'environnement par défaut
ENV SPRING_PROFILES_ACTIVE=docker
ENV JAVA_OPTS="-Xmx512m -Xms256m"

# Exposer le port 8080
EXPOSE 8080

# Point d'entrée avec gestion des signaux
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]

# Healthcheck pour Docker
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1
