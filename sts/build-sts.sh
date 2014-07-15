# Builds Docker image
# @author Chris Phillipson <fastnsilver@gmail.com>

if [ "$(docker run busybox echo 'test')" != "test" ]; then
  SUDO=sudo
  if [ "$($SUDO docker run busybox echo 'test')" != "test" ]; then
    echo "Could not run docker"
    exit 1
  fi
fi

mkdir ssh
ssh-keygen -f ssh/id_rsa -q -N ""

$SUDO docker build -t fans/sts-base . 