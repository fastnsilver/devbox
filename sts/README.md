# SpringSource ToolSuite

## Overview

This Docker container is based upon the excellent [work](http://pelle.io/delivering-gui-applications-with-docker/) done by Christian Pelster.


## Container 
* [Spring Source ToolSuite](http://spring.io/tools/sts) = 3.6.0.RELEASE
* [Ubuntu](http://www.ubuntu.com/download) = 12.04
* Oracle [JDK](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) = 8


## Requirements 

### Windows

Download and install [VirtualBox](http://download.virtualbox.org/virtualbox/4.3.12/VirtualBox-4.3.12-93733-Win.exe)

Download and install [Boot2Docker](https://github.com/boot2docker/windows-installer/releases/download/v1.1.1/docker-install.exe)

Double-click the boot2docker icon on your desktop.


### Mac OS X
Install [Homebrew](http://brew.sh/)

* Open Terminal and cut-and-paste the following

    `ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"`

Preliminaries
    
    brew update
    brew tap phinze/homebrew-cask
    brew install brew-cask
    
Install VirtualBox with

    brew cask install virtualbox

Install boot2docker with

    brew install boot2docker
    
Install Docker with

    brew install docker
    
Run boot2docker with

    boot2docker init
    boot2docker up
    
    
## Installation

    boot2docker
    git clone https://fastnsilver/devbox.git
    cd sts
    chmod +x *.sh
    ./get-sts.sh
    ./build-sts.sh  
    ./run-sts.sh
    
