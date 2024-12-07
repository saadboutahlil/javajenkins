# Utiliser l'image officielle Jenkins LTS
FROM jenkins/jenkins:lts

# Passer à l'utilisateur root pour installer des paquets
USER root

# Installer OpenJDK 17 et wget
RUN apt-get update && apt-get install -y wget openjdk-17-jdk

# Télécharger et installer Tomcat 7.0.109
RUN wget https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.109/bin/apache-tomcat-7.0.109.tar.gz -P /opt && \
    tar -xvzf /opt/apache-tomcat-7.0.109.tar.gz -C /opt && \
    rm /opt/apache-tomcat-7.0.109.tar.gz

# Renommer le dossier Tomcat
RUN mv /opt/apache-tomcat-7.0.109 /opt/tomcat

# Modifier le port de Tomcat dans le fichier server.xml
RUN sed -i 's/8080/8081/g' /opt/tomcat/conf/server.xml

# Copier le fichier .war dans Tomcat
COPY target/javajenkins.war /opt/tomcat/webapps/

# Copier le fichier entrypoint.sh dans /usr/local/bin
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Donner les permissions d'exécution
RUN chmod +x /usr/local/bin/entrypoint.sh

# Exposer les ports 8081 pour Tomcat et 8080 pour Jenkins
EXPOSE 8011 8080 50000

# Démarrer Jenkins et Tomcat avec le script entrypoint.sh
CMD ["/usr/local/bin/entrypoint.sh"]
