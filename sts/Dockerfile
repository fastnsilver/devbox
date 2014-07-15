# Docker image based on http://phusion.github.io/baseimage-docker/
# Installs Oracle JDK 8
# Credit (and inspiration) for this image goes out Christian Pelster
# @see http://pelle.io/delivering-gui-applications-with-docker/

FROM     phusion/baseimage
MAINTAINER Chris Phillipson <fastnsilver@gmail.com>

# Make sure the package repository is up to date
RUN apt-get update

# Add PPA repo for as per http://www.webupd8.org/2012/09/install-oracle-java-8-in-ubuntu-via-ppa.html
RUN add-apt-repository ppa:webupd8team/java

# Again make sure the package repository is up to date
RUN apt-get update

# Install JDK 8
RUN apt-get install oracle-java8-installer
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install oracle-java8-set-default

RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

# Make the SSH port available
EXPOSE 22
ADD ssh/id_rsa.pub /root/.ssh/authorized_keys
RUN chown root:root /root/.ssh/authorized_keys

ADD sts /root/sts/

# Start the SSH daemon
CMD ["/usr/sbin/sshd", "-D"]