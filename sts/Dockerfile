# Docker image based on http://phusion.github.io/baseimage-docker/
# Minimal environment to enable Java development utilizing the Spring Source Tool Suite IDE
# Credit (and inspiration) for this image goes to http://stackoverflow.com/users/884978/creack
# @see http://stackoverflow.com/questions/16296753/can-you-run-gui-apps-in-a-docker
# @see https://github.com/fcwu/docker-ubuntu-vnc-desktop

FROM	phusion/base-image
MAINTAINER Chris Phillipson <fastnsilver@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root

# Add PPA repo for Oracle JDK as per http://www.webupd8.org/2012/09/install-oracle-java-8-in-ubuntu-via-ppa.html
RUN 	add-apt-repository ppa:webupd8team/java

# Add PPA repo for Node.js as per http://stackoverflow.com/questions/7214474/how-to-keep-up-with-the-latest-versions-of-nodejs-in-ubuntu-ppa-compiling
RUN 	add-apt-repository ppa:chris-lea/node.js  

# Make sure the package repository is up to date
RUN 	apt-get update -y

# no Upstart or DBus
# https://github.com/dotcloud/docker/issues/1724#issuecomment-26294856
RUN 	apt-mark hold initscripts udev plymouth mountall
RUN 	dpkg-divert --local --rename --add /sbin/initctl && ln -sf /bin/true /sbin/initctl

# Install and setup project dependencies
RUN 	apt-get install -y curl wget
RUN 	locale-gen en_US en_US.UTF-8

# Prepare for Java download
RUN 	apt-get install -y python-software-properties
RUN 	apt-get install -y software-properties-common

# Install vnc, xvfb in order to create a 'fake' display and firefox
RUN apt-get install -y --force-yes --no-install-recommends supervisor \
        openssh-server pwgen sudo vim-tiny \
        net-tools \
        lxde x11vnc xvfb \
        gtk2-engines-murrine ttf-ubuntu-font-family \
        nodejs \
        libreoffice firefox 

# Accept EULA for Oracle Java
RUN 	echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 boolean true" | debconf-set-selections

# Install JDK 8
RUN 	apt-get install -y oracle-java8-installer
RUN 	apt-get install -y oracle-java8-set-default

# Clean-up
RUN 	apt-get autoclean \
    	&& apt-get autoremove \
    	&& rm -rf /var/lib/apt/lists/*

ADD 	noVNC /noVNC/
ADD 	sts-bundle/sts-3.6.0.RELEASE /sts/

ADD 	startup.sh /
ADD 	supervisord.conf /

EXPOSE 	6080
EXPOSE 	5900
EXPOSE 	22

WORKDIR /

ENTRYPOINT ["/startup.sh"]
