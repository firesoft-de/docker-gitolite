FROM alpine:latest

# Define environment variables (lifecycle restricted to build process)
ARG DOCKER_GITOLITE_SSH_KEY="null"
ARG DOCKER_GITOLITE_USER="null"

# Change Package sources
RUN sed -i 's/^\([^#]\)/#\1/' /etc/apt/sources.list
RUN sed -i '/^#deb .*security.debian.org/s/^#//' /etc/apt/sources.list
RUN echo "deb http://ftp.halifax.rwth-aachen.de/debian/ buster main" >> /etc/apt/sources.list
RUN echo "deb http://ftp.halifax.rwth-aachen.de/debian/ buster-updates main" >> /etc/apt/sources.list

# Upgrade packages
RUN apk update && apk upgrade

# Install OpenSSH server and Gitolite

# We don't want any prompt during the install of gitolite
ENV DEBIAN_FRONTEND=noninteractive

# Prefill debian config with gitolite configuration to further prevent gitolite from prompting an interactive input screen
# Afterwards install with apt-get
RUN echo "gitolite3 gitolite3/adminkey string ssh-ed25519 $DOCKER_GITOLITE_SSH_KEY" | debconf-set-selections && \
  echo "gitolite3 gitolite3/gituser string $DOCKER_GITOLITE_USER" | debconf-set-selections && \
  apt-get -y install gitolite3 openssh-server

# Volume used to store SSH host keys, generated on first run
VOLUME /etc/ssh/keys

# Volume used to store all Gitolite data (keys, config and repositories), initialized on first run
VOLUME /var/lib/git

# Entrypoint responsible for SSH host keys generation, and Gitolite data initialization
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

# Expose port 22 to access SSH
EXPOSE 22

# Default command is to run the SSH server
CMD ["sshd"]
