# SpringSource ToolSuite

## Overview

This Docker container is based upon the excellent [work](http://pelle.io/delivering-gui-applications-with-docker/) done by Christian Pelster.


## Container 
* [Spring Source ToolSuite](http://spring.io/tools/sts) = 3.6.0.RELEASE
* [Ubuntu](http://www.ubuntu.com/download) = 12.04


## Requirements 

### Windows
Download and install [Boot2Docker](https://github.com/boot2docker/windows-installer/releases/download/v1.1.1/docker-install.exe)

### Mac OS X
Install [Homebrew](

* Open Terminal and cut-and-paste the following

    ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"

Install Boot2Docker with

    brew install boot2docker
    

## Installation

    boot2docker
    git clone https://fastnsilver/devbox.git
    cd sts
    chmod +x *.sh
    ./get-sts.sh
    ./build-sts.sh  
    ./run-sts.sh
    