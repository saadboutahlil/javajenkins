#!/bin/bash

# Fonction pour vérifier si un service est en cours d'exécution
check_process() {
  pid=$1
  if ! ps -p $pid > /dev/null; then
    echo "Process $pid not running."
    exit 1
  fi
}

# Démarrer Jenkins en arrière-plan
echo "Starting Jenkins..."
java -jar /usr/share/jenkins/jenkins.war &
JENKINS_PID=$!
echo "Jenkins started with PID $JENKINS_PID"

# Attendre quelques secondes pour que Jenkins démarre
sleep 30

# Vérifier si Jenkins est en cours d'exécution
check_process $JENKINS_PID

# Démarrer Tomcat en arrière-plan
echo "Starting Tomcat..."
/opt/tomcat/bin/catalina.sh run &
TOMCAT_PID=$!
echo "Tomcat started with PID $TOMCAT_PID"

# Vérifier si Tomcat est en cours d'exécution
check_process $TOMCAT_PID

# Garder le conteneur actif en surveillant les deux processus
wait $JENKINS_PID
wait $TOMCAT_PID
