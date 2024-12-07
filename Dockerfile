# Utiliser l'image officielle Jenkins LTS
FROM jenkins/jenkins:lts

# Passer à l'utilisateur root pour installer des paquets
USER root

# Mettre à jour les dépôts et installer OpenJDK 17 et wget
RUN apt-get update && \
    apt-get install -y wget openjdk-17-jdk

# Télécharger et installer Tomcat 7.0.109
RUN wget https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.109/bin/apache-tomcat-7.0.109.tar.gz -P /opt && \
    tar -xvzf /opt/apache-tomcat-7.0.109.tar.gz -C /opt && \
    rm /opt/apache-tomcat-7.0.109.tar.gz

# Renommer le dossier Tomcat
RUN mv /opt/apache-tomcat-7.0.109 /opt/tomcat

# Définir les variables d'environnement pour JAVA_HOME et PATH
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# Exposer les ports Jenkins et Tomcat
EXPOSE 8011 50000

# Démarrer Jenkins et Tomcat
CMD ["bash", "-c", "jenkins & /opt/tomcat/bin/catalina.sh run"]
