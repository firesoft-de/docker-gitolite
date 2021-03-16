#!/bin/bash

# while getopts ":d:k:n:" opt; do
#   case $opt in
#     d) DEBUG="$OPTARG"
#     ;;
#     k) SSH_KEY="$OPTARG"
#     ;;
#     n) SSH_KEY_NAME="$OPTARG"
#     ;;
#   esac
# done

if [ "$DEBUG" = true ]; then
  echo "Debug mode"
  echo "SSH_KEY $SSH_KEY"
  echo "SSH_KEY_NAME $SSH_KEY_NAME"
fi

echo "Stoppe container..."
docker stop gitolite
echo "Container gestoppt!"
echo

echo "Lösche container..."
docker rm gitolite
echo "Container gelöscht!"
echo

echo "git pull..."
#cd docker-gitolite
git pull
cd ..
echo "git pull fertig!"
echo

echo "Container bauen..."

if [ $DEBUG = true ]; then
  docker build --no-cache=true -t gitolite:local docker-gitolite
else
  echo "NON"
  docker build -t gitolite:local docker-gitolite
fi

cd docker-gitolite

echo "Container gebaut!"
echo

echo "Starte neuen container..."
./run_gitolite.sh
echo "Container gestartet!"

echo
echo
echo "Update durchgeführt!"
