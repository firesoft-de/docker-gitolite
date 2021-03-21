# About

This is an improved version of the original docker-gitolite container by jgiannuzzi. This version focus on security by implementing the following mechanisms:

## Build on the system
The biggest flaw of the original container is the massive lack of updates. In March 2021 the last build of the container on docker hub was two years old. This means you're running a potential critical system (you're sources stay here!) with a two year old system.

Think that this is not a problem? Ok, would you use a two years old VM or vServer for hosting your sources?

![grafik](https://user-images.githubusercontent.com/34716031/111921604-b10b4c80-8a95-11eb-9cee-4c2ba1609103.png)

So I switched to not providing a prebuild container and focused on easy building on the users machine. Also I provided an update script to use with cron. So you're container will be updated on a regular base.

## Additional

I also switched to debian:buster-slim and the tag latest. 

# =====Original=====

# Docker image for Gitolite

This image allows you to run a git server in a container with OpenSSH and [Gitolite](https://github.com/sitaramc/gitolite#readme).

Based on Alpine Linux.

## Quick setup

Create volumes for your SSH server host keys and for your Gitolite config and repositories

* Docker >= 1.9

        docker volume create --name gitolite-sshkeys
        docker volume create --name gitolite-git

* Docker < 1.9

        docker create --name gitolite-data -v /etc/ssh/keys -v /var/lib/git tianon/true

Setup Gitolite with yourself as the administrator:

* Docker >= 1.10

        docker run --rm -e SSH_KEY="$(cat ~/.ssh/id_rsa.pub)" -e SSH_KEY_NAME="$(whoami)" -v gitolite-sshkeys:/etc/ssh/keys -v gitolite-git:/var/lib/git jgiannuzzi/gitolite true

* Docker == 1.9 (There is a bug in `docker run --rm` that removes volumes when removing the container)

        docker run --name gitolite-setup -e SSH_KEY="$(cat ~/.ssh/id_rsa.pub)" -e SSH_KEY_NAME="$(whoami)" -v gitolite-sshkeys:/etc/ssh/keys -v gitolite-git:/var/lib/git jgiannuzzi/gitolite true
        docker rm gitolite-setup

* Docker < 1.9

        docker run --rm -e SSH_KEY="$(cat ~/.ssh/id_rsa.pub)" -e SSH_KEY_NAME="$(whoami)" --volumes-from gitolite-data jgiannuzzi/gitolite true

Finally run your Gitolite container in the background:

* Docker >= 1.9

        docker run -d --name gitolite -p 22:22 -v gitolite-sshkeys:/etc/ssh/keys -v gitolite-git:/var/lib/git jgiannuzzi/gitolite

* Docker < 1.9

        docker run -d --name gitolite -p 22:22 --volumes-from gitolite-data jgiannuzzi/gitolite

You can then add users and repos by following the [official guide](https://github.com/sitaramc/gitolite#adding-users-and-repos).
