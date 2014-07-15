# Builds Docker image
# @author Chris Phillipson <fastnsilver@gmail.com>

if [ "$(docker run busybox echo 'test')" != "test" ]; then
  SUDO=sudo
  if [ "$($SUDO docker run busybox echo 'test')" != "test" ]; then
    echo "Could not run docker"
    exit 1
  fi
fi

$SUDO docker build -t fns/sts-base 