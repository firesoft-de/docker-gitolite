#!/bin/bash

if [[ "$SSH_KEY" ]] && [[ "$SSH_KEY_NAME" ]]; then

  echo
  echo "GO"
  echo

  docker run -d -e SSH_KEY="$SSH_KEY" -e SSH_KEY_NAME="$SSH_KEY_NAME" --name gitolite -p 918:22 -v gitolite-sshkeys:/etc/ssh/keys -v gitolite-git:/var/lib/gitolite3 --restart always gitolite:local

else

  docker run -d --name gitolite -p 918:22 -v gitolite-sshkeys:/etc/ssh/keys -v gitolite-git:/var/lib/gitolite3 --restart always gitolite:local
fi
