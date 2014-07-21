# Builds Docker image
# @author Chris Phillipson <fastnsilver@gmail.com>

if [ "$(docker run busybox echo 'test')" != "test" ]; then
  SUDO=sudo
  if [ "$($SUDO docker run busybox echo 'test')" != "test" ]; then
    echo "Could not run docker"
    exit 1
  fi
fi

# Downloads and unpacks Spring Source Tool Suite
# for 64-bit *nix
wget http://download.springsource.com/release/STS/3.6.0/dist/e4.4/spring-tool-suite-3.6.0.RELEASE-e4.4-linux-gtk-x86_64.tar.gz
tar -xzvf spring-tool-suite-3.6.0.RELEASE-e4.4-linux-gtk-x86_64.tar.gz

# Fetch noVNC
# @see http://kanaka.github.io/noVNC/
curl -L -O https://github.com/kanaka/noVNC/archive/master.zip
unzip -o -q master.zip
mv noVNC-master noVNC

# Build docker container
$SUDO docker build --rm -t fans/sts-base . 