#!/bin/bash

if [[ "$DOCKER_GITOLITE_SSH_KEY" ]] && [[ "$DOCKER_GITOLITE_SSH_KEY_NAME" ]]; then

  echo
  echo "GO"
  echo

  docker run -d -e SSH_KEY="$DOCKER_GITOLITE_SSH_KEY" -e SSH_KEY_NAME="$DOCKER_GITOLITE_SSH_KEY_NAME" -e SSH_USER="$DOCKER_GITOLITE_USER" --name gitolite -p 918:22 -v gitolite-sshkeys:/etc/ssh/keys -v gitolite-git:/var/lib/gitolite3 --restart always gitolite:local

else

  docker run -d --name gitolite -p 918:22 -v gitolite-sshkeys:/etc/ssh/keys -v gitolite-git:/var/lib/gitolite3 --restart always gitolite:local
fi
