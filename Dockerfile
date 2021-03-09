FROM debian:buster-slim

# Change Package sources
RUN sed -i 's/^\([^#]\)/#\1/' /etc/apt/sources.list
RUN sed -i '/^#deb .*security.debian.org/s/^#//' /etc/apt/sources.list
RUN echo "deb http://ftp.halifax.rwth-aachen.de/debian/ buster main" >> /etc/apt/sources.list
RUN echo "deb http://ftp.halifax.rwth-aachen.de/debian/ buster-updates main" >> /etc/apt/sources.list

# Upgrade packages
RUN apt-get update && apt-get -y upgrade

# Install OpenSSH server and Gitolite
# Unlock the automatically-created git user
RUN set -x \
 && apt-get install --no-cache gitolite openssh \
 && passwd -u git

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
