# Development Environment

This project is a derivative of the excellent work in RelateIQ's [Instant Development Environment](https://github.com/relateiq/docker_public).

## Installation:

### Linux

Install Virtualbox based off the [installation instructions](https://www.virtualbox.org/wiki/Linux_Downloads).

### MacOS

#### Install Homebrew

First, install [Homebrew](http://brew.sh/).

```
ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
```

#### Install Virtualbox and Vagrant

Install VirtualBox and Vagrant using [Brew Cask](https://github.com/phinze/homebrew-cask).

```
brew tap phinze/homebrew-cask
brew install brew-cask
brew cask install virtualbox
brew cask install vagrant
```

## Check out the repository

```
git clone https://github.com/fastnsilver/devbox.git
cd devbox/devenv
vagrant up
```

After Guest Additions is in, reload the vagrant:

```
vagrant reload
```

## Update devenv

This will pull all the images from the server and update Docker's configuration for DockerUI.

```
./bin/devenv update
vagrant reload
```

## Run devenv start

Start the devenv container:

```
./bin/devenv start
```

You should see console output like...

```
docker_public cphi$ ./bin/devenv start
Starting applications...
Started ZOOKEEPER in container aea8c4ea668d2cca454ff93e423f976119dfda1d060b328bbb1d5c95b68416c9
Started REDIS in container 7ad7e9d22e68a22a8fe9918a23373d019f5f544ed2e60242570bf6491786861f
Started CASSANDRA in container 6ecd409960847d1c949ffc47faf06f0feb17d8b3580a0b00ab358466d33210ad
Started ELASTICSEARCH in container bfe804b795e5c775526cdb001827cb26440aafc791d2a044eb09f07beac3de1a
Started MONGO in container 3ac7628858fae849230e6abaeac47c69d201f1784a0fe31f52ec2e5b99e07e62
Started KAFKA in container 4d4d67fd430185bf3d20fc5afd78988d79700128ed556f4d49a8c4c0ad681ad7
Started DOCKERUI in container 5c24438a0ffeb9b4c0c8196e6a951d44c0afe2c63aec3228499e8af403ea8944
Connection to 127.0.0.1 closed.
```

Now visit [http://localhost:9000/](http://localhost:9000/) and you should see your containers.

![Containers](dockerui.png)

## Other commands

```
Usage: ./bin/devenv {start|stop|kill|rm|update|restart|status|ssh}
```
