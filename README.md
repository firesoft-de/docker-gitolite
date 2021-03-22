# About

This is an improved version of the original docker-gitolite by jgiannuzzi. This version focus on removing security issues in the original version.

# Security improvments

Most users are to confident using containers and don't mind about the security implication of running a container 24/7 over years. Me neither when I started with container virtualization.
You have to keep in mind that in the end a container is just a small piece of your machine running programms separated from your other software. These programms are your container and they live on your machine in the state they where delivered during build time of the container. If you run a container build two years ago (like the original docker-gitolite container in 2021) you load and run two year old code on your machine. Have a moment here and remember the big CVE's of the last two years. If the affected software is installed in your container, than your currently running software with known security issues on your system. I can not think of a scenario where anybody wants that!

If you want to learn more, watch this video: https://youtu.be/RqhxphyVL88?t=1596 It is also available on englisch here https://www.youtube.com/watch?v=gb85IELehj8&t=1596s


## Build on the system
The biggest flaw of the original container is the massive lack of updates. In March 2021 the last build of the container on docker hub was two years old. This means you're running a potential critical system (you're sources stay here!) with a two year old system.

Think that this is not a problem? Ok, would you use a two years old VM or vServer for hosting your sources?

![grafik](https://user-images.githubusercontent.com/34716031/111921604-b10b4c80-8a95-11eb-9cee-4c2ba1609103.png)

So I do not provide a prebuild container. Instead I only provide the docker file that you can build on your machine when you want to have a fresh, clean and up to date container. Therefor I also introduced update routines in the docker file and focused on easy building on the users machine. In this repo you'll find an update script to use with cron. So you're container can be updated on a regular base.

## Additional

I also switched to debian:buster-slim and the tag latest. 

# Original

## Docker image for Gitolite

This image allows you to run a git server in a container with OpenSSH and [Gitolite](https://github.com/sitaramc/gitolite#readme).

Based on Alpine Linux.

### Quick setup

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
