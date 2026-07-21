# ETAPE 1 : BUILD
FROM maven:3.9-eclipse-temurin-11 AS build

WORKDIR /app

# Copier le pom.xml d'abord (pour profiter du cache Docker sur les dependances)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copier le reste du code source
COPY src ./src

# Construire le fichier .war (skip des tests pour aller plus vite en CI/CD)
RUN mvn clean package -DskipTests

# ETAPE 2 : RUNTIME
FROM tomcat:9.0-jdk11-temurin

# Supprimer les apps par defaut de Tomcat (webapps ROOT, docs, examples...)
RUN rm -rf /usr/local/tomcat/webapps/*

# Copier le .war genere depuis l'etape build
# Renomme en ROOT.war pour que l'app soit accessible sur "/" au lieu de "/gestion_g2_spring_mvc"
COPY --from=build /app/target/gestion_g2_spring_mvc.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
