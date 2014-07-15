# Docker image based on http://phusion.github.io/baseimage-docker/
# Installs Oracle JDK 8
# Credit (and inspiration) for this image goes out Christian Pelster
# @see http://pelle.io/delivering-gui-applications-with-docker/

FROM     ubuntu:latest
MAINTAINER Chris Phillipson <fastnsilver@gmail.com>

# Update the APT cache
RUN sed -i.bak 's/main$/main universe/' /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

# Install and setup project dependencies
RUN apt-get install -y curl wget
RUN locale-gen en_US en_US.UTF-8


# Prepare for Java download
RUN apt-get install -y python-software-properties
RUN apt-get install -y software-properties-common

# Add PPA repo for as per http://www.webupd8.org/2012/09/install-oracle-java-8-in-ubuntu-via-ppa.html
RUN add-apt-repository ppa:webupd8team/java

# Again make sure the package repository is up to date
RUN apt-get update

# Accept EULA for Oracle Java
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 boolean true" | debconf-set-selections

# Install JDK 8
RUN apt-get install -y oracle-java8-installer
RUN apt-get install -y oracle-java8-set-default

RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

# Make the SSH port available
EXPOSE 22
ADD ssh/id_rsa.pub /root/.ssh/authorized_keys
RUN chown root:root /root/.ssh/authorized_keys

ADD sts-bundle/sts-3.6.0.RELEASE /root/sts/

# Start the SSH daemon
CMD ["/usr/sbin/sshd", "-D"]
