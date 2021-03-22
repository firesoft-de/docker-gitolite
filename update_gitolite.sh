#!/bin/bash

DEFAULTCOLOR='\033[0m'
RED='\033[0;31m'

function echo_custom () {
  if [ "$DOCKER_GITOLITE_DEBUG" = true ]; then
  	echo -e "$*"
  fi
}

echo_custom ${RED}"Debug mode is on"
echo_custom "DOCKER_GITOLITE_SSH_KEY $DOCKER_GITOLITE_SSH_KEY"
echo_custom "DOCKER_GITOLITE_SSH_KEY_NAME $DOCKER_GITOLITE_SSH_KEY_NAME"
echo_custom "DOCKER_GITOLITE_USER $DOCKER_GITOLITE_USER"${DEFAULTCOLOR}
echo_custom

echo_custom "Stoppe container..."
docker stop gitolite
echo_custom "Container gestoppt!"
echo_custom

echo_custom "Lösche container..."
docker rm gitolite
echo_custom "Container gelöscht!"
echo_custom

echo_custom "git pull..."
#cd docker-gitolite
git pull
cd ..
echo_custom "git pull fertig!"
echo_custom

echo_custom "Container bauen..."

if [ $DOCKER_GITOLITE_DEBUG = true ]; then
  docker build --build-arg DOCKER_GITOLITE_SSH_KEY --build-arg DOCKER_GITOLITE_USER --no-cache=true -t gitolite:local docker-gitolite
else
  docker build --build-arg DOCKER_GITOLITE_SSH_KEY --build-arg DOCKER_GITOLITE_USER -q -t gitolite:local docker-gitolite
fi

cd docker-gitolite

echo_custom "Container gebaut!"
echo_custom

echo_custom "Starte neuen container..."
./run_gitolite.sh
echo_custom "Container gestartet!"

echo_custom
echo_custom
echo_custom "Update durchgeführt!"
