# Builds Docker image
# @author Chris Phillipson <fastnsilver@gmail.com>

if [ "$(docker run busybox echo 'test')" != "test" ]; then
  SUDO=sudo
  if [ "$($SUDO docker run busybox echo 'test')" != "test" ]; then
    echo "Could not run docker"
    exit 1
  fi
fi

# Add nsenter
# @see https://github.com/jpetazzo/nsenter
DOCKER_ENTER_FN_EXISTS=sed -n '/docker-enter()/=' .ashrc

if [ -z "$DOCKER_ENTER_FN_EXISTS" ]; then
	sed '$ a\docker-enter() { boot2docker ssh -t "[ -f /var/lib/boot2docker/nsenter ] || docker run --rm -v /var/lib/boot2docker/:/target jpetazzo/nsenter; sudo /var/lib/boot2docker/docker-enter $@"; }' .ashrc
fi

# Downloads and unpacks Spring Source Tool Suite
# for 64-bit *nix
wget http://download.springsource.com/release/STS/3.6.0/dist/e4.4/spring-tool-suite-3.6.0.RELEASE-e4.4-linux-gtk-x86_64.tar.gz
tar -xzvf spring-tool-suite-3.6.0.RELEASE-e4.4-linux-gtk-x86_64.tar.gz

# Fetch noVNC
# @see http://kanaka.github.io/noVNC/
wget https://github.com/kanaka/noVNC/archive/master.zip
unzip -o -q noVNC-master.zip
mv noVNC-master noVNC

# Build docker container
$SUDO docker build --rm -t fans/sts-base . 